;;(require 'framemove)
(windmove-default-keybindings)
;;(setq framemove-hook-into-windmove t)

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

;(global-set-key "\M-\"" 'windmove-left)          ; move to left windnow
;(global-set-key "\M-g" 'windmove-right)        ; move to right window
;(global-set-key "\M-r" 'windmove-up)              ; move to upper window
;(global-set-key "\M-v" 'windmove-down)          ; move to downer window

(defun windmove-top-left ()
  (interactive)
  (ignore-errors (windmove-left))
  (ignore-errors (windmove-left))
  (ignore-errors (windmove-up))
  (ignore-errors (windmove-up))
)

(defun windmove-middle-left ()
  (interactive)
  (windmove-top-left)
  (ignore-errors (windmove-down)))

(defun windmove-bottom-left ()
  (interactive)
  (ignore-errors (windmove-left))
  (ignore-errors (windmove-left))
  (ignore-errors (windmove-down))
  (ignore-errors (windmove-down))
)

(defun windmove-top-right ()
  (interactive)
  (ignore-errors (windmove-right))
  (ignore-errors (windmove-right))
  (ignore-errors (windmove-up))
  (ignore-errors (windmove-up))
)

(defun windmove-middle-right ()
  (interactive)
  (windmove-top-right)
  (ignore-errors (windmove-down)))

(defun windmove-bottom-right ()
  (interactive)
  (ignore-errors (windmove-right))
  (ignore-errors (windmove-right))
  (ignore-errors (windmove-down))
  (ignore-errors (windmove-down))
)

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
