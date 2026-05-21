;;; 460-vertico.el --- vertico-stack UI tweaks + embark
;;
;; Face overrides for vertico/marginalia/consult that need to coordinate
;; with the active theme, plus embark (the contextual-action piece
;; prelude-vertico doesn't ship).

;; The default `vertico-current' inherits from `highlight', which under
;; oled-dark is a bright yellow band (#c0c000) -- visually loud against
;; an OLED background. Inherit from `region' instead so the selection
;; bar matches the theme's text-selection color.
(with-eval-after-load 'vertico
  (set-face-attribute 'vertico-current nil
                      :inherit 'region
                      :background 'unspecified
                      :foreground 'unspecified
                      :extend t))

;; Embark: "act on the thing at point / in the minibuffer". Press C-.
;; in any buffer (or in the minibuffer over a candidate) to get a
;; context-aware action menu — find references, copy filename, open in
;; dired, browse URL, etc.
;;
;; embark-consult adds consult-aware integration so an `embark-export'
;; from a consult-line/grep buffer drops you in a writable occur/grep
;; buffer.
(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         ("C-h B" . embark-bindings))      ;; alternative to describe-bindings
  :init
  ;; Show prompter help in the same minibuffer rather than a new buffer.
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; Corfu: don't let RET confirm the highlighted completion candidate.
;; Default behavior + `corfu-preview-current = insert' inserts the
;; candidate inline when the popup is open, so a stray RET to make a
;; newline ends up accepting an unwanted dabbrev/cape completion.
;; TAB (corfu-complete) remains as the explicit completion key.
(with-eval-after-load 'corfu
  (keymap-unset corfu-map "RET" t))

;;; 460-vertico.el ends here
