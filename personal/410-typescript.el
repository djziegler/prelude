;;; 410-typescript.el --- TypeScript: auto-mode, tide bindings, deno error regex
;;
;; .tsx files use plain typescript-mode (the commented web-mode setup
;; below was an earlier experiment). The compilation-error-regexp-alist
;; entries below match deno's TS error format (multi-line messages
;; ending in `at file:///path:line:col') so M-x next-error/compile
;; jumps to the right place.

(global-set-key "\C-cy" 'tide-project-errors)

(add-to-list 'auto-mode-alist '("\\.tsx$" . typescript-mode))
;; (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
;; (add-hook 'web-mode-hook
;;           (lambda ()
;;             (when (string-equal "tsx" (file-name-extension buffer-file-name))
;;               (setup-tide-mode))))


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

;;; 410-typescript.el ends here
