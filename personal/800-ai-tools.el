;;; 800-ai-tools.el --- AI assistants: claude-code-ide, chatgpt-shell
;;
;; Use-package forms for the AI tooling packages. claude-code-ide
;; pulls via :vc (git), chatgpt-shell from MELPA.
;;
;; Most AI keybindings live in 200-keybindings.el (the chatgpt-shell
;; C-z i{s,c,f} bindings); the use-package internal :bind / :config
;; clauses below add the few that are package-specific.
;;
;; aidermacs was previously configured here (via straight); removed
;; — no longer in use. The straight bootstrap in 100-packages.el is
;; now unused but kept in case a future :straight use-package wants it.

(use-package claude-code-ide
  :vc (:url "https://github.com/manzaltu/claude-code-ide.el" :rev :newest)
  :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  (claude-code-ide-emacs-tools-setup)) ; Optionally enable Emacs MCP tools


(use-package chatgpt-shell)

;;(setq chatgpt-shell-openai-key (getenv "OPENAI_API_KEY"))

;; (defun chatgpt-shell-openai-models ()
;;   "Build a list of all OpenAI LLM models available."
;;   ;; Context windows have been verified as of 11/26/2024.
;;   (list (chatgpt-shell-openai-make-model
;;          :version "deepseek-chat"
;;          :token-width 3
;;          ;; https://platform.openai.com/docs/models/gpt-4o
;;          :context-window 128000)
;;         (chatgpt-shell-openai-make-model
;;          :version "deepseek-reasoner"
;;          :token-width 3
;;          ;; https://platform.openai.com/docs/models/gpt-01
;;          :context-window 128000
;;          :validate-command #'chatgpt-shell-validate-no-system-prompt)))

;;; 800-ai-tools.el ends here
