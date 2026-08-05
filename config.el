;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ahmad Adzlan Fadzli bin Khairi"
      user-mail-address "kaafadzli@unimas.my")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "SauceCodePro Nerd Font" :size 16)
      doom-variable-pitch-font (font-spec :family "SauceCodePro Nerd Font" :size 16)
      ;; projectile-project-search-path '("~/Documents" "/mnt/c/Users/alan_" "~/Documents/roam" "/mnt/c/Users/alan_/Dropbox/org" )
      projectile-project-search-path '("~/Documents" "~/Dropbox" "/mnt/c/Users/faadz/Projects" "/mnt/c/Users/faadz/Downloads")
)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org")

;; Set org-journal-date-format
(setq org-journal-date-format "%A, %Y-%m-%d"
      org-journal-file-format "%Y-%m-%d.org")

(after! org
  (load! "project-flight-logs")
  (setq org-agenda-files (append '("~/Dropbox/org") my/project-flight-logs))

  ;; To-Do keyword sequence with Nerd Font icons (Font Awesome 4 codepoints --
  ;; the oldest/most universally-patched icon set, present in any Nerd Font
  ;; build). Swap the glyph characters below if they don't render to taste.
  (setq org-todo-keywords
        '((sequence " TODO(t)" " WAITING(w@/!)" "|" " DONE(d!)" " CANCELLED(c@)")))
  (setq org-todo-keyword-faces
        '((" TODO" . (:foreground "#ff6c6b" :weight bold))
          (" WAITING" . (:foreground "#ECBE7B" :weight bold))
          (" DONE" . (:foreground "#98be65" :weight bold))
          (" CANCELLED" . (:foreground "#5B6268" :weight bold))))
  ;; Automatic CLOSED: timestamp + :LOGBOOK: state-change entry on DONE
  (setq org-log-done 'time
        org-log-into-drawer t)
  (add-hook 'org-mode-hook #'org-modern-mode)
)

(setq org-roam-directory "~/Dropbox/roam")
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
(map! :nv ";" #'evil-ex)

;; Compile LaTeX document and view
(map! :leader
      :desc "LaTeX compile and view"
      "l" #'TeX-command-run-all)

(after! tex
      ;; Set Okular as the default PDF viewer for LaTeX output
      (setq TeX-view-program-selection '((output-pdf "Okular")))

      ;; Custom command for Okular to handle SyncTeX reverse search properly
      ;; (--unique prevents Okular from opening a new window for every update)
      (setq TeX-view-program-list '(("Okular" "okular --unique file:%o#src:%n%b"))))

;; Save buffer using right-hand key combo.
(map! :leader
      (:prefix ("j" . "Right-hand combo")
      :desc "Save buffer"
      "l" #'save-buffer))

;; Load vimrc-mode
(require 'vimrc-mode)
(add-to-list 'auto-mode-alist '("\\.vim\\(rc\\)?\\'" . vimrc-mode))

;; Load arduino-mode
(require 'arduino-mode)
(add-to-list 'auto-mode-alist '("\\.ino\\'" . arduino-mode))

;; Load calfw and calfw-org
(require 'calfw)
(require 'calfw-org)
(setq cfw:display-calendar-holidays nil)

;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(add-hook 'evil-insert-state-exit-hook
          (lambda ()
            (call-interactively #'save-buffer)))

;; Set fancy splash screen image.
(setq fancy-splash-image (concat doom-user-dir "doom-splash.png"))

;; Set the path to mmdc (adjust to your system)
(setq ob-mermaid-cli-path "/home/adzlan/.npm-global/bin/mmdc")
;; Optional: Enable mermaid-mode for .mmd files
(use-package! mermaid-mode
  :mode "\\.mmd\\'")

;; Optional: Configure ob-mermaid for org-babel
(use-package! ob-mermaid
  :after org)
