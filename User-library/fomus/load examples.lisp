;; -*-lisp-*-
;; Load file for FOMUS

(with-open-stream (stream (open (current-pathname "examples.lisp")))
  (loop for form = (read stream () ())
        while form
        do
        (pprint form)
        (eval form)))