;;; 420-lsp.el --- LSP client preferences (eglot or lsp-mode)
;;
;; The active client is controlled by `prelude-lsp-client'
;; (see core/prelude-custom.el; default in Prelude 2.1 is 'eglot).
;; Each block below applies only when the corresponding client is
;; selected, so toggling the variable cleanly swaps configurations.

;; ---------------------------------------------------------------------------
;; lsp-mode
;; ---------------------------------------------------------------------------
(when (eq prelude-lsp-client 'lsp-mode)
  (with-eval-after-load 'lsp-mode
    (setq lsp-headerline-breadcrumb-enable nil))

  ;; lsp-ivy workspace symbol search
  (with-eval-after-load 'lsp-ivy
    (global-set-key (kbd "C-z s") #'lsp-ivy-workspace-symbol)
    (global-set-key (kbd "C-z S") #'lsp-ivy-global-workspace-symbol)))

;; ---------------------------------------------------------------------------
;; eglot
;; ---------------------------------------------------------------------------
(when (eq prelude-lsp-client 'eglot)
  ;; Force eager load so `with-eval-after-load 'eglot' callbacks fire
  ;; during startup. pj-lsp relies on this — its per-mode hooks must be
  ;; attached before the first code buffer's mode-hook calls
  ;; `eglot-ensure'. (Eglot is built into Emacs 29+, so the cost is
  ;; minimal.)
  (require 'eglot)

  ;; Bind eglot's lesser-used navigation commands (prelude only binds
  ;; rename, code-actions, format, and organize-imports).
  (define-key eglot-mode-map (kbd "C-c C-l i") #'eglot-find-implementation)
  (define-key eglot-mode-map (kbd "C-c C-l t") #'eglot-find-typeDefinition)
  (define-key eglot-mode-map (kbd "C-c C-l d") #'eglot-find-declaration))

;;; 420-lsp.el ends here
