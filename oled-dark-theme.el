(deftheme oled-dark
  "Created 2022-01-29.")

(custom-theme-set-variables
 'oled-dark
 '(ansi-color-names-vector ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"]))

(custom-theme-set-faces
 'oled-dark
 '(cursor ((t (:background "#ff0000"))))
 '(header-line ((((class color) (min-colors 89)) (:background "#666"))))
 '(fringe ((((class color) (min-colors 89)) (:background "#333333"))))
 '(highlight ((((class color) (min-colors 89)) (:foreground "#2e3436" :background "#c0c000"))))
 '(region ((((class color) (min-colors 89)) (:background "#555753"))))
 '(secondary-selection ((((class color) (min-colors 89)) (:background "#204a87"))))
 '(isearch ((((class color) (min-colors 89)) (:foreground "#eeeeec" :background "#ce5c00"))))
 '(lazy-highlight ((((class color) (min-colors 89)) (:background "#8f5902"))))
 '(trailing-whitespace ((((class color) (min-colors 89)) (:background "#a40000"))))
 '(mode-line ((((class color) (min-colors 89)) (:box (:line-width -1 :style released-button) :background "#000000" :foreground "#005500"))))
 '(mode-line-inactive ((((class color) (min-colors 89)) (:box (:line-width -1 :style released-button) :background "#000000" :foreground "#000055"))))
 '(compilation-mode-line-fail ((((class color) (min-colors 89)) (:foreground "#a40000"))))
 '(compilation-mode-line-run ((((class color) (min-colors 89)) (:foreground "#ce5c00"))))
 '(compilation-mode-line-exit ((((class color) (min-colors 89)) (:foreground "#4e9a06"))))
 '(minibuffer-prompt ((((class color) (min-colors 89)) (:foreground "#b4fa70"))))
 '(escape-glyph ((((class color) (min-colors 89)) (:foreground "#c4a000"))))
 '(homoglyph ((((class color) (min-colors 89)) (:foreground "#c4a000"))))
 '(error ((((class color) (min-colors 89)) (:foreground "#ff4b4b"))))
 '(warning ((((class color) (min-colors 89)) (:foreground "#fcaf3e"))))
 '(success ((((class color) (min-colors 89)) (:foreground "#8ae234"))))
 '(font-lock-builtin-face ((((class color) (min-colors 89)) (:foreground "#e090d7"))))
 '(font-lock-comment-face ((((class color) (min-colors 89)) (:foreground "#73d216"))))
 '(font-lock-constant-face ((((class color) (min-colors 89)) (:foreground "#e9b2e3"))))
 '(font-lock-function-name-face ((((class color) (min-colors 89)) (:foreground "#fce94f"))))
 '(font-lock-keyword-face ((((class color) (min-colors 89)) (:foreground "#b4fa70"))))
 '(font-lock-string-face ((((class color) (min-colors 89)) (:foreground "#e9b96e"))))
 '(font-lock-type-face ((((class color) (min-colors 89)) (:foreground "#8cc4ff"))))
 '(font-lock-variable-name-face ((((class color) (min-colors 89)) (:foreground "#fcaf3e"))))
 '(link ((((class color) (min-colors 89)) (:underline t :foreground "#729fcf"))))
 '(link-visited ((((class color) (min-colors 89)) (:underline t :foreground "#3465a4"))))
 '(gnus-group-news-1 ((((class color) (min-colors 89)) (:foreground "#e090d7"))))
 '(gnus-group-news-1-low ((((class color) (min-colors 89)) (:foreground "#75507b"))))
 '(gnus-group-news-2 ((((class color) (min-colors 89)) (:foreground "#729fcf"))))
 '(gnus-group-news-2-low ((((class color) (min-colors 89)) (:foreground "#3465a4"))))
 '(gnus-group-news-3 ((((class color) (min-colors 89)) (:foreground "#8ae234"))))
 '(gnus-group-news-3-low ((((class color) (min-colors 89)) (:foreground "#73d216"))))
 '(gnus-group-news-4 ((((class color) (min-colors 89)) (:foreground "#e9b2e3"))))
 '(gnus-group-news-4-low ((((class color) (min-colors 89)) (:foreground "#c17d11"))))
 '(gnus-group-news-5 ((((class color) (min-colors 89)) (:foreground "#fcaf3e"))))
 '(gnus-group-news-5-low ((((class color) (min-colors 89)) (:foreground "#f57900"))))
 '(gnus-group-news-low ((((class color) (min-colors 89)) (:foreground "#edd400"))))
 '(gnus-group-mail-1 ((((class color) (min-colors 89)) (:foreground "#e090d7"))))
 '(gnus-group-mail-1-low ((((class color) (min-colors 89)) (:foreground "#75507b"))))
 '(gnus-group-mail-2 ((((class color) (min-colors 89)) (:foreground "#729fcf"))))
 '(gnus-group-mail-2-low ((((class color) (min-colors 89)) (:foreground "#3465a4"))))
 '(gnus-group-mail-3 ((((class color) (min-colors 89)) (:foreground "#8ae234"))))
 '(gnus-group-mail-3-low ((((class color) (min-colors 89)) (:foreground "#73d216"))))
 '(gnus-group-mail-low ((((class color) (min-colors 89)) (:foreground "#edd400"))))
 '(gnus-header-content ((((class color) (min-colors 89)) (:weight normal :foreground "#c4a000"))))
 '(gnus-header-from ((((class color) (min-colors 89)) (:foreground "#edd400"))))
 '(gnus-header-subject ((((class color) (min-colors 89)) (:foreground "#8ae234"))))
 '(gnus-header-name ((((class color) (min-colors 89)) (:foreground "#729fcf"))))
 '(gnus-header-newsgroups ((((class color) (min-colors 89)) (:foreground "#c17d11"))))
 '(message-header-name ((((class color) (min-colors 89)) (:foreground "#729fcf"))))
 '(message-header-cc ((((class color) (min-colors 89)) (:foreground "#c4a000"))))
 '(message-header-other ((((class color) (min-colors 89)) (:foreground "#c17d11"))))
 '(message-header-subject ((((class color) (min-colors 89)) (:foreground "#8ae234"))))
 '(message-header-to ((((class color) (min-colors 89)) (:foreground "#edd400"))))
 '(message-cited-text ((((class color) (min-colors 89)) (:foreground "#8ae234"))))
 '(message-separator ((((class color) (min-colors 89)) (:foreground "#e090d7"))))
 '(smerge-refined-change ((((class color) (min-colors 89)) (:background "#204a87"))))
 '(ediff-current-diff-A ((((class color) (min-colors 89)) (:background "#555753"))))
 '(ediff-fine-diff-A ((((class color) (min-colors 89)) (:background "#204a87"))))
 '(ediff-even-diff-A ((((class color) (min-colors 89)) (:background "#41423f"))))
 '(ediff-odd-diff-A ((((class color) (min-colors 89)) (:background "#41423f"))))
 '(ediff-current-diff-B ((((class color) (min-colors 89)) (:background "#555753"))))
 '(ediff-fine-diff-B ((((class color) (min-colors 89)) (:background "#8f5902"))))
 '(ediff-even-diff-B ((((class color) (min-colors 89)) (:background "#41423f"))))
 '(ediff-odd-diff-B ((((class color) (min-colors 89)) (:background "#41423f"))))
 '(flyspell-duplicate ((((class color) (min-colors 89)) (:underline "#fcaf3e"))))
 '(flyspell-incorrect ((((class color) (min-colors 89)) (:underline "#ef2929"))))
 '(realgud-overlay-arrow1 ((((class color) (min-colors 89)) (:foreground "green"))))
 '(realgud-overlay-arrow2 ((((class color) (min-colors 89)) (:foreground "#fcaf3e"))))
 '(realgud-overlay-arrow3 ((((class color) (min-colors 89)) (:foreground "#e9b2e3"))))
 '(realgud-bp-disabled-face ((((class color) (min-colors 89)) (:foreground "#204a87"))))
 '(realgud-bp-line-enabled-face ((((class color) (min-colors 89)) (:underline "red"))))
 '(realgud-bp-line-disabled-face ((((class color) (min-colors 89)) (:underline "#204a87"))))
 '(realgud-file-name ((((class color) (min-colors 89)) :foreground "#729fcf")))
 '(realgud-line-number ((((class color) (min-colors 89)) :foreground "#e9b2e3")))
 '(realgud-backtrace-number ((((class color) (min-colors 89)) :foreground "#e9b2e3" :weight bold)))
 '(semantic-decoration-on-includes ((((class color) (min-colors 89)) (:underline "#888a85"))))
 '(semantic-decoration-on-private-members-face ((((class color) (min-colors 89)) (:background "#5c3566"))))
 '(semantic-decoration-on-protected-members-face ((((class color) (min-colors 89)) (:background "#8f5902"))))
 '(semantic-decoration-on-unknown-includes ((((class color) (min-colors 89)) (:background "#a40000"))))
 '(semantic-decoration-on-unparsed-includes ((((class color) (min-colors 89)) (:background "#41423f"))))
 '(semantic-tag-boundary-face ((((class color) (min-colors 89)) (:overline "#729fcf"))))
 '(semantic-unmatched-syntax-face ((((class color) (min-colors 89)) (:underline "#ef2929"))))
 '(default ((t (:background "#000000" :foreground "#eeeeec"))))
 '(window-divider ((t (:foreground "#0000FF"))))
 '(window-divider-first-pixel ((t (:foreground "tomato"))))
 '(window-divider-last-pixel ((t (:foreground "green yellow")))))

(provide-theme 'oled-dark)
