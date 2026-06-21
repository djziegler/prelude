;;; 900-host-display.el --- Frame fonts, theme, OLED-friendly background, UI chrome
;;
;; Machine- and monitor-specific display settings. The frame-font
;; line is what's currently active; the comments above keep a record
;; of fonts used on different monitors so I can switch back without
;; having to re-derive the size each time.
;;
;; OLED-related: load oled-dark theme, force black background, and
;; bind C-c C-b to reset background-color to black if some package
;; resets it. In terminal frames, defer to the terminal's own bg.

;; --- frame fonts --------------------------------------------------

;;(set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-18-*-*-*-m-0-iso10646-1" nil t)
;;(set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-32-*-*-*-m-0-iso10646-1" nil t)

;;LG 65'
;;(set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-28-*-*-*-m-0-iso10646-1" nil )
;; -26- was 84 chars wide on LG 65' with 3x split
;; trying -25- now.
;; NB: 3rd arg (FRAMES) = t -> apply to ALL frames and add to
;; default-frame-alist, so make-frame / emacsclient -c inherit this size.
;; Without it, only the initial frame gets the readable font.
(set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-25-*-*-*-m-0-iso10646-1" nil t)
;; NB: do NOT pin an absolute mode-line font here. An absolute font (e.g.
;; "DejaVu Sans Mono-10") gets baked into the new-frame default by
;; set-face-attribute, but the theme + doom-modeline reset mode-line to
;; inherit `default' only on the live startup frame -- so make-frame frames
;; ended up with the stale small font. Letting mode-line inherit `default'
;; keeps it consistent across all frames. For a deliberately smaller-but-
;; consistent modeline, use a RELATIVE height that scales per frame:
;;   (set-face-attribute 'mode-line nil :height 0.8)

;;NS 1080
;;(set-frame-font "-DAMA-Ubuntu Mono-bold-normal-normal-*-23-*-*-*-m-0-iso10646-1" nil t)

;;BenQ monitor
;(set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-37-*-*-*-m-0-iso10646-1" nil t)

(defun set-benq-frame-font ()
  (interactive)
  (set-face-attribute 'default (selected-frame) :font "Ubuntu Mono" :height 420 :weight 'medium))

;(set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-37-*-*-*-m-0-iso10646-1" nil t)


;; --- theme + background ------------------------------------------
;; OLED-aware: keep peak luminance manageable, default to black bg.
;; The C-c C-b binding manually resets if something else changes it.

(load-theme 'oled-dark t)

(defun set-background-color-to-black ()
  (interactive)
  (set-background-color "black"))
;;(set-face-background 'default "unspecified-bg"))

(global-set-key "\C-c\C-b" 'set-background-color-to-black)

(set-background-color-to-black)

;; In terminal mode, let the terminal's own background show through
(unless (display-graphic-p)
  (set-face-background 'default "unspecified-bg"))

;;(set-face-background 'default "unspecified-bg"))

(set-cursor-color "red")

;;(global-hl-line-mode 1)
;;(set-face-background 'hl-line "#111111")

;;(setq ring-bell-function 'ignore)


;; --- UI chrome ---------------------------------------------------
;; Tool-bar and menu-bar gone — wastes vertical space and don't fit
;; the keyboard-driven workflow.

(tool-bar-mode -1)
(menu-bar-mode -1)


;;(setq-default c-electric-flag nil)

;; --- chrome line color (OLED) ------------------------------------
;; Use `window-divider-mode' instead of the default character-cell
;; `vertical-border' (which is font-width wide and defeats the
;; pixel-shift mitigation by lighting many pixels). 3 px is a
;; visible-but-thin compromise; `right-only' since the modeline is
;; already the natural separator at window bottoms.
(setq window-divider-default-right-width 3
      window-divider-default-places 'right-only)
(window-divider-mode 1)

;; Mute the divider faces to match the fringe (#333333). Default has
;; no explicit color, so it resolves through `default' to ~white
;; (#eeeeec) — too bright for OLED.
(set-face-attribute 'window-divider              nil :foreground "#333333")
(set-face-attribute 'window-divider-first-pixel  nil :foreground "#333333")
(set-face-attribute 'window-divider-last-pixel   nil :foreground "#333333")

;; Also mute `vertical-border' for TTY frames (window-divider-mode
;; doesn't apply there) and for any transient code path that uses it.
(set-face-attribute 'vertical-border nil
                    :foreground "#333333"
                    :background "#333333")

;; Disable fringes entirely. Default 8px each side per window adds ~16
;; px of static chrome per window; at a horizontal split that's 16px
;; framing each side of the 3px divider. Tradeoff: no fringe gutter
;; for flymake markers, wrap arrows, or diff-hl indicators. Diagnostics
;; remain visible inline via underlines and via M-x flymake-show-buffer-diagnostics.
(fringe-mode 0)

;; --- pixel-shift left-edge protection ----------------------------
;; OLED pixel-shift can wander the rendered image a few pixels to the
;; left, eating the leftmost columns of text. Fringes (now off) used
;; to absorb this. The frame's `internal-border-width' is a uniform
;; padding inside the OS window border on all four sides; setting it
;; on demand restores a few pixels of slack on the left (and harmless
;; padding on the other sides — top/bottom/right shift isn't an
;; issue per OLED behavior). The `internal-border' face inherits the
;; default background, so the padding is invisible on the black OLED
;; background.
;;
;; M-x toggle-frame-left-pad — toggle a 12 px pad on/off.
;; C-u N M-x toggle-frame-left-pad — set pad to N px explicitly.
(defun toggle-frame-left-pad (&optional width)
  "Toggle a WIDTH-pixel `internal-border-width' on all frames.
With a prefix arg, set the pad to WIDTH px explicitly (0 to clear).
With no arg, toggle between 0 and 12 px."
  (interactive "P")
  (let* ((cur (or (frame-parameter nil 'internal-border-width) 0))
         (new (cond ((numberp width) width)
                    ((consp width) (prefix-numeric-value width))
                    ((zerop cur) 12)
                    (t 0))))
    (modify-all-frames-parameters (list (cons 'internal-border-width new)))
    (message "internal-border-width: %d → %d" cur new)))

;;; 900-host-display.el ends here
