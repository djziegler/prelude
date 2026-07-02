;;; 620-eat.el --- eat terminal tweaks -*- lexical-binding: t; -*-
;;
;; eat is the terminal backend for pj-layout session frames (set via
;; `pj-layout-terminal'). eat loads lazily — the first time a layout
;; session spawns — so configure it with `with-eval-after-load' rather
;; than requiring it eagerly at startup.

(with-eval-after-load 'eat
  ;; Bigger scrollback: the default is 131072 chars (~128 KiB, ~1.5–2k
  ;; lines), which scrolls useful history out fast. eat reads this live on
  ;; every output flush (it trims from point-min once the buffer is over
  ;; size), so a larger value just lets the buffer grow further before
  ;; trimming. 4 MiB (~50k+ lines) is generous; the per-flush trim cost is
  ;; still negligible at this size. Kept finite on purpose — `nil'
  ;; (unlimited) removes the trim but grows without bound, which is a bad
  ;; fit for long-lived daemon sessions.
  (setq eat-term-scrollback-size (* 4 1024 1024)))

;;; Catch eat windows up to the bottom when their frame is activated.
;;
;; eat only keeps windows on the *selected frame* pinned to the bottom as
;; output arrives: its `eat--synchronize-scroll-windows' walks
;; `(get-buffer-window-list)', which defaults to the selected frame. So the
;; same *eat* shown in another frame freezes its scroll until you type in it
;; (the input path re-syncs with `force-selected'). Rather than continuously
;; maintaining eats on frames you aren't looking at, we leave stock behavior
;; and instead snap a frame's eat windows to the bottom the moment you turn
;; to it — on focus (incl. GNOME workspace switches, via
;; `after-focus-change-function') and on in-Emacs selected-window changes.

(defgroup pj-eat nil
  "Local tweaks to the eat terminal emulator."
  :group 'terminals)

(defcustom pj-eat-catch-up-on-activation t
  "When non-nil, snap every eat window on a frame to the bottom when that
frame is activated (gains focus, or its selected window changes). This is the
unconditional version of what typing / C-l does: a window scrolled back is
also snapped forward. Set to nil to restore stock eat behavior (other frames'
eats stay frozen until you type in them)."
  :type 'boolean :group 'pj-eat)

(defun pj-eat--snap-window (win)
  "Snap WIN to the terminal's bottom if it shows a live eat session buffer.
Reuses eat's own `eat--synchronize-scroll' so the recenter math stays correct."
  (let ((buf (window-buffer win)))
    (when (and (eq (buffer-local-value 'major-mode buf) 'eat-mode)
               (buffer-local-value 'eat-terminal buf)
               (fboundp 'eat--synchronize-scroll))
      (with-current-buffer buf
        (eat--synchronize-scroll (list win))))))

(defun pj-eat--snap-frame (frame)
  "Snap every eat window on FRAME to the bottom."
  (when (frame-live-p frame)
    (dolist (win (window-list frame 'no-minibuf))
      (pj-eat--snap-window win))))

(defun pj-eat-snap-frame (&optional frame)
  "Snap every eat window on FRAME (default: the selected frame) to the bottom.
The frame-wide version of what C-l does for a single window — for when you
re-visit a multi-cell frame (e.g. the layout overview) whose eats froze while
another frame was selected. Works regardless of `pj-eat-catch-up-on-activation':
this is the manual fallback for when the auto catch-up is off or misses."
  (interactive)
  (pj-eat--snap-frame (or frame (selected-frame))))

(defun pj-eat--on-selection-change (frame)
  "`window-selection-change-functions' entry: catch up FRAME's eats."
  (when pj-eat-catch-up-on-activation
    (pj-eat--snap-frame frame)))

(defun pj-eat--on-focus-change ()
  "`after-focus-change-function' entry: catch up whichever frame(s) now have
focus. This is what fires on a WM activation — alt-tab, click into another
frame, or switching GNOME workspaces to the one holding an Emacs frame."
  (when pj-eat-catch-up-on-activation
    (dolist (frame (frame-list))
      (when (frame-focus-state frame)
        (pj-eat--snap-frame frame)))))

;; Register once; idempotent across reloads. Behaviour is gated by the toggle
;; above, so it can be flipped at runtime without re-registering.
(add-hook 'window-selection-change-functions #'pj-eat--on-selection-change)
(remove-function after-focus-change-function #'pj-eat--on-focus-change)
(add-function :after after-focus-change-function #'pj-eat--on-focus-change)

;; Manual frame-wide snap, mnemonic C-c C-l — the frame-level cousin of C-l
;; (single-window refresh). Bound BOTH globally (it's a frame-level action, so
;; it should work from any plain buffer) and in `eat-mode-map', overriding eat's
;; own C-c C-l => `eat-line-mode' so it fires in the overview's eat cells (the
;; main use; `eat-line-mode' stays available via M-x). Modes that bind C-c C-l
;; themselves shadow the global bind and keep their meaning — deliberately, so
;; org's `org-insert-link' (and markdown / latex equivalents) are untouched.
(global-set-key (kbd "C-c C-l") #'pj-eat-snap-frame)
(with-eval-after-load 'eat
  (define-key eat-mode-map (kbd "C-c C-l") #'pj-eat-snap-frame))

(provide '620-eat)
;;; 620-eat.el ends here
