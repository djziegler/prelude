;; Don't want the menu or line #'s
(setq prelude-minimalistic-ui 't)

;; Try to kill smartparens
;; as per: https://emacs.stackexchange.com/questions/3779/how-do-i-turn-off-smartparens-when-using-prelude
(advice-add #'smartparens-mode :before-until (lambda (&rest args) t))

(global-unset-key (kbd "C-p"))
(setq lsp-keymap-prefix (kbd "C-p"))
