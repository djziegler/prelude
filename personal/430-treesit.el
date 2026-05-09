;;; 430-treesit.el --- Tree-sitter grammar auto-management
;;
;; treesit-auto bundles a curated `treesit-language-source-alist' and
;; remaps classic major modes to their tree-sitter counterparts when a
;; grammar is available. With `treesit-auto-install' set to 'prompt,
;; opening a file in a remapped mode prompts to install the grammar
;; the first time it's needed; grammars land in ~/.emacs.d/tree-sitter/.

(use-package treesit-auto
  :ensure t
  :config
  (setq treesit-auto-install 'prompt)
  (global-treesit-auto-mode))

;;; 430-treesit.el ends here
