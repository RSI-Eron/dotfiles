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


(setq org-id-extra-files (directory-files-recursively "~/org/roam/" "org"))

;; replaced with ox-hugo partial template
;; Enable backlinks export
;; source:
;; https://github.com/org-roam/org-roam/blob/4f82ad98697f5524dd92972219f6049bb50c7f11/doc/org_export.md
;; https://seds.nl/notes/ox_hugo_export_all_roam_to_hugo/
(require 'org-roam)
(defun jethrokuan/org-roam--backlinks-list (file)
  ;; (if (org-roam--org-roam-file-p file)
  (if (org-roam-file-p file)
      (--reduce-from
       (concat acc (format "- [[file:%s][%s]]\n"
                           (file-relative-name (car it) org-roam-directory)
                                ;; (org-roam--get-title-or-slug (car it))))
                                (org-roam-db--get-title (car it))))
       "" (org-roam-sql [:select [file-from] :from file-links :where (= file-to $s1)] file))
    ""))

(defun jethrokuan/org-export-preprocessor (backend)
  (let ((links (jethrokuan/org-roam--backlinks-list (buffer-file-name))))
    (unless (string= links "")
      (save-excursion
      	(goto-char (point-max))
      	(insert (concat "\n* Backlinks\n") links)))))

(add-hook 'org-export-before-processing-hook 'jethrokuan/org-export-preprocessor)

;; =====================================================================


;; ================================ HUGO ===============================

;; Persist screenshot basename history through sessions
(defvar heron/hugo-screenshot-history nil)
(eval-after-load "savehist"
  '(add-to-list 'savehist-additional-variables 'heron/hugo-screenshot-history))

(defvar heron/flameshot-default-directory "~/dm/dm1/static/images/" "Default directory to store my screenshots")

(defun heron/hugo-screenshot (name)
  "Take a screenshot, save it to a folder named after the current buffer."

  (interactive
   (list (read-from-minibuffer "Screenshot name: " (car heron/hugo-screenshot-history) nil nil 'heron/hugo-screenshot-history)))

  ;; Add trailing '/' if it is not present
  (setq subdir heron/flameshot-default-directory)
  (if (not (string= (substring subdir -1) "/"))
      (setq subdir (concat subdir "/"))
    )

  ;; Create folder with current filename without extension
  (string-match "\\([^/]+?\\)\\(\\.[a-zA-Z]*\\)?$" buffer-file-name)
  (setq imagedir (concat (match-string 1 buffer-file-name) "/"))
  (setq subdir (concat subdir imagedir))
  (make-directory subdir :parents)

  ;; Search for the last screenshot
  (setq files-list (directory-files subdir nil (concat name "[0-9]+.png$")))
  (setq greatest-number 0)
  (cl-loop for file in files-list do
           (string-match "\\([0-9]+\\)\\.png$" file)
           (setq file-number (string-to-number (match-string 1 file)))
           (if (> file-number greatest-number)
               (setq greatest-number file-number)
               )
           )


  (setq screenshot-filename-base (concat name (number-to-string (+ 1 greatest-number))))
  (setq stderr-string (shell-command-to-string (concat "flameshot gui --raw 1> " subdir screenshot-filename-base ".png")))

  (if (string-empty-p stderr-string)
      ;;IF
      (progn
       (message (concat "File saved at " subdir screenshot-filename-base ".png"))
       ;; Inserting tag for Hugo
       (insert (concat "![" screenshot-filename-base "](" "/images/" imagedir screenshot-filename-base ".png" ")\n"))
      )

      ;; ELSE
       (progn
        (delete-file (concat subdir screenshot-filename-base ".png"))
        (message (concat "File was not saved: " stderr-string))
       )
       )
  )

(map! :leader "Ss" #'heron/hugo-screenshot)

(defun heron/set-flameshot-directory (path)
  "Set flameshot default saving directory"
  (interactive "DSet flameshot directory:")
  (setq heron/flameshot-default-directory path)
    )

(map! :leader "Sd" #'heron/set-flameshot-directory)

(defun heron/print-flameshot-directory ()
  "Print the flameshot saving directory"
  (interactive)
  (message heron/flameshot-default-directory)
    )

(map! :leader "Sp" #'heron/print-flameshot-directory)


(defvar heron/org-resource-directory "~/cours/resources/")
(defun heron/org-screenshot (name)
  "Take a screenshot, save it to a folder named after the current buffer."

  (interactive "sScreenshot name: ")

  ;; Add trailing '/' if it is not present
  (setq subdir heron/org-resource-directory)
  (if (not (string= (substring subdir -1) "/"))
      (setq subdir (concat subdir "/"))
    )

  (setq screenshot-filepath-full (concat subdir name ".png"))
  (if (file-exists-p screenshot-filepath-full)
  (message (concat "File " screenshot-filepath-full " already exist !"))
   (progn
     (setq stderr-string (shell-command-to-string (concat "flameshot gui --raw 1> " screenshot-filepath-full)))

     (if (string-empty-p stderr-string)
         ;;IF
         (progn
           (message (concat "File saved at " screenshot-filepath-full))
           ;; Inserting tag for org
           (insert (concat "#+ATTR_HTML: :width 600px\n[[" screenshot-filepath-full "]]\n"))
           )

       ;; ELSE
       (progn
         (delete-file screenshot-filepath-full)
         (message (concat "File was not saved: " stderr-string))
         )
       )
     )
   )
  )

(map! :leader "So" #'heron/org-screenshot)
