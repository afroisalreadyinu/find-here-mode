(defvar find-here-mode nil)
(make-variable-buffer-local 'find-here-mode)
(defvar find-here-base-path nil)
(make-variable-buffer-local 'find-here-base-path)

(defun find-here-mode (&optional arg)
  "find-here minor mode"
  (interactive "P")
  (setq find-here-mode (if (null arg) (not find-here-mode)
			 (> (prefix-numeric-value arg) 0))))

(defvar find-here-keymap
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "<return>") 'open-find-here-file)
    (define-key map (kbd "q") '(lambda () (interactive) (kill-buffer)))
    map))

(unless (assq 'find-here-mode minor-mode-alist)
  (setq minor-mode-alist
	(cons '(find-here-mode " find-here-mode")
	      minor-mode-alist)))

(unless (assq 'find-here-mode minor-mode-map-alist)
  (setq minor-mode-map-alist
	(cons (cons 'find-here-mode find-here-keymap)
	      minor-mode-map-alist)))


(defun run-find-here (filename-pattern)
  "Delete this file, then close buffer."
  (interactive "sPattern: ")
  (let* ((directory (file-name-directory (buffer-file-name)))
	 (output-buffer (generate-new-buffer
			 (format "find in %s"
				 (replace-regexp-in-string
				  "//" "" directory ))))
	 (command (format "find %s -name '%s'" directory filename-pattern))
	 (file-list (replace-regexp-in-string directory "" (shell-command-to-string command)))
	 (cleaned-file-list (replace-regexp-in-string "^/" "" file-list)))
    (switch-to-buffer output-buffer)
    (insert cleaned-file-list)
    (setq find-here-base-path directory)
    (find-here-mode)
    (read-only-mode)))

(defun find-here-current-line ()
  (save-excursion
    (beginning-of-line)
    (let ((linestart (point)))
      (beginning-of-line 2)
      (let ((lineend (- (point) 1)))
	(buffer-substring-no-properties linestart lineend)))))

(defun open-find-here-file()
  (interactive)
  (let* ((filename (find-here-current-line))
	 (filepath (concat (file-name-as-directory find-here-base-path) filename)))
    (find-file filepath)))

(provide 'find-here-mode)
