(in-package :CCL)

(defun find-box-tutorial-patch(box)
  (let ((name (string-downcase (box-string box)))
        (files (map-all-files (merge-pathnames (make-pathname :directory '(:relative "04-Kernel_Boxes"))
                                               (pwgl-location :tutorial))
                              :collect :include *valid-pwgl-tutorial-extensions*)))
    (alexandria:if-let (file
                        (find-if #'(lambda(x)
                                     (multiple-value-bind (indicies registers) (ppcre:scan-to-strings "[0-9]+\-(.*)\.pwgl" (string-downcase (file-namestring x)))
                                       indicies
                                       (when (> (length registers) 0)
                                         (equalp name (elt registers 0))))) files))
        (open-pwgl-patch file)
      (capi:display-message "No kernel box tutorial found for this box"))))

(make-key-event pwgl-pw-window pwgl-view #\t "show box tutorial" 
                (find-box-tutorial-patch self))

;;; (ppcre:scan-to-strings "[0-9]+\-(.*)\.pwgl" "061-score-editor.pwgl")
;;; (ppcre:scan-to-strings "[0-9]+\-(.*)\.pwgl" "01-g+.pwgl")
;;; (ppcre:scan-to-strings "[0-9]+\-(.*)\.pwgl" "05-g-oper.pwgl")