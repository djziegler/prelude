;;; 400-cpp.el --- C / C++ indentation + cff (find-other-file)
;;
;; Sets c-basic-offset and forces innamespace indentation to 0 (don't
;; double-indent the body of `namespace foo { ... }'). Also wires
;; cff-find-other-file (vendored at preload/cff.el) onto C-z h in
;; c-mode-common.

(set-variable `c-basic-offset 2)
(c-set-offset 'innamespace 0)
(setq-default c-offsets-alist
              '((innamespace . 0)))
(add-hook 'c++-mode-hook
          (lambda ()
            (c-set-offset 'innamespace 0)))
(setq treesit-c++-indent-namespace-contents nil)



;;(defconst my-cc-style
;;  '("cc-mode"
;;    (inlambda . 0) ; no extra indent for lambda
;;    (c-offsets-alist . ((innamespace . [0])))))

(defconst my-cc-style
  '("cc-mode"
    (c-offsets-alist . ((innamespace . [0])))))

(c-add-style "my-cc-mode" my-cc-style)


;;(defvar my-cpp-other-file-alist
;;  '(("\\.cpp\\'" (".hpp"))
;;    ("\\.hpp\\'" (".cpp"))))

;;(setq-default ff-other-file-alist 'my-cpp-other-file-alist)


(add-hook 'c-mode-common-hook
          (lambda ()
            (local-set-key  (kbd "C-z h") 'cff-find-other-file)))

;;; 400-cpp.el ends here
