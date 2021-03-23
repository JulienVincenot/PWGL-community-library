(in-package MC)

;;;Lock rhythm

(defun put-and-lock-this-layers-durations (durations)
  #'(lambda (layer) (put-and-lock-durations durations layer)))

(defun put-and-lock-durations (durations layer)
  "First update all pointers, then put durations in vector and put new pointers in current layer."
  (let ((local-pointer 1)) 
    (setf (aref pointers-vector layer 0 *ONSETTIME* *STARTPOINTER*) 1)
    (setf (aref pointers-vector layer 0 *ONSETTIME* *ENDPOINTER*)
          (put-durations-in-vector durations layer local-pointer))
    nil))


(defun unlock-rlayer (layer)
  (setf (aref pointers-vector layer 0 *ONSETTIME* *STARTPOINTER*) nil)
  (setf (aref pointers-vector layer 0 *ONSETTIME* *ENDPOINTER*)
          1))

(defun locked-rlayer? (layer)
  (if (aref pointers-vector layer 0 *ONSETTIME* *STARTPOINTER*) t nil))

(defun adjust-one-locked-rlayer-endpointer (layer index)
  "Subtract 1 from total number of durations to compensate for locked layers extra (hidden) duration."
  (if (> index 0)
      (setf (aref pointers-vector layer (1- index) *ONSETTIME* *ENDPOINTER*)
            (1- (aref pointers-vector layer (1- index) *ONSETTIME* *ENDPOINTER*)))))

;(aref pointers-vector 0 (1- 19) *ONSETTIME* *ENDPOINTER*)
;(locked-rlayer? 0)

;;;;Below is old - not used anymore
(defun check-and-correct-locked-rlayers (index)
  "Checks if layer is locked and then subtracts 1 from the total number of durations to compensate for locked layers extra (hidden) duration.
Then it unlocks layer to prevent from compensating twice."
  (loop for layer from 0 to (1- *max-numberof-layers*)
        do (if (locked-rlayer? layer)
               (progn (adjust-one-locked-rlayer-endpointer layer index)
                 (unlock-rlayer layer)))))
;;;;;;;;

(defun unlock-rlayers ()
  "Checks if layer is locked and unlocks it if it is locked."
  (loop for layer from 0 to (1- *max-numberof-layers*)
        do (if (locked-rlayer? layer)
               (unlock-rlayer layer))))

;(adjust-one-locked-rlayer-endpointer 0 0)
;;;Lock pitch

(defun put-and-lock-this-layers-pitches (pitches)
  #'(lambda (layer) (put-and-lock-pitches pitches layer)))

(defun put-and-lock-pitches (pitches layer)
  "First update all pointers, then put pitches in vector and put new pointers in current layer."
  (let ((local-pointer 1)) 
    (setf (aref pointers-vector layer 0 *PITCH* *STARTPOINTER*) 1)
    (setf (aref pointers-vector layer 0 *PITCH* *ENDPOINTER*)
          (put-pitches-in-vector pitches layer local-pointer))
    nil))

(defun unlock-player (layer)
  (setf (aref pointers-vector layer 0 *PITCH* *STARTPOINTER*) nil)
  (setf (aref pointers-vector layer 0 *PITCH* *ENDPOINTER*)
          0))

(defun locked-player? (layer)
  (if (aref pointers-vector layer 0 *PITCH* *STARTPOINTER*) t nil))

(defun unlock-players ()
    (loop for layer from 0 to (1- *max-numberof-layers*)
          do (if (locked-player? layer)
                 (unlock-player layer))))


;;;Lock timesign does not work - no way to put a sequence of timesigns on one index...

;old
(defun plug-rlayer (layer)
  "Make last solution for a rhythm layer into a locked layer."
  (if (< (system::cur-index) 1) (progn (system::pwgl-print "Run engine first!") nil)
    (let ((local-pointer 1)
          (end-pointer (aref pointers-vector layer (1- (system::cur-index)) *ONSETTIME* *ENDPOINTER*)))
      (setf (aref pointers-vector layer 0 *ONSETTIME* *STARTPOINTER*) 1)
      (setf (aref pointers-vector layer 0 *ONSETTIME* *ENDPOINTER*)
            (put-durations-in-vector '(-100) layer end-pointer)
            )
      nil)))

;new
(defun plug-rlayer (layer)
  "Make last solution for a rhythm layer into a locked layer."
    (let ((local-pointer 1)
          end-pointer)
      (if (< (system::cur-index) 1) (if (aref pointers-vector layer 1 *ONSETTIME* *ENDPOINTER*) ;If no solution last run, then pick endpointer from index 1.
                                          (setf end-pointer (1- (aref pointers-vector layer 1 *ONSETTIME* *ENDPOINTER*)))
                                        (setf end-pointer 1));;;kolla detta
        (setf end-pointer (aref pointers-vector layer (1- (system::cur-index)) *ONSETTIME* *ENDPOINTER*)))
      (setf (aref pointers-vector layer 0 *ONSETTIME* *STARTPOINTER*) 1)
      (setf (aref pointers-vector layer 0 *ONSETTIME* *ENDPOINTER*)
            (put-durations-in-vector '(-100) layer end-pointer))
      nil))

;(aref pointers-vector 0 0 *ONSETTIME* *STARTPOINTER*)
;(aref pointers-vector 0 1 *ONSETTIME* *ENDPOINTER*)
;(plug-rlayer 0)

(defun plug-this-rlayer ()
  #'(lambda (layer) (plug-rlayer layer)))

(defun plug-player (layer)
  "Make last solution for a pitch layer into a locked layer."
    (let ((local-pointer 1)
          end-pointer)
      (if (< (system::cur-index) 1) (setf end-pointer (aref pointers-vector layer 1 *PITCH* *ENDPOINTER*)) ;If no solution last run, then pick endpointer from index 1.
        (setf end-pointer (aref pointers-vector layer (1- (system::cur-index)) *PITCH* *ENDPOINTER*)))
      (setf (aref pointers-vector layer 0 *PITCH* *STARTPOINTER*) 1)
      (setf (aref pointers-vector layer 0 *PITCH* *ENDPOINTER*)
            end-pointer)
      nil))

(defun plug-this-player ()
  #'(lambda (layer) (plug-player layer)))


;(aref pointers-vector 0 1 *PITCH* *ENDPOINTER*)
;(aref pointers-vector 0 0 *PITCH* *ENDPOINTER*)
;(aref pointers-vector 0 1 *PITCH* *ENDPOINTER*)

;(1- (aref pointers-vector 0 0 *ONSETTIME* *ENDPOINTER*))




;(locked-rlayer? 0)

;(setf end-pointer (aref pointers-vector 0 0 *ONSETTIME* *ENDPOINTER*))

;(aref pointers-vector layer (1- (system::cur-index)) *ONSETTIME* *ENDPOINTER*)