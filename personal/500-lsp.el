;;(setq lsp-completion-provider :none)
;;(global-unset-key (kbd "C-l"))

;;(setq lsp-keymap-prefix (kbd "C-p"))
(setq lsp-headerline-breadcrumb-enable nil)

(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)



;;(setq tide-tsserver-process-environment '("TSS_LOG=-level verbose -file /tmp/tss.log"))




