;;; 420-lsp.el --- lsp-mode preferences + lsp-ivy bindings
;;
;; Was personal/500-lsp.el. Hides the breadcrumb, autostart for C/C++
;; buffers, and binds lsp-ivy workspace-symbol search on C-z s / C-z S.

;;(setq lsp-completion-provider :none)
;;(global-unset-key (kbd "C-l"))

;;(setq lsp-keymap-prefix (kbd "C-p"))
(setq lsp-headerline-breadcrumb-enable nil)

(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)


;;(setq tide-tsserver-process-environment '("TSS_LOG=-level verbose -file /tmp/tss.log"))


(global-set-key "\C-zs" 'lsp-ivy-workspace-symbol)
(global-set-key "\C-zS" 'lsp-ivy-global-workspace-symbol)

;;; 420-lsp.el ends here
