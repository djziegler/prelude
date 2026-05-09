;;; 270-key-chords.el --- key-chord-mode preferences
;;
;; Was personal/700-key-chords.el. key-chord-mode is wired by the
;; key-chord prelude module; this file just tunes the timing and
;; clears a global chord we don't want.

;; Max time delay between two key presses to be considered a key chord
(setq key-chord-two-keys-delay 0.05) ; default 0.1

;;(key-chord-define-global "yy" 'browse-kill-ring)
;;(key-chord-define-global "zc" 'comment-or-uncomment-region)
;;(key-chord-define-global "zm" 'winner-undo)
;;(key-chord-define-global "z/" 'winner-redo)
;;(key-chord-define-global "zg" 'counsel-git-grep)
;;(key-chord-define-global "zg" 'counsel-git-grep)

(key-chord-unset-global "uu")

;;; 270-key-chords.el ends here
