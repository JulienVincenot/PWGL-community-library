(in-package :MOTIFEXTRACTION)

;;; This file contains the class definition for a special list of 
;;; repeating patterns, where 2 to the power of the index of an element 
;;; in the list indicates the length of the patterns at that index.
;;; Each element of the list contains a list of RepeatingPattern Objects.

(defclass RPList (standard-object) ((patterns :initform () :reader getPatterns) 
		 (length :reader getLength)) )

;;; ------------------------------------------------------
;;; add ((this RPList) (pattern RepeatingPattern))
;;; ------------------------------------------------------
;;;
;;; PARAMETERS:
;;; this RPList - self-reference to this object
;;; pattern RepeatingPattern - the RepeatingPattern object
;;; to add to this list of RepeatingPatterns.
;;;
;;; DESCRIPTION: 
;;; Adds a RepeatingPattern object to this list. 
(defmethod add ((this RPList) (pattern RepeatingPattern)) (with-slots (patterns) this 
   (if (null patterns) ; if patterns list is empty:
       (setf patterns (list pattern))
           ; else, concatenate:
           (nconc patterns (list pattern)) 
   )
))

;;; ------------------------------------------------------
;;; findPattern ((this RPList) (pattern RepeatingPattern))
;;; ------------------------------------------------------
;;;
;;; PARAMETERS:
;;; this RPList - self-reference to this object
;;; pattern RepeatingPattern - the pattern to search for in
;;; this list of RepeatingPatterns.
;;;
;;; DESCRIPTION: 
;;; Finds and returns the instance of the RepeatingPattern
;;; containing the given pattern. Returns nil if the pattern wasn't found.
(defmethod findPattern ((this RPList) (pattern RepeatingPattern))
    (with-slots (patterns) this
        (find pattern patterns :test 'patternEqual) ) )

(defmethod removeFirst ((this RPList))
  (with-slots (patterns) this
    (setf patterns (cdr patterns))
  )
)


(defmethod RPListCar ((this RPList))
  (with-slots (patterns) this
    (car patterns)
  )
)

(defmethod removeFreq1 ((this RPList))
  (with-slots (patterns) this
    (setf patterns (delete-if #'(lambda (x) (eq 1 (getFreq x))  ) patterns))
  )
)

(defmethod removeMinFreq ((this RPList) (minFreq integer))
  (with-slots (patterns) this
    (setf patterns (delete-if #'(lambda (x) (< (getFreq x) minFreq) ) patterns))
  )
)


(defmethod isEmpty ((this RPList))
  (with-slots (patterns) this
    (null patterns)
  )
)

(defmethod printList ((this RPList))
  (with-slots (patterns) this
      (let ((patternsTemp patterns))
	(loop while (not (null patternsTemp)) do
	     (printPattern (car patternsTemp))
	     (setq patternsTemp (cdr patternsTemp))
	)
	(format t "~%")
      )
  )
)

;(defun testPrints ()
;  (let ((pattern (make-instance 'RepeatingPattern :pattern '(5) :positions '(1)))
;	(patternList (make-instance 'RPList) ))
;    (add patternList pattern)
;    (printList patternList)
;  )
;)



