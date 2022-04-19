(defun get-cargo-buffers ()
  (seq-filter
   (lambda (buf) (string= (with-current-buffer buf major-mode) "cargo-process-mode"))
   (buffer-list)))

(defun get-active-cargo-buffer ()
  (let* ((cargo-buffers (get-cargo-buffers))
         (cargo-buffers-len (length cargo-buffers)))
    (cond ((eq cargo-buffers-len 0)
           (error "No active cargo buffers"))
          ((> cargo-buffers-len 1)
           (error "Multiple active cargo buffers"))
          (t (car cargo-buffers)))))

(defun recompile-active-cargo-buffer ()
  (interactive)
  (with-current-buffer (get-active-cargo-buffer)
    (recompile)))

(global-set-key "\C-zg" 'recompile-active-cargo-buffer)
;;(global-set-key (kbd "<f1>") 'recompile-active-cargo-buffer)

(defun select-cargo-window ()
  (interactive)
  (select-window (get-buffer-window nil (get-active-cargo-buffer))))

(global-set-key "\C-zd" 'rust-debug-txt-to-org)

(defun rust-debug-txt-to-org ()
  (interactive)

  (let* ((cargo-buffer (get-active-cargo-buffer))
         (debug-buffer (get-buffer-create "*Debug*")))

    (with-current-buffer debug-buffer
      (fundamental-mode)
      (erase-buffer)
      (insert-buffer-substring-no-properties cargo-buffer)

      (goto-char (point-min))
      (while (re-search-forward "Some(\n[ ]+\\(.*\\)\n[ ]+),$" nil t)
        (replace-match "Some(\\1)" nil nil))

      (goto-char (point-min))
      (while (re-search-forward "[ ]?[{(]$" nil t)
        (replace-match "" nil nil))

      (goto-char (point-min))
      (while (re-search-forward "[ ]?\\[$" nil t)
        (replace-match "" nil nil))
      
      (goto-char (point-min))
      (while (re-search-forward "^[ ]*[})],?\n" nil t)
        (replace-match "" nil nil))

      (goto-char (point-min))
      (while (re-search-forward "^[ ]*],?\n" nil t)
        (replace-match "" nil nil))
      
      (goto-char (point-min))  
      (while (re-search-forward "^" nil t)
        (replace-match "* " nil nil))

      (goto-char (point-min))  
      (while (re-search-forward "    " nil t)
        (replace-match "*" nil nil))

      (goto-char (point-min))

      (org-mode)
      ))
  )

;;(global-set-key "\C-zd" 'rust-debug-txt-to-org)
(global-set-key "\C-zd" 'rust-debug-txt-to-org)
