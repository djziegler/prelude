;;; 300-windmove.el --- Window navigation: windmove + framemove + winner
;;
;; Was personal/300-windmove-config.el. Bundles three related concerns:
;; windmove (M-arrow / M-h M-' M-u M-m to move between windows),
;; framemove (extends windmove across frame boundaries), and winner
;; (undo/redo window configurations). Also disables M-h in modes that
;; would otherwise eat it (org-mode, nxml-mode).
;;
;; framemove is loaded from personal/preload/framemove.el (vendored
;; library), so it's available by the time this file runs.

(require 'cl)
(require 'framemove)
                                        ;(require 'ansi-term)

(windmove-default-keybindings)
(setq framemove-hook-into-windmove t)

                                        ; for use on regular keyboard
(global-set-key [M-left] 'windmove-left)          ; move to left windnow
(global-set-key [M-right] 'windmove-right)        ; move to right window
(global-set-key [M-up] 'windmove-up)              ; move to upper window
(global-set-key [M-down] 'windmove-down)          ; move to downer window

                                        ; for use on datahand
(global-set-key "\M-h" 'windmove-left)          ; move to left windnow
(global-set-key "\M-\'" 'windmove-right)        ; move to right window
(global-set-key "\M-u" 'windmove-up)              ; move to upper window
(global-set-key "\M-m" 'windmove-down)          ; move to downer window

(add-hook 'term-load-hook
          (lambda ()
                                        ; for use on regular keyboard to escape ansi-term
            (define-key term-raw-map [M-left] 'windmove-left)          ; move to left windnow
            (define-key term-raw-map [M-right] 'windmove-right)        ; move to right window
            (define-key term-raw-map [M-up] 'windmove-up)              ; move to upper window
            (define-key term-raw-map [M-down] 'windmove-down)          ; move to downer window

                                        ; for use on datahand to escape ansi-term
            (define-key term-raw-map "\M-h" 'windmove-left)          ; move to left windnow
            (define-key term-raw-map "\M-\'" 'windmove-right)        ; move to right window
            (define-key term-raw-map "\M-u" 'windmove-up)              ; move to upper window
            (define-key term-raw-map "\M-m" 'windmove-down)          ; move to downer window
            ))



                                        ;(global-set-key "\M-\"" 'windmove-left)          ; move to left windnow
                                        ;(global-set-key "\M-g" 'windmove-right)        ; move to right window
                                        ;(global-set-key "\M-r" 'windmove-up)              ; move to upper window
                                        ;(global-set-key "\M-v" 'windmove-down)          ; move to downer window

(defun windmove-top-left ()
  (interactive)
  (ignore-errors (windmove-left))
  (ignore-errors (windmove-left))
  (ignore-errors (windmove-up))
  (ignore-errors (windmove-up)))

(defun windmove-middle-left ()
  (interactive)
  (windmove-top-left)
  (ignore-errors (windmove-down)))

(defun windmove-bottom-left ()
  (interactive)
  (ignore-errors (windmove-left))
  (ignore-errors (windmove-left))
  (ignore-errors (windmove-down))
  (ignore-errors (windmove-down)))

(defun windmove-top-right ()
  (interactive)
  (ignore-errors (windmove-right))
  (ignore-errors (windmove-right))
  (ignore-errors (windmove-up))
  (ignore-errors (windmove-up)))

(defun windmove-middle-right ()
  (interactive)
  (windmove-top-right)
  (ignore-errors (windmove-down)))

(defun windmove-bottom-right ()
  (interactive)
  (ignore-errors (windmove-right))
  (ignore-errors (windmove-right))
  (ignore-errors (windmove-down))
  (ignore-errors (windmove-down)))

(global-set-key "\C-c1" 'windmove-top-left)
(global-set-key "\C-c2" 'windmove-top-right)
(global-set-key "\C-c3" 'windmove-bottom-left)
(global-set-key "\C-c4" 'windmove-bottom-right)

;;(key-chord-define-global "ZI" 'windmove-top-left)
;;(key-chord-define-global "ZK" 'windmove-middle-left)
;;(key-chord-define-global "Z<" 'windmove-bottom-left)
;;(key-chord-define-global "ZO" 'windmove-top-right)
;;(key-chord-define-global "ZL" 'windmove-middle-right)
;;(key-chord-define-global "Z>" 'windmove-bottom-right)


;; --- winner-mode --------------------------------------------------
;; Window-configuration undo/redo. C-M-h / C-M-' to walk back and
;; forward through previously-seen layouts.

(when (fboundp 'winner-mode)
  (winner-mode 1))

(global-set-key (kbd "C-M-h") 'winner-undo)
(global-set-key (kbd "C-M-'") 'winner-redo)


;; --- M-h compat ---------------------------------------------------
;; org-mode and nxml-mode bind M-h to mark-paragraph-style commands
;; that conflict with our windmove-left binding. Locally unset so the
;; global windmove-left wins.

(add-hook 'org-mode (lambda () (local-unset-key [M-left])))
(add-hook 'org-mode (lambda () (local-unset-key [M-right])))

(add-hook 'org-mode-hook (lambda () (local-unset-key [M-h])))
(add-hook 'org-mode-hook (lambda () (local-unset-key "\M-h")))

(add-hook 'nxml-mode-hook (lambda () (local-unset-key [M-h])))
(add-hook 'nxml-mode-hook (lambda () (local-unset-key "\M-h")))

                                        ;(add-hook 'org-mode-hook (lambda () (define-key 'org-mode-map [M-h] 'windmove-left)))
                                        ;(add-hook 'org-mode-hook (lambda () (local-set-key [M-h] 'windmove-left)))

;;; 300-windmove.el ends here
