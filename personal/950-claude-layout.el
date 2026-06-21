;;; 950-claude-layout.el --- load + keybind the pj per-workspace layout reconciler

;; Loads the layout subsystem from pj (graceful no-op if pj isn't checked out
;; on this machine, like the pj-modeline load in 901-modeline.el) and binds it
;; under the C-c w prefix. The manifest is personal config at
;; ~/.config/claude-layout.json (defcustom default in claude-layout.el).

(load (expand-file-name "~/projects/pj/layout/claude-layout.el") 'noerror 'nomessage)

(when (featurep 'claude-layout)
  (define-prefix-command 'layout-prefix-map)
  (global-set-key (kbd "C-c w") 'layout-prefix-map)
  ;; w = workspace/window layout
  (define-key layout-prefix-map (kbd "t") #'layout-toggle)          ; toggle an instance on/off
  (define-key layout-prefix-map (kbd "d") #'layout-dry-run)         ; preview the plan
  (define-key layout-prefix-map (kbd "r") #'layout-refresh)         ; re-assert frame content
  (define-key layout-prefix-map (kbd "a") #'layout-reconcile-here)) ; apply (run client on this host)

;;; 950-claude-layout.el ends here
