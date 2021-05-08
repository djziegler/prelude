(require 'prelude-packages "~/.emacs.d/core/prelude-packages.el" t)
(prelude-require-packages '(zig-mode))

;;(prelude-require-packages '(eev))

;; Fancy query replace
;;(global-anzu-mode +1)
(global-set-key [remap query-replace] 'anzu-query-replace)
(global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)

;; Prelude includes super-save-mode which saves buffers whenever they lose focus -
;; disable it.  May need to turn on regular auto-save mode after doing this.
(super-save-mode -1)

;; Don't reformat source code on save (only affects typescript at the moment)
(setq prelude-format-on-save nil)
(setq rust-format-on-save nil)

;;(prelude-require-packages '(framemove))

;; Don't like ace-window
(global-set-key [remap other-window] 'other-window)

;; Stop warning me about using up arrow etc.
(setq prelude-guru nil)

;; Don't like all the whitespace coloring
(setq prelude-whitespace nil)


;;(package-initialize)
;;(package-install 'use-package)

(set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-18-*-*-*-m-0-iso10646-1" nil t)

(defun set-background-color-to-black ()
  (interactive)
  (set-background-color "black"))

(global-set-key "\C-c\C-b" 'set-background-color-to-black)

(set-background-color-to-black)


(global-unset-key "\C-z")

;; We then remap c-: to C-z in kitty terminal emulator.
(global-set-key "\C-z:" 'avy-goto-char)
(global-set-key "\C-z\C-g" 'counsel-git-grep)
(global-set-key "\C-z\C-c" 'comment-or-uncomment-region)
(global-set-key "\C-z\C-z" 'suspend-frame)



;; AVY
;; Any lower-case letter or number.  Numbers are specified in the keyboard
;; number-row order, so that the candidate following '9' will be '0'.
;; (setq avy-keys (nconc (number-sequence ?a ?z)
;;                       (number-sequence ?1 ?9)
;;                       '(?0)))
(setq avy-keys (nconc (number-sequence ?a ?z)))


;; If you would like to have the places that are closest to the point have shorter key sequences, you can customize it like this:
(setq avy-orders-alist
      '((avy-goto-char . avy-order-closest)
        (avy-goto-word-0 . avy-order-closest)))


(when (fboundp 'winner-mode)
  (winner-mode 1))

(global-set-key (kbd "C-M-h") 'winner-undo)
(global-set-key (kbd "C-M-'") 'winner-redo)

;;(define-key global-map "\C-ce" 'eval-current-buffer)

;;(setq tramp-default-method "ssh")

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")

(set-cursor-color "red")

;;(global-hl-line-mode 1)
;;(set-face-background 'hl-line "#111111")


;;(setq ring-bell-function 'ignore)

;;(setq-default c-electric-flag nil)

(global-set-key "\C-c C-`" 'next-error)

(global-set-key "\C-c\C-c" 'comment-region)

(global-set-key "\C-cq" 'query-replace-regexp)

(add-hook 'org-mode (lambda () (local-unset-key [M-left])))
(add-hook 'org-mode (lambda () (local-unset-key [M-right])))

(add-hook 'org-mode-hook (lambda () (local-unset-key [M-h])))
(add-hook 'org-mode-hook (lambda () (local-unset-key "\M-h")))

(add-hook 'nxml-mode-hook (lambda () (local-unset-key [M-h])))
(add-hook 'nxml-mode-hook (lambda () (local-unset-key "\M-h")))

                                        ;(add-hook 'org-mode-hook (lambda () (define-key 'org-mode-map [M-h] 'windmove-left)))

                                        ;(add-hook 'org-mode-hook (lambda () (local-set-key [M-h] 'windmove-left)))


(global-set-key "\C-cf" 'flycheck-first-error)
(global-set-key "\C-cp" 'flycheck-previous-error)
(global-set-key "\C-cn" 'flycheck-next-error)

(global-set-key "\C-cN" 'tags-loop-continue)

(global-set-key "\C-x1" 'delete-other-windows-vertically)

(defun save-and-recompile ()
    (interactive)
    (save-some-buffers 't)
    (setq pre-compile-window-configuration (current-window-configuration))
    ;(condition-case nil
    ;     (kill-compilation)
    ;   (error nil))
    (recompile))

(global-set-key "\C-cc" 'save-and-recompile)

(setq recentf-max-saved-items 1000)
(setq recentf-max-menu-items 100)

(set-variable `c-basic-offset 2)
(c-set-offset 'innamespace 0)

(defconst my-cc-style
  '("cc-mode"
    (inlambda . 0) ; no extra indent for lambda
    (c-offsets-alist . ((innamespace . [0])))))

(global-set-key "\C-co" 'other-frame)
;(global-set-key "\C-cr" 'restart-compile)
(global-set-key "\C-cg" 'goto-line)

(global-set-key "\C-cy" 'tide-project-errors)

(global-set-key "\M-*" 'pop-tag-mark)

(setenv "PAGER" "/bin/cat")
(setenv "EDITOR" "/usr/bin/emacsclient") ; `which emacsclient`
(server-start)

(defun revert-all-buffers ()
    "Refreshes all open buffers from their respective files."
    (interactive)
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (and (buffer-file-name) (file-exists-p (buffer-file-name)) (not (buffer-modified-p)))
          (revert-buffer t t t) )))
    (message "Refreshed open files.") )

(tool-bar-mode -1)
(menu-bar-mode -1)

(setq-default frame-title-format '("%f [%m]"))

(add-to-list 'auto-mode-alist '("\\.tsx$" . typescript-mode))
;; (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
;; (add-hook 'web-mode-hook
;;           (lambda ()
;;             (when (string-equal "tsx" (file-name-extension buffer-file-name))
;;               (setup-tide-mode))))

(setq-default eshell-buffer-shorthand t)
