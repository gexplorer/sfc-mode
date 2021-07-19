;;; sfc-mode.el --- Super vue mode -*- lexical-binding: t; -*-

(require 'polymode)

(defgroup super-vue nil
  "Major mode for vue"
  :group 'languages)

(defcustom sfc-template-default-mode "html-mode"
  "Default mode for template block."
  :type 'string)

(defcustom sfc-template-modes
  '(("html" . "vue-html-mode"))
  "Available modes for template block."
  :type '(alist :key-type string :value-type string))

(defun sfc-template-mode-matcher ()
  "Find vue template mode."
  (re-search-forward "<template lang=\"\\(.+\\)\"" (save-excursion (end-of-line) (point)) t)
  (if-let* ((lang (match-string-no-properties 1))
            (mode (cdr (assoc lang sfc-template-modes))))
      mode
    sfc-template-default-mode))

(define-auto-innermode sfc-template-innermode
  :head-matcher (cons "^\\(<template.*>\n\\)" 1)
  :tail-matcher (cons "^\\(</template>\n\\)" 1)
  :mode-matcher 'sfc-template-mode-matcher
  :head-mode 'host
  :tail-mode 'host
  :adjust-face 0)

(defcustom sfc-script-default-mode "js-mode"
  "Default mode for script block."
  :type 'string)

(defcustom sfc-script-modes
  '(("ts" . "typescript-mode"))
  "Available modes for script block."
  :type '(alist :key-type string :value-type string))

(defun sfc-script-mode-matcher ()
  "Find vue script mode."
  (re-search-forward "<script lang=\"\\(.+\\)\"" (save-excursion (end-of-line) (point)) t)
  (if-let* ((lang (match-string-no-properties 1))
            (mode (cdr (assoc lang sfc-script-modes))))
      mode
    sfc-script-default-mode))

(define-auto-innermode sfc-script-innermode
  :head-matcher (cons "^\\(<script.*>\n\\)" 1)
  :tail-matcher (cons "^\\(</script>\n\\)" 1)
  :mode-matcher 'sfc-script-mode-matcher
  :fallback-mode 'js-mode
  :head-mode 'host
  :tail-mode 'host
  :adjust-face 0)

(defun sfc-style-mode-matcher ()
  "Find vue style mode."
  (re-search-forward "<style lang=\"\\(.+\\)\"" (save-excursion (end-of-line) (point)) t)
  (if (> (match-beginning 0) 0)
      (pcase (match-string-no-properties 1)
        ("css" "css-mode")
        (_ nil))
    nil)
  )

(define-auto-innermode sfc-style-innermode
  :head-matcher (cons "^\\(<style.*>\n\\)" 1)
  :tail-matcher (cons "^\\(</style>\n\\)" 1)
  :mode-matcher 'sfc-style-mode-matcher
  :fallback-mode 'css-mode
  :head-mode 'host
  :tail-mode 'host
  :adjust-face 0)

(define-polymode sfc-mode
  :hostmode 'poly-html-hostmode
  :innermodes '(sfc-template-innermode
                sfc-script-innermode
                sfc-style-innermode)
  :lighter '(:eval (with-current-buffer (pm-span-buffer) (format-mode-line '(" Vue[" mode-name "]"))))
  )

(provide 'sfc-mode)
;;; sfc-mode.el ends here
