;;; post-init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-
(use-package compile-angel
  :demand t
  :config
  ;; The following disables compilation of packages during installation;
  ;; compile-angel will handle it.
  (setq package-native-compile nil)
  ;; Set `compile-angel-verbose' to nil to disable compile-angel messages.
  ;; (When set to nil, compile-angel won't show which file is being compiled.)
  (setq compile-angel-verbose t)

  ;; The following directive prevents compile-angel from compiling your init
  ;; files. If you choose to remove this push to `compile-angel-excluded-files'
  ;; and compile your pre/post-init files, ensure you understand the
  ;; implications and thoroughly test your code. For example, if you're using
  ;; the `use-package' macro, you'll need to explicitly add:
  ;; (eval-when-compile (require 'use-package))
  ;; at the top of your init file.
  (compile-angel-exclude-directory "~/.emacs.d/lsp-bridge/")
  (compile-angel-exclude-directory "~/.emacs.d/pkgs/")
  (compile-angel-exclude-directory "~/.emacs.d/site-lisp/emacs-application-framework/")
  (push "/init.el" compile-angel-excluded-files)
  (push "/custom.el" compile-angel-excluded-files)
  (push "/early-init.el" compile-angel-excluded-files)
  (push "/pre-init.el" compile-angel-excluded-files)
  (push "/package-init.el" compile-angel-excluded-files)
  (push "/compile-angle.el" compile-angel-excluded-files)
  (push "/pre-early-init.el" compile-angel-excluded-files)
  (push "/post-early-init.el" compile-angel-excluded-files)
  (push "/local-config.el" compile-angel-excluded-files)
  ;; A local mode that compiles .el files whenever the user saves them.
  ;; (add-hook 'emacs-lisp-mode-hook #'compile-angel-on-save-local-mode)
  ;; A global mode that compiles .el files prior to loading them via `load' or
  ;; `require'. Additionally, it compiles all packages that were loaded before
  ;; the mode `compile-angel-on-load-mode' was activated.
  (compile-angel-on-load-mode 1))

;; Auto-revert in Emacs is a feature that automatically updates the
;; contents of a buffer to reflect changes made to the underlying file
;; on disk.
(use-package autorevert
  :ensure nil
  :commands (auto-revert-mode global-auto-revert-mode)
  :hook
  (after-init . global-auto-revert-mode)
  :init
  ;; (setq auto-revert-verbose t)
  (setq auto-revert-interval 3)
  (setq auto-revert-remote-files nil)
  (setq auto-revert-use-notify t)
  (setq auto-revert-avoid-polling nil))

