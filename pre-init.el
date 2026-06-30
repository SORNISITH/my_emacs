
;;; pre-init.el --- Pre Init -*- no-byte-compile: t; lexical-binding: t; -*-
;; Suppress native compilation warnings
(setq native-comp-async-report-warnings-errors nil
      native-comp-warning-on-missing-source nil)

;; Suppress specific warning types
(setq warning-suppress-types '((comp) (files)))

(setq straight-repository-branch "develop"        ; Use develop branch of straight.el
      straight-use-package-by-default t          ; Make `straight-use-package' the default
      straight-check-for-modifications '(check-on-save find-when-checking) ; Check for modified files
      ;; straight-vc-git-default-clone-depth 1      ; Shallow clone to save space
      straight-enable-use-package-integration t   ; Enable use-package integration
      straight-cache-autoloads t                 ; Cache autoloads to improve startup time
      )

;; Bootstrapping straight.el
;; See: github.com/radian-software/straight.el#bootstrapping-straightel
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Configure `use-package'
(straight-use-package 'use-package)
;; (straight-use-package 'org)

;; Enable verbose logging for debugging
(setq use-package-verbose t
      use-package-compute-statistics t  ; Generate loading statistics
      debug-on-error t)                 ; Show the debugger on errors

;; Fixes eglot problem ("Feature provided by other file: ...")
(straight-use-package '(project :type built-in))
(straight-use-package '(xref :type built-in))

;; Force reinstall problematic packages
(straight-use-package '(transient :type git :host github :repo "magit/transient"))
(straight-use-package '(magit :type git :host github :repo "magit/magit"))
(straight-use-package '(rg :type git :host github :repo "dajva/rg.el"))
