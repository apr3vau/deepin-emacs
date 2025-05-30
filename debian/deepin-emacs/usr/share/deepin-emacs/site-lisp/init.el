;;; deepin-emacs --- Summary
;; Emacs in deepin package.

;;; Commentary:

;;; Code:
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)


;;; PATH problem
(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))


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

(when (executable-find "rg")
  (setq xref-search-program 'ripgrep))

(auto-save-mode 1)
(setq auto-save-timeout 5)

(setq fast-but-imprecise-scrolling t)
(setq redisplay-skip-fontification-on-input t)

(setq tab-always-indent 'complete)


;;; Theme

(use-package doom-themes
  :config (load-theme 'doom-one t))


;;; Completion

(use-package corfu
  :config
  (global-corfu-mode 1)
  (setq corfu-auto t
	corfu-auto-prefix 0
        corfu-cycle t))
(use-package corfu-terminal
  :config (unless (display-graphic-p)
	    (corfu-terminal-mode 1)))
(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

(use-package vertico
  :config
  (vertico-mode 1)
  (setq vertico-count 15))
(use-package orderless
  :if window-system
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))


;;; Consult

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
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
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
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

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
   consult-bookmark consult-recent-file consult-xref
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
  )
(use-package consult-projectile
  )

;; local modes added to prog-mode hooks
(add-to-list 'consult-preview-allowed-hooks 'hl-todo-mode)
(add-to-list 'consult-preview-allowed-hooks 'elide-head-mode)
;; enabled global modes
(add-to-list 'consult-preview-allowed-hooks 'global-org-modern-mode)
(add-to-list 'consult-preview-allowed-hooks 'global-hl-todo-mode)



;;; Icons

(use-package kind-icon
  :after company
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
  (let* ((kind-func (lambda (cand) (company-call-backend 'kind cand)))
         (formatter (kind-icon-margin-formatter `((company-kind . ,kind-func)))))
    (defun my-company-kind-icon-margin (cand _selected)
      (funcall formatter cand))
    (setq company-format-margin-function #'my-company-kind-icon-margin)))

(when (display-graphic-p)
  (use-package nerd-icons
    :config (unless (find-font (font-spec :name "Symbols Nerd Font Mono"))
              (nerd-icons-install-fonts t)))
  (use-package nerd-icons-completion
    :after marginalia
    :config
    (nerd-icons-completion-mode)
    (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))
  (use-package nerd-icons-ibuffer
    :hook (ibuffer-mode . nerd-icons-ibuffer-mode))
  (use-package nerd-icons-dired
    :hook
    (dired-mode . nerd-icons-dired-mode))
  (use-package treemacs-nerd-icons
    :config
    (treemacs-load-theme "nerd-icons")))


;;; Development Utils

(use-package rainbow-delimiters
  :hook
  (lisp-mode . rainbow-delimiters-mode)
  (emacs-lisp-mode . rainbow-delimiters-mode))
(use-package treemacs
  :config (global-set-key (kbd "M-0") 'treemacs-select-window))

(use-package editorconfig
  :config (editorconfig-mode 1))

(use-package autorevert
  :diminish
  :hook (after-init . global-auto-revert-mode))

(use-package aggressive-indent
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
  :diminish
  :hook (after-init . global-hungry-delete-mode)
  :init (setq hungry-delete-chars-to-skip " \t\f\v"
              hungry-delete-except-modes
              '(help-mode minibuffer-mode minibuffer-inactive-mode calc-mode)))

(use-package subword
  :diminish
  :hook ((prog-mode . subword-mode)
         (minibuffer-setup . subword-mode)))

(use-package expand-region
  :config (global-set-key (kbd "C-=") 'er/expand-region))

(use-package yasnippet
  :config
  (yas-global-mode)
  (global-set-key (kbd "C-x y") 'yas-insert-snippet))

(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown")
  :bind (:map markdown-mode-map
	      ("C-c C-e" . markdown-do)))


;;; UI

(use-package anzu
  :diminish
  :bind (([remap query-replace] . anzu-query-replace)
         ([remap query-replace-regexp] . anzu-query-replace-regexp)
         :map isearch-mode-map
         ([remap isearch-query-replace] . anzu-isearch-query-replace)
         ([remap isearch-query-replace-regexp] . anzu-isearch-query-replace-regexp))
  :hook (after-init . global-anzu-mode))

(use-package company-posframe
  :if window-system
  :config (company-posframe-mode 1))
(use-package vertico-posframe
  :if window-system
  :config (vertico-posframe-mode 1))
(use-package marginalia
  :config (marginalia-mode 1))

(use-package which-key
  :config (which-key-mode 1))
(use-package which-key-posframe
  :if window-system
  :config (which-key-posframe-mode 1))

(use-package page-break-lines
  :if window-system
  :config (global-page-break-lines-mode 1))

(use-package magit
  :after transient-posframe-mode)

(use-package highlight-thing
  :if window-system
  :config
  (global-highlight-thing-mode 1)
  (setq highlight-thing-delay-seconds 0))

(use-package flycheck
  :config
  (global-flycheck-mode 1)
  (define-key flycheck-mode-map (kbd "s-<") 'flycheck-previous-error)
  (define-key flycheck-mode-map (kbd "s->") 'flycheck-next-error))

(use-package flycheck-posframe
  :config (flycheck-posframe-mode 1))

(use-package symbol-overlay
  :config
  (add-hook 'fundamental-mode-hook 'symbol-overlay-mode)
  (global-set-key (kbd "C-<") 'symbol-overlay-jump-prev)
  (global-set-key (kbd "C->") 'symbol-overlay-jump-next))

(use-package highlight-indent-guides
  :config
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

(use-package hide-mode-line
  :hook (((treemacs-mode
           eshell-mode shell-mode
           term-mode vterm-mode eat-mode
           embark-collect-mode
           pdf-annot-list-mode) . turn-on-hide-mode-line-mode)
         (dired-mode . (lambda()
                         (and (bound-and-true-p hide-mode-line-mode)
                              (turn-off-hide-mode-line-mode))))))

(use-package transient-posframe
  :if window-system
  :diminish
  :custom-face
  (transient-posframe ((t (:inherit tooltip))))
  (transient-posframe-border ((t (:inherit posframe-border :background unspecified))))
  :init (setq transient-mode-line-format nil
              transient-posframe-poshandler 'posframe-poshandler-frame-center
              transient-posframe-parameters '((left-fringe . 8)
                                              (right-fringe . 8)))
  :config (transient-posframe-mode 1))

(use-package doom-modeline
  :if window-system
  :config (doom-modeline-mode 1))

(use-package minions
  :config (minions-mode 1))

(use-package composite
  :if window-system
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

(use-package awesome-tab
  :after nerd-icons
  :config (awesome-tab-mode 1))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-center-content t))

;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/elpa/awesome-tab/"))


;;; Coding
;; Lisp

(use-package sly
  :config
  (setq sly-lisp-implementations
        '((sbcl ("sbcl"))
          (ecl ("ecl")))
        inferior-lisp-program "sbcl"))
(use-package sly-asdf
  :config (add-to-list 'sly-contribs 'sly-asdf 'append))

(define-key emacs-lisp-mode-map (kbd "C-c C-c") 'compile-defun)
(define-key emacs-lisp-mode-map (kbd "C-c C-k") 'elisp-byte-compile-buffer)
(define-key sly-editing-mode-map (kbd "C-c C-c") 'sly-compile-defun)
(define-key sly-editing-mode-map (kbd "C-c C-k") 'sly-compile-and-load-file)

(define-key prog-mode-map (kbd "C-c C-k") 'compile)

(use-package lisp-extra-font-lock
  :config (lisp-extra-font-lock-global-mode 1))

;; Others
(use-package cmake-mode
  )
(use-package yaml-mode
  )
(use-package swift-mode
  )
(use-package python-mode
  )
(use-package go-mode
  )
(use-package rust-mode
  )
(use-package web-mode
  )


;; LSP

;; From Centaur
(use-package eglot
  :hook ((prog-mode . (lambda ()
                        (unless (derived-mode-p
                                 'emacs-lisp-mode 'lisp-mode
                                 'makefile-mode 'snippet-mode
                                 'ron-mode)
                          (eglot-ensure))))
         ((markdown-mode yaml-mode yaml-ts-mode) . eglot-ensure))
  :init
  (setq read-process-output-max (* 1024 1024)) ; 1MB
  (setq eglot-autoshutdown t
        eglot-events-buffer-size 0
        eglot-send-changes-idle-time 0.5))

(use-package consult-eglot
  :after consult eglot
  :bind (:map eglot-mode-map
              ("C-M-." . consult-eglot-symbols)))


;; Media
  )
  )

(when window-system
  (toggle-frame-maximized)
  (set-frame-parameter nil 'alpha-background 92)
  (add-to-list 'default-frame-alist '(alpha-background . 92))
  )

(provide 'init)

;;; init.el ends here
