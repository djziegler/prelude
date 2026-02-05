(require 'prelude-packages "~/.emacs.d/core/prelude-packages.el" t)
(prelude-require-packages '(zig-mode))
(prelude-require-packages '(lsp-ivy))

(prelude-require-packages '(use-package))


;;(add-hook 'zig-mode (lambda () (kill-local-variable 'compile-command)))
;;(add-hook 'zig-mode (lambda () (setq-local compile-command "BAng")))

(use-package all-the-icons
  :if (display-graphic-p))

;; sudo apt install libtool libtool-bin
(use-package vterm :ensure t)

(defun my/vterm-mode-setup ()
  "Setup vterm keybindings.
These explicit bindings fix keys in terminal frames and are harmless in GUI."
  (local-set-key (kbd "C-c C-t") 'vterm-copy-mode)
  (local-set-key (kbd "RET") #'vterm-send-return)
  (local-set-key (kbd "DEL") #'vterm-send-backspace)
  (local-set-key [up] #'vterm-send-up)
  (local-set-key [down] #'vterm-send-down)
  (local-set-key [left] #'vterm-send-left)
  (local-set-key [right] #'vterm-send-right)
  (local-set-key [tab] (lambda () (interactive) (vterm-send-key "<tab>")))
  (local-set-key (kbd "TAB") (lambda () (interactive) (vterm-send-key "<tab>")))
  (local-set-key (kbd "C-q") #'vterm-send-next-key)
  (local-set-key (kbd "C-e") (lambda () (interactive) (vterm-send-key "<escape>"))))

(add-hook 'vterm-mode-hook #'my/vterm-mode-setup)
;;  "M-h" "M-'" "M-m" "M-u"

(use-package doom-modeline
             :ensure t
             :init (doom-modeline-mode 1))

(use-package chatgpt-shell)

;;(setq chatgpt-shell-openai-key (getenv "OPENAI_API_KEY"))

;; (defun chatgpt-shell-openai-models ()
;;   "Build a list of all OpenAI LLM models available."
;;   ;; Context windows have been verified as of 11/26/2024.
;;   (list (chatgpt-shell-openai-make-model
;;          :version "deepseek-chat"
;;          :token-width 3
;;          ;; https://platform.openai.com/docs/models/gpt-4o
;;          :context-window 128000)
;;         (chatgpt-shell-openai-make-model
;;          :version "deepseek-reasoner"
;;          :token-width 3
;;          ;; https://platform.openai.com/docs/models/gpt-01
;;          :context-window 128000
;;          :validate-command #'chatgpt-shell-validate-no-system-prompt)))


;; Straight package manager
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))



(use-package aidermacs
  :straight (:host github :repo "MatthewZMD/aidermacs" :files ("*.el"))
  :config
  (setq aidermacs-default-model "sonnet")
  (global-set-key (kbd "C-c a") 'aidermacs-transient-menu)
                                        ; Ensure emacs can access *_API_KEY through .bashrc or setenv
  ;;(setenv "ANTHROPIC_API_KEY" anthropic-api-key)
                                        ; See the Configuration section below
  (setq aidermacs-auto-commits t)
  (setq aidermacs-use-architect-mode t))


;; Define your custom doom-modeline
;;(doom-modeline-def-modeline 'my-simple-line
;;                            '(bar matches buffer-info remote-host buffer-position parrot selection-info)
;;                            '(misc-info minor-modes input-method buffer-encoding major-mode process vcs checker))

;;(setq doom-modeline-height 250)
;;(setq doom-modeline-hud 't)


(doom-modeline-def-segment buffer-info-test
  "Display only the current buffer's name, but with fontification."
  (concat
   (propertize (format " %s " "                                        ") 'face
               (if (doom-modeline--active)
                   'doom-modeline-buffer-major-mode
                 'mode-line-inactive))))

(doom-modeline-def-segment server-name-segment
  "Display the Emacs server name, only if EMACS_SERVER_NAME was set."
  (when (getenv "EMACS_SERVER_NAME")
    (propertize (format "[%s] " server-name) 'face
                (if (doom-modeline--active)
                    'doom-modeline-buffer-major-mode
                  'mode-line-inactive))))

(doom-modeline-def-modeline 'my-simple-line
                            '(server-name-segment buffer-info-simple remote-host buffer-position)
                            '())
;;(doom-modeline-set-modeline 'my-simple-line 'default)

;;(custom-set-faces '(fringe ((t (:background "blue")))))

;; Add to `doom-modeline-mode-hook` or other hooks
(defun setup-custom-doom-modeline ()
  (doom-modeline-set-modeline 'my-simple-line 'default))

(when (display-graphic-p)
  (setup-custom-doom-modeline))

;; Globally hide the mode line
;;(setq-default mode-line-format nil)

;;(prelude-require-packages '(eev))

;;window-divider-default-bottom-width and window-divider-default-right-width
;;(setq window-divider-default-bottom-width 1
      
;; Fancy query replace
;;(global-anzu-mode +1)
(global-set-key [remap query-replace] 'anzu-query-replace)
(global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)

;; Prelude includes super-save-mode which saves buffers whenever they lose focus -
;; disable it.  May need to turn on regular auto-save mode after doing this.
;;(super-save-mode -1)

;; Don't reformat source code on save (only affects typescript at the moment)
(setq prelude-format-on-save nil)
(setq rust-format-on-save nil)

;;(prelude-require-packages '(framemove))

;; Don't like ace-window
(global-set-key [remap other-window] 'other-window)

;; Stop warning me about using up arrow etc.
(setq prelude-guru nil)

;; Don't like all the whitespace coloring
(setq prelude-whitespace nil)


;; Don't put active region in X clipboard (slow with transient-mark-mode over
;; remote X) - https://emacs.stackexchange.com/questions/57473/throttle-transient-mark-mode-highlighting
(setq select-active-regions nil)

;;(package-initialize)
;;(package-install 'use-package)

;;(set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-18-*-*-*-m-0-iso10646-1" nil t)
;;(set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-32-*-*-*-m-0-iso10646-1" nil t)

;;LG 65'
;;(set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-28-*-*-*-m-0-iso10646-1" nil )
;; -26- was 84 chars wide on LG 65' with 3x split
;; trying -25- now.
(set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-25-*-*-*-m-0-iso10646-1" nil )
(set-face-attribute 'mode-line nil :font "DejaVu Sans Mono-10")

;;NS 1080 
;;(set-frame-font "-DAMA-Ubuntu Mono-bold-normal-normal-*-23-*-*-*-m-0-iso10646-1" nil t)

;;BenQ monitor
;(set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-37-*-*-*-m-0-iso10646-1" nil t)

(defun set-benq-frame-font ()
  (interactive)
  (set-face-attribute 'default (selected-frame) :font "Ubuntu Mono" :height 420 :weight 'medium))

;(set-frame-font "-DAMA-Ubuntu Mono-normal-normal-normal-*-37-*-*-*-m-0-iso10646-1" nil t)


(load-theme 'oled-dark t)

(defun set-background-color-to-black ()
  (interactive)
  (set-background-color "black"))

(global-set-key "\C-c\C-b" 'set-background-color-to-black)

(set-background-color-to-black)

;; undef M-c (previously captialize word) so we can use it as a new prefix char
(global-unset-key "\M-c")

;;(global-unset-key "\C-ck")
;;(global-set-key "\C-ck" 'kill-buffer))

;;(global-unset-key "\C-z")


;;(defun point-to-register-a ()
;;  (interactive)
;;  (point-to-register ?a))

(defun point-to-register-a ()
  (interactive)
  (set-register ?a (point-marker)))

(defun jump-to-register-a ()
   (interactive)
   (register-val-jump-to (get-register ?a) nil))

(defun point-to-register-b ()
  (interactive)
  (set-register ?b (point-marker)))

(defun jump-to-register-b ()
   (interactive)
   (register-val-jump-to (get-register ?b) nil))

(defun point-to-register-c ()
  (interactive)
  (set-register ?c (point-marker)))

(defun jump-to-register-c ()
   (interactive)
   (register-val-jump-to (get-register ?c) nil))



(global-set-key "\C-za" 'aider-transient-menu)

;; We then remap c-: to C-z in kitty terminal emulator.
(global-set-key "\C-za" 'point-to-register-a)
(global-set-key "\C-zb" 'point-to-register-b)
(global-set-key "\C-zc" 'point-to-register-c)
(global-set-key "\C-z\C-a" 'jump-to-register-a)
(global-set-key "\C-z\C-b" 'jump-to-register-b)
(global-set-key "\C-z\C-c" 'jump-to-register-c)

;;(global-set-key "\C-zr" 'point-to-register)
;;(global-set-key "\C-zj" 'jump-to-register)
(global-set-key "\C-z:" 'avy-goto-char)
(global-set-key "\C-z'" 'avy-goto-char-2)
(global-set-key "\C-zt" 'avy-goto-char-timer)
(global-set-key "\C-o" 'avy-goto-char-2)
(global-set-key "\C-z\C-g" 'counsel-git-grep)
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

(global-set-key "\C-zs" 'lsp-ivy-workspace-symbol)
(global-set-key "\C-zS" 'lsp-ivy-global-workspace-symbol)

;; AVY
;; Any lower-case letter or number.  Numbers are specified in the keyboard
;; number-row order, so that the candidate following '9' will be '0'.
;; (setq avy-keys (nconc (number-sequence ?a ?z)
;;                       (number-sequence ?1 ?9)
;;                       '(?0)))
(setq avy-keys (nconc (number-sequence ?a ?z)))


;; If you would like to have the places that are closest to the point have shorter key sequences, you can customize it like this:
(setq avy-orders-alist
      '((avy-goto-char . avy-order-closest)
        (avy-goto-word-0 . avy-order-closest)))


(when (fboundp 'winner-mode)
  (winner-mode 1))

(global-set-key (kbd "C-M-h") 'winner-undo)
(global-set-key (kbd "C-M-'") 'winner-redo)

;;(define-key global-map "\C-ce" 'eval-current-buffer)

;;(setq tramp-default-method "ssh")

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")

(set-cursor-color "red")

;;(global-hl-line-mode 1)
;;(set-face-background 'hl-line "#111111")


;;(setq ring-bell-function 'ignore)

;;(setq-default c-electric-flag nil)

(global-set-key "\C-c C-`" 'next-error)

(global-set-key "\C-c\C-c" 'comment-region)

(global-set-key "\C-cq" 'query-replace-regexp)

(add-hook 'org-mode (lambda () (local-unset-key [M-left])))
(add-hook 'org-mode (lambda () (local-unset-key [M-right])))

(add-hook 'org-mode-hook (lambda () (local-unset-key [M-h])))
(add-hook 'org-mode-hook (lambda () (local-unset-key "\M-h")))

(add-hook 'nxml-mode-hook (lambda () (local-unset-key [M-h])))
(add-hook 'nxml-mode-hook (lambda () (local-unset-key "\M-h")))

                                        ;(add-hook 'org-mode-hook (lambda () (define-key 'org-mode-map [M-h] 'windmove-left)))

                                        ;(add-hook 'org-mode-hook (lambda () (local-set-key [M-h] 'windmove-left)))


(global-set-key "\C-cf" 'flycheck-first-error)
(global-set-key "\C-cp" 'flycheck-previous-error)
(global-set-key "\C-cn" 'flycheck-next-error)

(global-set-key "\C-cN" 'tags-loop-continue)

(global-set-key "\C-x1" 'delete-other-windows-vertically)

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
  (set-window-configuration pre-compile-window-configuration)
  )

(global-set-key "\M-cc" 'restore-pre-compile-window-configuration)

(setq recentf-max-saved-items 1000)
(setq recentf-max-menu-items 100)

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



;;(global-set-key "\C-co" 'other-frame)
;(global-set-key "\C-cr" 'restart-compile)
(global-set-key "\C-cg" 'goto-line)

(global-set-key "\C-cy" 'tide-project-errors)

(global-set-key "\M-*" 'pop-tag-mark)

(setenv "PAGER" "/bin/cat")
(setenv "EDITOR" "/usr/bin/emacsclient") ; `which emacsclient`
;; to use: EMACS_SERVER_NAME=work emacs
;; emacsclient -nw -s work
(when (getenv "EMACS_SERVER_NAME")
  (setq server-name (getenv "EMACS_SERVER_NAME")))
(server-start)

(defun revert-all-buffers ()
    "Refreshes all open buffers from their respective files."
    (interactive)
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (and (buffer-file-name) (file-exists-p (buffer-file-name)) (not (buffer-modified-p)))
          (revert-buffer t t t) )))
    (message "Refreshed open files.") )

(tool-bar-mode -1)
(menu-bar-mode -1)

(setq-default frame-title-format
              '(:eval (concat
                       (when (getenv "EMACS_SERVER_NAME")
                         (format "[%s] " server-name))
                       "%f [%m]")))

(add-to-list 'auto-mode-alist '("\\.tsx$" . typescript-mode))
;; (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
;; (add-hook 'web-mode-hook
;;           (lambda ()
;;             (when (string-equal "tsx" (file-name-extension buffer-file-name))
;;               (setup-tide-mode))))

(setq-default eshell-buffer-shorthand t)


;; error: The module's source code could not be parsed: Expected '(', got 'async' at file:///home/dziegler/titan1c/experiments/http-server.ts:81:1
(require 'compile)
;;(add-hook 'typescript-mode-hook (lambda ()
;;                           (add-to-list 'compilation-error-regexp-alist '("^error: .* at file://\\([^:]+\\):\\([0-9]+\\):[0-9]+$" 1 2))))

;; error: TS2339 [ERROR]: Property 'entries' does not exist on type 'Promise<FormData>'.
;;                data = Object.fromEntries(await (denoRequest.formData()).entries());
;;                                                                         ~~~~~~~
;;    at file:///home/dziegler/titan1c/experiments/http-server.ts:74:74
;;
;; TS2773 [ERROR]:     Did you forget to use 'await'?
;;                    data = Object.fromEntries(await (denoRequest.formData()).entries());
;;                                                                             ~~~~~~~
;;        at file:///home/dziegler/titan1c/experiments/http-server.ts:74:74
;;(add-hook 'typescript-mode-hook (lambda ()
  ;;                                (add-to-list 'compilation-error-regexp-alist '("^\\(error: \\)?TS[0-9]+.*\\n.*\\n.*\\n[ ]+at file://\\([^:]+\\):\\([0-9]+\\):[0-9]+$" 3 4))))

;;(add-hook 'typescript-mode-hook (lambda ()
;;                                  (add-to-list 'compilation-error-regexp-alist '(".*\n.*\n[ ]+~*\n[ ]+at file://\\([^:]+\\):\\([0-9]+\\):[0-9]+$" 1 2))))

;;(require 'compile)
;;(add-to-list 'compilation-error-regexp-alist '("^\\(?:error: \\)?TS[0-9]+ .*\n.*\n[ ]+~*\n[ ]+at file://\\(/[^:]+\\):\\([0-9]+\\):[0-9]+$" 1 2))

(require 'compile)
;;(add-to-list 'compilation-error-regexp-alist '("^\\(?:error: \\)?TS[0-9]+ .*\n.*\n[ ]+~*\n[ ]+at file://\\(/[^:]+\\):\\([0-9]+\\):[0-9]+$" 1 2))


(add-to-list 'compilation-error-regexp-alist '("^\\(?:error: \\)?TS[0-9]+ .*\n.*\n.*\n[ \t]+at file://\\(/[^:]+\\):\\([0-9]+\\):[0-9]+$" 1 2))
(add-to-list 'compilation-error-regexp-alist '("^\\(?:error: \\)?TS[0-9]+ .*\n.*\n.*\n.*\n[ \t]+at file://\\(/[^:]+\\):\\([0-9]+\\):[0-9]+$" 1 2))
(add-to-list 'compilation-error-regexp-alist '("^\\(?:error: \\)?TS[0-9]+ .*\n.*\n.*\n.*\n.*\n[ \t]+at file://\\(/[^:]+\\):\\([0-9]+\\):[0-9]+$" 1 2))
(add-to-list 'compilation-error-regexp-alist '("^\\(?:error: \\)?TS[0-9]+ .*\n.*\n.*\n.*\n.*\n.*\n[ \t]+at file://\\(/[^:]+\\):\\([0-9]+\\):[0-9]+$" 1 2))
(add-to-list 'compilation-error-regexp-alist '("^\\(?:error: \\)?TS[0-9]+ .*\n.*\n.*\n.*\n.*\n.*\n.*\n[ \t]+at file://\\(/[^:]+\\):\\([0-9]+\\):[0-9]+$" 1 2))

(org-babel-do-load-languages 'org-babel-load-languages
                             (append org-babel-load-languages
                                     '((sqlite     . t))))



;;(defvar my-cpp-other-file-alist
;;  '(("\\.cpp\\'" (".hpp"))
;;    ("\\.hpp\\'" (".cpp"))))

;;(setq-default ff-other-file-alist 'my-cpp-other-file-alist) 


(add-hook 'c-mode-common-hook
          (lambda() 
            (local-set-key  (kbd "C-z h") 'cff-find-other-file)))





(advice-add 'set-window-vscroll :after
            (defun me/vterm-toggle-scroll (&rest _)
              (when (eq major-mode 'vterm-mode)
                (if (> (window-end) (buffer-size))
                    (when vterm-copy-mode (vterm-copy-mode-done nil))
                  (vterm-copy-mode 1)))))

