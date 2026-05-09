;;; 901-modeline.el --- doom-modeline + custom segments + pj integration
;;
;; Loads after 900-host-display.el (which set up the theme/background)
;; so modeline faces compose correctly. Defines a minimal custom
;; modeline `my-simple-line' that's used as the default in graphic
;; frames, with optional pj-checkout segment (colored chip per pj
;; checkout) when ~/projects/pj/ is present.
;;
;; Two custom segments are defined here but unused in `my-simple-line'
;; — kept as parking spots: buffer-info-test (alignment scratch),
;; server-name-segment (would show [server-name] if EMACS_SERVER_NAME
;; was set; currently the same info is in the frame title from
;; 110-emacs-niceties.el).

(use-package all-the-icons
  :if (display-graphic-p))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))


;;(doom-modeline-def-modeline 'my-simple-line
;;                            '(bar matches buffer-info remote-host buffer-position parrot selection-info)
;;                            '(misc-info minor-modes input-method buffer-encoding major-mode process vcs checker))

;;(setq doom-modeline-height 250)
;;(setq doom-modeline-hud 't)


(doom-modeline-def-segment buffer-info-test
  "Display only the current buffer's name, but with fontification."
  (concat
   (propertize (format " %s " "                                        ") 'face
               (if (doom-modeline--active)
                   'doom-modeline-buffer-major-mode
                 'mode-line-inactive))))

(doom-modeline-def-segment server-name-segment
  "Display the Emacs server name, only if EMACS_SERVER_NAME was set."
  (when (getenv "EMACS_SERVER_NAME")
    (propertize (format "[%s] " server-name) 'face
                (if (doom-modeline--active)
                    'doom-modeline-buffer-major-mode
                  'mode-line-inactive))))


;; pj-modeline: optional integration with the pj container tool.
;; Loads from ~/projects/pj/contrib/ if present; gracefully no-ops on
;; machines without pj installed. The segment list below conditionally
;; includes `pj-checkout' so doom-modeline doesn't try to render an
;; unregistered segment when pj isn't available.
(defvar my/pj-modeline-available
  (load (expand-file-name "~/projects/pj/contrib/pj-modeline.el")
        'noerror 'nomessage)
  "Whether ~/projects/pj/contrib/pj-modeline.el was loadable.
Non-nil only if pj is installed at the expected path.")

(when my/pj-modeline-available
  (pj-modeline-mode 1))

(doom-modeline-def-modeline 'my-simple-line
                            (if my/pj-modeline-available
                                '(server-name-segment buffer-info-simple pj-checkout remote-host buffer-position)
                              '(server-name-segment buffer-info-simple remote-host buffer-position))
                            '())
;;(doom-modeline-set-modeline 'my-simple-line 'default)

;;(custom-set-faces '(fringe ((t (:background "blue")))))

;; Add to `doom-modeline-mode-hook` or other hooks
(defun setup-custom-doom-modeline ()
  (doom-modeline-set-modeline 'my-simple-line 'default))

(when (display-graphic-p)
  (setup-custom-doom-modeline))

;; Globally hide the mode line
;;(setq-default mode-line-format nil)

;;(prelude-require-packages '(eev))

;;; 901-modeline.el ends here
