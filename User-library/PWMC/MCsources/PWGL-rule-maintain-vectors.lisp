(in-package MC)
;;Adapted for the pwgl environment - change "system::" to adopt to other environments


(defun rule-put-previous-object ()
  '(if (> (system::cur-index) 1)
       ;(progn (ccl::pwgl-print (list system::rl (system::cur-index)));remove this
       (put-object-at-index (second system::rl) (1- (system::cur-index)))
     T))

(defun rule-put-this-object ()
  (list 'put-object-at-index '?1 '(system::cur-index)))

(defun heuristic-rule-put-this-object ()
  '((progn (put-object-at-index ?1 (system::cur-index)) 0)))