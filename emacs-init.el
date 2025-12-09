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

(when (eq system-type 'gnu/linux)
  (setq package-check-signature nil)
  ;; use xclip
  (use-package xclip
    :ensure t)
  (xclip-mode 1)
)

(unless (display-graphic-p)
  (menu-bar-mode -1))

(use-package  multiple-cursors
  :ensure t
  :bind (("M-m" . mc/edit-lines)))

;; Magit setup for Emacs
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch))
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1))

;;  Let's add forge for permalinks etc
(use-package forge
     :ensure t
     :after magit
     :config
     ;; Add your GitLab instance if it's self-hosted
     (add-to-list 'forge-alist
                  '("gitlab.com" "https://gitlab.com/api/v4" "gitlab.com" forge-gitlab-repository))
                  '("github.com" "https://api.github.com" "github.com" forge-github-repository))

(setq-default gist-view-gist t)

(use-package eglot
  :custom
  ;; (eglot-send-changes-idle-time 60 "I'd rather not do this at all, but it's better than nothing.")
  (eglot-connect-timeout 60 "elixir-ls takes a while to start, sometimes.")
  :config
  (add-to-list 'eglot-server-programs '(elixir-ts-mode "elixir-ls"))
  (add-to-list 'eglot-stay-out-of 'eldoc)
  :hook ((python-ts-mode elixir-ts-mode kotlin-ts-mode) . eglot-ensure))

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

(use-package lsp-mode
  :ensure t
  :commands lsp
  :config
  (setq lsp-prefer-flymake nil))  ;; Optional: Use lsp-mode instead of flymake for diagnostics

(use-package go-mode
  :ensure t
  :hook ((go-mode . lsp)
         (go-mode
          . (lambda ()
              ;; Drop tabs from visible whitespace list
              (setq-local whitespace-style '(face empty lines-tail trailing))
              ;; Let LSP rewrite my file, because Go is too annoying otherwise
              (add-hook 'before-save-hook #'lsp-format-buffer nil 'local)
              (add-hook 'before-save-hook #'lsp-organize-imports nil 'local))))
  :config
  (add-to-list 'exec-path (concat (getenv "GOPATH") "/bin")))

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
