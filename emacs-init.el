(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(eval-when-compile
  (require 'use-package))
;; (setq use-package-verbose t)

(use-package async
  :ensure t
  :config
  (defun my/init-hook ()
    "If the current buffer is 'emacs-init.org' the code-blocks are tangled."
    (when (equal (buffer-file-name) my-org-file)
      (async-start
       `(lambda ()
          (require 'org)
          (org-babel-tangle-file ,my-org-file))
       (lambda (result)
         (message "Tangled file compiled.")))))
  (add-hook 'after-save-hook 'my/init-hook))

(add-to-list 'load-path my-elisp-dir)

(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(use-package ido
  :config
  (ido-mode t)
  (setq ido-everywhere t
        ;; If the file at point exists, use that
        ido-use-filename-at-point nil
        ;; Or if it is an URL...
        ido-use-url-at-point nil
        ;; Even if TAB completes uniquely,
        ;; still wait for RET
        ido-confirm-unique-completion t
        ;; If the input does not exist,
        ;; don't look in unexpected places.
        ;; I probably want a new file.
        ido-auto-merge-work-directories-length -1))

(use-package uniquify
  ;; :ensure t
  :config
  (setq uniquify-buffer-name-style 'post-forward
        uniquify-separator ":"))

;; Syntax highlighting on.
(global-font-lock-mode 1)
(defconst font-lock-maximum-decoration t)

;; Show various whitespace.
(setq whitespace-style '(face empty tabs lines-tail trailing))
(global-whitespace-mode t)
(setq-default show-trailing-whitespace t)

;; Enable highlighting when marking a region
(setq-default transient-mark-mode t)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(setq-default fill-column 79)

(unless (display-graphic-p)
  (menu-bar-mode -1))

(when (boundp 'aquamacs-version)
  ;; Make this more Emacsy.
  (one-buffer-one-frame-mode -1)
  (tabbar-mode -1)

  ;; Make some keybindings saner.
  (define-key osx-key-mode-map `[(,osxkeys-command-key w)] nil)
  (define-key osx-key-mode-map [home] 'move-beginning-of-line)
  (define-key osx-key-mode-map  [end] 'move-end-of-line)
  (define-key osx-key-mode-map [A-home] 'beginning-of-buffer)
  (define-key osx-key-mode-map  [A-end] 'end-of-buffer)
  (define-key osx-key-mode-map [C-left] 'backward-word)
  (define-key osx-key-mode-map [C-right] 'forward-word)

  ;; Get rid of the stupid "Mac" modifiers.
  (setq ns-use-mac-modifier-symbols nil)

  ;; Improve zooming.
  (require 'zoom-replacement)
  (define-key osx-key-mode-map `[(,osxkeys-command-key =)] 'zoom-interactive)
  (define-key osx-key-mode-map `[(,osxkeys-command-key +)] 'zoom-interactive)
  (define-key osx-key-mode-map `[(,osxkeys-command-key -)] 'zoom-interactive-out))

(unless (boundp 'aquamacs-version)
  (when (display-graphic-p)
    ;; Nicer font.
    (set-face-attribute
     'default nil
     :family "Inconsolata" :height 140 :weight 'normal)))

;; Autorevert to make VCS nicer
(global-auto-revert-mode 1)

;; One space between sentences, please.
(setq sentence-end-double-space nil)

;; Undo some cruft that may have been done.
(cua-mode 0)
(if window-system (tool-bar-mode 0))
(setq inhibit-startup-screen t)

;; Better behaviour when started with multiple files.
(setq inhibit-startup-buffer-menu t)
(setq split-width-threshold 150)

;; Current point in mode bar.
(line-number-mode t)
(column-number-mode t)

;; Turn off backups (that's what VCS is for) and move auto-save out the way.
(setq auto-save-default nil)
(setq make-backup-files nil)

;; Can I have muliple cursors??
(use-package multiple-cursors
  :ensure t)
;; Setting keybind for mc here for now. Do this better.
(global-set-key (kbd "M-m") 'mc/edit-lines)

(setq-default gist-view-gist t)

(use-package org
  :config
  (setq org-src-fontify-natively t))

(use-package clojure-mode
  :ensure t
  :init
  (add-hook 'clojure-mode-hook #'enable-paredit-mode)
  :config
  (use-package flycheck-clj-kondo
    :ensure t))

(use-package cider
  :ensure t
  :defer t)

(use-package csv-mode
  :ensure t)

(use-package dockerfile-mode
  :ensure t
  :mode "\\.docker$")

(use-package go-mode
  :ensure t
  :hook ((go-mode . lsp)
         ;; Drop tabs from visible whitespace list
         (go-mode . (lambda ()
                      (setq-local whitespace-style
                                  '(face empty lines-tail trailing))))
         ;; Let LSP rewrite my file, because Go is too annoying otherwise
         (before-save . lsp-format-buffer)
         (before-save . lsp-organize-imports))
  :config
  (add-to-list 'exec-path (concat (getenv "GOPATH") "/bin")))

;; (use-package flycheck-gometalinter
;;   :ensure t
;;   :config
;;   (progn
;;     (setq flycheck-gometalinter-fast t)
;;     (setq flycheck-gometalinter-tests t)
;;     (setq flycheck-gometalinter-deadline "10s")
;;     (flycheck-gometalinter-setup)))

;; (use-package flycheck-golangci-lint
;;   :ensure t
;;   :hook (go-mode . flycheck-golangci-lint-setup)
;;   :config
;;   (setq flycheck-golangci-lint-tests t)
;;   (setq flycheck-golangci-lint-deadline "5s")
;;   ;; There's a bug that requires us to stick = on the front.
;;   (setq flycheck-golangci-lint-config
;;         (expand-file-name "~/.gostuff/golangci-emacs.yml")))

;; web-mode, please.
(use-package web-mode
  :ensure t
  :mode (("\\.html?$" . web-mode)
         ("\\.tsx$" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-script-padding 2)
  ;; Use tidy5 instead of tidy, because we like HTML5.
  (setq flycheck-html-tidy-executable "tidy5")
  (add-hook 'web-mode-hook
        (lambda ()
          (when (string-equal "tsx" (file-name-extension buffer-file-name))
            (setup-tide-mode)))))

;; This is like HTML, right?
(use-package sass-mode
  :ensure t
  :mode "\\.scss\\'")

(use-package jq-mode
  :ensure t
  :mode (("\\.jq$" . jq-mode)))

(use-package markdown-mode
  :ensure t)

(use-package powershell
  :ensure t)

(use-package python-mode
  :ensure t
  :init
  (setq py-underscore-word-syntax-p nil)
  :custom
  ;; This breaks indenting various things.
  ;; (py-closing-list-dedents-bos t)
  (py-docstring-syle 'django)
  (py-docstring-fill-column 79)
  (py-mark-decorators t)
  (py-indent-list-style 'one-level-to-beginning-of-statement))

;; (add-hook 'rust-mode-hook #'flycheck-rust-setup)

(use-package cargo
  :ensure t
  )

(use-package rust-mode
  :ensure t
  )

(add-hook 'shell-mode-hook 'emacs-lock-mode)

(use-package terraform-mode
  :ensure t)

(add-hook 'text-mode-hook
          (lambda ()
            (setq-local whitespace-style '(face empty tabs trailing))
            (turn-on-visual-line-mode)))

(use-package typescript-mode
  :ensure t)

(setq-default typescript-indent-level 2)

(use-package tide
  :ensure t
  :after (typescript-mode flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)))

(use-package yaml-mode
  :ensure t)
