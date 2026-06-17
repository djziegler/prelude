;;; 902-checkout-chip.el --- per-checkout color chip + task label in the modeline -*- lexical-binding: t; -*-

;; Lightweight, projectile-keyed cousin of pj-modeline (no pj, no containers).
;; When you run many parallel checkouts/worktrees (wordwiki--0, wordwiki--1, ...)
;; this shows, per buffer, a stable-colored chip with the checkout name and its
;; current unit of work, so you don't edit/build in the wrong tree:
;;
;;     [wordwiki--1 · audio trimming]
;;
;; Task label source: `current-task.txt' in the project root if present, else the
;; git branch (when not main/master), else just the name.  Color is hashed from
;; the checkout NAME (stable per slot across restarts); only `--' variant names
;; are colored, canonical names stay plain (matches the pj convention).
;;
;; Cheap by construction: the modeline/frame-title only READ a per-root cache;
;; the cache is (re)computed off the redisplay hot path - on window selection,
;; find-file, magit refresh, and `my/set-task' - by reading two tiny files
;; (current-task.txt and the resolved .git/HEAD).  No file-notify, no polling,
;; no watching big build trees.

(require 'subr-x)
(require 'uniquify)

(defgroup my/checkout nil
  "Per-checkout modeline chip + task label."
  :group 'mode-line)

(defcustom my/checkout-palette
  '("#d97a7a" "#7ad9b4" "#d9c47a" "#7a9fd9"
    "#a07ad9" "#d9a47a" "#7ad9d9" "#9bd97a")
  "Palette for `--' variant checkouts.  hash(name) mod len picks one."
  :type '(repeat color)
  :group 'my/checkout)

