;;; 950-pj-layout.el --- load + keybind the pj per-workspace layout reconciler

;; Loads the layout subsystem from pj (graceful no-op if pj isn't checked out
;; on this machine, like the pj-modeline load in 901-modeline.el) and binds it
;; under the C-c w prefix, plus C-z c to jump back to the current desktop's
;; claude terminal. The manifest is personal config at
;; ~/.config/claude-layout.json (defcustom default in pj-layout.el).

(load (expand-file-name "~/projects/pj/layout/pj-layout.el") 'noerror 'nomessage)

(when (featurep 'pj-layout)
  (define-prefix-command 'pj-layout-prefix-map)
  (global-set-key (kbd "C-c w") 'pj-layout-prefix-map)
  ;; w = workspace/window layout
  (define-key pj-layout-prefix-map (kbd "t") #'pj-layout-toggle)          ; toggle an instance on/off
  (define-key pj-layout-prefix-map (kbd "d") #'pj-layout-dry-run)         ; preview the plan
  (define-key pj-layout-prefix-map (kbd "r") #'pj-layout-refresh)         ; re-assert frame content
  (define-key pj-layout-prefix-map (kbd "a") #'pj-layout-reconcile-here) ; apply (run client on this host)
  ;; Jump the selected window back to this desktop's *claude:ID* terminal, when
  ;; it's been switched away and the buffer switcher won't offer it (it's still
  ;; live in the overview). C-z is the personal prefix; c = "claude" (replaces
  ;; comment-line, which stays on C-z C-c as comment-or-uncomment-region).
  (global-set-key (kbd "C-z c") #'pj-layout-switch-to-claude))

;;; 950-pj-layout.el ends here
