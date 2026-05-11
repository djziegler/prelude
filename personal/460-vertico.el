;;; 460-vertico.el --- vertico-stack UI tweaks
;;
;; Face overrides for vertico/marginalia/consult that need to coordinate
;; with the active theme. Loaded after the package modules so the faces
;; exist by the time we customize them.

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

;;; 460-vertico.el ends here
