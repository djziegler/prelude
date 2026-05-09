;;; 250-registers.el --- Three named-register helpers (a, b, c)
;;
;; A small convenience: store/jump to three fixed registers without
;; having to type the register letter each time. The keybindings live
;; in 200-keybindings.el; the symbols below are looked up at key-press
;; time, so this file's load-order relative to 200- doesn't matter.

(defun point-to-register-a ()
  (interactive)
  (set-register ?a (point-marker)))

(defun jump-to-register-a ()
  (interactive)
  (register-val-jump-to (get-register ?a) nil))

(defun point-to-register-b ()
  (interactive)
  (set-register ?b (point-marker)))

(defun jump-to-register-b ()
  (interactive)
  (register-val-jump-to (get-register ?b) nil))

(defun point-to-register-c ()
  (interactive)
  (set-register ?c (point-marker)))

(defun jump-to-register-c ()
  (interactive)
  (register-val-jump-to (get-register ?c) nil))

;;; 250-registers.el ends here
