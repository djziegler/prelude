;;; 600-eshell.el --- eshell `eshell-here' + nushell launcher
;;
;; `C-z !' opens an eshell in a small window at the bottom whose name
;; is the current buffer's directory. `eshell/x' is an in-shell exit
;; helper. `nushell' spawns a `*nushell*' shell using the `nu' binary
;; instead of bash.

(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
    current buffer's file. The eshell is renamed to match that
    directory to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (height (/ (window-total-height) 3))
         (name   (car (last (split-string parent "/" t)))))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))

    (insert (concat "ls"))
    (eshell-send-input)))

(global-set-key (kbd "C-z !") 'eshell-here)

(defun eshell/x ()
  (insert "exit")
  (eshell-send-input)
  (delete-window))


;; Eshell shorthand makes shell aliases (e.g. for `~') feel less
;; surprising in eshell.
(setq-default eshell-buffer-shorthand t)


(defun nushell ()
  (interactive)
  (let ((explicit-shell-file-name "nu"))
    (shell "*nushell*")))

;;; 600-eshell.el ends here
