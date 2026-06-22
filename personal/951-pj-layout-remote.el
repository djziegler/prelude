;;; 951-pj-layout-remote.el --- personal convenience: reconcile remote layouts

;; pj-layout-reconcile-here (from pj) reconciles the DAEMON host (itasca). These
;; are my own convenience commands to reconcile a REMOTE host's layout from
;; within emacs (which runs on itasca): they ssh to the remote and run the client
;; THERE, injecting the remote GUI session's Wayland/D-Bus env (a non-interactive
;; ssh lacks it). Output goes to *pj-layout:<target>*.
;;
;; Caveats (this is the "push" direction, deliberately kept out of pj):
;;  - needs itasca -> HOST ssh to work (HOST reachable inbound). treehaus: yes;
;;    laptop: only when it's awake / on-net / reachable -- best effort.
;;  - the remote must be UNLOCKED (the window-layout extension is user-mode and
;;    its D-Bus is dead on the lock screen). I.e. run this while sitting at HOST.
;;  - env assumes the remote GUI session is seat0 (wayland-0, /run/user/$UID).

(defun pj-layout--reconcile-remote (host target)
  "ssh to HOST and run the layout client for TARGET, async; log to a buffer."
  (let* ((buf (get-buffer-create (format "*pj-layout:%s*" target)))
         (remote (concat
                  "export XDG_RUNTIME_DIR=/run/user/$(id -u); "
                  "export DBUS_SESSION_BUS_ADDRESS=unix:path=$XDG_RUNTIME_DIR/bus; "
                  "export WAYLAND_DISPLAY=wayland-0; export DISPLAY=:0; "
                  "python3 ~/projects/pj/layout/pj-layout-client.py "
                  (shell-quote-argument target))))
    (with-current-buffer buf (erase-buffer))
    (make-process
     :name (format "pj-layout-%s" target)
     :buffer buf
     :command (list "ssh" host remote)   ; one remote arg -> remote shell runs it
     :sentinel (lambda (p _e)
                 (when (memq (process-status p) '(exit signal))
                   (message "pj-layout %s: %s -- see %s"
                            target
                            (if (= 0 (process-exit-status p)) "done" "FAILED")
                            (buffer-name buf)))))
    (message "pj-layout: reconciling %s on %s..." target host)))

(defun pj-layout-reconcile-treehaus ()
  "Reconcile the treehaus layout (ssh treehaus + run the client there)."
  (interactive)
  (pj-layout--reconcile-remote "treehaus.entropy.org" "treehaus"))

(defun pj-layout-reconcile-laptop ()
  "Reconcile the laptop layout (ssh laptop + run the client there; best-effort)."
  (interactive)
  (pj-layout--reconcile-remote "laptop.entropy.org" "laptop"))

;; bind under the existing C-c w prefix (defined in 950-pj-layout.el)
(when (boundp 'pj-layout-prefix-map)
  (define-key pj-layout-prefix-map (kbd "T") #'pj-layout-reconcile-treehaus)
  (define-key pj-layout-prefix-map (kbd "L") #'pj-layout-reconcile-laptop))

;;; 951-pj-layout-remote.el ends here
