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
  ;; (Add eglot customizations here as you migrate.)
  ;; Useful starting points:
  ;;   (add-to-list 'eglot-stay-out-of 'flymake)  ;; if you prefer flycheck
  )

;;; 420-lsp.el ends here
