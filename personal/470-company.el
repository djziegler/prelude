;;; 470-company.el --- company-mode tweaks (currently a stub)
;;
;; Was personal/801-company.el. Everything below is currently
;; commented out — historical note: tried to stop RET from triggering
;; completion, but never wired up the active path. Kept as a parking
;; spot in case the experiment is revived.

;; as per https://emacs.stackexchange.com/questions/13286/how-can-i-stop-the-enter-key-from-triggering-a-completion-in-company-mode

;(with-eval-after-load 'company
;  (define-key company-active-map (kbd "<return>") nil)
;  (define-key company-active-map (kbd "RET") nil)
;  (define-key company-active-map (kbd "C-SPC") #'company-complete-selection))

;;; 470-company.el ends here
