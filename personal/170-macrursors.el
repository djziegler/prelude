;;; 170-macrursors.el --- Multiple cursors via kmacros  -*- lexical-binding: t; -*-

;; macrursors: like multiple-cursors.el but the underlying mechanism is
;; just keyboard macros recorded at the primary cursor and replayed at
;; each mark. Sidesteps mc.el's per-command allowlist and plays better
;; with LSP/company. Installed via straight (not on MELPA).

(straight-use-package '(macrursors :host github :repo "corytertel/macrursors"))
(require 'macrursors)

;; Show a faint cursor at each mark while editing.
(dolist (mode '(corfu-mode))
  (when (fboundp mode)
    (add-hook 'macrursors-pre-finish-hook mode)
    (add-hook 'macrursors-post-finish-hook mode)))

;; Workflow:
;;   1. Mark instances/lines (one of the bindings below).
;;   2. Edit -- macrursors enters a macro-recording state automatically
;;      after the first mark command.
;;   3. RET (or `macrursors-end') replays the macro at every mark.
;;   4. C-g aborts (`macrursors-early-quit').
(global-set-key (kbd "C-;")     #'macrursors-mark-all-lines-or-instances)
(global-set-key (kbd "C-M-;")   #'macrursors-mark-all-instances-of)
(global-set-key (kbd "C->")     #'macrursors-mark-next-instance-of)
(global-set-key (kbd "C-<")     #'macrursors-mark-previous-instance-of)
(global-set-key (kbd "C-c m l") #'macrursors-mark-next-line)
(global-set-key (kbd "C-c m p") #'macrursors-mark-previous-line)
(global-set-key (kbd "C-c m s") #'macrursors-mark-all-symbols)
(global-set-key (kbd "C-c m w") #'macrursors-mark-all-words)
(global-set-key (kbd "C-c m d") #'macrursors-mark-all-defuns)
(global-set-key (kbd "C-c m i") #'macrursors-mark-from-isearch)

(provide '170-macrursors)
;;; 170-macrursors.el ends here
