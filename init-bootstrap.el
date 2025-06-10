;; deepin-emacs --- Summary -*- lexical-binding: t -*-
;; Emacs in deepin package.

;;; Commentary:

;;; Code:
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)


;;; PATH problem

(use-package exec-path-from-shell
  :ensure t
  :config (exec-path-from-shell-initialize))


;;; Emacs default settings
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

(setq-default blink-cursor-mode nil)
(setq-default indent-tabs-mode nil)

(set-face-attribute 'default nil :height 110)

(electric-pair-mode 1)
(savehist-mode 1)

(when window-system
  (global-hl-line-mode 1))

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq display-line-numbers 'relative)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(use-package xref
  :config (when (executable-find "rg")
            (setq xref-search-program 'ripgrep)))

(use-package auto-save
  :hook (after-init . auto-save-mode)
  :config (setq auto-save-timeout 5))

(setq fast-but-imprecise-scrolling t
      scroll-conservatively 101
      redisplay-skip-fontification-on-input t
      inhibit-startup-message t

      tab-always-indent 'complete)


;;; Theme

(use-package doom-themes
  :ensure t
  :config (load-theme 'doom-dracula t))


;;; Completion

(use-package corfu
  :ensure t
  :config
  (global-corfu-mode 1)
  (setq corfu-auto t
	corfu-auto-prefix 0
        corfu-cycle t))
(use-package corfu-terminal
  :if (null window-system)
  :ensure t
  :config (corfu-terminal-mode 1))
(use-package cape
  :ensure t
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

(use-package vertico
  :ensure t
  :config
  (vertico-mode 1)
  (setq vertico-count 15))
(use-package orderless
  :if window-system
  :ensure t
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))


;;; Consult

;; From Centaur
(use-package consult
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flycheck)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-Line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
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
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  ;; (setq xref-show-xrefs-function #'consult-xref
  ;;       xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
  )
(use-package consult-flycheck
  :ensure t
  )
(use-package consult-projectile
  :ensure t
  :bind (("M-s p" . consult-projectile)))

;; local modes added to prog-mode hooks
(add-to-list 'consult-preview-allowed-hooks 'hl-todo-mode)
(add-to-list 'consult-preview-allowed-hooks 'elide-head-mode)
;; enabled global modes
(add-to-list 'consult-preview-allowed-hooks 'global-org-modern-mode)
(add-to-list 'consult-preview-allowed-hooks 'global-hl-todo-mode)


;;; Icons

(use-package kind-icon
  :if (null window-system)
  :ensure t
  :after company
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
  ;; We don't use company.
  ;; (let* ((kind-func (lambda (cand) (company-call-backend 'kind cand)))
  ;;        (formatter (kind-icon-margin-formatter `((company-kind . ,kind-func)))))
  ;;   (defun my-company-kind-icon-margin (cand _selected)
  ;;     (funcall formatter cand))
  ;;   (setq company-format-margin-function #'my-company-kind-icon-margin))
  )

(use-package nerd-icons
  :if window-system
  :ensure t
  :config (when (and window-system
                     (null (find-font (font-spec :name "Symbols Nerd Font Mono"))))
            (nerd-icons-install-fonts t)))

(use-package nerd-icons-completion
  :if window-system
  :ensure t
  :after marginalia
  :config
  (add-hook 'after-init-hook 'nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook 'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :if window-system
  :ensure t
  :config (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-ibuffer
  :if window-system
  :ensure t
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package nerd-icons-dired
  :if window-system
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode))
(use-package treemacs-nerd-icons
  :if window-system
  :ensure t
  :config
  (treemacs-load-theme "nerd-icons"))


;;; UI

;; Scrolling
(use-package ultra-scroll
  :init (unless (package-installed-p 'ultra-scroll) (package-vc-install "https://github.com/jdtsmith/ultra-scroll"))
  :hook (after-init . ultra-scroll-mode))

;; Extra info
(use-package anzu
  :ensure t
  :diminish
  :bind (([remap query-replace] . anzu-query-replace)
         ([remap query-replace-regexp] . anzu-query-replace-regexp)
         :map isearch-mode-map
         ([remap isearch-query-replace] . anzu-isearch-query-replace)
         ([remap isearch-query-replace-regexp] . anzu-isearch-query-replace-regexp))
  :hook (after-init . global-anzu-mode))

(use-package helpful
  :ensure t
  :config
  (global-set-key (kbd "C-h f") #'helpful-callable)
  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h k") #'helpful-key)
  (global-set-key (kbd "C-h x") #'helpful-command)
  (global-set-key (kbd "C-c C-d") #'helpful-at-point)
  (global-set-key (kbd "C-h F") #'helpful-function))

(use-package which-key
  :ensure t
  :hook (after-init . which-key-mode))

(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode))

;; Prettifier

(use-package page-break-lines
  :if window-system
  :ensure t
  :hook (after-init . global-page-break-lines-mode))

(use-package highlight-thing
  :if window-system
  :ensure t
  :hook (after-init . global-highlight-thing-mode)
  :config
  (setq highlight-thing-delay-seconds 0
        highlight-thing-excluded-major-modes '(dired-mode)))

(use-package symbol-overlay
  :ensure t
  :hook (fundamental . symbol-overlay-mode)
  :bind (("C-<" . symbol-overlay-jump-prev)
         ("C->" . symbol-overlay-jump-next)))

(use-package highlight-indent-guides
  :ensure t
  :hook (prog-mode . highlight-indent-guides-mode)
  :config (setq highlight-indent-guides-method 'bitmap
                highlight-indent-guides-bitmap-function 'highlight-indent-guides--bitmap-line
                highlight-indent-guides-auto-odd-face-perc 60
                highlight-indent-guides-auto-even-face-perc 30
                highlight-indent-guides-auto-character-face-perc 90))

;; Posframe

(use-package company-posframe
  :if window-system
  :ensure t
  :hook (after-init . company-posframe-mode))
(use-package vertico-posframe
  :if window-system
  :ensure t
  :hook (after-init . vertico-posframe-mode))

(use-package which-key-posframe
  :if window-system
  :ensure t
  :hook (after-init . which-key-posframe-mode))

(use-package flycheck-posframe
  :ensure t
  :after flycheck
  :hook (after-init . flycheck-posframe-mode))

(use-package transient-posframe
  :if window-system
  :ensure t
  :diminish
  :custom-face
  (transient-posframe ((t (:inherit tooltip))))
  (transient-posframe-border ((t (:inherit posframe-border :background unspecified))))
  :init (setq transient-mode-line-format nil
              transient-posframe-poshandler 'posframe-poshandler-frame-center
              transient-posframe-parameters '((left-fringe . 8)
                                              (right-fringe . 8)))
  :config (transient-posframe-mode 1))

;; Tabbar and Modeline

(use-package awesome-tab
  :init (unless (package-installed-p 'awesome-tab) (package-vc-install "https://github.com/apr3vau/awesome-tab"))
  :after nerd-icons
  :hook (after-init . awesome-tab-mode))

(use-package hide-mode-line
  :ensure t
  :hook (((treemacs-mode
           eshell-mode shell-mode
           term-mode vterm-mode eat-mode
           embark-collect-mode
           pdf-annot-list-mode) . turn-on-hide-mode-line-mode)
         (dired-mode . (lambda()
                         (and (bound-and-true-p hide-mode-line-mode)
                              (turn-off-hide-mode-line-mode))))))

(use-package doom-modeline
  :if window-system
  :ensure t
  :hook (after-init . doom-modeline-mode))

(use-package minions
  :ensure t
  :hook (after-init . minions-mode))

;; Ligatures
;; From Centaur
(use-package composite
  :if window-system
  :ensure nil
  :init (defvar composition-ligature-table (make-char-table nil))
  :hook (((prog-mode
           conf-mode nxml-mode markdown-mode help-mode
           shell-mode eshell-mode term-mode vterm-mode)
          . (lambda () (setq-local composition-function-table composition-ligature-table))))
  :config
  ;; support ligatures, some toned down to prevent hang
  (let ((alist
         '((33  . ".\\(?:\\(==\\|[!=]\\)[!=]?\\)")
           (35  . ".\\(?:\\(###?\\|_(\\|[(:=?[_{]\\)[#(:=?[_{]?\\)")
           (36  . ".\\(?:\\(>\\)>?\\)")
           (37  . ".\\(?:\\(%\\)%?\\)")
           (38  . ".\\(?:\\(&\\)&?\\)")
           (42  . ".\\(?:\\(\\*\\*\\|[*>]\\)[*>]?\\)")
           ;; (42 . ".\\(?:\\(\\*\\*\\|[*/>]\\).?\\)")
           (43  . ".\\(?:\\([>]\\)>?\\)")
           ;; (43 . ".\\(?:\\(\\+\\+\\|[+>]\\).?\\)")
           (45  . ".\\(?:\\(-[->]\\|<<\\|>>\\|[-<>|~]\\)[-<>|~]?\\)")
           ;; (46 . ".\\(?:\\(\\.[.<]\\|[-.=]\\)[-.<=]?\\)")
           (46  . ".\\(?:\\(\\.<\\|[-=]\\)[-<=]?\\)")
           (47  . ".\\(?:\\(//\\|==\\|[=>]\\)[/=>]?\\)")
           ;; (47 . ".\\(?:\\(//\\|==\\|[*/=>]\\).?\\)")
           (48  . ".\\(?:x[a-zA-Z]\\)")
           (58  . ".\\(?:\\(::\\|[:<=>]\\)[:<=>]?\\)")
           (59  . ".\\(?:\\(;\\);?\\)")
           (60  . ".\\(?:\\(!--\\|\\$>\\|\\*>\\|\\+>\\|-[-<>|]\\|/>\\|<[-<=]\\|=[<>|]\\|==>?\\||>\\||||?\\|~[>~]\\|[$*+/:<=>|~-]\\)[$*+/:<=>|~-]?\\)")
           (61  . ".\\(?:\\(!=\\|/=\\|:=\\|<<\\|=[=>]\\|>>\\|[=>]\\)[=<>]?\\)")
           (62  . ".\\(?:\\(->\\|=>\\|>[-=>]\\|[-:=>]\\)[-:=>]?\\)")
           (63  . ".\\(?:\\([.:=?]\\)[.:=?]?\\)")
           (91  . ".\\(?:\\(|\\)[]|]?\\)")
           ;; (92 . ".\\(?:\\([\\n]\\)[\\]?\\)")
           (94  . ".\\(?:\\(=\\)=?\\)")
           (95  . ".\\(?:\\(|_\\|[_]\\)_?\\)")
           (119 . ".\\(?:\\(ww\\)w?\\)")
           (123 . ".\\(?:\\(|\\)[|}]?\\)")
           (124 . ".\\(?:\\(->\\|=>\\||[-=>]\\||||*>\\|[]=>|}-]\\).?\\)")
           (126 . ".\\(?:\\(~>\\|[-=>@~]\\)[-=>@~]?\\)"))))
    (dolist (char-regexp alist)
      (set-char-table-range composition-ligature-table (car char-regexp)
                            `([,(cdr char-regexp) 0 font-shape-gstring]))))
  (set-char-table-parent composition-ligature-table composition-function-table))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-center-content t))

(use-package ace-window
  :ensure t
  :custom-face
  (aw-leading-char-face ((t (:inherit font-lock-keyword-face :foreground unspecified :bold t :height 3.0))))
  (aw-minibuffer-leading-char-face ((t (:inherit font-lock-keyword-face :bold t :height 1.0))))
  (aw-mode-line-face ((t (:inherit mode-line-emphasis :bold t))))
  :bind (([remap other-window] . ace-window))
  :hook (emacs-startup . ace-window-display-mode))

;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa/awesome-tab/"))


;;; Coding

;; Helper
(use-package magit
  :ensure t
  :after transient-posframe-mode)

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode 1)
  (define-key flycheck-mode-map (kbd "s-<") 'flycheck-previous-error)
  (define-key flycheck-mode-map (kbd "s->") 'flycheck-next-error))

(use-package treemacs
  :ensure t
  :bind (("M-0" . treemacs-select-window)))

(use-package yafolding
  :ensure t
  :hook ((prog-mode . yafolding-mode)))

(use-package autorevert
  :ensure nil
  :diminish
  :hook (after-init . global-auto-revert-mode))

(use-package aggressive-indent
  :ensure t
  :diminish
  :hook ((after-init . global-aggressive-indent-mode))
  :config
  ;; Disable in some modes
  (dolist (mode '(gitconfig-mode
                  asm-mode web-mode html-mode
                  css-mode css-ts-mode
                  go-mode go-ts-mode
                  python-ts-mode yaml-ts-mode
                  scala-mode
                  shell-mode term-mode vterm-mode
                  prolog-inferior-mode
                  sly-mrepl-mode))
    (add-to-list 'aggressive-indent-excluded-modes mode)))

(use-package hungry-delete
  :ensure t
  :diminish
  :hook (after-init . global-hungry-delete-mode)
  :init (setq hungry-delete-chars-to-skip " \t\f\v"
              hungry-delete-except-modes
              '(help-mode minibuffer-mode minibuffer-inactive-mode calc-mode)))

(use-package subword
  :ensure nil
  :diminish
  :hook ((prog-mode . subword-mode)
         (minibuffer-setup . subword-mode)))

(use-package expand-region
  :ensure t
  :config (global-set-key (kbd "C-=") 'er/expand-region))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode)
  (global-set-key (kbd "C-x y") 'yas-insert-snippet))

;; Lisp

(use-package sly
  :ensure t
  :config
  (setq sly-lisp-implementations
        '((sbcl ("sbcl"))
          (ecl ("ecl")))
        inferior-lisp-program "sbcl"))
(use-package sly-asdf
  :ensure t
  :config (add-to-list 'sly-contribs 'sly-asdf 'append))

(define-key emacs-lisp-mode-map (kbd "C-c C-c") 'compile-defun)
(define-key emacs-lisp-mode-map (kbd "C-c C-k") 'elisp-byte-compile-buffer)
(define-key sly-editing-mode-map (kbd "C-c C-c") 'sly-compile-defun)
(define-key sly-editing-mode-map (kbd "C-c C-k") 'sly-compile-and-load-file)

(define-key prog-mode-map (kbd "C-c C-k") 'compile)

(use-package lisp-extra-font-lock
  :init (unless (package-installed-p 'lisp-extra-font-lock) (package-vc-install "https://github.com/apr3vau/lisp-extra-font-lock"))
  :config (lisp-extra-font-lock-global-mode 1))

;; Others
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown")
  :bind (:map markdown-mode-map
	      ("C-c C-e" . markdown-do)))
(use-package cmake-mode
  :ensure t
  )
(use-package yaml-mode
  :ensure t
  )
(use-package swift-mode
  :ensure t
  )
(use-package python-mode
  :ensure t
  )
(use-package pyvenv
  :ensure t
  )
(use-package go-mode
  :ensure t
  )
(use-package rust-mode
  :ensure t
  )
(use-package web-mode
  :ensure t
  :mode
  (("\\.html\\'" . web-mode)
   ("\\.phtml\\'" . web-mode)
   ("\\.php\\'" . web-mode)
   ("\\.tpl\\'" . web-mode)
   ("\\.[agj]sp\\'" . web-mode)
   ("\\.as[cp]x\\'" . web-mode)
   ("\\.erb\\'" . web-mode)
   ("\\.mustache\\'" . web-mode)
   ("\\.djhtml\\'" . web-mode)))


;; LSP
;; From Centaur
(use-package lsp-mode
  :ensure t
  :diminish
  :defines (lsp-diagnostics-disabled-modes lsp-clients-python-library-directories)
  :autoload lsp-enable-which-key-integration
  :commands (lsp-format-buffer lsp-organize-imports)
  :preface
  ;; Performace tuning
  ;; @see https://emacs-lsp.github.io/lsp-mode/page/performance/
  (setq read-process-output-max (* 1024 1024)) ; 1MB
  (setenv "LSP_USE_PLISTS" "true")
  :hook ((prog-mode . (lambda ()
                        (unless (derived-mode-p 'emacs-lisp-mode 'lisp-mode 'makefile-mode 'snippet-mode)
                          (lsp-deferred))))
         ((markdown-mode yaml-mode yaml-ts-mode) . lsp-deferred))
  :bind (:map lsp-mode-map
              ("C-c C-d" . lsp-describe-thing-at-point)
              ([remap xref-find-definitions] . lsp-find-definition)
              ([remap xref-find-references] . lsp-find-references))
  :init (setq lsp-use-plists t

              lsp-keymap-prefix "C-c l"
              lsp-keep-workspace-alive nil
              lsp-signature-auto-activate nil
              lsp-modeline-code-actions-enable nil
              lsp-modeline-diagnostics-enable nil
              lsp-modeline-workspace-status-enable nil

              lsp-semantic-tokens-enable t
              lsp-progress-spinner-type 'progress-bar-filled

              lsp-enable-file-watchers nil
              lsp-enable-folding nil
              lsp-enable-symbol-highlighting nil
              lsp-enable-text-document-color nil

              lsp-enable-indentation nil
              lsp-enable-on-type-formatting nil

              ;; For diagnostics
              lsp-diagnostics-disabled-modes '(markdown-mode gfm-mode)

              ;; For clients
              lsp-clients-python-library-directories '("/usr/local/" "/usr/"))
  :config
  (use-package consult-lsp
    :ensure t
    :bind (:map lsp-mode-map
                ("C-M-." . consult-lsp-symbols)))

  (with-no-warnings

    ;; Disable `lsp-mode' in `git-timemachine-mode'
    (defun my-lsp--init-if-visible (fn &rest args)
      (unless (bound-and-true-p git-timemachine-mode)
        (apply fn args)))
    (advice-add #'lsp--init-if-visible :around #'my-lsp--init-if-visible)

    ;; Enable `lsp-mode' in sh/bash/zsh
    (defun my-lsp-bash-check-sh-shell (&rest _)
      (and (memq major-mode '(sh-mode bash-ts-mode))
           (memq sh-shell '(sh bash zsh))))
    (advice-add #'lsp-bash-check-sh-shell :override #'my-lsp-bash-check-sh-shell)
    (add-to-list 'lsp-language-id-configuration '(bash-ts-mode . "shellscript"))))

(use-package lsp-ui
  :ensure t
  :custom-face
  (lsp-ui-sideline-code-action ((t (:inherit warning))))
  :bind (("C-c u" . lsp-ui-imenu)
         :map lsp-ui-mode-map
         ("s-<return>" . lsp-ui-sideline-apply-code-actions)
         ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
         ([remap xref-find-references] . lsp-ui-peek-find-references))
  :hook (lsp-mode . lsp-ui-mode)
  :init
  (setq lsp-ui-sideline-show-diagnostics nil
        lsp-ui-sideline-ignore-duplicate t
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-symbol nil
        lsp-ui-doc-delay 0.1
        lsp-ui-doc-show-with-cursor t
        lsp-ui-imenu-auto-refresh 'after-save
        lsp-ui-imenu-colors `(,(face-foreground 'font-lock-keyword-face)
                              ,(face-foreground 'font-lock-string-face)
                              ,(face-foreground 'font-lock-constant-face)
                              ,(face-foreground 'font-lock-variable-name-face)))
  :config
  (with-no-warnings
    ;; Display peek in child frame if possible
    ;; @see https://github.com/emacs-lsp/lsp-ui/issues/441
    (defvar lsp-ui-peek--buffer nil)
    (defun lsp-ui-peek--peek-display (fn src1 src2)
      (if window-system
          (let* ((win-width (frame-width))
                 (lsp-ui-peek-list-width (/ (frame-width) 2))
                 (string (-some--> (-zip-fill "" src1 src2)
                           (--map (lsp-ui-peek--adjust win-width it) it)
                           (-map-indexed 'lsp-ui-peek--make-line it)
                           (-concat it (lsp-ui-peek--make-footer)))))
            (setq lsp-ui-peek--buffer (get-buffer-create " *lsp-peek--buffer*"))
            (posframe-show lsp-ui-peek--buffer
                           :string (mapconcat 'identity string "")
                           :min-width (frame-width)
                           :internal-border-color (face-background 'posframe-border nil t)
                           :internal-border-width 1
                           :poshandler #'posframe-poshandler-frame-center))
        (funcall fn src1 src2)))
    (defun lsp-ui-peek--peek-destroy (fn)
      (if window-system
          (progn
            (when (bufferp lsp-ui-peek--buffer)
              (posframe-hide lsp-ui-peek--buffer))
            (setq lsp-ui-peek--last-xref nil))
        (funcall fn)))
    (advice-add #'lsp-ui-peek--peek-new :around #'lsp-ui-peek--peek-display)
    (advice-add #'lsp-ui-peek--peek-hide :around #'lsp-ui-peek--peek-destroy)

    ;; Handle docs
    (defun my-lsp-ui-doc--handle-hr-lines nil
      (let (bolp next before after)
        (goto-char 1)
        (while (setq next (next-single-property-change (or next 1) 'markdown-hr))
          (when (get-text-property next 'markdown-hr)
            (goto-char next)
            (setq bolp (bolp)
                  before (char-before))
            (delete-region (point) (save-excursion (forward-visible-line 1) (point)))
            (setq after (char-after (1+ (point))))
            (insert
             (concat
              (and bolp (not (equal before ?\n)) (propertize "\n" 'face '(:height 0.5)))
              (propertize "\n" 'face '(:height 0.5))
              (propertize " "
                          ;; :align-to is added with lsp-ui-doc--fix-hr-props
                          'display '(space :height (1))
                          'lsp-ui-doc--replace-hr t
                          'face `(:background ,(face-foreground 'font-lock-comment-face nil t)))
              ;; :align-to is added here too
              (propertize " " 'display '(space :height (1)))
              (and (not (equal after ?\n)) (propertize " \n" 'face '(:height 0.5)))))))))
    (advice-add #'lsp-ui-doc--handle-hr-lines :override #'my-lsp-ui-doc--handle-hr-lines)))

;; `lsp-mode' and `treemacs' integration
(use-package lsp-treemacs
  :ensure t
  :after lsp-mode
  :bind (:map lsp-mode-map
              ("C-<f8>" . lsp-treemacs-errors-list)
              ("M-<f8>" . lsp-treemacs-symbols)
              ("s-<f8>" . lsp-treemacs-java-deps-list))
  :config
  (lsp-treemacs-sync-mode 1)
  (with-eval-after-load 'ace-window
    (when (boundp 'aw-ignored-buffers)
      (push 'lsp-treemacs-symbols-mode aw-ignored-buffers)
      (push 'lsp-treemacs-java-deps-mode aw-ignored-buffers))))

;; Python
(use-package lsp-pyright
  :ensure t
  :init
  (when (executable-find "python3")
    (setq lsp-pyright-python-executable-cmd "python3"))

  (defun lsp-pyright-format-buffer ()
    "Use `yapf' to format the buffer."
    (interactive)
    (when (and (executable-find "yapf") buffer-file-name)
      (call-process "yapf" nil nil nil "-i" buffer-file-name))))

;; Julia
(use-package lsp-julia
  :ensure t
  :hook (julia-mode . (lambda () (require 'lsp-julia))))

;; Java
(use-package lsp-java
  :ensure t
  :hook ((java-mode java-ts-mode jdee-mode) . (lambda () (require 'lsp-java))))


;; Media

(use-package dirvish
  :ensure t
  :config (dirvish-override-dired-mode 1))

(use-package emms
  :ensure t
  )
(use-package erc
  :ensure t
  )

(when window-system
  (toggle-frame-maximized)
  (set-frame-parameter nil 'alpha-background 95)
  (add-to-list 'default-frame-alist '(alpha-background . 95))
  )

(provide 'init)

;;; init.el ends here
