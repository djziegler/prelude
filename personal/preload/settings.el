;; Don't want the menu or line #'s
(setq prelude-minimalistic-ui 't)

;; Prelude 2.1 defaults `prelude-lsp-client' to 'eglot. Pin to lsp-mode
;; for now to preserve existing behavior; flip to 'eglot when ready and
;; the eglot block in personal/420-lsp.el will take over.
(setq prelude-lsp-client 'lsp-mode)

;; scss-mode (MELPA 20180123, unmaintained) pushes onto two legacy-flymake
;; variables removed from modern Emacs, erroring at load time. Stub them so
;; the package loads; the legacy flymake-scss path is inert and unused.
(defvar flymake-allowed-file-name-masks nil)
(defvar flymake-err-line-patterns nil)

;; Try to kill smartparens
;; as per: https://emacs.stackexchange.com/questions/3779/how-do-i-turn-off-smartparens-when-using-prelude
(advice-add #'smartparens-mode :before-until (lambda (&rest args) t))

(global-unset-key (kbd "C-p"))
(setq lsp-keymap-prefix (kbd "C-p"))
