;;; 610-vterm.el --- vterm package, keybindings, and toggle-scroll
;;
;; Installs vterm, sets up the keybindings vterm needs in both GUI and
;; terminal frames (some keys don't reach the major-mode-map by default
;; in tty), and adds an advice that auto-toggles vterm-copy-mode on
;; manual scrolling. C-c C-c is overridden to send literal ^C through
;; to the underlying shell instead of being eaten by emacs.
;;
;; Requires libtool and libtool-bin from the system: `sudo apt install
;; libtool libtool-bin'.

(use-package vterm :ensure t)

;; Let windmove escape from vterm. Without these, M-arrow / M-h /
;; M-' / M-u / M-m are captured by vterm and sent to the running
;; shell instead of moving point between windows. customize-set-variable
;; triggers vterm's :set handler which rebuilds vterm-mode-map to
;; defer the listed keys to the global map.
(customize-set-variable
 'vterm-keymap-exceptions
 (delete-dups
  (append (default-value 'vterm-keymap-exceptions)
          '("M-h" "M-'" "M-u" "M-m"           ;; datahand windmove keys
            "M-<left>" "M-<right>"            ;; regular-keyboard windmove
            "M-<up>" "M-<down>"))))

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


(add-hook 'vterm-mode-hook
          (lambda ()
            (define-key vterm-mode-map (kbd "C-c C-c") #'vterm-send-C-c)))


;; Auto-enter vterm-copy-mode when the user scrolls back up away from
;; the prompt; auto-leave when scrolled back to the bottom. Lets you
;; use normal emacs motion in the scrollback.
(advice-add 'set-window-vscroll :after
            (defun me/vterm-toggle-scroll (&rest _)
              (when (eq major-mode 'vterm-mode)
                (if (> (window-end) (buffer-size))
                    (when vterm-copy-mode (vterm-copy-mode-done nil))
                  (vterm-copy-mode 1)))))

;;; 610-vterm.el ends here
