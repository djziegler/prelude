;;; 150-projectile.el --- Projectile tweaks  -*- lexical-binding: t; -*-

;; On Ubuntu the package `fd-find' installs the binary as `fdfind' to
;; avoid colliding with `fdclone' (which owns /usr/bin/fd and dies with
;; "No such device or address" when launched without a tty -- e.g.,
;; from an Emacs subprocess). Point Projectile at the real fd.
(setq projectile-fd-executable "fdfind")

(provide '150-projectile)
;;; 150-projectile.el ends here
