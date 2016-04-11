(require 'package) ;; You might already have this line
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line



;; -------------------------------
;; Irony, flyspell setup
;; -------------------------------
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'c-mode-hook 'company-mode)
(add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'c-mode-hook 'flycheck-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))


;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's asynchronous function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)


(when (eq system-type 'windows-nt) ;; Only needed on Windows
  (setq w32-pipe-read-delay 0))

(require 'yasnippet)
(yas/global-mode 1)



;; -----------
;; Color theme
;; -----------

(set-face-attribute 'default nil :font "Droid Sans Mono-11")

(require 'color-theme)
(color-theme-initialize)
(color-theme-billw)

(font-lock-add-keywords 'c++-mode
  '(("\\<\\(and\\|or\\|not\\|override\\|assert\\|IX_RELEASE_ASSERT\\|IX_DEBUG_ASSERT\\|ASSERT_COND\\|PARAMETER_COND\\)\\>" . font-lock-keyword-face)
    ("\\<\\(nullptr\\)\\>" . font-lock-constant-face)))

(custom-set-variables
 '(display-time-mode t)
 '(font-use-system-font t)
 '(inhibit-startup-screen t)
 '(safe-local-variable-values
   (quote
    ((c-file-offsets
      (innamespace . 0)
      (inline-open . 0)
      (case-label . +))
     (c-set-style . "stroustrup")
     (c-offsets-alist
      (inexpr-class . +)
      (inexpr-statement . +)
      (lambda-intro-cont . +)
      (inlambda . c-lineup-inexpr-block)
      (template-args-cont c-lineup-template-args +)
      (incomposition . +)
      (inmodule . +)
      (innamespace . +)
      (inextern-lang . +)
      (composition-close . 0)
      (module-close . 0)
      (namespace-close . 0)
      (extern-lang-close . 0)
      (composition-open . 0)
      (module-open . 0)
      (namespace-open . 0)
      (extern-lang-open . 0)
      (objc-method-call-cont c-lineup-ObjC-method-call-colons c-lineup-ObjC-method-call +)
      (objc-method-args-cont . c-lineup-ObjC-method-args)
      (objc-method-intro .
			 [0])
      (friend . 0)
      (cpp-define-intro c-lineup-cpp-define +)
      (cpp-macro-cont . +)
      (cpp-macro .
		 [0])
      (inclass . +)
      (stream-op . c-lineup-streamop)
      (arglist-cont-nonempty c-lineup-gcc-asm-reg c-lineup-arglist)
      (arglist-cont c-lineup-gcc-asm-reg 0)
      (arglist-intro . +)
      (catch-clause . 0)
      (else-clause . 0)
      (do-while-closure . 0)
      (label . 2)
      (access-label . -)
      (substatement-label . 2)
      (substatement . +)
      (statement-case-open . 0)
      (statement-case-intro . +)
      (statement-block-intro . +)
      (statement-cont . +)
      (statement . 0)
      (brace-entry-open . 0)
      (brace-list-entry . 0)
      (brace-list-intro . +)
      (brace-list-close . 0)
      (brace-list-open . 0)
      (block-close . 0)
      (inher-cont . c-lineup-multi-inher)
      (inher-intro . +)
      (member-init-cont . c-lineup-multi-inher)
      (member-init-intro . +)
      (annotation-var-cont . +)
      (annotation-top-cont . 0)
      (topmost-intro-cont . c-lineup-topmost-intro-cont)
      (topmost-intro . 0)
      (knr-argdecl . 0)
      (func-decl-cont . +)
      (inline-close . 0)
      (inline-open . +)
      (class-close . 0)
      (class-open . 0)
      (defun-block-intro . +)
      (defun-close . 0)
      (defun-open . 0)
      (string . c-lineup-dont-change)
      (arglist-close . c-lineup-arglist)
      (substatement-open . 0)
      (case-label . 0)
      (block-open . 0)
      (c . 1)
      (comment-intro . 0)
      (knr-argdecl-intro . -))
     (c-comment-only-line-offset . 0)
     (c-tab-always-indent . t))))
 '(show-paren-mode t))



;; --------------------------------------
;; Delete all bad whitespace befor saving
;; --------------------------------------
(defun safe-cleanup ()
  (cond
   ((equal major-mode 'c-mode)      (whitespace-cleanup))
   ((equal major-mode 'c++-mode)    (whitespace-cleanup))
   ((equal major-mode 'python-mode) (whitespace-cleanup))
   ((equal major-mode 'tex-mode)    (whitespace-cleanup))
   ((equal major-mode 'latex-mode)  (whitespace-cleanup))))


(add-hook 'before-save-hook 'safe-cleanup)
(setq backup-directory-alist '(("." . "/dev/shm/"))) ; save ~ file in /dev/shm



;; ------------------------------
;; User functions
;; ------------------------------
(defun generate-compile-command ()
  (interactive)
  (setq ext (downcase (file-name-extension buffer-file-name)))
  (cond
   ((equal major-mode 'c-mode)
    (setq compile-command (coerce (concat
				   "gcc -std=c99 -g -Wall -Wshadow "
				   (file-name-nondirectory buffer-file-name)
				   " -o "
				   (file-name-sans-extension(file-name-nondirectory buffer-file-name)))
				  'string)))
   ((equal major-mode 'c++-mode)
    (setq compile-command (coerce (concat
				   "g++ -g -Wall -Wshadow "
				   (file-name-nondirectory buffer-file-name)
				   " -o "
				   (file-name-sans-extension(file-name-nondirectory buffer-file-name)))
				  'string)))
   ((equal major-mode 'python-mode)
    (setq compile-command (coerce (concat "python \"" buffer-file-name "\"") 'string)))
   (t (setq compile-command (coerce (concat "\"" buffer-file-name "\"") 'string)))))


(defun find-make (dir_test)
  (if (equal dir_test "/")
      nil
      (if (or (file-readable-p (expand-file-name "Makefile" dir_test))
              (file-readable-p (expand-file-name "makefile" dir_test)))
          dir_test
          (find-make (expand-file-name ".." dir_test)))))

(defun gen-compile-command ()
  (interactive)
  (setq make_dir (find-make (expand-file-name ".")))
  (if make_dir
      (setq compile-command (concat "make -C " make_dir))
      (generate-compile-command)))

(defun indent-whole-buffer ()
  "indent whole buffer"
  (interactive)
  (whitespace-cleanup)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))



;; ------------------------------
;; Key binding
;; ------------------------------

(add-hook 'c-mode-common-hook
	  (lambda()
	    (local-set-key [f4] 'ff-find-other-file)))
(global-set-key [f5]  'kill-this-buffer)
(global-set-key [f9]  'compile)
(global-set-key [f10] 'gen-compile-command)

(global-set-key [C-left]  'previous-buffer)
(global-set-key [C-right] 'next-buffer)
(global-set-key [C-tab]   'other-window)

(global-set-key "\C-xa" 'indent-whole-buffer)
(global-set-key "\C-q"  'goto-line)
(global-set-key "\C-v"  'company-complete-common-or-cycle)

(global-set-key [mouse-3] 'imenu)


;; -------------------------------
;; Emacs visual
;; -------------------------------
(fset 'yes-or-no-p 'y-or-n-p)
(line-number-mode 1)
(column-number-mode 1)
(display-time)
(setq display-time-24hr-format t)
(setq system-time-locale "C")

(setq frame-title-format "%b - %f")
(setq visible-bell t)
(show-paren-mode 1) ;; match parenthesis
(setq-default hilight-paren-expression t)
(setq auto-fill-mode 1)


;; -------------------------------
;; Configure editor
;; -------------------------------
(setq default-major-mode 'text-mode)
(setq-default indent-tabs-mode nil)

(require 'cc-mode)
(add-to-list 'c-mode-common-hook
      (lambda ()
        (c-set-style "stroustrup")))

(add-hook 'latex-mode-hook
          (lambda ()
            (flyspell-mode)))


;; -------------------------------
;; Auto mode
;; -------------------------------
(setq auto-mode-alist (cons '("\\.cu$" . cuda-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cl$" . c-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.inl$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.jdf$" . parsec-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.tex$" . LaTeX-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("CMakeLists.txt" . cmake-mode) auto-mode-alist))
