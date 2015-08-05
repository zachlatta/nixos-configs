;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration."
  (setq-default
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (ie. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load. If it is the symbol `all' instead
   ;; of a list then all discovered layers will be installed.
   dotspacemacs-configuration-layers
   '(
     (auto-completion :variables
                      auto-completion-enable-help-tooltip t
                      auto-completion-enable-sort-by-usage t)
     chrome
     dockerfile
     emacs-lisp
     eyebrowse
     finance
     floobits
     games
     git
     github
     go
     html
     markdown
     (org :variables
          org-enable-github-support t)
     rails
     react
     shell
     shell-scripts
     syntax-checking
     version-control
     )
   ;; List of additional packages that will be installed wihout being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages then consider to create a layer, you can also put the
   ;; configuration in `dotspacemacs/config'.
   dotspacemacs-additional-packages
   '(
     with-editor
     )
   ;; A list of packages and/or extensions that will not be install and loaded.
   dotspacemacs-excluded-packages '()
   ;; If non-nil spacemacs will delete any orphan packages, i.e. packages that
   ;; are declared in a layer which is not a member of
   ;; the list `dotspacemacs-configuration-layers'
   dotspacemacs-delete-orphan-packages t))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; Either `vim' or `emacs'. Evil is always enabled but if the variable
   ;; is `emacs' then the `holy-mode' is enabled at startup.
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer.
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed.
   dotspacemacs-startup-banner 'random
   ;; List of items to show in the startup buffer. If nil it is disabled.
   ;; Possible values are: `recents' `bookmarks' `projects'."
   dotspacemacs-startup-lists '(recents projects)
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(solarized-dark
                         solarized-light)
   ;; If non nil the cursor color matches the state color.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
   ;; size to make separators look not too crappy.
   dotspacemacs-default-font '("Source Code Pro"
                               :size 13
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The leader key accessible in `emacs state' and `insert state'
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it.
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; The command key used for Evil commands (ex-commands) and
   ;; Emacs commands (M-x).
   ;; By default the command key is `:' so ex-commands are executed like in Vim
   ;; with `:' and Emacs commands are executed with `<leader> :'.
   dotspacemacs-command-key ":"
   ;; If non nil then `ido' replaces `helm' for some commands. For now only
   ;; `find-files' (SPC f f) is replaced.
   dotspacemacs-use-ido nil
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content.
   dotspacemacs-enable-paste-micro-state nil
   ;; Guide-key delay in seconds. The Guide-key is the popup buffer listing
   ;; the commands bound to the current keystrokes.
   dotspacemacs-guide-key-delay 0.4
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil ;; to boost the loading time.
   dotspacemacs-loading-progress-bar nil
   ;; If non nil the frame is fullscreen when Emacs starts up.
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX."
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'.
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'.
   dotspacemacs-inactive-transparency 90
   ;; If non nil unicode symbols are displayed in the mode line.
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters the
   ;; point when it reaches the top or bottom of the screen.
   dotspacemacs-smooth-scrolling t
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   dotspacemacs-smartparens-strict-mode nil
   ;; Select a scope to highlight delimiters. Possible value is `all',
   ;; `current' or `nil'. Default is `all'
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil advises quit functions to keep server open when quitting.
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now.
   dotspacemacs-default-package-repository nil
   )
  ;; User initialization goes here
  (setq-default
   ;; Indent two spaces
   js-indent-level 2
   sh-basic-offset 2
   sh-indentation 2
   web-mode-markup-indent-offset 2
   web-mode-css-indent-offset 2
   web-mode-code-indent-offet 2
   )
  )