(defvar my/checkout--cache (make-hash-table :test 'equal)
  "Per project-root cache: root -> (:name :color :task :branch).")

;;; ---- resolvers (called off the redisplay hot path) ----

(defun my/checkout--root ()
  "Project root of the current buffer, or nil."
  (and (fboundp 'projectile-project-root)
       (ignore-errors (projectile-project-root))))

(defun my/checkout--gitdir (root)
  "Resolve the real git dir for ROOT (handles worktrees, where .git is a file)."
  (let ((dotgit (expand-file-name ".git" root)))
    (cond
     ((file-directory-p dotgit) dotgit)
     ((file-regular-p dotgit)
      (with-temp-buffer
        (insert-file-contents dotgit nil 0 4096)
        (goto-char (point-min))
        (when (re-search-forward "gitdir: *\\(.*\\)" nil t)
          (expand-file-name (string-trim (match-string 1)) root)))))))

(defun my/checkout--branch (root)
  "Current branch for ROOT by parsing .git/HEAD, or nil/\"detached\"."
  (let ((gd (my/checkout--gitdir root)))
    (when gd
      (let ((head (expand-file-name "HEAD" gd)))
        (when (file-readable-p head)
          (with-temp-buffer
            (insert-file-contents head nil 0 4096)
            (goto-char (point-min))
            (cond
             ((re-search-forward "ref: *refs/heads/\\(.*\\)" nil t)
              (string-trim (match-string 1)))
             (t "detached"))))))))

(defun my/checkout--task (root)
  "First non-blank line of ROOT/current-task.txt, or nil."
  (let ((f (expand-file-name "current-task.txt" root)))
    (when (file-readable-p f)
      (with-temp-buffer
        (insert-file-contents f nil 0 4096)
        (goto-char (point-min))
        (let ((line (string-trim (buffer-substring (point-min) (line-end-position)))))
          (unless (string-empty-p line) line))))))

(defun my/checkout--color (name)
  "Stable color for NAME, only for `--' variant checkouts; nil otherwise.
A numeric suffix (wordwiki--3) indexes the palette directly so a sequential
pool is rainbow-distinct; other variant names fall back to a hash."
  (when (and name (string-match-p "--" name))
    (let* ((suffix (replace-regexp-in-string "\\`.*--" "" name))
           (n (if (string-match-p "\\`[0-9]+\\'" suffix)
                  (string-to-number suffix)
                (sxhash-equal name))))
      (nth (mod n (length my/checkout-palette)) my/checkout-palette))))

(defun my/checkout--refresh (root)
  "Recompute and cache the chip data for ROOT; return the plist."
  (when root
    (let ((name (file-name-nondirectory (directory-file-name root))))
      (puthash root
               (list :name name
                     :color (my/checkout--color name)
                     :task (my/checkout--task root)
                     ;; branch only as a label fallback; ignore the boring defaults
                     :branch (let ((b (my/checkout--branch root)))
                               (unless (member b '("main" "master" nil)) b)))
               my/checkout--cache))))

(defun my/checkout--ensure (root)
  "Cached chip data for ROOT, computing once if absent."
  (or (gethash root my/checkout--cache)
      (my/checkout--refresh root)))

(defun my/checkout--label (d)
  "Task-or-branch label string from plist D, or nil."
  (or (plist-get d :task) (plist-get d :branch)))

;;; ---- refresh triggers (off the hot path) ----

(defun my/checkout--touch (&rest _)
  "Recompute the current buffer's checkout entry and repaint the modeline."
  (let ((root (my/checkout--root)))
    (when root (my/checkout--refresh root)))
  (force-mode-line-update))

(add-hook 'window-selection-change-functions #'my/checkout--touch)
(add-hook 'find-file-hook #'my/checkout--touch)
(with-eval-after-load 'magit
  (add-hook 'magit-post-refresh-hook #'my/checkout--touch))

;;; ---- commands ----

(defun my/set-task (task)
  "Set this checkout's task label (writes current-task.txt; blank clears it)."
  (interactive
   (list (read-string "Task for this checkout (blank to clear): "
                      (let ((root (my/checkout--root)))
                        (and root (plist-get (my/checkout--ensure root) :task))))))
  (let* ((root (or (my/checkout--root) (user-error "Not inside a project/checkout")))
         (file (expand-file-name "current-task.txt" root))
         (val (string-trim task)))
    (if (string-empty-p val)
        (when (file-exists-p file) (delete-file file))
      (with-temp-file file (insert val "\n")))
    (my/checkout--refresh root)
    (force-mode-line-update t)
    (message "checkout task: %s" (if (string-empty-p val) "(cleared - falls back to branch)" val))))

(defun my/checkout-refresh ()
  "Drop the whole checkout cache and repaint (use after out-of-band changes)."
  (interactive)
  (clrhash my/checkout--cache)
  (force-mode-line-update t))

;;; ---- frame title (one frame per checkout: shows task in the WM titlebar) ----

(defun my/checkout--frame-title ()
  (let ((root (my/checkout--root)))
    (if root
        (let* ((d (my/checkout--ensure root))
               (label (my/checkout--label d)))
          (concat (plist-get d :name)
                  (and label (concat ": " label))
                  "  -  " (buffer-name)))
      (concat (buffer-name) "  -  Emacs"))))

(setq frame-title-format '(:eval (my/checkout--frame-title)))

;;; ---- doom-modeline segment + slot it into the my-simple-line layout ----

(with-eval-after-load 'doom-modeline
  (doom-modeline-def-segment my-checkout
    "Colored [checkout - task] chip for the current buffer."
    (let ((root (my/checkout--root)))
      (if (not root)
          ""
        (let* ((d (my/checkout--ensure root))
               (label (my/checkout--label d))
               (color (plist-get d :color))
               (text (concat " [" (plist-get d :name)
                             (and label (concat " · " label)) "] ")))
          (if color
              (propertize text 'face `(:background ,color :foreground "black" :weight bold))
            text)))))

  ;; Same layout as 901-modeline.el's `my-simple-line', with `my-checkout' in
  ;; place of `pj-checkout' (pj stays loaded but no longer drives this modeline).
  (doom-modeline-def-modeline 'my-simple-line
    '(server-name-segment buffer-info-simple my-checkout remote-host buffer-position)
    '())
  ;; Apply in GUI *and* tty frames (901-modeline.el only applies it under
  ;; display-graphic-p; we want the checkout chip in terminal frames too).
  (when (fboundp 'setup-custom-doom-modeline)
    (setup-custom-doom-modeline)))

;;; ---- companion: uniquify so colliding files show their checkout ----

(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

(provide '902-checkout-chip)
;;; 902-checkout-chip.el ends here
