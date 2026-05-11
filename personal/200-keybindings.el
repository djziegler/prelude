;;; 200-keybindings.el --- Global keybindings + small command defuns
;;
;; All `global-set-key' calls live here, in original load order so
;; later bindings shadow earlier ones the same way they did before
;; the reorg (e.g. `\C-zc' is bound twice — point-to-register-c first,
;; then comment-line; comment-line wins because it comes later).
;;
;; Functions referenced by these bindings may live in other files
;; (e.g. point-to-register-a in 250-registers.el, chatgpt-shell in
;; 800-ai-tools.el). That's fine — `global-set-key' stores the
;; symbol; the function only needs to be fboundp at key-press time.

;; Anzu replaces query-replace with a count-as-you-type variant.
;;(global-anzu-mode +1)
(global-set-key [remap query-replace] 'anzu-query-replace)
(global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)

;; Don't like ace-window — keep plain other-window.
(global-set-key [remap other-window] 'other-window)

;; Undef M-c (previously `capitalize-word') so we can use it as a new
;; prefix char.
(global-unset-key "\M-c")

;;(global-unset-key "\C-ck")
;;(global-set-key "\C-ck" 'kill-buffer))

;;(global-unset-key "\C-z")     ; done in preload/aaa-first.el


;; --- C-z prefix bindings -------------------------------------------
;; We then remap c-: to C-z in the kitty terminal emulator, so most of
;; the C-z bindings below come from typing C-: physically.

;; (Previously \C-za was bound to 'aider-transient-menu' too, then
;; immediately shadowed by point-to-register-a. aidermacs is no
;; longer used; the dead binding has been dropped.)

(global-set-key "\C-za" 'point-to-register-a)
(global-set-key "\C-zb" 'point-to-register-b)
(global-set-key "\C-zc" 'point-to-register-c)        ; shadowed by 'comment-line below
(global-set-key "\C-z\C-a" 'jump-to-register-a)
(global-set-key "\C-z\C-b" 'jump-to-register-b)
(global-set-key "\C-z\C-c" 'jump-to-register-c)      ; shadowed by 'comment-or-uncomment-region below

;;(global-set-key "\C-zr" 'point-to-register)
;;(global-set-key "\C-zj" 'jump-to-register)
(global-set-key "\C-z:" 'avy-goto-char)
(global-set-key "\C-z'" 'avy-goto-char-2)
(global-set-key "\C-zt" 'avy-goto-char-timer)
(global-set-key "\C-o" 'avy-goto-char-2)
(global-set-key "\C-z\C-g" 'consult-git-grep)
(global-set-key "\C-z\C-c" 'comment-or-uncomment-region)
(global-set-key "\C-zc" 'comment-line)
(global-set-key "\C-z\C-z" 'suspend-frame)
(global-set-key "\C-z\C-s" 'ace-swap-window)
(global-set-key "\C-z\C-r" 'recompile)
(global-set-key "\C-zm" 'magit-status)

(global-set-key "\C-zis" 'chatgpt-shell)
(global-set-key "\C-zic" 'chatgpt-shell-prompt-compose)
(global-set-key "\C-zif" 'chatgpt-shell-quick-insert)
;;(global-set-key "\C-zig" 'gptel-add)

(global-set-key "\C-zo" 'recentf-open)


;; --- AVY (jump-to-character) configuration -------------------------

;; Any lower-case letter or number.  Numbers are specified in the keyboard
;; number-row order, so that the candidate following '9' will be '0'.
;; (setq avy-keys (nconc (number-sequence ?a ?z)
;;                       (number-sequence ?1 ?9)
;;                       '(?0)))
(setq avy-keys (nconc (number-sequence ?a ?z)))

;; Place candidates that are closest to point on shorter key sequences.
(setq avy-orders-alist
      '((avy-goto-char . avy-order-closest)
        (avy-goto-word-0 . avy-order-closest)))


;; --- C-c bindings --------------------------------------------------

;;(define-key global-map "\C-ce" 'eval-current-buffer)
;;(setq tramp-default-method "ssh")

(global-set-key "\C-c C-`" 'next-error)

(global-set-key "\C-c\C-c" 'comment-region)

(global-set-key "\C-cq" 'query-replace-regexp)

;; Diagnostic navigation lives on the standard `next-error' framework:
;;   M-g n  next-error      (flymake / compilation / grep / occur)
;;   M-g p  previous-error
;;   M-x flymake-show-buffer-diagnostics  — navigable list buffer
;;
;; Old `C-c f/p/n' bindings to flycheck-* removed: they were shadowed
;; in code buffers by crux (C-c f/n) and projectile (C-c p) so they
;; never fired, and eglot now feeds flymake natively.

(global-set-key "\C-cN" 'tags-loop-continue)

(global-set-key "\C-x1" 'delete-other-windows-vertically)


;; --- save-and-recompile -------------------------------------------
;; C-c c saves all modified buffers and reruns the last compile, while
;; remembering the window configuration so M-c c can restore it.

(defun save-and-recompile ()
  (interactive)
  (save-some-buffers 't)
  (setq pre-compile-window-configuration (current-window-configuration))
                                        ;(condition-case nil
                                        ;     (kill-compilation)
                                        ;   (error nil))
  (recompile))

(global-set-key "\C-cc" 'save-and-recompile)

(defun restore-pre-compile-window-configuration ()
  (interactive)
  (set-window-configuration pre-compile-window-configuration))

(global-set-key "\M-cc" 'restore-pre-compile-window-configuration)


;;(global-set-key "\C-co" 'other-frame)
;;(global-set-key "\C-cr" 'restart-compile)
(global-set-key "\C-cg" 'goto-line)

(global-set-key "\M-*" 'pop-tag-mark)

;;; 200-keybindings.el ends here