;; Recentf is an Emacs package that maintains a list of recently
;; accessed files, making it easier to reopen files you have worked on
;; recently.
(use-package recentf
  :ensure nil
  :commands (recentf-mode recentf-cleanup)
  :hook
  (after-init . recentf-mode)

  :init
  (setq recentf-auto-cleanup (if (daemonp) 300 'never))
  (setq recentf-exclude
        (list "\\.tar$" "\\.tbz2$" "\\.tbz$" "\\.tgz$" "\\.bz2$"
              "\\.bz$" "\\.gz$" "\\.gzip$" "\\.xz$" "\\.zip$"
              "\\.7z$" "\\.rar$"
              "COMMIT_EDITMSG\\'"
              "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
              "-autoloads\\.el$" "autoload\\.el$"))

  :config
  ;; A cleanup depth of -90 ensures that `recentf-cleanup' runs before
  ;; `recentf-save-list', allowing stale entries to be removed before the list
  ;; is saved by `recentf-save-list', which is automatically added to
  ;; `kill-emacs-hook' by `recentf-mode'.
  (add-hook 'kill-emacs-hook #'recentf-cleanup -90))

;; savehist is an Emacs feature that preserves the minibuffer history between
;; sessions. It saves the history of inputs in the minibuffer, such as commands,
;; search strings, and other prompts, to a file. This allows users to retain
;; their minibuffer history across Emacs restarts.
(use-package savehist
  :ensure nil
  :commands (savehist-mode savehist-save)
  :hook
  (after-init . savehist-mode)
  :init
  (setq history-length 300)
  (setq savehist-autosave-interval 600))

;; save-place-mode enables Emacs to remember the last location within a file
;; upon reopening. This feature is particularly beneficial for resuming work at
;; the precise point where you previously left off.
(use-package saveplace
  :ensure nil
  :commands (save-place-mode save-place-local-mode)
  :hook
  (after-init . save-place-mode)
  :init
  (setq save-place-limit 400))

;; The undo-fu package is a lightweight wrapper around Emacs' built-in undo
;; system, providing more convenient undo/redo functionality.
(use-package undo-fu
  :commands (undo-fu-only-undo
             undo-fu-only-redo
             undo-fu-only-redo-all
             undo-fu-disable-checkpoint)
  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z") 'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))



;; UNDO -----------------------------------------------------------------
;; The undo-fu-session package complements undo-fu by enabling the saving
;; and restoration of undo history across Emacs sessions, even after restarting.
(use-package undo-fu-session
  :commands undo-fu-session-global-mode
  :hook (after-init . undo-fu-session-global-mode))

;; This package is useful for users who want to disable the mouse to:
;; - Prevent accidental clicks or cursor movements that may unexpectedly change
;;   the cursor position.
;; - Reinforce a keyboard-centric workflow by discouraging reliance on the mouse
;;   for navigation.

;; DISABLE MOUSE ----------------------------------------------------------------------------------------------------------------
(use-package inhibit-mouse
  :config
  (if (daemonp)
      (add-hook 'server-after-make-frame-hook #'inhibit-mouse-mode)
    (inhibit-mouse-mode 1)))




;; Enable `auto-save-mode' to prevent data loss. Use `recover-file' or
;; `recover-session' to restore unsaved changes.
(setq auto-save-default t)

;; Trigger an auto-save after 300 keystrokes
(setq auto-save-interval 300)

;; Trigger an auto-save 30 seconds of idle time.
(setq auto-save-timeout 30)


;; When auto-save-visited-mode is enabled, Emacs will auto-save file-visiting
;; buffers after a certain amount of idle time if the user forgets to save it
;; with save-buffer or C-x s for example.
;;
;; This is different from auto-save-mode: auto-save-mode periodically saves
;; all modified buffers, creating backup files, including those not associated
;; with a file, while auto-save-visited-mode only saves file-visiting buffers
;; after a period of idle time, directly saving to the file itself without
;; creating backup files.
(setq auto-save-visited-interval 5)   ; Save after 5 seconds if inactivity
(auto-save-visited-mode 1)

(use-package persist-text-scale
  :commands (persist-text-scale-mode
             persist-text-scale-restore)

  :hook (after-init . persist-text-scale-mode)

  :custom
  (text-scale-mode-step 1.07))



;;; useful.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-
;;; Enable automatic insertion and management of matching pairs of characters
;;; (e.g., (), {}, "") globally using `electric-pair-mode'.
(use-package elec-pair
  :ensure nil
  :commands (electric-pair-mode
             electric-pair-local-mode
             electric-pair-delete-pair)
  :hook (after-init . electric-pair-mode))
(electric-indent-mode -1)
;; Allow Emacs to upgrade built-in packages, such as Org mode
(setq package-install-upgrade-built-in t)
;; When Delete Selection mode is enabled, typed text replaces the selection
;; if the selection is active.
(delete-selection-mode 1)

;; Display the current line and column numbers in the mode line
(setq line-number-mode t)
(setq column-number-mode t)
(setq mode-line-position-column-line-format '("%l:%C"))

;; Display of line numbers in the buffer:
;;(setq-default display-line-numbers-type 'relative)
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

;; Set the maximum level of syntax highlighting for Tree-sitter modes
;;(setq treesit-font-lock-level 4)
(use-package which-key
  :ensure nil ; builtin
  :commands which-key-mode
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 1.5)
  (which-key-idle-secondary-delay 0.25)
  (which-key-add-column-padding 1)
  (which-key-max-description-length 40))

(unless (and (eq window-system 'mac)
             (bound-and-true-p mac-carbon-version-string))
  ;; Enables `pixel-scroll-precision-mode' on all operating systems and Emacs
  ;; versions, except for emacs-mac.
  ;;
  ;; Enabling `pixel-scroll-precision-mode' is unnecessary with emacs-mac, as
  ;; this version of Emacs natively supports smooth scrolling.
  ;; https://bitbucket.org/mituharu/emacs-mac/commits/65c6c96f27afa446df6f9d8eff63f9cc012cc738
  (setq pixel-scroll-precision-use-momentum nil) ; Precise/smoother scrolling
  (pixel-scroll-precision-mode 1))

;; Display the time in the modeline
(add-hook 'after-init-hook #'display-time-mode)

;; Paren match highlighting
(add-hook 'after-init-hook #'show-paren-mode)

;; Track changes in the window configuration, allowing undoing actions such as
;; closing windows.
(setq winner-boring-buffers '("*Completions*"
                              "*Minibuf-0*"
                              "*Minibuf-1*"
                              "*Minibuf-2*"
                              "*Minibuf-3*"
                              "*Minibuf-4*"
                              "*Compile-Log*"
                              "*inferior-lisp*"
                              "*Fuzzy Completions*"
                              "*Apropos*"
                              "*Help*"
                              "*cvs*"
                              "*Buffer List*"
                              "*Ibuffer*"
                              "*esh command on file*"))
(add-hook 'after-init-hook #'winner-mode)

;; Window dividers separate windows visually. Window dividers are bars that can
;; be dragged with the mouse, thus allowing you to easily resize adjacent
;; windows.
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Window-Dividers.html
(add-hook 'after-init-hook #'window-divider-mode)

;; DIRED-------------------------------------------------------------------------------------------------------------------------
;; Constrain vertical cursor movement to lines within the buffer
(setq dired-movement-style 'bounded-files)
;; Hide files from dired
(setq dired-omit-files (concat "\\`[.]\\'"
                               "\\|\\(?:\\.js\\)?\\.meta\\'"
                               "\\|\\.\\(?:elc|a\\|o\\|pyc\\|pyo\\|swp\\|class\\)\\'"
                               "\\|^\\.DS_Store\\'"
                               "\\|^\\.\\(?:svn\\|git\\)\\'"
                               "\\|^\\.ccls-cache\\'"
                               "\\|^__pycache__\\'"
                               "\\|^\\.project\\(?:ile\\)?\\'"
                               "\\|^flycheck_.*"
                               "\\|^flymake_.*"))

(add-hook 'dired-mode-hook #'dired-omit-mode)
;; dired: Group directories first
(with-eval-after-load 'dired
  (let ((args "--group-directories-first -ahlv"))
    (when (or (eq system-type 'darwin) (eq system-type 'berkeley-unix))
      (if-let* ((gls (executable-find "gls")))
          (setq insert-directory-program gls)
        (setq args nil)))
    (when args
      (setq dired-listing-switches args))))

(use-package dired-subtree
  :after dired
  :bind
  ( :map dired-mode-map
    ("<tab>" . dired-subtree-toggle)
    ("TAB" . dired-subtree-toggle)
    ("<backtab>" . dired-subtree-remove)
    ("S-TAB" . dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))

;; Enables visual indication of minibuffer recursion depth after initialization.
(add-hook 'after-init-hook #'minibuffer-depth-indicate-mode)



;; Support for Git files (.gitconfig, .gitignore, .gitattributes...)
(use-package git-modes
  :commands (gitattributes-mode
             gitconfig-mode
             gitignore-mode)
  :mode (("/\\.gitignore\\'" . gitignore-mode)
         ("/info/exclude\\'" . gitignore-mode)
         ("/git/ignore\\'" . gitignore-mode)
         ("/.gitignore_global\\'" . gitignore-mode)  ; jc-dotfiles

         ("/\\.gitconfig\\'" . gitconfig-mode)
         ("/\\.git/config\\'" . gitconfig-mode)
         ("/modules/.*/config\\'" . gitconfig-mode)
         ("/git/config\\'" . gitconfig-mode)
         ("/\\.gitmodules\\'" . gitconfig-mode)
         ("/etc/gitconfig\\'" . gitconfig-mode)

         ("/\\.gitattributes\\'" . gitattributes-mode)
         ("/info/attributes\\'" . gitattributes-mode)
         ("/git/attributes\\'" . gitattributes-mode)))


;; MODE ----------------------------------------------------------------------------------------------------------------------------------------
;; Configure built-in sgml-mode to automatically enable
;; `sgml-electric-tag-pair-mode' in `html-mode' and `mhtml-mode', providing
;; automatic insertion of matching closing tags.

;; Install ob-go
(use-package ob-go
  :straight t
  :defer t)

(use-package jq-mode
  :straight t
  :defer t)

(use-package ob-mermaid
  :straight t
  :defer t)

(use-package ob-graphql
  :straight t
  :defer t)

(use-package sgml-mode
  :ensure nil
  :commands (sgml-mode sgml-electric-tag-pair-mode)
  :hook ((html-mode mhtml-mode) . sgml-electric-tag-pair-mode))

;; Support for YAML files.
;;
;; NOTE: Prefer the tree-sitter-based yaml-ts-mode over yaml-mode when
;; available, as it provides more accurate syntax parsing and enhanced editing
;; features.
(use-package yaml-mode
  :commands yaml-mode
  :mode (("\\.yaml\\'" . yaml-mode)
         ("\\.yml\\'" . yaml-mode)))

;; Support for Dockerfile files.
;;
;; NOTE: Prefer the tree-sitter-based dockerfile-ts-mode over dockerfile-mode
;; when available, as it provides more accurate syntax parsing and enhanced
;; editing features.
(use-package dockerfile-mode
  :commands dockerfile-mode
  :mode ("Dockerfile\\'" . dockerfile-mode))

;; Support for Gnuplot files
(use-package gnuplot
  :commands gnuplot-mode
  :mode ("\\.gp\\'" . gnuplot-mode))

;; Support for *.lua files.
;;
;; Prefer the tree-sitter-based lua-ts-mode over lua-mode when available, as it
;; provides more accurate syntax parsing and enhanced editing features.
(use-package lua-mode
  :commands lua-mode
  :mode ("\\.lua\\'" . lua-mode))

;; Jinja2 template support for files commonly used in configuration management
;; systems and web frameworks. This mode enables syntax highlighting and basic
;; editing facilities for templates written using the Jinja2 templating
;; language.
(use-package jinja2-mode
  :commands jinja2-mode
  :mode ("\\.j2\\'" . jinja2-mode))

;; CSV file support with automatic column alignment. This configuration enables
;; csv-align-mode whenever a CSV file is opened, improving readability by
;; keeping columns visually aligned according to a configurable maximum width
;; and a set of recognized field separators.
(use-package csv-mode
  :commands (csv-mode
             csv-align-mode
             csv-guess-set-separator)
  :mode ("\\.csv\\'" . csv-mode)
  :hook ((csv-mode . csv-align-mode)
         (csv-mode . csv-guess-set-separator))
  :custom
  (csv-align-max-width 100)
  (csv-separators '("," ";" " " "|" "\t")))
(use-package toml-mode
  :straight t
  :defer t
  :mode "/\\(Cargo.lock\\|\\.cargo/config\\)\\'")

(use-package yaml-mode
  :straight t
  :defer t
  :hook (kubed-display-resource-mode . yaml-mode)
;  :hook (yaml-mode . apheleia-mode)
  :mode "\\.yml\\'"
  :mode "\\.yaml\\'")

;; (use-package yaml-pro
;;   :straight t
;;   :hook (yaml-mode . yaml-pro-mode)
;;   :hook (yaml-ts-mode . yaml-pro-ts-mode))
(use-package web-mode
  :straight t
  :defer t
  :mode (("\\.phtml\\'"      . web-mode)
         ("\\.tpl\\.php\\'"  . web-mode)
         ("\\.twig\\'"       . web-mode)
         ("\\.xml\\'"        . web-mode)
         ("\\.html\\'"       . web-mode)
         ("\\.htm\\'"        . web-mode)
         ("\\.[gj]sp\\'"     . web-mode)
         ("\\.as[cp]x?\\'"   . web-mode)
         ("\\.eex\\'"        . web-mode)
         ("\\.erb\\'"        . web-mode)
         ("\\.mustache\\'"   . web-mode)
         ("\\.handlebars\\'" . web-mode)
         ("\\.hbs\\'"        . web-mode)
         ("\\.eco\\'"        . web-mode)
         ("\\.ejs\\'"        . web-mode)
         ("\\.svelte\\'"     . web-mode)
         ("\\.ctp\\'"        . web-mode)
         ("\\.djhtml\\'"     . web-mode)
         ("\\.vue\\'"        . web-mode))
  :bind (:map web-mode-map
              ;; Quick actions with direct M-g prefix
              ("M-g /" . web-mode-element-close)
              ("M-g k" . web-mode-element-kill)
              ("M-g s" . web-mode-element-select)

              ;; Tag operations (M-g t prefix)
              ("M-g t n" . web-mode-tag-next)
              ("M-g t p" . web-mode-tag-previous)
              ("M-g t m" . web-mode-tag-match)
              ("M-g t s" . web-mode-tag-select)
              ("M-g t b" . web-mode-tag-beginning)
              ("M-g t e" . web-mode-tag-end)

              ;; Element operations (M-g e prefix)
              ("M-g e n" . web-mode-element-next)
              ("M-g e p" . web-mode-element-previous)
              ("M-g e u" . web-mode-element-parent)
              ("M-g e d" . web-mode-element-child)
              ("M-g e k" . web-mode-element-kill)
              ("M-g e w" . web-mode-element-wrap)
              ("M-g e s" . web-mode-element-select)
              ("M-g e c" . web-mode-element-clone)
              ("M-g e r" . web-mode-element-rename)

              ;; Attribute operations (M-g a prefix)
              ("M-g a n" . web-mode-attribute-next)
              ("M-g a p" . web-mode-attribute-previous)
              ("M-g a k" . web-mode-attribute-kill)
              ("M-g a i" . web-mode-attribute-insert)
              ("M-g a s" . web-mode-attribute-select))
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-enable-auto-pairing t
        web-mode-enable-css-colorization t))

(use-package emmet-mode
  :straight t
  :defer t
  :hook ((css-mode  . emmet-mode)
         (html-mode . emmet-mode)
         (web-mode  . emmet-mode)
         (templ-ts-mode  . emmet-mode)
         (sass-mode . emmet-mode)
         (scss-mode . emmet-mode)
         (web-mode  . emmet-mode))
  :bind (:map emmet-mode-keymap
              ("M-RET" . 'emmet-expand-yas)))

;; Support for Go
;;
;; NOTE: Prefer the tree-sitter-based go-ts-mode over go-mode
;; when available, as it provides more accurate syntax parsing and enhanced
;; editing features.
(use-package go-mode
  :commands go-mode
  :mode ("\\.go\\'" . go-mode))

;; Support for Rust
(use-package rust-mode
  :commands rust-mode
  :mode ("\\.rs\\'" . rust-mode)
  :custom
  (rust-indent-offset 2))

;; Major mode for editing crontab files
(use-package crontab-mode
  :commands crontab-mode
  :mode ("/crontab\\(\\.X*[[:alnum:]]+\\)?\\'"  . crontab-mode))

;; Major mode for editing Nginx configuration files
(use-package nginx-mode
  :commands nginx-mode
  :mode (("nginx\\.conf\\'" . nginx-mode)
         ("/nginx/.+\\.conf\\'" . nginx-mode)))

;; Major mode for HashiCorp Configuration Language (HCL) files
(use-package hcl-mode
  :commands hcl-mode
  :mode ("\\.hcl\\'" . hcl-mode))

;; Major mode for Nix expression language files
(use-package nix-mode
  :commands nix-mode
  :mode ("\\.nix\\'" . nix-mode))

;; Major mode for editing Fish shell scripts
(use-package fish-mode
  :commands fish-mode
  :mode ("\\.fish\\'" . fish-mode))

;; Vim configuration file support. This mode provides syntax highlighting and
;; editing support for various Vim configuration files, including vimrc, gvimrc,
;; local overrides, and project-specific configuration files.
(use-package vimrc-mode
  :commands vimrc-mode
  :mode ("\\.vim\\(rc\\)?\\'" . vimrc-mode))

;; Support for Jenkinsfile files
(use-package jenkinsfile-mode
  :commands jenkinsfile-mode
  :mode ("Jenkinsfile\\'" . jenkinsfile-mode))


;; BUFFER ----------------------------------------------------------------------------------------------------------------------
(use-package buffer-guardian
  :custom
  ;; When non-nil, include remote files in the auto-save process
  (buffer-guardian-inhibit-saving-remote-files t)

  ;; When non-nil, buffers visiting nonexistent files are not saved
  (buffer-guardian-inhibit-saving-nonexistent-files nil)

  ;; Save the buffer even if the window change results in the same buffer
  (buffer-guardian-save-on-same-buffer-window-change t)

  ;; Non-nil to enable verbose mode to log when a buffer is automatically saved
  (buffer-guardian-verbose nil)

  ;; Save all buffers after N seconds of user idle time. (Disabled by default)
  ;; (buffer-guardian-save-all-buffers-idle 30)

  ;; Save all buffers every N seconds. (Disabled by default)
  ;; (setq buffer-guardian-save-all-buffers-interval (* 60 30))

  :hook
  (after-init . buffer-guardian-mode))

;; snippet ---------------------------------------------------------------------------------------------------------------------
;; The official collection of snippets for yasnippet.
(use-package yasnippet
  :straight t
  :demand t
  ;; :diminish yas-minor-mode
  :commands yas-minor-mode-on
  :bind (("C-c y d" . yas-load-directory)
         ("C-c y i" . yas-insert-snippet)
         ("C-c y f" . yas-visit-snippet-file)
         ("C-c y n" . yas-new-snippet)
         ("C-c y t" . yas-tryout-snippet)
         ("C-c y l" . yas-describe-tables)
         ("C-c y g" . yas-global-mode)
         ("C-c y m" . yas-minor-mode)
         ("C-c y r" . yas-reload-all)
         ("C-c y x" . yas-expand)
         :map yas-keymap
         ("C-i" . yas-next-field-or-maybe-expand))
  :mode ("/\\.emacs\\.d/snippets/" . snippet-mode)
  :hook ((prog-mode org-mode) . yas-minor-mode-on)
  :custom
  (yas-prompt-functions '(yas-completing-prompt yas-no-prompt))
  (yas-triggers-in-field t)
  (yas-wrap-around-region t)
  :custom-face
  (yas-field-highlight-face ((t (:background "#2a2a3a")))))


(use-package yasnippet
  :hook (templ-ts-mode . yas-minor-mode))
(use-package yasnippet-snippets
  :straight t
  :after yasnippet
  :demand t)

;; (use-package doom-snippets
;;   :straight (:host github :repo "hlissner/doom-snippets" :files ("*.el" "*"))
;;   :after yasnippet
;;   :demand t)

(use-package yasnippet-capf
  :straight t
  :after (cape yasnippet)
  :hook ((prog-mode text-mode conf-mode) . +cape-yasnippet--setup-h)
  :config
  (defun +cape-yasnippet--setup-h ()
    (add-to-list 'completion-at-point-functions #'yasnippet-capf)))

;; VERTICO ---------------------------------------------------------------------------------------------------------------------
(use-package vertico
  :straight t
  :defer t
  :commands vertico-mode
  :hook ((after-init . vertico-mode)
         (vertico-mode . vertico-multiform-mode))
  :hook (minibuffer-setup . vertico-repeat-save)
  :bind (("M-R" . vertico-repeat)
         :map vertico-map
         ("C-g" . abort-minibuffers)
         ("<escape>" . abort-minibuffers)
         ("RET" . vertico-directory-enter)
         ("DEL" . vertico-directory-delete-char)
         ("M-DEL" . vertico-directory-delete-word))
  :custom
  (vertico-cycle t)
  (vertico-resize nil)
  (vertico-count 12))
(use-package orderless
  ;; Vertico leverages Orderless' flexible matching capabilities, allowing users
  ;; to input multiple patterns separated by spaces, which Orderless then
  ;; matches in any order against the candidates.
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;; From https://github.com/abougouffa/minemacs/blob/main/core/me-lib-extra.el
;;;###autoload
(defun +region-or-thing-at-point (&optional leave-region-marked)
  "Return the region or the thing at point.

  If LEAVE-REGION-MARKED is no-nil, don't call `desactivate-mark'
  when a region is selected."
  (when-let* ((thing (ignore-errors
                       (or (prog1 (thing-at-point 'region t)
                             (unless leave-region-marked (deactivate-mark)))
                           (cl-some (+apply-partially-right #'thing-at-point t)
                                    '(symbol email number string word))))))
    ;; If the matching thing has multi-lines, join them
    (string-join (string-lines thing))))

(use-package consult
  :straight t
  :hook (embark-collect-mode . consult-preview-at-point-mode)
  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ;; ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ([remap recentf-open-files] . consult-recent-file)
         ([remap recentf] . consult-recent-file)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x t b" . consult-buffer-other-tab)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)
         ;; M-g bindings in `goto-map'
         ("M-g C" . consult-theme)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g O" . consult-org-heading)
         ("M-g j a" . consult-org-agenda)
         ;; Pulsar commands
         ("M-g l t" . pulsar-recenter-top)
         ("M-g l m" . pulsar-recenter-middle)
         ("M-g l c" . pulsar-recenter-center)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))

  ;; Enable automatic preview at point in the *Completions* buffer.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  :init
  ;; Optionally configure the register formatting. This improves the register
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  ;; Don't preview GPG encrypted files to avoid asking about the decryption password
  ;;(push "\\.gpg$" consult-preview-excluded-files)
  (setq-default completion-in-region-function #'consult-completion-in-region)

  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-find consult-grep consult-fd
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any)
   :initial (+region-or-thing-at-point))
  (setq consult-narrow-key "<"))

(use-package embrace
  :straight t
  :bind (("C-c j" . embrace-commander)  ; wrap/surround
         ("C-c a" . embrace-add)        ; add surrounding
         ("C-c d" . embrace-delete))    ; extract/remove surrounding
  :config
  ;; Add custom pairs for programming
  ;; (embrace-add-pair ?` "`" "`")     ; backticks
  ;; (embrace-add-pair ?~ "~" "~")     ; tildes
  ;; (embrace-add-pair ?= "=" "=")     ; equals
  ;; (embrace-add-pair ?/ "/" "/")     ; slashes
  ;; (embrace-add-pair ?_ "_" "_")     ; underscores
  ;; (embrace-add-pair ?* "*" "*")     ; asterisks

  ;; HTML/XML tags
  ;; (embrace-add-pair ?< "<" ">")
  
  ;; Mode-specific pairs using hooks
  (add-hook 'org-mode-hook
            (lambda ()
              (embrace-add-pair ?b "*" "*")   ; bold
              (embrace-add-pair ?i "/" "/")   ; italic
              (embrace-add-pair ?c "~" "~")   ; code
              (embrace-add-pair ?v "=" "=")   ; verbatim
              (embrace-add-pair ?u "_" "_")   ; underline
              (embrace-add-pair ?s "+" "+")))) ; strikethrough

;; Enhanced completion for org-mode
(add-hook 'org-mode-hook
          (lambda ()
            ;; Add useful completion functions for org-mode
            (add-hook 'completion-at-point-functions #'cape-dabbrev nil t)
            (add-hook 'completion-at-point-functions #'cape-file nil t)))
;;
;; (add-hook 'markdown-mode-hook
;;           (lambda ()
;;             (embrace-add-pair ?c "`" "`")))
;; 
;; (add-hook 'gfm-mode-hook
;;           (lambda ()
;;             (embrace-add-pair ?c "`" "`")))
;; 
;; (add-hook 'emacs-lisp-mode-hook
;;           (lambda ()
;;             (embrace-add-pair ?q "`" "'"))))

;; Some usefull functions
(defun dorneanu/vsplit-file-open (f)
  (let ((evil-vsplit-window-right t))
    (split-window-vertically)
    (find-file f)))

(defun dorneanu/split-file-open (f)
  (let ((evil-split-window-below t))
    (split-window-horizontally)
    (find-file f)))

(use-package embark
  :straight t
  :after (vertico)
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("M-RET" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)  ;; alternative for describe-bindings
   :map embark-file-map
   ("V" . dorneanu/vsplit-file-open)
   ("X" . dorneanu/split-file-open))
  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Using embark and ace
;; (require 'ace-window)

(defun dorneanu/embark-ace-action (fn)
  "Create an embark action that uses ace-window to select target window."
  (lambda (target)
    (with-demoted-errors "%S"
      (let ((window (if (> (length (aw-window-list)) 1)
                        (aw-select "Select window: ")
                      (selected-window))))
        (when window
          (select-window window)
          (funcall fn target))))))

;; Define ace-window variants of common actions
(defun dorneanu/embark-find-file-ace (file)
  "Open file in ace-selected window."
  (let ((window (aw-select "Select window: ")))
    (when window
      (select-window window)
      (find-file file))))

(defun dorneanu/embark-switch-to-buffer-ace (buffer)
  "Switch to buffer in ace-selected window."
  (let ((window (aw-select "Select window: ")))
    (when window
      (select-window window)
      (switch-to-buffer buffer))))

;; Add to embark keymaps
(with-eval-after-load 'embark
  (define-key embark-file-map "O" #'dorneanu/embark-find-file-ace)
  (define-key embark-buffer-map "O" #'dorneanu/embark-switch-to-buffer-ace))

(use-package embark-consult
  :straight t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package counsel
  :straight t
  :commands (counsel-org-tag))

(with-eval-after-load 'org
  ;; (setq org-src-window-setup 'reorganize-frame)
  (setq org-src-fontify-natively t)  ; syntax highlighting for source code blocks

  ;; Tab should do indent in code blocks
  (setq org-src-tab-acts-natively nil)

  ;; Don't remove (or add) any extra whitespace
  (setq org-src-preserve-indentation nil)
  (setq org-edit-src-content-indentation 2))


(org-babel-do-load-languages
 'org-babel-load-languages
 '((sql . t)
   (go . t)
   (C . t)
   (python . t)
   (latex,t)
   (plantuml . t)
   (emacs-lisp . t)
   (mermaid . t)
   (graphql . t)
   (shell . t)))

;; Automatically display inline images after babel execution
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)


(use-package treesit
  :straight (:type built-in)
  :mode (("\\.tsx\\'" . tsx-ts-mode)
         ("\\.py\\'" . python-ts-mode)
         ("\\.cmake\\'" . cmake-ts-mode)
         ("\\.go\\'" . go-ts-mode)
         ("\\.js\\'" . typescript-ts-mode)
         ("\\.mjs\\'" . typescript-ts-mode)
         ("\\.mts\\'" . typescript-ts-mode)
         ("\\.cjs\\'" . typescript-ts-mode)
         ("\\.ts\\'" . typescript-ts-mode)
         ("\\.jsx\\'" . tsx-ts-mode)
         ("\\.json\\'" . json-ts-mode)
         ("\\.yaml\\'" . yaml-ts-mode)
         ("\\.css\\'" . css-ts-mode)
         ("\\.yml\\'" . yaml-ts-mode)
         ("\\.php\\'" . php-ts-mode)
         ("\\.prisma\\'" . prisma-ts-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.mm\\'" . objc-mode)
         ("\\.mdx\\'" . markdown-mode))
  :preface
  (defun os/setup-install-grammars ()
    "Install Tree-sitter grammars if they are absent."
    (interactive)
    (dolist (grammar
             '((css . ("https://github.com/tree-sitter/tree-sitter-css" "v0.20.0"))
               (html . ("https://github.com/tree-sitter/tree-sitter-html" "v0.20.1"))
               (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.21.2" "src"))
               (kotlin "https://github.com/fwcd/tree-sitter-kotlin")
               (json . ("https://github.com/tree-sitter/tree-sitter-json" "v0.20.2"))
               (python . ("https://github.com/tree-sitter/tree-sitter-python" "v0.20.4"))
               (go "https://github.com/tree-sitter/tree-sitter-go" "v0.20.0")
               (markdown "https://github.com/ikatyang/tree-sitter-markdown")
               (make "https://github.com/alemuller/tree-sitter-make")
               (elisp "https://github.com/Wilfred/tree-sitter-elisp")
               (cmake "https://github.com/uyha/tree-sitter-cmake")
               (c "https://github.com/tree-sitter/tree-sitter-c")
               (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
               (objc "https://github.com/tree-sitter-grammars/tree-sitter-objc")
               (toml "https://github.com/tree-sitter/tree-sitter-toml")
               ;;(php "https://github.com/tree-sitter/tree-sitter-php" "v0.22.8" "php/src" )
               (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
               (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
               (yaml . ("https://github.com/ikatyang/tree-sitter-yaml" "v0.5.0"))
               (prisma "https://github.com/victorhqc/tree-sitter-prisma")))
      (add-to-list 'treesit-language-source-alist grammar)
      (add-to-list 'treesit-language-source-alist
                   '(php "https://github.com/tree-sitter/tree-sitter-php" "master" "php/src"))

      ;; Only install `grammar' if we don't already have it
      ;; installed. However, if you want to *update* a grammar then
      ;; this obviously prevents that from happening.
      (unless (treesit-language-available-p (car grammar))
        (treesit-install-language-grammar (car grammar)))))

  ;; Optional, but recommended. Tree-sitter enabled major modes are
  ;; distinct from their ordinary counterparts.
  ;;
  ;; You can remap major modes with `major-mode-remap-alist'. Note
  ;; that this does *not* extend to hooks! Make sure you migrate them
  ;; also
  ;;(dolist (mapping
  ;;         '((python-mode . python-ts-mode)
  ;;           (css-mode . css-ts-mode)
  ;;           (typescript-mode . typescript-ts-mode)
  ;;           (js-mode . typescript-ts-mode)
  ;;           (js2-mode . typescript-ts-mode)
  ;;           (c-mode . c-ts-mode)
  ;;           (c++-mode . c++-ts-mode)
  ;;           (c-or-c++-mode . c-or-c++-ts-mode)
  ;;           (bash-mode . bash-ts-mode)
  ;;           (css-mode . css-ts-mode)
  ;;           (json-mode . json-ts-mode)
  ;;           (js-json-mode . json-ts-mode)
  ;;           (sh-mode . bash-ts-mode)
  ;;           (sh-base-mode . bash-ts-mode)))
  ;;  (add-to-list 'major-mode-remap-alist mapping))
  :config
  (os/setup-install-grammars))


(use-package combobulate
  :straight t
  :after (treesit)
  :bind (("C-," . combobulate))
  :preface
  ;; You can customize Combobulate's key prefix here.
  ;; Note that you may have to restart Emacs for this to take effect!
  (setq combobulate-key-prefix "C-x ,")
  ;;
  ;; You can manually enable Combobulate with `M-x
  ;; combobulate-mode'.
  :hook
  ((python-ts-mode . combobulate-mode)
   (js-ts-mode . combobulate-mode)
   (go-mode . go-ts-mode)
   (html-ts-mode . combobulate-mode)
   (css-ts-mode . combobulate-mode)
   (yaml-ts-mode . combobulate-mode)
   (typescript-ts-mode . combobulate-mode)
   (json-ts-mode . combobulate-mode)
   (tsx-ts-mode . combobulate-mode))
  ;; Amend this to the directory where you keep Combobulate's source
  ;; code.
  ;;:load-path ("~/workspace/combobulate")
  )

(use-package python
  :defer t
  :straight t
  :after ob
  :mode (("SConstruct\\'" . python-mode)
         ("SConscript\\'" . python-mode)
         ("[./]flake8\\'" . conf-mode)
         ("/Pipfile\\'"   . conf-mode))
  :init
  (setq python-indent-guess-indent-offset-verbose nil)
  ;; (add-hook 'python-mode-local-vars-hook #'lsp)
  :config
  (setq python-indent-guess-indent-offset-verbose nil)
  (when (and (executable-find "python3")
             (string= python-shell-interpreter "python"))
    (setq python-shell-interpreter "python3")))

;; Activate eglot for python-mode
;; (add-hook 'python-mode-hook 'eglot-ensure)


;; From https://github.com/dakra/dmacs/blob/nil/init.org
(use-package markdown-mode
  :mode (("/itsalltext/.*\\(gitlab\\|github\\).*\\.txt$" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode)
         ("\\.md\\'" . gfm-mode))
  :bind (:map markdown-mode-map
              ("M-n" . markdown-next-visible-heading)
              ("M-p" . markdown-previous-visible-heading)
              ("M-N" . markdown-forward-same-level)
              ("M-P" . markdown-backward-same-level)
              ("M-O" . markdown-up-heading)
              ("M-ö" . markdown-forward-paragraph)
              ("M-ä" . markdown-backward-paragraph)
              ("C-c =" . markdown-insert-header-dwim))
  :hook (gfm-mode . apheleia-mode)
  :config
  ;; Display remote images
  (setq markdown-display-remote-images t)
  ;; Enable fontification for code blocks
  (setq markdown-fontify-code-blocks-natively t)
  ;; Add some more languages
  (dolist (x '(("ini" . conf-mode)
               ("clj" . clojure-mode)
               ("cljs" . clojure-mode)
               ("cljc" . clojure-mode)))
    (add-to-list 'markdown-code-lang-modes x))
  ;; use pandoc with source code syntax highlighting to preview markdown (C-c C-c p)
  (setq markdown-command "pandoc -s --highlight-style pygments -f markdown_github -t html5"))
;; ORG-MODE ------------------------------------------------------------------------------------------------------------------
(use-package org
  :straight (:type built-in)
  :hook ((org-mode . toggle-truncate-lines))
  :bind (
         ;; Global keybindings
         ("M-g A" . org-agenda)

         :map org-mode-map
         ;; Basic structure
         ("C-c o i h" . org-insert-heading)
         ("C-c o i s" . org-insert-subheading)
         ("C-c o i t" . org-insert-todo-heading)
         ("C-c o i c" . dorneanu/org-insert-link-from-clipboard)

         ;; Timestamps
         ("C-c C-y" . org-toggle-timestamp-type)
         ("C-c ." . org-time-stamp-inactive)     ; Default to inactive timestamps

         ;; Structuring
         ("M-s-n" . org-drag-element-forward)
         ("M-s-p" . org-drag-element-backward)

         ;; Clocking
         ("C-c o c i" . org-clock-in)
         ("C-c o c o" . org-clock-out)
         ("C-c o c r" . org-clock-report)
         ("C-c o c m" . dorneanu/org-clock-enter-manually)

         ;; Demote / Promote
         ("C-c o d +" . org-promote-subtree)
         ("C->" . org-demote-subtree)
         ("C-c o d -" . org-demote-subtree)
         ("C-<" . org-promote-subtree)

         ;; Navigation
         ;; ("C-c o n n" . org-next-visible-heading)
         ;; ("C-c o n p" . org-previous-visible-heading)
         ("M-n" . org-next-visible-heading)
         ("M-p" . org-previous-visible-heading)
         ("M-N" . org-forward-heading-same-level)
         ("M-P" . org-backward-heading-same-level)
         ("M-O" . org-up-element)
         ("M-ö" . org-forward-paragraph)
         ("M-ä" . org-backward-paragraph)

         ;; Todo state
         ("C-c o t t" . org-todo)
         ("C-c o t d" . org-deadline)
         ("C-c o t s" . org-schedule)

         ;; Tags and properties
         ("C-c o :" . org-set-tags-command)
         ("C-c o p" . org-set-property)

         ;; Formatting
         ;; ("C-c o b" . org-bold)
         ;; ("C-c o i" . org-italic)
         ;; ("C-c o u" . org-underline)
         ("C-c o f f" . org-emphasize)

         ;; Hide / show
         ("C-c o f ." . dorneanu/org-focus-current-subtree)
         ("C-c o f s" . org-fold-hide-sublevels)
         ("C-c o f t" . org-fold-hide-subtree)

         ;; Soting
         ("C-c o s" . org-sort)
         ;; Export
         ("C-c o e e" . org-export-dispatch)

         ;; Misc
         ("C-c o a" . org-archive-subtree)
         ;; Note: refile bindings (C-c o r *) are set up in with-eval-after-load below
         ("C-c o k" . org-store-link)
         ("C-c o l" . org-insert-link)
         ("C-c o e m" . my/toggle-org-emphasis-markers)
         ("C-c o e r" . my/refresh-org-emphasis)
         ("C-c '" . org-edit-special)
         ("C-c o o p" . org-present)

         ([(shift return)] . crux-smart-open-line)
         ([(control shift return)] . crux-smart-open-line-above)

         ;; Minibuffer calendar navigation (macOS-friendly)
         :map org-read-date-minibuffer-local-map
         ("M-<left>"    . (lambda () (interactive) (org-eval-in-calendar '(calendar-backward-day 1))))
         ("M-<right>"   . (lambda () (interactive) (org-eval-in-calendar '(calendar-forward-day 1))))
         ("M-<up>"      . (lambda () (interactive) (org-eval-in-calendar '(calendar-backward-week 1))))
         ("M-<down>"    . (lambda () (interactive) (org-eval-in-calendar '(calendar-forward-week 1))))
         ("M-S-<left>"  . (lambda () (interactive) (org-eval-in-calendar '(calendar-backward-month 1))))
         ("M-S-<right>" . (lambda () (interactive) (org-eval-in-calendar '(calendar-forward-month 1))))
         ("M-S-<up>"    . (lambda () (interactive) (org-eval-in-calendar '(calendar-backward-year 1))))
         ("M-S-<down>"  . (lambda () (interactive) (org-eval-in-calendar '(calendar-forward-year 1))))

         :map org-src-mode-map
         ("C-x n" . org-edit-src-exit))
  :custom
  (org-auto-align-tags t)
  (org-edit-src-content-indentation 2)     ; indent the content of src blocks by 2 spaces
  (org-edit-src-turn-on-auto-save t)       ; auto-save org-edit-src
  (org-fontify-quote-and-verse-blocks t)
  (org-pretty-entities t)
  (org-pretty-entities-include-sub-superscripts nil)
  (org-special-ctrl-a/e t)
  (org-startup-indented t)
  (org-element-use-cache nil)


  :config
  (setq org-hide-leading-stars             t
        org-hide-macro-markers             t
        org-hide-properties                t
        org-cycle-hide-drawer-startup      t
        org-hide-drawer-startup            t
        ;; Some characters to choose from: …, ⤵, ▼, ↴, ⬎, ⤷, and ⋱
        org-ellipsis                       "…"
        org-image-actual-width             600
        org-redisplay-inline-images        t
        org-display-inline-images          t
        org-auto-align-tags                t
        org-startup-with-inline-images     "inlineimages"
        org-pretty-entities                t
        org-hide-emphasis-markers          t
        org-fontify-whole-heading-line     t
        org-fontify-done-headline          t
        org-fontify-quote-and-verse-blocks t
        org-startup-indented               t
        org-startup-align-all-tables       t
        org-use-property-inheritance       t
        org-list-allow-alphabetical        t
        ;; M-RET should not split the lines
        org-M-RET-may-split-line           '((default . nil))
        org-insert-heading-respect-content nil
        org-adapt-indentation              t
        org-log-done                       nil
        org-log-state-notes-into-drawer    nil     ;; No state change notes
        org-log-into-drawer                nil     ;; Does this make sense?
        org-directory                      "~/repos/priv/org/"
        org-default-notes-file             (expand-file-name "notes.org" org-directory))

  (setq org-return-follows-link t)
  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 2.0))
  (setq org-startup-with-latex-preview t)
  (setq org-latex-preview-auto-regen t)
  
  
  ;; Set TODO keywords
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"
           "STARTED(s)"
           "NEXT(n)"
           "WIP(p)"
           "WAITING(w)"
           "|"
           "DONE(d)"
           "CANCELED(c)")
          (sequence
           "PROJ(P)"
           "MEETING(m)"
           "REVIEW(r)"
           "IDEA(i)")))
  ;; "|"
  ;; "STOP(c)"
  ;; "EVENT(m)"

  ;; Set colors for TODO keywords
  (setq org-todo-keyword-faces
        '(("TODO" . (:foreground "#ff6b6b" :weight bold))
          ("STARTED" . (:foreground "#ff9500" :weight bold))
          ("NEXT" . (:foreground "#007acc" :weight bold))
          ("WIP" . (:foreground "#4ecdc4" :weight bold))
          ("WAITING" . (:foreground "#ffe66d" :weight bold))
          ("DONE" . (:foreground "#51cf66" :weight bold))
          ("CANCELED" . (:foreground "#6c757d" :weight bold :strike-through t))
          ("PROJ" . (:foreground "#9c27b0" :weight bold))
          ("MEETING" . (:foreground "#e91e63" :weight bold))
          ("REVIEW" . (:foreground "#ff5722" :weight bold))
          ("IDEA" . (:foreground "#ffc107" :weight bold))))

  ;; Clock configuration for mode-line display
  (setq org-clock-clocked-in-display 'mode-line)  ; Show in mode-line

  ;; Custom function to get enhanced clock string
  (defun my/org-clock-get-clock-string ()
    "Get clock string showing session:total/effort format."
    (when (org-clock-is-active)
      (let* ((session-minutes (floor (/ (float-time (time-subtract (current-time) org-clock-start-time)) 60)))
             (session-time (org-duration-from-minutes session-minutes))
             (total-time (save-excursion
                           (with-current-buffer (marker-buffer org-clock-marker)
                             (goto-char org-clock-marker)
                             (org-duration-from-minutes (org-clock-sum-current-item)))))
             (effort (save-excursion
                       (with-current-buffer (marker-buffer org-clock-marker)
                         (goto-char org-clock-marker)
                         (org-entry-get (point) "Effort")))))
        (concat "[" session-time "/" total-time
                (when effort (concat "/" effort)) "]"))))

  ;; Advice to override the default clock string function
  (defun my/advice-org-clock-get-clock-string (orig-fun)
    "Advice to enhance org-clock-get-clock-string with session:total format."
    (or (my/org-clock-get-clock-string)
        (funcall orig-fun)))

  (advice-add 'org-clock-get-clock-string :around #'my/advice-org-clock-get-clock-string)

  ;; No blank lines before new entries
  (setq org-blank-before-new-entry
        '((heading . nil)
          (plain-list-item . nil))))


(use-package htmlize :ensure t)   ; best syntax highlighter for export

;; (with-eval-after-load 'ox-html
;;   (setq org-html-htmlize-output-type 'css)
;;   (setq org-html-doctype "html5")
;;   (setq org-html-head-include-default-style nil)  ; remove default small styles
;; 
;;   ;; Custom style
;;   (setq org-html-head-extra
;;         "<style>
;;   pre.src { 
;;     font-size: 1.0em !important; 
;;     line-height: 1.5; 
;;     padding: 1.2em; 
;;     border: 1px solid #ddd; 
;;     border-radius: 8px; 
;;     background: #fdfdfd;
;;   }
;;   </style>"))

;; ELDOC ----------------------------------------------------------------------------------------------------------------------
(use-package eldoc
  :straight t
  :hook (prog-mode . eldoc-mode)
  :bind (:map prog-mode-map
              ("C-c e d" . eldoc)
              ("C-c e t" . eldoc-toggle))
  :init
  (global-eldoc-mode -1)
  :config
  (setq eldoc-documentation-strategy 'eldoc-documentation-compose-eagerly
        eldoc-echo-area-use-multiline-p t
        eldoc-echo-area-display-truncation-message nil
        eldoc-idle-delay 0.1))
;; FORMART --------------------------------------------------------------------------------------------------------------------
;; (use-package apheleia
;;   :straight t
;;   :bind (("C-c f f" . apheleia-format-buffer))
;;   :config
;;   ;; For Python we want to format with isort and black
;;   ;; (setf (alist-get 'isort apheleia-formatters)
;;   ;;       '("isort" "--stdout" "-"))
;;   ;; (setf (alist-get 'python-mode apheleia-mode-alist)
;;   ;;       '(isort black))
;; 
;;   ;; Replace default (black) to use ruff for sorting import and formatting.
;;   (setf (alist-get 'python-mode apheleia-mode-alist)
;;         '(ruff-isort ruff))
;;   (setf (alist-get 'python-ts-mode apheleia-mode-alist)
;;         '(ruff-isort ruff))
;; 
;;   ;; For golang
;;   (setf (alist-get 'gofmt apheleia-formatters)
;;         '("goimports"))
;;   (apheleia-global-mode))

(use-package restclient) 
;; FLYCHECK -------------------------------------------------------------------------------------------------------------------
(use-package flycheck
  :straight t
  :hook (prog-mode . flycheck-mode))

(use-package consult-flycheck
  :straight t
  :bind (("M-g f" . consult-flycheck)))

;; CRUX -----------------------------------------------------------------------------------------------------------------------
(use-package crux
  :straight t
  :bind (("C-x C-d" . crux-duplicate-current-line-or-region)
         ("C-c u" . crux-view-url)
         ("C-c f r" . crux-rename-buffer-and-file)
         ("C-c f d" . crux-delete-file-and-buffer)
         ("C-x C-b" . create-scratch-buffer)
         ;; ("s-k"   . crux-kill-whole-line)
         ;;("s-o"   . crux-smart-open-line-above)
         ("C-a"   . crux-move-beginning-of-line)
         ("C-k"   . crux-kill-whole-line)
         ([(shift return)] . crux-smart-open-line)
         ([(control shift return)] . crux-smart-open-line-above))
  :config
  ;; No need to create a new scratch buffer every time
  ;; Just use one.
  (defun create-scratch-buffer ()
    "Create a scratch buffer."
    (interactive)
    (switch-to-buffer (get-buffer-create "*scratch*"))
    (lisp-interaction-mode))

  (crux-with-region-or-buffer indent-region)
  (crux-with-region-or-buffer untabify)
  (crux-with-region-or-point-to-eol kill-ring-save)
  (defalias 'rename-file-and-buffer #'crux-rename-file-and-buffer))

;; MULTIPLE_CURSOR--------------------------------------------------------------------------------------------------------------
;; (use-package multiple-cursors  ;; fk off multi cursor what i need
;;   :bind
;;   (("M-i" . 'mc/mark-next-like-this)
;;    ("" . 'mc/mark-previous-like-this)))

(use-package multiple-cursors
  :straight t
  :hook ((multiple-cursors-mode-enabled-hook . (lambda() (corfu-mode -1)))
         (multiple-cursors-mode-disabled-hook . (lambda () (corfu-mode 1))))
  :bind
  (:map prog-mode-map
        ("C-c m l" . mc/edit-lines)
        ("C-c m a" . mc/edit-beginnings-of-lines)
        ("C-c m e" . mc/edit-ends-of-lines)
        ("C-c m d" . mc/mark-all-dwim)
        ("C-c m s" . mc/mark-all-symbols-like-this)
        ("C-c m w" . mc/mark-all-words-like-this)
        ("C-c m r" . mc/mark-all-in-region)
        ("C-c m R" . mc/mark-all-in-region-regexp)
        ("C-c m S" . mc/mark-all-symbols-like-this-in-defun)
        ("C-c m W" . mc/mark-all-words-like-this-in-defun)
        ("C-c m n" . mc/mark-next-like-this)
        ("C-c m p" . mc/mark-previous-like-this)
        ("C-c m N" . mc/skip-to-next-like-this)
        ("C-c m P" . mc/skip-to-previous-like-this)
        ("C-c m M-n" . mc/unmark-next-like-this)
        ("C-c m M-p" . mc/unmark-previous-like-this)
        ("s-<mouse-1>"   . mc/add-cursor-on-click)
        ("C-S-<mouse-1>" . mc/add-cursor-on-click)))


;; MOVETEXT --------------------------------------------------------------------------------------------------------------------
(use-package move-text    ;; drag text move around like vim alt + j/k
  :ensure t
  :config
  (move-text-default-bindings)
  (global-set-key (kbd "C-<up>") #'move-text-up)
  (global-set-key (kbd "C-<down>") #'move-text-down))
;; WGREP

(use-package wgrep
  :straight t
  :after embark-consult
  :demand t
  :bind (:map grep-mode-map
              ("e" . wgrep-change-to-wgrep-mode)
              ("C-x C-q" . wgrep-change-to-wgrep-mode))
  :custom
  (wgrep-auto-save-buffer t)
  (wgrep-change-readonly-file t))

;; AVY -------------------------------------------------------------------------------------------------------------------------

(use-package avy
  :demand t
  :bind (("C-x j c" . avy-goto-char)
         ("C-x j w" . avy-goto-word-1)
         ("C-'" . avy-goto-word-1)
         ("C-x j l" . avy-goto-line)
         ("C-x j z" . avy-zap-to-char-dwim))
  :config
  (setq avy-all-windows t
        avy-all-windows-alt t
        avy-background t
        avy-style 'pre))

(use-package avy-zap
  :straight t
  :bind (("M-z" . avy-zap-to-char-dwim)
         ("M-Z" . avy-zap-up-to-char-dwim)))

;; MODLINE ---------------------------------------------------------------------------------------------------------------------
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode ))
;;;(setq doom-modeline-buffer-name nil)
(setq doom-modeline-battery nil)
(setq doom-modeline-lsp-icon nil)
(setq doom-modeline-icon nil)
;;;(setq doom-modeline-time nil)
(setq display-time-default-load-average nil)
(setq doom-modeline-time nil)

;; THEMES ---------------------------------------------------------------------------------------------------------------------
(use-package doom-themes
  :straight (:build t)
  :defer t)
(use-package kaolin-themes
  :straight t
  :defer t)

(use-package ef-themes
  :straight t)

(use-package modus-themes
  :straight t)

(use-package solarized-theme
  :straight t)

(use-package rg-themes
  :straight (:type git :host github :repo "raegnald/rg-themes"))

(use-package lambda-themes
  :straight (:type git :host github :repo "lambda-emacs/lambda-themes")
  :custom
  (lambda-themes-set-italic-comments t)
  (lambda-themes-set-italic-keywords t)
  (lambda-themes-set-variable-pitch t))

(use-package color-theme-sanityinc-tomorrow
  :straight t)
(use-package spacegray-theme)
;; Config THEME ------------------------------------------------------------------------------------------------------------------
(let ((inhibit-redisplay t))
  ;; Disable all active themes
  (mapc #'disable-theme custom-enabled-themes)
  ;; Load the built-in theme
  (load-theme 'modus-operandi t))
;; (load-theme 'gruber-darker t))
;; FONT ---------------------------------------------------------------------------------------------------------------------------
;; Set the default font to DejaVu Sans Mono with specific size and weight
(set-face-attribute 'default nil
                    :height 210 :weight 'normal :family "Iosevka")

;; FOLD KARAMI -----------------------------------------------------------------------------------------------------------------
(use-package kirigami
  :commands (kirigami-open-fold
             kirigami-open-fold-rec
             kirigami-close-fold
             kirigami-toggle-fold
             kirigami-open-folds
             kirigami-close-folds-except-current
             kirigami-close-folds)

  :bind
  (("C-c z o" . kirigami-open-fold)          ; Open fold at point
   ("C-c z O" . kirigami-open-fold-rec)      ; Open fold recursively
   ("C-c z r" . kirigami-open-folds)         ; Open all folds
   ("C-c z c" . kirigami-close-fold)         ; Close fold at point
   ("C-c z m" . kirigami-close-folds)        ; Close all folds
   ("C-c z a" . kirigami-toggle-fold)))      ; Toggle fold at point
;; Uncomment the following if you are an `evil-mode' user:
;; (with-eval-after-load 'evil
;;   (define-key evil-normal-state-map "zo" 'kirigami-open-fold)
;;   (define-key evil-normal-state-map "zO" 'kirigami-open-fold-rec)
;;   (define-key evil-normal-state-map "zc" 'kirigami-close-fold)
;;   (define-key evil-normal-state-map "za" 'kirigami-toggle-fold)
;;   (define-key evil-normal-state-map "zr" 'kirigami-open-folds)
;;   (define-key evil-normal-state-map "zm" 'kirigami-close-folds))

;; FOLD ---------------------------------------------------------------------------------------------------------------------------
;; Intelligent code folding by using the structural understanding of the
;; built-in tree-sitter parser. Unlike traditional folding methods that rely on
;; regular expressions or indentation, treesit-fold uses the actual syntax tree
;; of the code to accurately identify foldable regions such as functions,
;; classes, comments, and documentation strings. This allows for faster and more
;; language, ensuring that fold boundaries are always syntactically correct even
;; in complex or nested code structures.
(use-package treesit-fold
  :commands (treesit-fold-close
             treesit-fold-close-all
             treesit-fold-open
             treesit-fold-toggle
             treesit-fold-open-all
             treesit-fold-mode
             global-treesit-fold-mode
             treesit-fold-open-recursively
             treesit-fold-line-comment-mode)
  :custom
  (treesit-fold-line-count-show t)
  (treesit-fold-line-count-format " ▼")
  :config
  (set-face-attribute 'treesit-fold-replacement-face nil
                      :foreground "#808080"
                      :box nil
                      :weight 'bold))
;; Systems and General Purpose
(add-hook 'c-ts-mode-hook #'treesit-fold-mode)
(add-hook 'c++-ts-mode-hook #'treesit-fold-mode)
(add-hook 'java-ts-mode-hook #'treesit-fold-mode)
(add-hook 'rust-ts-mode-hook #'treesit-fold-mode)
(add-hook 'go-ts-mode-hook #'treesit-fold-mode)
(add-hook 'ruby-ts-mode-hook #'treesit-fold-mode)
;; Web and Frontend
(add-hook 'js-ts-mode-hook #'treesit-fold-mode)
(add-hook 'typescript-ts-mode-hook #'treesit-fold-mode)
(add-hook 'tsx-ts-mode-hook #'treesit-fold-mode)
(add-hook 'css-ts-mode-hook #'treesit-fold-mode)
(add-hook 'html-ts-mode-hook #'treesit-fold-mode)
;; Scripting and Infrastructure
(add-hook 'bash-ts-mode-hook #'treesit-fold-mode)
(add-hook 'cmake-ts-mode-hook #'treesit-fold-mode)
(add-hook 'dockerfile-ts-mode-hook #'treesit-fold-mode)
;; Data and Configuration
(add-hook 'json-ts-mode-hook #'treesit-fold-mode)
(add-hook 'toml-ts-mode-hook #'treesit-fold-mode)
;; Third-party
;; (add-hook 'kotlin-ts-mode-hook #'treesit-fold-mode)
;; (add-hook 'swift-ts-mode-hook #'treesit-fold-mode)
;; (add-hook 'elixir-ts-mode-hook #'treesit-fold-mode)
;; (add-hook 'zig-ts-mode-hook #'treesit-fold-mode)

;; ;;----------------------------------------------------LSP--------------------------------------------------------------------------
;; ;;; CORFU & CAPEF------------------------------------------------------------------------------------------------------------------------
(use-package cape
  :straight t
  :defer t
  :commands (cape-dabbrev cape-file cape-elisp-block)
  :bind ("C-c p" . cape-prefix-map)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.
  ;; Append cape functions safely
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))
;; 
(use-package corfu
  :straight t
  :defer t
  :commands (corfu-mode global-corfu-mode)
  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode)
         (lsp-completion-mode . dorneanu/corfu-setup-lsp))
  :custom
  ;; Hide commands in M-x which do not apply to the current mode.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Disable Ispell completion function. As an alternative try `cape-dict'.
  (text-mode-ispell-word-completion nil)
  (tab-always-indent 'complete)
  ;; Only use `corfu' when calling `completion-at-point' or
  ;; `indent-for-tab-command'
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.25)
  (corfu-preselect 'first)
  (corfu-quit-at-boundary nil)
  (corfu-separator ?\s)            ; Use space
  (corfu-quit-no-match 'separator) ; Don't quit if there is `corfu-separator' inserted
  (corfu-preview-current 'insert)        ; Preview first candidate. Insert on input if only one
  (corfu-preselect-first t)        ; Preselect first candidate?
  (lsp-completion-provider :none)       ; Use corfu instead for lsp completion
  (corfu-on-exact-match nil)
  (completion-cycle-threshold nil)      ; Always show completion candidates
  (corfu-insert-at-point t)
  :config
  (setq corfu-quit-no-match t)
  ;; Modify completion behavior for better Eglot integration
  (defun my/corfu-complete-full ()
    "Insert complete candidate, including any additional text edits."
    (interactive)
    (let ((completion-extra-properties nil))
      (corfu-insert)))

  ;; Setup lsp to use corfu for lsp completion
  (defun dorneanu/corfu-setup-lsp ()
    "Use orderless completion style with lsp-capf instead of the default lsp-passthrough."
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
          '(orderless)))

  ;; Free the RET key for less intrusive behavior.
  ;; Option 1: Unbind RET completely
  ;; (keymap-unset corfu-map "RET")
  ;; Option 2: Use RET only in shell modes
  (keymap-set corfu-map "RET" `( menu-item "" nil :filter
                                 ,(lambda (&optional _)
                                    (and (derived-mode-p 'eshell-mode 'comint-mode)
                                         #'corfu-send))))
  ;; Bind TAB to the new completion function
  (define-key corfu-map [tab] #'my/corfu-complete-full)
  (define-key corfu-map (kbd "TAB") #'my/corfu-complete-full)
  (global-corfu-mode))
;; Candidate information popup
(use-package corfu-popupinfo
  :straight (:type built-in)
  :hook (corfu-mode . corfu-popupinfo-mode)
  :bind ( ; Bind these to toggle/scroll documentation
         :map corfu-map
         ("M-p" . corfu-popupinfo-scroll-down)
         ("M-n" . corfu-popupinfo-scroll-up)
         ("M-d" . corfu-popupinfo-toggle))
  :custom
  (corfu-popupinfo-delay nil)
  (corfu-popupinfo-max-height 15))
;; Corfu popup on terminal
(use-package corfu-terminal
  :straight t
  :hook (corfu-mode . corfu-terminal-mode))

;; 
;; 
;; ;; ;;; EGLOT********************
;; (use-package eglot
;;   :ensure nil
;;   :bind (("C-c l e " . eglot)
;;          ("C-c C-." . eglot-code-actions))
;;   ;; :disabled t
;;   :defer t
;;   :commands (eglot
;;              eglot-rename
;;              eglot-ensure
;;              eglot-rename
;;              eglot-format-buffer)
;;   :custom
;;   (eglot-report-progress t)  ; Prevent minibuffer spam
;;   (eglot-autoshutdown t) ; shutdown after closing the last managed buffer
;;   (eglot-sync-connect 0) ; async, do not block
;;   (eglot-extend-to-xref t) ; can be interesting!
;;   (eglot-report-progress nil) ; disable annoying messages in echo area!
;;   (eglot-events-buffer-size 0)
;;   :config
;;   ;; Optimizations
;;   (fset #'jsonrpc--log-event #'ignore)
;;   (setq jsonrpc-event-hook nil)
;;   ;; Not sure if this really helps
;;   ;; Enable completion capabilities
;;   ;; (setq completion-category-overrides '((eglot (styles orderless))))
;;   ;; Configure tab for completion
;;   (setq tab-always-indent 'complete)
;;   ;; Enable snippet/template support
;;   (setq eglot-insert-completion-annotations t)
;;   (setq eglot-ignored-server-capabilities '(:inlayHintProvider))
;;   ;; Enable eglot for certain modes
;;   ;; (add-hook 'go-mode-hook 'eglot-ensure)
;;   ;; (add-to-list 'eglot-server-programs
;;   ;;              `(python-mode
;;   ;;                . ,(eglot-alternatives '(("pyright-langserver" "--stdio")
;;   ;;                                         "jedi-language-server"
;;   ;;                                         "pylsp"))))
;;   (add-to-list 'eglot-server-programs
;;                '(python-mode . ("ruff" "server")))
;;   (add-to-list 'eglot-server-programs '(markdown-mode . ("marksman"))))
;; 
;; (setq eglot-ignored-server-capabilities
;;       '(:inlayHintProvider
;;         :hoverProvider
;;         :documentHighlightProvider
;;         :publishDiagnostics))n
;; ;; ;;; LSP_MODE*****************

(use-package web-mode
  :ensure t
  :mode (("\\.tsx\\'" . web-mode)
         ("\\.jsx\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

;; Optional: Use tree-sitter for better syntax
(use-package treesit
  :config
  (setq treesit-language-source-alist
        '((tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
          (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")))
  (add-to-list 'major-mode-remap-alist '(typescript-ts-mode . tsx-ts-mode)))

(use-package lsp-mode
  :ensure nil
  :defer t
  :bind (("C-c l s" . lsp))
  :hook (
         (go-ts-mode . lsp-deferred)
         (go-mode . lsp-deferred)
         (web-mode . lsp-deferred)
         (tsx-ts-mode . lsp-deferred)
         (typescript-ts-mode . lsp-deferred)
         ;; (python-mode . lsp-deferred)
         (templ-ts-mode . lsp-deferred)
         ;; (python-ts-mode . lsp-deferred)
         )
  :commands (lsp lsp-deferred)
  :custom
  ;; (lsp-print-io nil)
  ;; (lsp-trace nil)
  ;; (lsp-print-performance nil)
  ;; (lsp-prefer-flymake t)
  ;; (lsp-disabled-clients (emmet-ls))
  (lsp-use-plist t)
  (lsp-keymap-prefix "C-c l")
  (lsp-completion-provider :none)                    ; we use Corfu
  (lsp-diagnostics-provider :flycheck)
  ;; (lsp-session-file (locate-user-emacs-file ".lsp-session"))
  (lsp-log-io nil)                                  ; IMPORTANT! Use only for debugging! Drastically affects performance
  (lsp-keep-workspace-alive nil)                    ; Close LSP server if all project buffers are closed
  (lsp-idle-delay 0.5)                             ; Debounce timer for `after-change-function'
  ;; core
  (lsp-enable-xref t)                              ; Use xref to find references
  (lsp-auto-configure t)                           ; Used to decide between current active servers
  ;; (lsp-eldoc-enable-hover t)                       ; Display signature information in the echo area
  (lsp-enable-dap-auto-configure nil)              ; Debug support
  (lsp-enable-file-watchers t)
  (lsp-file-watch-threshold 1000)
  (lsp-file-watch-ignored-directories '("[/\\\\]\\.git$" "[/\\\\]vendor$" "[/\\\\]node_modules$" "[/\\\\]\\.cache$"))
  (lsp-enable-folding nil)
  (lsp-enable-imenu t)
  (lsp-enable-indentation nil)                     ; I use prettier
  (lsp-enable-links nil)                           ; No need since we have `browse-url'
  (lsp-enable-on-type-formatting nil)              ; Prettier handles this
  (lsp-enable-suggest-server-download t)           ; Useful prompt to download LSP providers
  (lsp-enable-symbol-highlighting t)               ; Shows usages of symbol at point in the current buffer
  (lsp-enable-text-document-color nil)             ; This is Treesitter's job
  (lsp-ui-sideline-show-hover nil)                 ; Sideline used only for diagnostics
  (lsp-ui-sideline-diagnostic-max-lines 20)        ; 20 lines since typescript errors can be quite big

  ;; completion
  (lsp-completion-enable t)
  (lsp-completion-show-detail t)
  (lsp-completion-enable-additional-text-edit t)    ; Ex: auto-insert an import for a completion candidate
  (lsp-enable-snippet t)                           ; Important to provide full JSX completion
  (lsp-completion-show-kind t)
  (lsp-completion-show-label-description t)        ; Show extra detail like package path

  ;; headerline
  (lsp-headerline-breadcrumb-enable nil)               ; Optional, I like the breadcrumbs
  (lsp-headerline-breadcrumb-enable-diagnostics nil)   ; Don't make them red, too noisy
  (lsp-headerline-breadcrumb-enable-symbol-numbers nil)
  (lsp-headerline-breadcrumb-icons-enable nil)

  ;; modeline
  (lsp-modeline-code-actions-enable t)             ; Modeline should be relatively clean
  (lsp-modeline-diagnostics-enable t)              ; Quick error count in modeline
  (lsp-modeline-workspace-status-enable t)         ; Modeline displays "LSP" when lsp-mode is enabled
  (lsp-signature-auto-activate '(:on-trigger-char :on-server-request))
  (lsp-signature-render-documentation t)
  (lsp-signature-doc-lines 1)                      ; Don't raise the echo area. It's distracting
  (lsp-ui-doc-use-childframe t)                    ; Show docs for symbol at point
  ;; (lsp-eldoc-render-all nil)                       ; This would be very useful if it would respect `lsp-signature-doc-lines', currently it's distracting

  ;; lens
  (lsp-lens-enable nil)                            ; Optional, I don't need it

  ;; semantic
  (lsp-semantic-tokens-enable nil)                 ; Related to highlighting, and we defer to treesitter

  ;; inlay hints
  (lsp-inlay-hint-enable nil)                        ; Show parameter names and type hints inline

  :config
  ;; Merge LSP completions with yasnippet so snippets appear alongside LSP candidates
  (defun my/lsp-capf-with-snippets ()
    "Replace lsp-completion-at-point with a super-capf that includes yasnippet."
    (setq-local completion-at-point-functions
                (cl-substitute-if
                 (cape-capf-super #'lsp-completion-at-point #'yasnippet-capf)
                 (lambda (fn) (eq fn #'lsp-completion-at-point))
                 completion-at-point-functions)))
  (add-hook 'lsp-completion-mode-hook #'my/lsp-capf-with-snippets)
  )

;; Workaround for lsp-ts-query bug: `#'nil' used as predicate crashes on load
(with-eval-after-load 'lsp-ts-query
  (setq lsp-ts-query-parser-install-directories
        (vector (expand-file-name (locate-user-emacs-file "tree-sitter")))))
(use-package lsp-pyright
  :straight t
  :defer t
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :init
  (add-hook 'python-ts-mode-hook
            (lambda () (require 'lsp-pyright) (lsp-deferred))))

(use-package lsp-mode
  :hook ((templ-ts-mode . lsp-deferred)
         (go-mode . lsp-deferred))
  :commands lsp)

(with-eval-after-load 'lsp-mode
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection "templ")
    :major-modes '(templ-ts-mode)
    :server-id 'templ-ls
    :activation-fn (lsp-activate-on "templ"))))



(setq web-mode-enable-auto-indentation nil)
(setq lsp-enable-indentation nil)

(use-package lsp-tailwindcss
  :straight (:type git :host github :repo "merrickluo/lsp-tailwindcss")
  :defer t
  :init (setq lsp-tailwindcss-add-on-mode t)
  :config
  (setq lsp-tailwindcss-add-on-mode t)
  (setq lsp-tailwindcss-server-path "/home/nzvoid/.npm-global/bin/tailwindcss-language-server")
  (dolist (tw-major-mode
           '(web-mode
             web-ts-mode
             css-mode
             css-ts-mode
             typescript-mode
             typescript-ts-mode
             tsx-ts-mode
             html-mode
             js2-mode
             js-ts-mode))
    (add-to-list 'lsp-tailwindcss-major-modes tw-major-mode))
  )
(use-package lsp-eslint
  :straight (:type built-in)
  :after lsp-mode)
(use-package consult-lsp
  :straight t
  :after consult lsp-mode
  :bind (:map lsp-mode-map
              ([remap xref-find-apropos] . consult-lsp-symbols)))

(setq lsp-go-analyses '((shadow . t)
                        (simplifycompositelit . :json-false)))

(setq lsp-file-watch-ignored-directories
      '("[/\\\\]\\.git$"
        "[/\\\\]\\.svn$"
        "[/\\\\]\\.hg$"
        "[/\\\\]node_modules$"
        "[/\\\\]build$"
        "[/\\\\]dist$"
        "[/\\\\]\\.cache$"
        "[/\\\\]\\.next$"
        "[/\\\\]coverage$"))

;; Optional: Increase watch limit if needed

(setq lsp-file-watch-ignored-files
      '("[/\\\\]\\.\\(json\\|md\\|txt\\)$"
        "[/\\\\]node_modules[/\\\\]"
    "[/\\\\]\\.git\\'" "[/\\\\]\\.github\\'" "[/\\\\]\\.gitlab\\'"
    "[/\\\\]\\.circleci\\'" "[/\\\\]\\.hg\\'" "[/\\\\]\\.bzr\\'" "[/\\\\]_darcs\\'"
    "[/\\\\]\\.svn\\'" "[/\\\\]_FOSSIL_\\'" "[/\\\\]\\.jj\\'" "[/\\\\]\\.idea\\'"
    "[/\\\\]\\.ensime_cache\\'" "[/\\\\]\\.eunit\\'" "[/\\\\]node_modules"
    "[/\\\\]\\.yarn\\'" "[/\\\\]\\.turbo\\'" "[/\\\\]\\.fslckout\\'"
    "[/\\\\]\\.tox\\'" "[/\\\\]\\.nox\\'" "[/\\\\]dist\\'"
    "[/\\\\]dist-newstyle\\'" "[/\\\\]\\.hifiles\\'" "[/\\\\]\\.hiefiles\\'"
    "[/\\\\]\\.stack-work\\'" "[/\\\\]\\.bloop\\'" "[/\\\\]\\.bsp\\'"
    "[/\\\\]\\.metals\\'" "[/\\\\]target\\'" "[/\\\\]\\.ccls-cache\\'"
    "[/\\\\]\\.vs\\'" "[/\\\\]\\.vscode\\'" "[/\\\\]\\.venv\\'"
    "[/\\\\]\\.mypy_cache\\'" "[/\\\\]\\.pytest_cache\\'" "[/\\\\]\\.build\\'"
    "[/\\\\]__pycache__\\'" "[/\\\\]site-packages\\'" "[/\\\\].pyenv\\'"
    "[/\\\\]\\.deps\\'" "[/\\\\]build-aux\\'" "[/\\\\]autom4te.cache\\'"
    "[/\\\\]\\.reference\\'" "[/\\\\]bazel-[^/\\\\]+\\'"
    "[/\\\\]\\.cache[/\\\\]lsp-csharp\\'" "[/\\\\]\\.meta\\'" "[/\\\\]\\.nuget\\'"
    "[/\\\\]\\.lake\\'" "[/\\\\]Library\\'" "[/\\\\]\\.lsp\\'"
    "[/\\\\]\\.clj-kondo\\'" "[/\\\\]\\.shadow-cljs\\'" "[/\\\\]\\.babel_cache\\'"
    "[/\\\\]\\.cpcache\\'" "[/\\\\]\\checkouts\\'" "[/\\\\]\\.gradle\\'"
    "[/\\\\]\\.m2\\'" "[/\\\\]bin/Debug\\'" "[/\\\\]obj\\'" "[/\\\\]_opam\\'"
    "[/\\\\]_build\\'" "[/\\\\]\\.elixir_ls\\'" "[/\\\\]\\.elixir-tools\\'"
    "[/\\\\]\\.terraform\\'" "[/\\\\]\\.terragrunt-cache\\'" "[/\\\\]\\result"
    "[/\\\\]\\result-bin" "[/\\\\]\\.direnv\\'" "[/\\\\]\\.devenv\\'"
))


(setq lsp-enable-on-type-formatting nil)
(setq lsp-format-buffer nil)

;; ;;; LSP-Bridge***************--------------------------------------------------------------------------------------------------------
;; (add-to-list 'load-path "~/.emacs.d/lsp-bridge/")
;; (require 'lsp-bridge)
;; (setq lsp-bridge-python-command "~/.pyenv/versions/3.13.13/bin/python3")
;; (setq acm-candidate-match-function 'orderless-initialism)
;; (setq acm-enable-doc nil)
;; (setq acm-enable-preview t)
;; (setq acm-backend-search-file-words-max-number 5)
;; (setq lsp-bridge-enable-search-words nil)
;; (setq acm-backend-yas-candidates-number 4)
;; (setq acm-enable-tabnine nil)
;; (setq acm-enable-icon nil)
;; ;; END --------------------------------------------------------------------------------------------------------------------------


;; DICTIONARY ---------------------------------------------------------
(use-package quick-sdcv
  :init
  ;; When non-nil, a distinct buffer is created for each word searched.
  (setq quick-sdcv-unique-buffers t)

  ;; Change the prefix character used before dictionary names, replacing the
  ;; default `-->`:
  (setq quick-sdcv-dictionary-prefix-symbol "►")

  ;; Change the quick-sdcv dictionaries ellipsis from … to " ▼"

  ;; (In quick-sdcv buffers, `outline-minor-mode' is enabled by default, which
  ;; allows sections corresponding to individual dictionaries to be folded. The
  ;; ellipsis … indicates a folded section, making it easy to collapse all
  ;; dictionaries and expand only those of interest.)
  (setq quick-sdcv-ellipsis " ▼")

  ;; Automatically fold all dictionary entries when performing a search.
  ;; You can then unfold the dictionaries you want to read.
  (setq quick-sdcv-fold-on-search t))


;; The easysession Emacs package is a session manager for Emacs that can persist
;; and restore file editing buffers, indirect buffers/clones, Dired buffers,
;; windows/splits, the built-in tab-bar (including tabs, their buffers, and
;; windows), and Emacs frames. It offers a convenient and effortless way to
;; manage Emacs editing sessions and utilizes built-in Emacs functions to
;; persist and restore frames.
(use-package easysession
  :commands (easysession-switch-to
             easysession-save-as
             easysession-save-mode
             easysession-load-including-geometry)

  :custom
  ;;  (easysession-mode-line-misc-info t)  ; Display the session inl the modeline
  (easysession-save-interval (* 10 60))  ; Save every 10 minutes
  (setq tab-bar-format '(tab-bar-format-tabs
                         tab-bar-format-align-right
                         tab-bar-format-global))

  (add-to-list 'global-mode-string '(:eval (easysession-mode-line-session-name-format)) 'append)
  :init
  ;; Key mappings
  (global-set-key (kbd "C-c ss") #'easysession-save)
  (global-set-key (kbd "C-c sl") #'easysession-switch-to)
  (global-set-key (kbd "C-c sL") #'easysession-switch-to-and-restore-geometry)
  (global-set-key (kbd "C-c sr") #'easysession-rename)
  (global-set-key (kbd "C-c sR") #'easysession-reset)
  (global-set-key (kbd "C-c sd") #'easysession-delete)

  (if (fboundp 'easysession-setup)
      ;; The `easysession-setup' function adds hooks:
      ;; - To enable automatic session loading during `emacs-startup-hook', or
      ;;   `server-after-make-frame-hook' when running in daemon mode.
      ;; - To automatically save the session at regular intervals, and when
      ;;   Emacs exits.
      (easysession-setup)
    ;; Legacy
    ;; The depth 102 and 103 have been added to to `add-hook' to ensure that the
    ;; session is loaded after all other packages. (Using 103/102 is
    ;; particularly useful for those using minimal-emacs.d, where some
    ;; optimizations restore `file-name-handler-alist` at depth 101 during
    ;; `emacs-startup-hook`.)
    (add-hook 'emacs-startup-hook #'easysession-load-including-geometry 102)
    (add-hook 'emacs-startup-hook #'easysession-save-mode 103)))

(defun my-easysession-only-main-saved ()
  "Only save the main session."
  (when (string= "main" (easysession-get-current-session-name))
    t))
(setq easysession-save-mode-predicate 'my-easysession-only-main-saved)


;; EAF framework --------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d/site-lisp/emacs-application-framework/")

;; Safe require - won't error if package is missing
(require 'eaf nil t)           ; t = no error if not found
(require 'eaf-browser nil t)
(require 'eaf-pdf-viewer nil t)

(defun my/org-display-math ()
  (interactive)
  (insert "\\[ \\]")
  (backward-char 3))

(use-package templ-ts-mode
  :straight (templ-ts-mode :type git :host github :repo "danderson/templ-ts-mode")
  :mode "\\.templ\\'")
(add-to-list 'treesit-language-source-alist
             '(templ "https://github.com/vrischmann/tree-sitter-templ"))
(treesit-install-language-grammar 'templ)
(use-package wgrep
  :ensure t
  :bind (:map grep-mode-map
              ("C-c C-q" . wgrep-change-to-wgrep-mode)
         :map occur-mode-map
              ("C-c C-q" . wgrep-change-to-wgrep-mode))
  :config
  ;; Optional: automatically save the files after you press C-c C-c
  (setq wgrep-auto-save-buffer t))

(use-package dumb-jump
  :hook (xref-backend-functions . dumb-jump-xref-activate)
  :custom
  (xref-show-definitions-function 'xref-show-definitions-completing-read) ;; use consult instead of pop-up buffer
  )

;; ;; Enable variables highlighting
;; (customize-set-variable 'treesit-font-lock-level 4)

(add-hook 'php-ts-mode-hook (lambda ()
			                  ;; Use spaces for indent
			                  (setq-local indent-tabs-mode nil)))

;; DISABLE GPG anoying password
;; 1. Completely disable auth-sources for TRAMP
(connection-local-set-profile-variables
 'remote-without-auth-sources
 '((auth-sources . nil)))

(connection-local-set-profiles
 '(:application tramp)
 'remote-without-auth-sources)

;; 2. Extra important: disable during completion (this is often the culprit)
(setq tramp-completion-use-auth-sources nil)
;; Disable auth-sources for TRAMP connections
(setq tramp-completion-use-auth-sources nil)

;; Force auth-sources only for non-remote things
(setq auth-sources (if (file-remote-p default-directory)
                       nil
                     '("~/.authinfo.gpg" "~/.authinfo")))  ;; disable annoying gpg configmation
(setq org-agenda-files
      '("~/org/mylearn.org"
        "~/org/buyee.org"))  ;; setup org agenda

(require 'ansi-color)  ;; fix ansii in compile mode
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

(use-package ox-hugo
  :ensure t   ;Auto-install the package from Melpa
  :pin melpa  ;`package-archives' should already have ("melpa" . "https://melpa.org/packages/")
  :after ox)

(load (expand-file-name "~/.quicklisp/slime-helper.el")) ;; add slime for elisp
(setq inferior-lisp-program "sbcl")  ;; interpreter for sbcl
(setq pdf-view-use-scaling t)
(setq pdf-view-resize-factor 1.1)
(setq org-image-actual-width nil)
(prefer-coding-system 'utf-8)
(setq pdf-view-continuous t)
(setq pdf-cache-image-limit 1000)
(remove-hook 'racket-mode-hook #'racket-xp-mode)
(setq racket-xp-untype-expressions t)
(set-language-environment "UTF-8")  ;; view font correct
(setq x-input-method-use-echo-area nil)
(setq default-input-method nil)
(setq tramp-verbose 1)
(blink-cursor-mode 1)
(require 'project)
(setq project-vc-extra-root-markers '("pom.xml"))
(setq blink-cursor-interval 0.3 )
(setq tramp-auto-save-directory "/tmp")
(setq enable-dir-local-variables nil)
;; Configure Emacs to ask for confirmation before exiting
(setq confirm-kill-emacs 'y-or-n-p)
;; Enabled backups save your changes to a file intermittently
(setq kept-old-versions 10)
(setq kept-new-versions 10)
(load custom-file 'noerror 'no-message)
(minimal-emacs-load-user-init "local-config.el")


