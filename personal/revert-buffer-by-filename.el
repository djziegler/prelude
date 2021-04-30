;; Call from shell as follows:
;;   emacsclient -e '(revert-buffer-by-filename "~/entropy/docs/new-dumping-model.org")'
;; Now also preserves current line number in (one) window that is displaying buffer -
;;   so should probably rename.
(defun revert-buffer-by-filename (filename)
       "Revert the buffer that is visiting a specified filename (if any)"
       (interactive "fFilename to revert: ")
       (let ((buffer (get-file-buffer filename)))
         (if buffer
             (progn
               (message "Reverting `%s'" filename)
               (with-current-buffer buffer
                 (let ((buffer-window (get-buffer-window nil t)))
                   (progn
                     ;(message "Buffer window `%s'" buffer-window)
                     (cond (buffer-window
                            (with-selected-window buffer-window
                              (let ((preRevertLineNum (line-number-at-pos)))
                                (progn
                                  ;(message "Line was `%s'" preRevertLineNum)
                                  (revert-buffer t t)
                                  (goto-char (point-min))
                                  (forward-line (1- preRevertLineNum))
                                  ))))
                           (t (revert-buffer t t))))))))))
