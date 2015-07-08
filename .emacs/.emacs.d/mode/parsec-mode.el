;;; parsec-mode.el --- major-mode for editing Parsec sources

;------------------------------------------------------------------------------

;;; Commentary:

;; Provides syntax highlighting and indentation for *.jdf source files.
;;
;; Add this code to your .emacs file to use the mode:
;;
;;  (setq load-path (cons (expand-file-name "/dir/with/parsec-mode") load-path))
;;  (require 'parsec-mode)
;;  (add-to-list 'auto-mode-alist '("\\.jdf\\'" . parsec-mode))

;------------------------------------------------------------------------------

;;
;; User hook entry point.
;;
(defvar parsec-mode-hook nil)


;;
;; Keyword highlighting regex-to-face map.
;;
(defconst parsec-font-lock-keywords
  (list '("\\(R\\(W\\|EAD\\)\\|WRITE\\)" . font-lock-constant-face)
        '("\\(<-\\|->\\|\\.\\.\\)" . font-lock-keyword-face)
        '("\\(BODY\\|END\\)" . font-lock-keyword-face))
  "Highlighting expressions for Parsec mode.")

(define-derived-mode parsec-mode c++-mode "parsec"
  (set (make-local-variable 'font-lock-defaults) '(parsec-font-lock-keywords)))
  
; This file provides parsec-mode.
(provide 'parsec-mode)

;;; parsec-mode.el ends here
