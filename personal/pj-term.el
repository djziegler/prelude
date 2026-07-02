;;; pj-term.el --- Loader: `pj-term' interactive command.

;; Implementation lives in the pj repo at
;; ~/projects/pj/contrib/pj-term.el so it co-evolves with pj's
;; container-naming convention. This file is just a hook into
;; prelude's personal-dir auto-loading.
;;
;; Loads with 'noerror, and only binds C-z p when the load succeeded,
;; so this config works on machines that don't have pj checked out.

(when (load (expand-file-name "~/projects/pj/contrib/pj-term.el")
            'noerror 'nomessage)
  (global-set-key "\C-zp" 'pj-term))

;;; pj-term.el ends here
