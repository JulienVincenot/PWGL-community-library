(in-package :MOTIFEXTRACTION)

;;; This file contains the class definition for for the RepeatingPattern
;;; class. Each RepeatingPattern object contains the pattern itself, it's 
;;; frequency of occurence within the input string being analyzed, and 
;;; a list of the positions in which the pattern occurs in the input string.

(defclass RepeatingPattern (standard-object) ((pattern :accessor getPattern :initarg :pattern) 
		 (frequency :initform 1 :accessor getFreq :initarg :frequency) 
		 (positions :accessor getPositions :initarg :positions)) )

(defmethod getPatternLength ((this RepeatingPattern))
  (length (getPattern this))
)

;;; ------------------------------------------------------
;;; addOccurence ((this RepeatingPattern) (position integer))
;;; ------------------------------------------------------
;;;
;;; PARAMETERS:
;;; this RepeatingPattern - self-reference to this object
;;; position integer - the position to add to the position list
;;;
;;; DESCRIPTION: 
;;; Adds the given position to the position list of this RepeatingPattern
;;; object, and increments the frequency count.
(defmethod addOccurence ((this RepeatingPattern) (position integer) )
    (with-slots (positions frequency) this
        (nconc positions (list position))
         (setf frequency (1+ frequency)) )
)


;;; ------------------------------------------------------
;;; patternEqual ((this RepeatingPattern) (otherPattern sequence))
;;; ------------------------------------------------------
;;;
;;; PARAMETERS:
;;; this RepeatingPattern - self-reference to this object
;;; otherPattern sequence - the pattern with which to check if this pattern matches,
;;;                this should be a list
;;;
;;; DESCRIPTION: 
;;; Checks is the pattern within this object matches the 
;;; otherPattern passed to the method
(defmethod patternEqual ((this RepeatingPattern) (otherPattern RepeatingPattern)) 
    (equal (getPattern otherPattern) (getPattern this)) )


;;; outputs this pattern in the format: {pattern, frequency, positions}
(defmethod printPattern ((this RepeatingPattern))
  (with-slots (pattern frequency positions) this
    (format t "{Pattern: ~S, Frequency: ~D, Positions: ~S}  " pattern frequency positions)
  )
)

(defmethod toString ((this RepeatingPattern))
  (with-slots (pattern frequency positions) this
    (format nil "{~S, ~D, ~S}  " pattern frequency positions)
  )
)

;;; ---------------------
;;; stringJoin ((this RepeatingPattern) (pattern2 RepeatingPattern) (k integer))
;;; ---------------------
;;; PARAMETERS:
;;; this RepeatingPattern - self-reference to this object
;;; pattern2 RepeatingPattern - the second pattern to join to this one
;;; k - The order of the string join operation
;;;
;;; DESCRIPTION:
;;; Performs the "string join" operation of order-k and returns the resulting pattern.
(defmethod stringJoin ((this RepeatingPattern) (pattern2 RepeatingPattern) (k integer))
  (let ((m (length (getPattern this))) ; the length of the pattern string in this object
        (x (getPositions this)) ; temporary variable for the positions list of this RepeatingPattern object
	(y (reverse (getPositions pattern2))) ; temporary variable for the positions list of the pattern2 RepeatingPattern object
	(ytemp ()) ; a temporary copy of y
	(currX) ; current element from x
	(currY) ; current element from y
	(yPosition) ; current position in the y list
	(newPattern (append (getPattern this) (subseq (getPattern pattern2) k ) )) ; create the new pattern
        (newFrequency 0) ; frequency of the new pattern
	(newPositions () )) ; the positions list of the new pattern
    

    (setq ytemp y)
    ; ensure that the string join will produce a result
    (if (or (= 0 k) (equal (subseq (getPattern this) (- m k)) (subseq (getPattern pattern2) 0 k))) 
	(loop while (and (not (null x)) (not (null ytemp))) do 
	     (setq currX (car x) 
		   currY (car ytemp)
		   yPosition 0)
	     ; check the y list for matches with currX
	     (loop while (not (null currY)) do

                  ; check if x = y-m+k
		  (if (= currX (+ (- currY m) k) ) 
		      (setq newPositions (append newPositions (list currX)) )
		  )

		  ; check if we can remove some y's (exploiting the fact that the
		  ; position lists are ordered)
		  (if (> currX (+ (- currY m) k) )
		      (setq currY nil)		  
		      ; else
		      (setq yPosition (1+ yPosition)
		          yTemp (cdr ytemp)
			  currY (car ytemp)) 
		  )
	     )
	     (setq x (cdr x))
	     (setq yTemp (subseq y 0 yPosition))
         )
	
    )
    (setq newFrequency (length newPositions))
    (make-instance 'RepeatingPattern :pattern newPattern :frequency newFrequency :positions newPositions)
    
  )
)


;;; ------------------------------------------------------
;;; incrementFreq ((this RepeatingPattern))
;;; ------------------------------------------------------
;;;
;;; PARAMETERS:
;;; this RepeatingPattern - self-reference to this object
;;;
;;; DESCRIPTION: 
;;; Increments the frequency count of this RepeatingPattern object.
;(defmethod incrementFreq ((this RepeatingPattern)) (setf (getFreq this) (1+ (getFreq this)) ) )

; example
;(setf rp1 (make-instance 'RepeatingPattern :pattern '(1 2 3) :positions '(2)))

;(incrementFreq rp1)

;(getFreq rp1)
