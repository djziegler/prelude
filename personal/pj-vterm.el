;;; pj-vterm.el --- Loader: `pj-vterm' interactive command.

;; Implementation lives in the pj repo at
;; ~/projects/pj/contrib/pj-vterm.el so it co-evolves with pj's
;; container-naming convention. This file is just a hook into
;; prelude's personal-dir auto-loading.
;;
;; Loads with 'noerror, and only binds C-z p when the load succeeded,
;; so this config works on machines that don't have pj checked out.

(when (load (expand-file-name "~/projects/pj/contrib/pj-vterm.el")
            'noerror 'nomessage)
  (global-set-key "\C-zp" 'pj-vterm))

;;; pj-vterm.el ends here
