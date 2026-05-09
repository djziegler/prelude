;;; 110-emacs-niceties.el --- Emacs / Prelude global preferences
;;
;; Small, mostly order-independent settings: turn off prelude features
;; we don't want, set recentf size, browse-url program, format-on-save
;; defaults, server-start, frame title, and a few utility defuns. No
;; package side-effects beyond `setq' and friends.

;; Prelude includes super-save-mode which saves buffers whenever they
;; lose focus — disable it. May need to turn on regular auto-save mode
;; after doing this.
;;(super-save-mode -1)

;; Don't reformat source code on save (only affects typescript at the moment)
(setq prelude-format-on-save nil)
(setq rust-format-on-save nil)

;; Stop warning me about using up arrow etc.
(setq prelude-guru nil)

;; Don't like all the whitespace coloring
(setq prelude-whitespace nil)

;; Don't put active region in X clipboard (slow with transient-mark-mode over
;; remote X) - https://emacs.stackexchange.com/questions/57473/throttle-transient-mark-mode-highlighting
(setq select-active-regions nil)

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")

(setq recentf-max-saved-items 1000)
(setq recentf-max-menu-items 100)


;; Server / external editor integration. emacsclient (used as $EDITOR)
;; talks to this server. EMACS_SERVER_NAME=work emacs lets you run
;; multiple named servers and target one from the shell:
;;   EMACS_SERVER_NAME=work emacs ...
;;   emacsclient -nw -s work
(setenv "PAGER" "/bin/cat")
(setenv "EDITOR" "/usr/bin/emacsclient") ; `which emacsclient`
(when (getenv "EMACS_SERVER_NAME")
  (setq server-name (getenv "EMACS_SERVER_NAME")))
(server-start)

(setq-default frame-title-format
              '(:eval (concat
                       (when (getenv "EMACS_SERVER_NAME")
                         (format "[%s] " server-name))
                       "%f [%m]")))


(defun revert-all-buffers ()
  "Refreshes all open buffers from their respective files."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (buffer-file-name) (file-exists-p (buffer-file-name)) (not (buffer-modified-p)))
        (revert-buffer t t t) )))
  (message "Refreshed open files.") )

;;; 110-emacs-niceties.el ends here
