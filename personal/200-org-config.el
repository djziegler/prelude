(add-hook 'org-mode-hook (lambda () (local-unset-key [C-M-j])))
(add-hook 'org-mode-hook (lambda () (local-set-key [C-M-j] 'org-insert-heading)))

(add-hook 'org-mode-hook (lambda () (local-unset-key [C-\'])))
(add-hook 'org-mode-hook (lambda () (local-unset-key [?\C-\'])))
          
;;(add-hook 'org-mode-hook (lambda () (local-unset-key "\C-'")))

                                        ;(add-hook 'org-mode-hook (lambda () (auto-revert-mode 1)))
(setq org-todo-keywords
      '((sequence "WAITING(w)" "LATER(l)" "SOMEDAY(s)" "TODO(t)" "TODAY(o)" "NEXT(n)" "|" "DONE(d)" "DEFERRED(e)" "CANCELLED(c)")))

(add-hook 'org-mode-hook (lambda () (define-key org-mode-map (kbd "\C-cH") 'org-insert-heading-after-current)))

(add-hook 'org-mode-hook (lambda () (define-key org-mode-map (kbd "\C-ch") 'org-insert-subheading)))

(setq org-highest-priority ?A)
(setq org-lowest-priority ?D)
(setq org-default-priority ?C)
(setq org-directory "~/org")
(setq org-startup-indented t)

(setq org-agenda-files
      '("~/org"
        "~/org/computing"
        "~/org/cycling"
        "~/org/etc"
        "~/org/home"
        "~/org/projects"
        "~/org/study"
        "~/org/trips"
        "~/entropy/docs"))

(setq org-default-notes-file (concat org-directory "/capture.org"))
(define-key global-map "\C-ct" 'org-capture)

(setq org-refile-targets '((nil :maxlevel . 9)
			   (org-agenda-files :maxlevel . 9)))
(setq org-outline-path-complete-in-steps nil)         ; Refile in a single go
;;(setq org-refile-use-outline-path t)                  ; Show full paths for refiling
(setq org-refile-use-outline-path 'file)                  ; Show full paths for refiling

