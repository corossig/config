(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
(setq font-lock-maximum-size nil)
(transient-mark-mode t)
(fset 'yes-or-no-p 'y-or-n-p)
(line-number-mode 1)
(column-number-mode 1)
(display-time)
(setq display-time-24hr-format t)
(setq system-time-locale "C")
(mouse-wheel-mode t)
(require 'paren)
(show-paren-mode 1)
(setq-default hilight-paren-expression t)
(require 'cc-mode)
(add-to-list 'c-mode-common-hook
      (lambda ()
        (c-set-style "stroustrup")))
;;        (c-set-style "gnu")))

;; Change default split
;;(setq split-width-threshold 1)

;;create a backup file directory
(setq backup-directory-alist '(("." . "/dev/shm/")))

(defun safe-cleanup ()
  (cond
   ((equal major-mode 'c-mode)  (whitespace-cleanup))
   ((equal major-mode 'c++-mode)  (whitespace-cleanup))
   ((equal major-mode 'python-mode)  (whitespace-cleanup))
   ((equal major-mode 'tex-mode)  (whitespace-cleanup))
   ((equal major-mode 'latex-mode)  (whitespace-cleanup))))
  

;; Delete all bad whitespace befor saving
(add-hook 'before-save-hook 'safe-cleanup)

(global-set-key [F1] '(grammar-check))

;; Add nullptr c++11 keyword
(font-lock-add-keywords 'c++-mode
  '(("\\<\\(and\\|or\\|not\\|override\\|assert\\|SAFE_FREE\\|SAFE_DELETE\\|ASSERT_COND\\|PARAMETER_COND\\)\\>" . font-lock-keyword-face)
    ("\\<\\(nullptr\\)\\>" . font-lock-constant-face)))


(require 'autoinsert)
(auto-insert-mode)  ;;; Adds hook to find-files-hook
(setq auto-insert-directory "~/.emacs.d/template/")
(setq auto-insert-query nil)
(define-auto-insert "\\.c$" ["my-c-template.c" prepare-file])
(define-auto-insert "\\.cpp" ["my-cpp-template.cpp" prepare-file])
(define-auto-insert "\\.cc" ["my-cpp-template.cpp" prepare-file])
(define-auto-insert "\\.h$"   ["my-h-template.h" prepare-file])
(define-auto-insert "\\.hpp$"   ["my-hpp-template.hpp" prepare-file])
(define-auto-insert "Makefile" ["my-Makefile-template" prepare-file])
(define-auto-insert "\\.tex$" "my-tex-template.tex")
(define-auto-insert "\\.py$" "my-py-template.py")
(define-auto-insert "CMakeLists.txt" ["CMakeLists-template.txt" prepare-file])

(defun prepare-file ()
  (save-excursion
    ;; Replace $FILENAME$ with file name sans suffix
    (while (search-forward "$FILENAME$" nil t)
      (save-restriction
        (narrow-to-region (match-beginning 0) (match-end 0))
        (replace-match (file-name-sans-extension (upcase(file-name-nondirectory buffer-file-name))) t
                       ))))
  (save-excursion
    ;; Replace $DATE$ with current date
    (while (search-forward "$DATE$" nil t)
      (save-restriction
        (narrow-to-region (match-beginning 0) (match-end 0))
        (replace-match (format-time-string "%b %d, %Y" (current-time)) t
                       ))))
  (save-excursion
    ;; Replace $YEAR$ with current year
    (while (search-forward "$YEAR$" nil t)
      (save-restriction
        (narrow-to-region (match-beginning 0) (match-end 0))
        (replace-match (format-time-string "%Y" (current-time)) t
                       ))))

  (save-excursion
    ;; Replace $DIR$ with current dir
    (while (search-forward "$DIR$" nil t)
      (save-restriction
        (narrow-to-region (match-beginning 0) (match-end 0))
        (replace-match (file-name-nondirectory (directory-file-name (file-name-directory (expand-file-name buffer-file-name)))) t
                       )))))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/mode"))
(autoload 'cmake-mode "cmake-mode" "Major mode for editing CMakeList." t)
(autoload 'cuda-mode "cuda-mode" "Major mode for CUDA." t)
(autoload 'parsec-mode "parsec-mode" "Major mode for editing Parsec." t)

(defun indent-whole-buffer ()
  "indent whole buffer"
  (interactive)
  (whitespace-cleanup)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))
(global-set-key "\C-xa" 'indent-whole-buffer)

(setq auto-fill-mode 1)
(setq-default indent-tabs-mode nil)

(fset 'return-indent "\C-j")
(global-set-key [13] 'return-indent)

(setq visible-bell t)

(setq default-major-mode 'text-mode)

(setq frame-title-format "%b - %f")

(defun equal_mul (compar list)
       (if (equal list nil)
           nil
           (if (equal compar (car list))
               T
               (equal_mul compar (cdr list)))))

(defun generate-compile-command ()
  (interactive)
  (setq ext (downcase (file-name-extension buffer-file-name)))
  (cond
   ((equal major-mode 'c-mode) (setq compile-command (coerce (concat
                                                              "gcc -std=c99 -g -Wall -Wshadow "
                                                              (file-name-nondirectory buffer-file-name)
                                                              " -o "
                                                              (file-name-sans-extension(file-name-nondirectory buffer-file-name)))
                                                             'string)))
   ((equal major-mode 'c++-mode) (setq compile-command (coerce (concat
                                                                "g++ -g -Wall -Wshadow "
                                                                (file-name-nondirectory buffer-file-name)
                                                                " -o "
                                                                (file-name-sans-extension(file-name-nondirectory buffer-file-name)))
                                                               'string)))
   ((equal major-mode 'python-mode) (setq compile-command (coerce (concat "python \"" buffer-file-name "\"") 'string)))
   (t (setq compile-command (coerce (concat "\"" buffer-file-name "\"") 'string)))))

(defun find-make (dir_test)
  (if (equal dir_test "/")
      nil
      (if (or (file-readable-p (expand-file-name "Makefile" dir_test))
              (file-readable-p (expand-file-name "makefile" dir_test)))
          dir_test
          (find-make (expand-file-name ".." dir_test)))))

(defun compilation ()
  (interactive)
  (setq make_dir (find-make (expand-file-name ".")))
  (if make_dir
      (setq compile-command (concat "make -C " make_dir))
      (generate-compile-command)))

(global-set-key [f9] 'compile)
(global-set-key [f10] 'compilation)

(defun makefile-mode-settings ()
    (setq whitespace-style '(tabs spaces space-mark tab-mark face lines-tail))
    (whitespace-mode       t)
    (show-paren-mode       1)

    (setq tab-width             4)
    (setq require-final-newline t)
)


(add-hook 'c-mode-common-hook
          (lambda()
            (local-set-key [f4] 'ff-find-other-file)))

;;(eval-after-load "flyspell"
 ;; '(ispell-change-dictionary "american"))

(add-hook 'latex-mode-hook
          (lambda ()
            (flyspell-mode)))

(global-set-key [f5] 'kill-this-buffer)
(global-set-key [f2] 'flyspell-buffer)
(global-set-key [f3] 'yank-rectangle)
(global-set-key [f12] 'kill-rectangle)

;; TAGS Part
(global-set-key [f6] 'ggtags-find-reference)
(global-set-key [f7] 'ggtags-find-tag-continue)
(global-set-key [f8] (read-kbd-macro "C-u M-."))
(global-set-key (kbd "C-SPC") 'complete-tag)


(global-set-key [C-left] 'previous-buffer)
(global-set-key [C-right] 'next-buffer)
(global-set-key [C-tab] 'other-window)
(global-set-key [C-kp-0] 'delete-window)
(global-set-key "\C-q" 'goto-line)
(global-set-key [mouse-3] 'imenu)
(global-set-key "\C-a" 'grammar-check)

(setq auto-mode-alist (cons '("\\.cu$" . cuda-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cl$" . c-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.inl$" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.jdf$" . parsec-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.tex$" . LaTeX-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("CMakeLists.txt" . cmake-mode) auto-mode-alist))

(add-to-list 'load-path "~/.emacs.d/site-lisp/")
(require 'color-theme)
(color-theme-initialize)
(color-theme-billw)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(display-time-mode t)
 '(font-use-system-font t)
 '(inhibit-startup-screen t)
 '(safe-local-variable-values
   (quote
    ((c-file-offsets
      (innamespace . 0)
      (inline-open . 0)
      (case-label . +))
     (c-set-style . "K&R")
     (eval progn
           (c-set-offset
            (quote innamespace)
            (quote 0))
           (c-set-offset
            (quote inline-open)
            (quote 0)))
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
     (c-cleanup-list scope-operator brace-else-brace brace-elseif-brace brace-catch-brace empty-defun-braces list-close-comma defun-close-semi)
     (c-hanging-semi&comma-criteria c-semi&comma-no-newlines-before-nonblanks)
     (c-hanging-colons-alist
      (member-init-intro before)
      (inher-intro)
      (case-label after)
      (label after)
      (access-label after))
     (c-hanging-braces-alist
      (substatement-open after)
      (brace-list-open after)
      (brace-entry-open)
      (defun-open after)
      (class-open after)
      (inline-open after)
      (block-open after)
      (block-close . c-snug-do-while)
      (statement-case-open after)
      (substatement after))
     (c-comment-only-line-offset . 0)
     (c-tab-always-indent . t))))
 '(show-paren-mode t))

(add-to-list 'load-path
              "~/.emacs.d/yasnippet-0.8.0")
(require 'yasnippet)


(add-to-list 'load-path
              "~/.emacs.d/markdown-mode-2.0")
(require 'markdown-mode)
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))


(yas/global-mode 1)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(set-face-attribute 'default nil :font "Droid Sans Mono-11")
;;(add-to-list 'default-frame-alist '(font .  "Droid Sans Mono 11" ))
;;(set-face-attribute 'default t :font  "Droid Sans Mono 11" )

;;(set-face-attribute 'default nil :font "DejaVu Sans Mono 11")
;;(require 'grammar)
(put 'downcase-region 'disabled nil)


