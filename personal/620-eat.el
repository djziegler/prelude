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

(provide '620-eat)
;;; 620-eat.el ends here
