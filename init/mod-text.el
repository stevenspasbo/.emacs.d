(add-hook 'text-mode-hook 'my/enable-hard-wrap)

(use-package markdown-mode :ensure t
  :mode (("\\.md\\'" . markdown-mode)
         ("/README\\'" . markdown-mode))
  :config
  (progn
    (let ((map markdown-mode-map))
      (define-key map (kbd "<backspace>") nil)
      (define-key map (kbd "<M-left>") nil)
      (define-key map (kbd "<M-right>") nil)

      (nvmap map
             (kbd ",i") 'markdown-insert-image
             (kbd ",l") 'markdown-insert-link
             (kbd ",L") 'markdown-insert-reference-link-dwim)

      (imap map (kbd "M--") 'markdown-insert-hr)

      (nmap map
            "[p" 'markdown-promote
            "]p" 'markdown-demote)

      (define-key map (kbd "s-*") 'markdown-insert-list-item)
      (define-key map (kbd "s-b") 'markdown-insert-bold)
      (define-key map (kbd "s-i") 'markdown-insert-italic)
      (define-key map (kbd "s-`") 'markdown-insert-del)
      )
    ))

(defvar markdown-regex-del "\\(^\\|[^\\]\\)\\(\\(~\\{2\\}\\)\\([^ \n	\\]\\|[^ \n	]\\(?:.\\|\n[^\n]\\)*?[^\\ ]\\)\\(\\3\\)\\)")
(defun markdown-insert-del ()
  "Insert markup to make a region or word bold.
If there is an active region, make the region bold.  If the point
is at a non-bold word, make the word bold.  If the point is at a
bold word or phrase, remove the bold markup.  Otherwise, simply
insert bold delimiters and place the cursor in between them."
  (interactive)
  (let ((delim "~~"))
    (if (markdown-use-region-p)
        ;; Active region
        (let ((bounds (markdown-unwrap-things-in-region
                       (region-beginning) (region-end)
                       markdown-regex-del 2 4)))
          (markdown-wrap-or-insert delim delim nil (car bounds) (cdr bounds)))
      ;; Bold markup removal, bold word at point, or empty markup insertion
      (if (thing-at-point-looking-at markdown-regex-del)
          (markdown-unwrap-thing-at-point nil 2 4)
        (markdown-wrap-or-insert delim delim 'word nil nil)))))

;;
(provide 'mod-text)