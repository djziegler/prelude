;;; 100-packages.el --- Package install + straight bootstrap
;;
;; Runs first in the personal/ load order so every later file can
;; assume use-package, prelude-require-packages, and straight are
;; available. Network access required on first run only — subsequent
;; runs reuse what package.el / straight has already cached.

(require 'prelude-packages "~/.emacs.d/core/prelude-packages.el" t)
(prelude-require-packages '(zig-mode))
;; lsp-ivy install was gated on `prelude-lsp-client = 'lsp-mode'.
;; lsp-mode itself has been uninstalled; line removed.

(prelude-require-packages '(use-package))

;;(add-hook 'zig-mode (lambda () (kill-local-variable 'compile-command)))
;;(add-hook 'zig-mode (lambda () (setq-local compile-command "BAng")))

;;(prelude-require-packages '(framemove))


;; Straight package manager. Used by aidermacs in 800-ai-tools.el.
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;; 100-packages.el ends here
