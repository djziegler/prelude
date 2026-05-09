;;; pj-lsp.el --- Loader: bridge lsp-mode to LSP servers in pj containers.

;; The actual implementation lives in the pj repo at
;; ~/projects/pj/contrib/pj-lsp.el so it co-evolves with pj's
;; container-naming convention. This file is just a hook into
;; prelude's personal-dir auto-loading.
;;
;; Loads with 'noerror so this config works on machines that don't have
;; pj checked out at the expected path.

(load (expand-file-name "~/projects/pj/contrib/pj-lsp.el") 'noerror 'nomessage)

;;; pj-lsp.el ends here
