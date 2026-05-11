;;; 420-lsp.el --- eglot preferences and keybindings
;;
;; Eglot-only config. The earlier lsp-mode branch (gated on
;; `prelude-lsp-client = 'lsp-mode') was removed when lsp-mode itself
;; was uninstalled — if you ever want to switch back, reinstall
;; lsp-mode + lsp-ui and restore the gated block from git history.

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
  (define-key eglot-mode-map (kbd "C-c C-l d") #'eglot-find-declaration)

  ;; Region-aware format. `eglot-format' formats the active region
  ;; when one is set, falls back to whole buffer otherwise — a
  ;; superset of the C-c C-l f / eglot-format-buffer binding.
  (define-key eglot-mode-map (kbd "C-c C-l F") #'eglot-format))

;;; 420-lsp.el ends here
