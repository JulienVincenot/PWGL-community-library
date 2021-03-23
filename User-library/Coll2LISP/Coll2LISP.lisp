(in-package :coll2lisp)

(PWGLdef coll2lisp-box ()
         "coll2lisp-box"
         ()         
         (mapcar (lambda (line) (mapcar #'read-from-string (segment-words line)))
                 (read-file-lines (car (capi:prompt-for-files ())))))



;;; (car (capi:prompt-for-files ()))
;;;   this could be also: (capi:prompt-for-file ())

;;; note: if you add the box to the path (double-click), use:
;;; coll2lisp::coll2lisp-box