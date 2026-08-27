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
      ;; A real proportional face for prose (zen's mixed-pitch-mode), distinct
      ;; from the monospace coding font above.
      doom-variable-pitch-font (font-spec :family "SauceCodePro Nerd Font" :size 16)
      projectile-project-search-path '("~/Projects" "~/Documents" "/mnt/c/Users/faadz/Projects" "/mnt/c/Users/faadz/Downloads")
)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Projects/org")

;; Set org-journal-date-format
(setq org-journal-date-format "%A, %Y-%m-%d"
      org-journal-file-format "%Y-%m-%d.org")

(after! org
  (load! "project-flight-logs")
  (setq org-agenda-files (append '("~/Projects/org") my/project-flight-logs))

  (setq org-todo-keywords
        '((sequence "TODO(t)" "WAITING(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)")))
  (setq org-todo-keyword-faces
        '(("TODO" . (:foreground "#ff6c6b" :weight bold))
          ("WAITING" . (:foreground "#ECBE7B" :weight bold))
          ("DONE" . (:foreground "#98be65" :weight bold))
          ("CANCELLED" . (:foreground "#5B6268" :weight bold))))
  ;; Automatic CLOSED: timestamp + :LOGBOOK: state-change entry on DONE
  (setq org-log-done 'time
        org-log-into-drawer t)
  (add-hook 'org-mode-hook #'org-modern-mode)
)

;; Toggle a table column's shrunk/full width display (SPC m b w, alongside
;; Doom's existing "tables" (b) localleader prefix in the org module).
(map! :after org
      :map org-mode-map
      :localleader
      (:prefix ("b" . "tables")
       "w" #'org-table-toggle-column-width))

(setq org-roam-directory "~/Projects/roam")
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;;; ============================================================================
;;; Dashboard Configuration
;;; ============================================================================

;; Custom dashboard logo image
;; Use fancy-splash-image for custom images (NOT +doom-dashboard-banner-file)
(setq fancy-splash-image
      (expand-file-name "doom-splash.png" doom-private-dir))

;; Padding around the dashboard banner (vertical . horizontal)
(setq +doom-dashboard-banner-padding '(4 . 4))

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

;; Prefer Okular; Doom's :lang latex module handles the SyncTeX setup.
(setq +latex-viewers '(okular))

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


;; Set the path to mmdc (adjust to your system)
(setq ob-mermaid-cli-path "/home/adzlan/.npm-global/bin/mmdc")
;; Optional: Enable mermaid-mode for .mmd files
(use-package! mermaid-mode
  :mode "\\.mmd\\'")

;; Optional: Configure ob-mermaid for org-babel
(use-package! ob-mermaid
  :after org)

;; --- Writing experience: spelling, grammar, zen, word lookup -------------

;; Default dictionary. Emacs auto-discovers every hunspell dict found via
;; `hunspell -D' (including ms_MY, installed from syafiqhadzir/hunspell-ms
;; at /usr/share/hunspell/) -- no manual `ispell-hunspell-dictionary-alist'
;; entry needed. IMPORTANT: don't pre-seed that alist yourself; ispell only
;; runs auto-discovery when it's still nil (see `ispell-set-spellchecker-params'
;; in ispell.el), so setting it early silently breaks discovery of every
;; other dictionary. Switch per-buffer with `ispell-change-dictionary' (SPC t s).
(setq ispell-dictionary "en_GB")

;; org-modern's boxed labels/tables assume a stable, unscaled buffer, so keep
;; zen from scaling text in org-mode -- but LaTeX/markdown/prose buffers
;; should still get bigger text on zen toggle. Doom's own guard
;; (`+zen-text-scale' = 0) is all-or-nothing across every major mode, so
;; override the hook to skip scaling only in org-mode instead.
(setq +zen-text-scale 1)
(setq writeroom-width 70)
(after! writeroom-mode
  (defun +zen-enable-text-scaling-mode-h ()
    (unless (derived-mode-p 'org-mode)
      (text-scale-set (if writeroom-mode +zen-text-scale 0))
      (visual-fill-column-adjust))))

;; The :checkers grammar module's `langtool' package guesses a classpath of
;; /usr/share/languagetool:/usr/share/java/languagetool/* on Linux, which
;; matches Debian's `languagetool' apt package -- not available on Ubuntu
;; 22.04. Point it at the official standalone build installed manually to
;; /usr/share/languagetool instead. This must be set before `langtool' is
;; first loaded (M-x langtool-check et al are autoloaded/deferred), since
;; the module's own :config only guesses langtool-java-classpath when none
;; of langtool-bin/langtool-language-tool-jar/langtool-java-classpath are
;; already set.
(setq langtool-language-tool-jar "/usr/share/languagetool/languagetool-commandline.jar")
;; LanguageTool 6.6 needs Java 17+ (UnsupportedClassVersionError on the
;; system default, Java 11) -- point langtool at the 17 JRE installed
;; alongside it (`sudo apt install openjdk-17-jre-headless') without
;; touching the system-wide `java' alternative.
(setq langtool-java-bin "/usr/lib/jvm/java-17-openjdk-amd64/bin/java")

;; The :checkers grammar module auto-enables writegood-mode (weasel-word /
;; passive-voice highlighting) on every prose buffer, which wasn't asked for.
;; Keep LanguageTool's on-demand grammar check but drop this auto-highlight.
(after! writegood-mode
  (dolist (hook '(org-mode-hook markdown-mode-hook latex-mode-hook LaTeX-mode-hook))
    (remove-hook hook #'writegood-mode)))

;; Don't spellcheck very large buffers automatically (org-agenda files,
;; roam nodes) -- it adds noticeable latency just opening them.
(add-hook! 'flyspell-mode-hook
  (when (> (buffer-size) 200000)
    (flyspell-mode -1)))

;; Quick word lookups without leaving Emacs.
(use-package! define-word
  :commands (define-word define-word-at-point))

(use-package! powerthesaurus
  :commands (powerthesaurus-lookup-word-at-point
             powerthesaurus-lookup-word-dwim))

(map! :leader
      (:prefix ("j" . "Right-hand combo")
       :desc "Define word at point" "d" #'define-word-at-point
       :desc "Thesaurus lookup" "t" #'powerthesaurus-lookup-word-dwim))