(defun dotspacemacs/config ()
  "Configuration function.
 This function is called at the very end of Spacemacs initialization after
layers configuration."

  ;;
  ;; user keybindings
  ;;

  (evil-leader/set-key
    "oc" 'org-capture
    "own" 'make-frame-command
    "ot" 'title-case-region-or-line
    )

  ;;
  ;; markdown-mode config
  ;;

  ;; Enable org's table editor in markdown mode
  (add-hook 'markdown-mode-hook 'turn-on-orgtbl)

  ;; Format for this function from http://ergoemacs.org/emacs/elisp_command_working_on_string_or_region.html
  (defun markdown-fmt-orgtbl (string &optional from to)
    "Formats Org-mode style tables as GitHub Markdown Tables.

When called interactively, work on the current paragraph or text selection.

When called in Lisp code, if STRING is non-nil, returns a changed string.
If STRING is nil, change the text in the region between positions FROM,  TO."
    (interactive
     (if (use-region-p)
         (list nil (region-beginning) (region-end))
       (let ((bds (bounds-of-thing-at-point 'paragraph)))
         (list nil (car bds) (cdr bds)))))
    (let* ((work-on-string-p (if string t nil))
           (result (if work-on-string-p
                       string
                     (buffer-substring-no-properties from to)))
           (case-fold-search t)
           (replace-pairs '(("-|"    . " |")
                            ("|-"    . "| ")
                            ("-\\+-" . " | "))))
      (dolist (pair replace-pairs)
        (setq result (replace-regexp-in-string (car pair) (cdr pair) result)))
      (if work-on-string-p
          result
        (save-excursion
          (delete-region from to)
          (goto-char from)
          (insert result)))))

  ;; bind table formatter to <SPC> m t
  (evil-leader/set-key-for-mode 'markdown-mode "mt" 'markdown-fmt-orgtbl)

  ;;
  ;; org mode config
  ;;

  ;; agenda setup
  (setq org-agenda-files (quote ("~/dev/org"
                                 "~/dev/org/hackedu")))

  ;; todo keywords
  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
                (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

  ;; todo state triggers
  ;;
  ;; - Moving a task to CANCELLED adds a CANCELLED tag
  ;; - Moving a task to WAITING adds a WAITING tag
  ;; - Moving a task to HOLD adds WAITING and HOLD tags
  ;; - Moving a task to a done state removes WAITING and HOLD tags
  ;; - Moving a task to TODO removes WAITING, CANCELLED, and HOLD tags
  ;; - Moving a task to NEXT removes WAITING, CANCELLED, and HOLD tags
  ;; - Moving a task to DONE removes WAITING, CANCELLED, and HOLD tags
  (setq org-todo-state-tags-triggers
        (quote (("CANCELLED" ("CANCELLED" . t))
                ("WAITING" ("WAITING" . t))
                ("HOLD" ("WAITING") ("HOLD" . t))
                (done ("WAITING") ("HOLD"))
                ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
                ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
                ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

  ;; org-capture
  (setq org-directory "~/dev/org")
  (setq org-default-notes-file "~/dev/org/refile.org")

  (setq org-capture-templates
        (quote (("t" "todo" entry (file org-default-notes-file)
                 "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
                ("r" "respond" entry (file org-default-notes-file)
                 "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
                ("n" "note" entry (file org-default-notes-file)
                 "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
                ("j" "Journal" entry (file+datetree "~/dev/org/journal.org")
                 "* %?\n%U\n" :clock-in t :clock-resume t)
                ("m" "Meeting" entry (file org-default-notes-file)
                 "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t))))

  ;; refile setup
  ;;

  ;; targets include this file and any file contributing to the agenda, up to 9 levels deep
  (setq org-refile-targets (quote ((nil :maxlevel . 9)
                                   (org-agenda-files :maxlevel . 9))))

  ;; use full outline paths for refile targets
  (setq org-refile-use-outline-path t)

  ;;
  ;; misc
  ;;

  ;; use chrome as default browser
  (setq
   browse-url-browser-function 'browse-url-generic
   browse-url-generic-program "google-chrome-stable")

  ;; add newline at end of file
  (setq require-final-newline 'visit-save)

  ;; titlecase function
  ;; original version: http://ergoemacs.org/emacs/elisp_title_case_text.html
  (defun title-case-region-or-line (begin end)
    "Title case text between nearest brackets, or current line, or text selection.
Capitalize first letter of each word, except words like {to, of, the, a, in, or, and, …}. If a word already contains cap letters such as HTTP, URL, they are left as is.

When called in a elisp program, begin end are region boundaries.
URL `http://ergoemacs.org/emacs/elisp_title_case_text.html'
Version 2015-05-07"
    (interactive
     (if (use-region-p)
         (list (region-beginning) (region-end))
       (let (
             p1
             p2
             (skipChars "^\"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕"))
         (progn
           (skip-chars-backward skipChars (line-beginning-position))
           (setq p1 (point))
           (skip-chars-forward skipChars (line-end-position))
           (setq p2 (point)))
         (list p1 p2))))
    (let* (
           (strPairs [
                       [" A " " a "]
                       [" And " " and "]
                       [" At " " at "]
                       [" As " " as "]
                       [" By " " by "]
                       [" Be " " be "]
                       [" Into " " into "]
                       [" In " " in "]
                       [" Is " " is "]
                       [" It " " it "]
                       [" For " " for "]
                       [" Of " " of "]
                       [" Or " " or "]
                       [" On " " on "]
                       [" Via " " via "]
                       [" The " " the "]
                       [" That " " that "]
                       [" To " " to "]
                       [" Vs " " vs "]
                       [" With " " with "]
                       [" From " " from "]
                       ["'S " "'s "]
                       ]))
      (save-excursion 
        (save-restriction
          (narrow-to-region begin end)
          (upcase-initials-region (point-min) (point-max))
          (let ((case-fold-search nil))
            (mapc
             (lambda (x)
               (goto-char (point-min))
               (while
                   (search-forward (aref x 0) nil t)
                 (replace-match (aref x 1) 'FIXEDCASE 'LITERAL)))
             strPairs))))))
)

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
