;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "erwan.poles"
      user-mail-address "erwan.poles@epita.fr")

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

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)
;;(setq doom-theme 'doom-solarized-light)
;;(setq doom-theme 'doom-palenight)
(setq doom-theme 'doom-snazzy)
;;(setq doom-theme 'doom-horizon)
;;(setq doom-theme 'doom-henna)


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; My C config
(setq-default c-default-style "bsd"
              c-basic-offset 4)

;;(setq-default global-company-mode t)

(map!
      :leader :desc "Switch to next tab" "<right>" #'centaur-tabs-forward
      :leader :desc "Switch to previous tab" "<left>" #'centaur-tabs-backward)
(map! :after drag-stuff
      :nvi "M-<right>" #'centaur-tabs-forward
      :nvi "M-<left>" #'centaur-tabs-backward)
;; (use-package centaur-tabs
;;   :demand
;;   :config
;;   (centaur-tabs-mode t)
;;   :bind
;;   ("C-<prior>" . centaur-tabs-backward)
;;   ("C-<next>" . centaur-tabs-forward))

(setq inferior-lisp-program "sbcl")


;; Workaround for cpp-mode error (void-function lsp--matching-clients?)
(after! lsp-mode
  (advice-remove #'lsp #'+lsp-dont-prompt-to-install-servers-maybe-a))


;; Enable cursor shining
(beacon-mode 1)


;; =============================== ORG MODE ============================
;; Disable company for org-mode
(defun disable-company-on-org ()
  (company-mode -1))
(add-hook 'org-mode-hook #'disable-company-on-org)


;; Enable auto tangling at save time for org files (Redirection of code blocks to file)
;; Add `#+auto_tangle: t' at the top of org file to use this feature
(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config (setq org-auto-tangle-default t))


(after! org
  (setq org-hide-emphasis-markers t)
  ;;(setq org-id-extra-files (directory-files-recursively org-roam-directory "\.org$"))
  )

;; =====================================================================
