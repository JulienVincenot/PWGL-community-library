(progn
  (load "/tmp/haskell-mode-2.4/haskell-site-file.el")

  (require 'flymake)

  (defun flymake-hslint-init ()
    (let* ((temp-file   (flymake-init-create-temp-buffer-copy
			 'flymake-create-temp-inplace))
	   (local-file  (file-relative-name
			 temp-file
			 (file-name-directory buffer-file-name))))
      (list "hslint" (list local-file))))

  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.l?hs\\'" flymake-hslint-init))
  (setq inferior-haskell-find-project-root nil)
  (add-hook 'haskell-mode-hook 'flymake-mode))
