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
  (setq eat-term-scrollback-size (* 4 1024 1024))

  ;; Reclaim a column of width. eat puts a 1-char left margin on every eat
  ;; buffer for its shell-prompt annotations (the -/0/X command-status
  ;; indicators), which narrows the terminal by one column vs vterm. That column
  ;; matters: at ~78 cols Claude Code drops its token/context status line, which
  ;; reappears with the extra width. The annotations are near-useless in a
  ;; claude session (the "shell" runs a full-screen TUI, not shell commands), so
  ;; turn them off. Takes effect for eat buffers created after this — recreate a
  ;; session to reclaim the column on it.
  (setq eat-enable-shell-prompt-annotation nil))

;;; Let windmove / F11 escape eat (the port of `vterm-keymap-exceptions').
;;
;; eat's semi-char mode sends most keys to the terminal. `eat-semi-char-non-
;; bound-keys' is the eat analog of `vterm-keymap-exceptions': keys listed here
;; are NOT bound to self-input, so they fall through to the global map. eat
;; already lets M-<arrows> through, so only the datahand windmove letters and
;; F11 need adding. Format is key vectors: [?\e ?h] means M-h (KEY carries no
;; meta itself); [f11] is the function key. `customize-set-variable' fires
;; eat's :set, which rebuilds the keymap and reloads eat (guarded, so it's safe
;; to run from here).
(with-eval-after-load 'eat
  (customize-set-variable
   'eat-semi-char-non-bound-keys
   (delete-dups
    (append (default-value 'eat-semi-char-non-bound-keys)
            (list [?\e ?h] [?\e ?\'] [?\e ?u] [?\e ?m]  ; datahand windmove keys
                  [f11])))))                             ; toggle-frame-fullscreen

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

;;; Make an eat pty follow the frame you're working in.
;;
;; eat sizes the pty from the buffer-local `window-adjust-process-window-size-
;; function'. For pj-layout sessions that's `pj-layout--pty-size', which pins
;; the pty to the instance-tagged frame and ignores any *other* frame you open
;; on the same session — so a second (untagged) frame you work in shows a
;; clipped / ill-fitting view (the pty stays the instance frame's size). This
;; installs a policy that instead prefers the *selected* frame's window, and
;; re-sizes on activation, so whichever frame you're in fits.
;;
;; Cost: the terminal reflows when you switch to a differently-sized frame.
;; Undo: set `pj-eat-pty-follow-active-frame' to nil — the installed policy then
;; skips the selected-frame preference and reverts to the instance-frame /
;; largest behaviour (i.e. stock pj-layout). No buffer surgery needed.

(defcustom pj-eat-pty-follow-active-frame t
  "When non-nil, size an eat pty to the frame you're working in (the selected
frame), so a session shown in several frames fits whichever one you're using.
When nil, fall back to the instance-frame / largest policy (stock behaviour) —
the undo switch if reflow-on-frame-switch is disruptive. Honoured live, so
flipping it takes effect on the next frame switch (or `M-x
pj-eat-resize-ptys')."
  :type 'boolean :group 'pj-eat
  :set (lambda (sym val)
         (set-default sym val)
         (when (fboundp 'window--adjust-process-windows)
           (run-at-time 0 nil #'window--adjust-process-windows))))

(defun pj-eat--active-frame-pty-size (process windows)
  "`window-adjust-process-window-size-function' that prefers the selected frame.
Choose WINDOWS on the selected frame; else on `pj-layout-instance'-tagged
frames; else all; and take the largest of the chosen set. Honours
`pj-eat-pty-follow-active-frame' live: when nil it skips the selected-frame
step, so behaviour reverts to the instance-frame / largest policy."
  (let* ((sel (and pj-eat-pty-follow-active-frame
                   (seq-filter (lambda (w) (eq (window-frame w) (selected-frame)))
                               windows)))
         (inst (seq-filter
                (lambda (w) (frame-parameter (window-frame w) 'pj-layout-instance))
                windows)))
    (window-adjust-process-window-size-largest process (or sel inst windows))))

(defvar pj-eat--last-pty-frame nil
  "Selected frame at the last pty resize; guards against redundant reflows.")
(defvar pj-eat--pty-resize-pending nil
  "Non-nil while a deferred `pj-eat--do-pty-resize' is queued (coalescing).")

(defun pj-eat-resize-ptys ()
  "Recompute every process window size now (applies the current pty policy)."
  (interactive)
  (when (fboundp 'window--adjust-process-windows)
    (window--adjust-process-windows)))

(defun pj-eat--do-pty-resize ()
  (setq pj-eat--pty-resize-pending nil)
  (when pj-eat-pty-follow-active-frame
    (pj-eat-resize-ptys)))

(defun pj-eat--request-pty-resize ()
  "Deferred + coalesced pty resize, only when the selected frame actually
changed (so switching windows *within* a frame never reflows the terminal)."
  (when (and pj-eat-pty-follow-active-frame
             (not (eq (selected-frame) pj-eat--last-pty-frame)))
    (setq pj-eat--last-pty-frame (selected-frame))
    (unless pj-eat--pty-resize-pending
      (setq pj-eat--pty-resize-pending t)
      ;; Defer out of the redisplay/focus hook before touching process sizes.
      (run-at-time 0 nil #'pj-eat--do-pty-resize))))

(defun pj-eat--activate-frame (frame)
  "Catch FRAME's eats up on activation: snap scroll (if `pj-eat-catch-up-on-
activation') and make the pty follow this frame (if `pj-eat-pty-follow-active-
frame'). Each feature is independently toggled."
  (when (frame-live-p frame)
    (dolist (win (window-list frame 'no-minibuf))
      (let ((buf (window-buffer win)))
        (when (eq (buffer-local-value 'major-mode buf) 'eat-mode)
          (when pj-eat-catch-up-on-activation
            (pj-eat--snap-window win))
          ;; Install the follow-active policy on this eat buffer (once),
          ;; overriding pj-layout's instance-frame policy. Kept even when the
          ;; toggle is off — the policy fn itself reverts behaviour then.
          (when (and pj-eat-pty-follow-active-frame
                     (not (eq (buffer-local-value
                               'window-adjust-process-window-size-function buf)
                              #'pj-eat--active-frame-pty-size)))
            (with-current-buffer buf
              (setq-local window-adjust-process-window-size-function
                          #'pj-eat--active-frame-pty-size))))))
    (pj-eat--request-pty-resize)))

(defun pj-eat--on-selection-change (frame)
  "`window-selection-change-functions' entry: activate FRAME's eats."
  (pj-eat--activate-frame frame))

(defun pj-eat--on-focus-change ()
  "`after-focus-change-function' entry: activate whichever frame(s) now have
focus. This is what fires on a WM activation — alt-tab, click into another
frame, or switching GNOME workspaces to the one holding an Emacs frame."
  (dolist (frame (frame-list))
    (when (frame-focus-state frame)
      (pj-eat--activate-frame frame))))

;; Register once; idempotent across reloads. Both features (scroll catch-up and
;; pty-follow) are gated by their own toggle inside `pj-eat--activate-frame', so
;; either can be flipped at runtime without re-registering these hooks.
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
