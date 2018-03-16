;;; -*- lexical-binding: t; coding: utf-8 -*-
;;; init.el -- Emacs startup file of Eric Haberstroh

;;; Commentary:
;; This is the Emacs initialization file of Eric Haberstroh.

;;; Code:
;; At first, let's load the Common Lisp library built into Emacs. It contains
;; some functions we will need in the course of this init file.
(require 'cl)

;; Instead of the built-in Emacs package manager (package.el), this
;; configuration uses straight.el, a modern alternative that allows for easy
;; reproduction of the entire Emacs configuration on a different machine and
;; overcomes some other flaws of package.el. This bit of code initializes the
;; straight.el package managing system. Taken from:
;; <https://github.com/raxod502/straight.el#getting-started>
(when (version< emacs-version "24.4")
  (error "This configuration will only work for Emacs >=
24.4. Stopping execution."))
(let ((bootstrap-file (concat user-emacs-directory "straight/repos/straight.el/bootstrap.el"))
      (bootstrap-version 3))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; straight.el works well together with use-package, which allows for
;; easy configuration of package options for each individual package
;; we require. For this to work, we need to tell straight.el that we
;; want to make use of use-package.
(straight-use-package 'use-package)

;; In order to tell use-package to use the straight.el package manager
;; in every instance, we could either use ":straight t" in every
;; use-package call, or simply set the value of
;; straight-use-package-by-default to a non-nil value, which is what I
;; prefer.
(setq straight-use-package-by-default t)

;; Toolbars, menu bars and scrollbars are for noobs.
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; All frames shall initially be maximized.
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; The title of the frame should usually be just "Emacs".
(setq frame-title-format "Emacs")

;; Nobody needs that bloody splash screen.
(setq inhibit-startup-message t)

;; As one of the first packages, let's use diminish.el, which allows us to hide
;; minor modes from the modeline. We can use this together with use-package as
;; described at
;; <https://github.com/jwiegley/use-package#diminishing-and-delighting-minor-modes>.
(use-package diminish)

;; Let's use a different theme: Abyss Theme taken from
;; <https://emacsthemes.com/themes/abyss-theme.html>.
(use-package abyss-theme
  :config
  (load-theme 'abyss t))

;; Powerline is a nicer theme for the modeline. This is taken from
;; <https://github.com/milkypostman/powerline>.
(use-package powerline
  :config
  (powerline-default-theme))

;; Always show line numbers.
(global-linum-mode 1)

;; I want to have relative line numbers so that I can efficiently operate on
;; multiple lines with a prefix argument (C-u). For this, we need the
;; linum-relative package.
(use-package linum-relative
  :diminish linum-relative-mode
  :config
  (linum-relative-mode 1)
  ;; Show the absolute line number in the current line. See
  ;; <https://emacs.stackexchange.com/questions/19532/hybrid-line-number-mode-in-emacs>
  (setq linum-relative-current-symbol ""))

;; Hack is a nicer font than the default. Taken from
;; <https://github.com/source-foundry/Hack>.
(set-face-attribute 'default nil
		    :family "Hack" :height 120)

;; Do not show continuation lines. Instead truncate lines that are too long.
(setq-default truncate-lines t
	      truncate-partial-width-windows t)

;; Set the default fill-column to a more sensible 80.
(setq-default fill-column 80)

;; Automatically close any brackets we might open.
(electric-pair-mode 1)

;; Show matching parens.
(show-paren-mode 1)

;; Quickly jump between windows with ace-window. Taken from
;; <https://github.com/abo-abo/ace-window>.
(use-package ace-window
  :bind (("M-o" . ace-window))
  :config
  ;; Make the font for the window label bigger.
  (set-face-attribute 'aw-leading-char-face nil :height 400))

;; Use C-c and the arrow keys to quickly move between windows.
(global-set-key (kbd "C-c <left>") 'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>") 'windmove-up)
(global-set-key (kbd "C-c <down>") 'windmove-down)

;; Quickly jump to positions within a buffer with ace-jump. Taken from
;; <https://github.com/winterTTr/ace-jump-mode>.
(use-package ace-jump-mode
  :bind (("C-c SPC" . ace-jump-mode)
	 ("C-x SPC" . ace-jump-mode-pop-mark))
  :config
  (ace-jump-mode-enable-mark-sync))

;; Neotree shows a tree of the current directory and allows for quick switching
;; between files in a project.
(use-package neotree
  :bind (("<f8>" . neotree-toggle)))

;; which-key is a package that allows for easy discovery of available
;; keybindings.
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode))

;; With prettify-symbols-mode, certain symbols can be "prettified" in the
;; buffer.
(setq-default prettify-symbols-alist '(("lambda" . ?λ)
                                       ("delta" . ?Δ)
                                       ("gamma" . ?Γ)
                                       ("phi" . ?φ)
                                       ("psi" . ?ψ)))
(global-prettify-symbols-mode 1)

;; drag-stuff adds Drag & Drop support to Emacs.
(use-package drag-stuff
  :diminish drag-stuff-mode
  :config
  (drag-stuff-global-mode 1))

;; multiple-cursors adds support for multiple cursors to Emacs, a feature that I
;; learned to greatly appreciate in other editors like Sublime Text and Atom, so
;; much so that I cannot imagine to live without them anymore. To use them in
;; Emacs, first mark a word by hitting C-SPC and moving to where it ends. Then
;; add more cursors, either with C-< to go back, C-> to go forward, C-c C-< to
;; mark all. To quit, use RET or C-g. This is all well explained in Emacs Rocks
;; Ep. 13 <http://emacsrocks.com/e13.html>.
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

;; I would like to have a vertical bar as the default cursor.
(setq-default cursor-type 'bar)

;; Company is a text completion framework for Emacs.
(use-package company
  :diminish company-mode
  :config
  (add-hook 'after-init-hook 'global-company-mode))

;; Helm is an incremental completion and selection narrowing framework.
(use-package helm
  :diminish helm-mode
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files))
  :config
  (require 'helm-config)
  (helm-mode 1)
  (helm-adaptive-mode 1)
  (setq helm-M-x-fuzzy-match t
        helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match t))

;; Projectile is a project interaction library for Emacs.
(use-package projectile
  :config
  (projectile-mode))

;; helm-projectile integrates Projectile and Helm.
(use-package helm-projectile
  :config
  (setq projectile-completion-system 'helm)
  (helm-projectile-on))

;; helm-descbinds describes keybindings in a more modern fashion.
(use-package helm-descbinds
  :config
  (helm-descbinds-mode))

;; Flyspell provides on-the-fly spell checking. We will enable it in all text
;; modes and also enable flyspell-prog-mode which checks strings and comments in
;; source code files.
(use-package flyspell
  :diminish flyspell-mode
  :config
  (add-hook 'text-mode-hook 'turn-on-flyspell)
  (add-hook 'prog-mode-hook 'flyspell-prog-mode))

;; undo-tree lets you visualize the changes you have made to a document and jump
;; back to any prior state. We globally bind C-x u to undo-tree-visualize
;; instead of the default undo function.
(use-package undo-tree
  :bind (("C-x u" . undo-tree-visualize))
  :config
  (global-undo-tree-mode))

;; When ZSH is installed on the system, use that as the shell for the ANSI
;; terminal. Otherwise fallback to Bash.
(if (executable-find "zsh")
    (setq explicit-shell-file-name (executable-find "zsh"))
  (setq explicit-shell-file-name (executable-find "bash")))

;; This advice tells term to kill the buffer when the terminal process has
;; ended, instead of letting it float around uselessly.
(defadvice term-sentinel (around my-advice-term-sentinel (proc msg))
  (if (memq (process-status proc) '(signal exit))
      (let ((buffer (process-buffer proc)))
        ad-do-it
        (kill-buffer buffer))
    ad-do-it))
(ad-activate 'term-sentinel)

;; This advice tells term to automatically use the right shell.
(defadvice ansi-term (before force-bash)
  (interactive (list explicit-shell-file-name)))
(ad-activate 'ansi-term)

;; I would like to have a quick keybinding to jump into an ANSI terminal.
(global-set-key (kbd "<f7> t") 'ansi-term)

;; I would also like a quick keybinding to get a calculator.
(global-set-key (kbd "<f7> c") 'calc-dispatch)

;; Let's set up some basic keybindings for Org as recommended by the manual
;; <https://orgmode.org/manual/Activation.html#Activation>.
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c b") 'org-iswitchb)

;; Some more settings for Org:
(setq org-hide-leading-stars 'hidestars
      org-return-follows-link t
      org-duration-format 'h:mm
      org-time-clocksum-format
      '(:hours "%d" :require-hours t :minutes "%02d" :require-minutes t))

;; I use org-bullets to have nicer bullet points in Org files.
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; Let's setup Org capture templates. I use only two at the moment: one for
;; tasks in my tasks.org file, another for journal entries in journal.org.
(setq org-capture-templates
      '(("t" "Task in tasks.org" entry (file+headline "~/org/tasks.org" "Inbox")
         "* TODO %?")
        ("j" "Journal entry" entry (file+datetree "~/org/journal.org")
         "* Persönliches Logbuch %U\n%?")))

;; Apart from TODO and DONE, I would also like to have the following TODO
;; states: WAIT (I'm waiting for someone else to do something), DELEGATED (I
;; gave this task to someone else) and CANCELLED. Notice the "|" in the sequence
;; of TODO states: This tells Org where the list of "done" states begins, i.e.
;; which keywords do not require any further action on the task.
(setq org-todo-keywords
      '((sequence "TODO" "WAIT" "|" "DONE" "CANCELLED" "DELEGATED")))

;; All my Org files live in ~/org/, so let's tell Org to treat all files in that
;; directory as agenda files. When refiling, I also want to be able to move a
;; subheading to any of the level-1 headings in any of those agenda files.
(setq org-agenda-files '("~/org/")
      org-refile-targets (quote ((org-agenda-files :level . 1))))

;; With MobileOrg, I can synchronize my notes with my phone via Dropbox. We need
;; to tell MobileOrg where to put tasks that come from the phone as well as
;; where in my Dropbox the sync files live.
(setq org-mobile-inbox-for-pull "~/org/tasks.org")
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")

;; Insert German quotation marks in LaTeX buffers.
(setq-default TeX-close-quote "\"'"
              tex-close-quote "\"'"
              TeX-open-quote "\"`"
              tex-open-quote "\"`")

;; Associate .tex files with latex-mode.
(add-to-list 'auto-mode-alist '("\\.tex\\'" . latex-mode))

;; Use markdown-mode for Markdown files and associate the common filename
;; extensions with this mode.
(use-package markdown-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.md\\'"       . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode)))

;; For PHP files, let's use the excellent php-mode and clone it directly from
;; the GitHub repository.
(use-package php-mode
  :straight (php-mode :type git :host github :repo "ejmr/php-mode"))

;; For pure HTML files and templates, I'd rather use web-mode.
(use-package web-mode
  :config
  ;; Tell Emacs to associate .blade.php files with web-mode
  (add-to-list 'auto-mode-alist '("\\.blade\\.php\\'" . web-mode)))

;; In Emacs Lisp buffers, enable eldoc-mode to display help for any symbol in
;; the echo area.
(add-hook 'emacs-lisp-mode-hook (lambda () (eldoc-mode 1)))
(add-hook 'lisp-interaction-mode-hook (lambda () (eldoc-mode 1)))

;; Elfeed is an excellent RSS reader. Let's first set it up to use a directory
;; in ~/org/ as its database since I synchronize this directory between
;; machines.
(use-package elfeed
  :config
  (setq elfeed-db-directory "~/org/elfeeddb"))

;; With elfeed-org, I can conveniently keep a list of subscriptions in an Org
;; file, which is much easier to handle than updating some Elisp code fragment.
;; Before we can use elfeed-org, we need to load dash and s since for some
;; reason they're not pulled in automatically.
(use-package dash)
(use-package s)

(use-package elfeed-org
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/org/feeds.org")))

;; Let's also make the feeds listing more pretty with elfeed-goodies.
(use-package elfeed-goodies
  :config
  (elfeed-goodies/setup))

;; Magit is an excellent interface to Git. Never having to leave Emacs for
;; anything is the whole point, isn't it? First, we need to manually provide a
;; recipe for let-alist because the wise masters have decided that nobody should
;; be using Emacs 24 anymore.
(use-package let-alist
  :straight (let-alist :type git :host github :repo "pille1842/let-alist"))
;; The keybindings are recommendations from the manual
;; <https://magit.vc/manual/magit.html#Getting-Started>.
(use-package magit
  :bind (("C-x g"   . magit-status)
         ("C-x M-g" . magit-dispatch-popup))
  :config
  (global-magit-file-mode 1))

;; These functions allow for easy scaling of text not only in the buffer, but
;; also in the modeline and other areas displaying text. They can be called with
;; C-+ (scale up), C-- (scale down).
(lexical-let* ((default (face-attribute 'default :height))
               (size default))

  (defun global-scale-default ()
    (interactive)
    (setq size default)
    (global-scale-internal size))

  (defun global-scale-up ()
    (interactive)
    (global-scale-internal (incf size 20)))

  (defun global-scale-down ()
    (interactive)
    (global-scale-internal (decf size 20)))

  (defun global-scale-internal (arg)
    (set-face-attribute 'default (selected-frame) :height arg)
    (set-temporary-overlay-map
     (let ((map (make-sparse-keymap)))
       (define-key map (kbd "C-+") 'global-scale-up)
       (define-key map (kbd "C--") 'global-scale-down)
       (define-key map (kbd "C-0") 'global-scale-default) map))))
(global-set-key (kbd "C-+") 'global-scale-up)
(global-set-key (kbd "C--") 'global-scale-down)

;; engine-mode makes searching the internet from within Emacs very easy. We just
;; require the package and set up a few search engines. Using C-x / and the
;; letter we assigned to each defined search engine, we can search for the
;; active region or let engine-mode prompt us for a search term if no region is
;; active.
(use-package engine-mode
  :diminish engine-mode
  :config
  (defengine duckduckgo
    "https://duckduckgo.com/?q=%s"
    :keybinding "d")
  (defengine github
    "https://github.com/search?ref=simplesearch&q=%s"
    :keybinding "h")
  (defengine google
    "https://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
    :keybinding "g")
  (defengine stackoverflow
    "https://stackoverflow.com/search?q=%s"
    :keybinding "s")
  (defengine wikipedia-de
    "https://www.wikipedia.org/search-redirect.php?language=de&go=Go&search=%s"
    :keybinding "w")
  (defengine wikipedia-en
    "https://www.wikipedia.org/search-redirect.php?language=en&go=Go&search=%s"
    :keybinding "e")
  (engine-mode t))

;; I do not want to use the Customize interface of Emacs, and I certainly don't
;; want any pockets of Emacs Lisp it creates to make it into my init
;; file. Therefore, we let the custom-file be a temporary file per session that
;; is never loaded.
(setq custom-file (make-temp-file "ehcustom"))

;; Disable the bell.
(setq ring-bell-function 'ignore)

;; Do not use French spacing (two spaces at the end of sentences).
(setq sentence-end-double-space nil)

;; Never indent with tabs, and use four spaces to indent.
(setq-default indent-tabs-mode nil)
(setq tab-width 4)

;; Use UTF-8 as the default encoding.
(set-language-environment "UTF-8")

;; While this init file may be under version control, there are certain private
;; settings I would like to keep in a separate file called "private.el".
(setq private-file (concat user-emacs-directory "private.el"))
(load private-file 'noerror)
;;; init.el ends here
