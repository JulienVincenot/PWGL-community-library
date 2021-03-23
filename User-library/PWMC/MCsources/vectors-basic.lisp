(in-package MC)
(defconstant *max-numberof-layers* 10)
(defconstant *max-numberof-notes* 2000) ;in one layer
(defconstant *max-numberof-variables* (* *max-numberof-notes* *max-numberof-layers*))
(defconstant *max-size-timesigngrid* (* *max-numberof-notes* 6)) ;rough estimation - quarternotes divided into sixtuplets
(defconstant *ONSETTIME*  0)
(defconstant *#-RHYTHM-EVENT* 2);To count events (excluding pauses)
(defconstant *PITCH* 1)
(defconstant *GRIDPOINTS*  0)
(defconstant *TIMESIGN* 1)
(defconstant *STARTPOINTER* 0)
(defconstant *ENDPOINTER* 1)

(defconstant *TIMESIGNLAYER* *max-numberof-layers*)

(defvar *grid-definitions-for-timesign* '((4 (0 1/16 1/8 3/16 1/4)) (8 (0 1/16 1/8)) (16 (0 1/16)))) 
;in the form ((low (one-beat-grid)) (low (one-beat-grid)))


; part-sol-vector layernr note onset/pitch/#onset/onset-no-pauses/flag-cell-start
(defvar part-sol-vector (make-array (list *max-numberof-layers* *max-numberof-notes* 3) :initial-element nil))
;pitches and durations are paired in the vector, but due to pauses those are not the true pairs: the pitch and the duration
;sequences are not synchronized in the vector! #-rhythm-event can be used to synchronize pitch and rhythm.


; pointers-vector layernr index onset/pitch startpointer/end --- one layer extra reserved for time signatures
(defvar pointers-vector (make-array (list (1+ *max-numberof-layers*) *max-numberof-variables* 2 2)
                                    :initial-element nil))


; (part-sol-timegridvector onsetforgrid/timesign grid)
(defvar part-sol-timegridvector (make-array (list 2 *max-size-timesigngrid*)))  ;En gridgemensam fšr alla layers!!


(defvar *this-variable* nil)

;Set default start offset to 1. First value for onset vector is reserved as a flag.
(loop for layernr from 0 to (1- *max-numberof-layers*)
      do (progn
           (setf (aref part-sol-vector layernr 1 *ONSETTIME*) 1)
           (setf (aref part-sol-vector layernr 0 *#-RHYTHM-EVENT*) 0)
           (setf (aref part-sol-vector layernr 1 *#-RHYTHM-EVENT*) 1))) ;to make sure count is correct the first time.
;Set endpointers at index 0 to 1.
(loop for layernr from 0 to *max-numberof-layers*
      do (progn 
           (setf (aref pointers-vector layernr 0 *ONSETTIME* *ENDPOINTER*) 1)
           (setf (aref pointers-vector layernr 0 *PITCH* *ENDPOINTER*) 0)))

(setf (aref part-sol-timegridvector *GRIDPOINTS* 1) 1)

(defun ratios-to-onsets-with-offset (offset ratios)
  "Transform duration ratios to onsets starting at offset. Pauses are indicated as negative ratios / onsets. 
Last value is offset for last duration."
  (mapcar '*
          (append (loop for dx in ratios
                        collect (if (or (plusp dx) (= dx 0)) 1 -1 )) '(1))

          (cons offset (loop for dx in ratios
                            sum (abs dx) into thesum
                            collect (+ offset thesum)))))

(defun onsets-to-ratios (onsets)
  "Transform onsettimes to duration ratios. Pauses are indicated as negative ratios / onsets. 
Last onset value should be offset for last duration."
  (loop for x in onsets
        for y in (rest onsets)
        collect (* (- (abs y) (abs x))
                   (if (plusp x) 1 -1))))


(defun put-durations-in-vector (durations layer local-pointer)
  "Put the onsets for durations starting at where the local-pointer points. Output is the end pointer.
Rhythm events (pauses skipped) are counted from start of a layer and stored with the rhythms."
  (let ((onsets
         (ratios-to-onsets-with-offset
          (abs (aref part-sol-vector layer local-pointer *ONSETTIME*))
          durations)))
    ;;;update note count below
    (dolist (onset onsets)
      (setf (aref part-sol-vector layer local-pointer *ONSETTIME*) onset)
      (setf (aref part-sol-vector layer local-pointer *#-RHYTHM-EVENT*) 
            (if (plusp onset)
              (1+ (aref part-sol-vector layer (1- local-pointer) *#-RHYTHM-EVENT*))
            (aref part-sol-vector layer (1- local-pointer) *#-RHYTHM-EVENT*)))
      (incf local-pointer)
      )
    (1- local-pointer)))



(defun put-timesign-in-vector (timesign local-grid local-pointer)
  "Put grid and time signature in vector, starting at local pointer. Local grid has to end with the 
first onset for the next event. Outputs the new local pointer."
  (let* ((offset-for-this-grid (aref part-sol-timegridvector *GRIDPOINTS* local-pointer))
         (global-grid (mapcar #'(lambda (timepoint) (+ timepoint offset-for-this-grid)) local-grid)))
    (setf (aref part-sol-timegridvector *TIMESIGN* local-pointer) timesign) 
    (dolist (one-gridpoint (cdr global-grid))
      (incf local-pointer)
      (setf (aref part-sol-timegridvector *GRIDPOINTS* local-pointer) one-gridpoint)) 
    local-pointer
    ))


(defun put-timesign-at-index (timesign local-grid index)
  "First update all pointers, then put durations in vector and put new pointers in current layer."
  (let* ((local-pointer (aref pointers-vector *TIMESIGNLAYER* (1- index) *ONSETTIME* *ENDPOINTER*)))
    (update-all-pointers index)
    (setf (aref pointers-vector *TIMESIGNLAYER* index *ONSETTIME* *STARTPOINTER*) local-pointer)
    (setf (aref pointers-vector *TIMESIGNLAYER* index *ONSETTIME* *ENDPOINTER*)
          (put-timesign-in-vector timesign local-grid local-pointer))))


(defun update-all-pointers (index)
  "Put previous start and end pointer in the current index slot for all layers."
  (loop for layer from 0 to *max-numberof-layers*
        do (progn
             (setf (aref pointers-vector layer index *ONSETTIME* *STARTPOINTER*)
                   (aref pointers-vector layer (1- index) *ONSETTIME* *STARTPOINTER*))
             (setf (aref pointers-vector layer index *ONSETTIME* *ENDPOINTER*)
                   (aref pointers-vector layer (1- index) *ONSETTIME* *ENDPOINTER*))
             (setf (aref pointers-vector layer index *PITCH* *STARTPOINTER*)
                   (aref pointers-vector layer (1- index) *PITCH* *STARTPOINTER*))
             (setf (aref pointers-vector layer index *PITCH* *ENDPOINTER*)
                   (aref pointers-vector layer (1- index) *PITCH* *ENDPOINTER*)))))

(defun put-durations-at-index (durations layer index)
  "First update all pointers, then put durations in vector and put new pointers in current layer."
  (let ((local-pointer (aref pointers-vector layer (1- index) *ONSETTIME* *ENDPOINTER*)))
    (update-all-pointers index)
    
    (setf (aref pointers-vector layer index *ONSETTIME* *STARTPOINTER*) local-pointer)
    (setf (aref pointers-vector layer index *ONSETTIME* *ENDPOINTER*)
          (put-durations-in-vector durations layer local-pointer))))


(defun put-pitches-in-vector (pitches layer local-pointer)
  "Put pitches starting at where the local-pointer points. Output is the end pointer"
    (setf (aref part-sol-vector layer local-pointer *PITCH*) (first pitches))
    (dolist (pitch (cdr pitches))
      (incf local-pointer)
      (setf (aref part-sol-vector layer local-pointer *PITCH*) pitch)
      )
    ;(ccl::pwgl-print local-pointer)
    local-pointer)



(defun put-pitches-at-index (pitches layer index)
  "First update all pointers, then put pitches in vector and put new pointers in current layer."
  (let ((local-pointer (1+ (aref pointers-vector layer (1- index) *PITCH* *ENDPOINTER*))))
    (update-all-pointers index)
    (setf (aref pointers-vector layer index *PITCH* *STARTPOINTER*) local-pointer)
    (setf (aref pointers-vector layer index *PITCH* *ENDPOINTER*)
          (put-pitches-in-vector pitches layer local-pointer))
    ))


(defun get-onebeat-grid (low)
  "Finds the definition for low from the global variable *grid-definitions-for-timesign*. 
If not found, it returns nil."
  (if *grid-definitions-for-timesign*
      (let ((n -1))
        (loop for i from 0 to (1- (length *grid-definitions-for-timesign*))
              while (/= (car (nth i *grid-definitions-for-timesign*)) low)
              do (setf n i))
        (cadr (nth (1+ n) *grid-definitions-for-timesign*)))
    nil))

(defun get-onemeasure-grid (timesign)
  "Gives one measure gridpoints for timesign. The definition for low is taken from from the global 
variable *grid-definitions-for-timesign*. If not found, it returns measure start and stop points."
  (let ((one-beat-grid (get-onebeat-grid (cadr timesign)))
        (one-measure-grid '(0)))  
    (if one-beat-grid
        (loop for beat from 1 to (car timesign)
              do (let ((offset (car (last one-measure-grid))))
                   (setf one-measure-grid
                         (append 
                          one-measure-grid
                          (cdr (mapcar #'(lambda (gridpoint) (+ gridpoint offset))
                                       one-beat-grid))))))
      (setf one-measure-grid (list 0 (apply '/ timesign))))
    one-measure-grid))

;;;
(defun put-pitches-to-motif-object (motif-object indexx)
  "From previous pitch, get pitches for motif and set the pitchcell slot on the object with these pitches"
  (let* ((this-motif (get-motif-intervals motif-object))
         (previous-pitch (get-last-pitch-at-index (get-layer-nr motif-object) (1- indexx)))
         (this-pitchcell (list previous-pitch)))
    (if (listp previous-pitch) (setf previous-pitch (car (last previous-pitch))))
    (setf this-pitchcell  (loop for n from 0 to (1- (get-nr-of-events motif-object))
                                collect (setf previous-pitch  (+ previous-pitch (nth n this-motif)))))
    (set-pitchcell this-pitchcell motif-object)
    t))

;;; This is the top level function to use to put any object. Output is always t. ;;;
(defun put-object-at-index (this-object index)
  (setf *this-variable* this-object)  ;NEW - save layer nr
  (if (typep this-object 'rhythmcell)
      (put-durations-at-index (get-rhythmcell this-object) (get-layer-nr this-object) index))
  (if (typep this-object 'pitchmotifcell) ;NEW motif
      (if (not (first-pitch? this-object index)) (put-pitches-to-motif-object this-object index)))
  (if (typep this-object 'pitchcell) 
      (put-pitches-at-index (get-pitchcell this-object) (get-layer-nr this-object) index))
  (if (typep this-object 'timesign)
      (put-timesign-at-index (get-timesign this-object) (get-onemeasure-grid (get-timesign this-object)) index))
  t)


              
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun get-one-rhythmlayer (layer stop-local-pointer)
  (loop for local-pointer from 1 to stop-local-pointer
        collect (aref part-sol-vector layer local-pointer *ONSETTIME*)))

(defun get-one-rhythmlayer-at-index (layer index)
  (let ((stop-local-pointer (aref pointers-vector layer index *ONSETTIME* *ENDPOINTER*)))
    (if stop-local-pointer
        (get-one-rhythmlayer layer stop-local-pointer)
      nil)))

(defun get-durations-from-vector (layer start-local-pointer stop-local-pointer)
  (onsets-to-ratios
  (loop for local-pointer from start-local-pointer to stop-local-pointer
        collect (aref part-sol-vector layer local-pointer *ONSETTIME*))))


(defun get-onsets-from-vector (layer start-local-pointer stop-local-pointer)
  (loop for local-pointer from start-local-pointer to stop-local-pointer
        collect (aref part-sol-vector layer local-pointer *ONSETTIME*)))

(defun get-onsets-from-vector-between-timepoints (layer first-timepoint second-timepoint tot-length-layer)
  "The first timepoint is included in the answer (if it exists).The second timepoint is not included in the answer. Offset is 1, layer start at time 1 (not 0). Last offset in vector is not included. Tot-length is number of events (including pauses). pauses are filtered out."
  (remove 0 (let ((timepoints nil))
                (loop for local-pointer from 1 to tot-length-layer 
                      do (let ((this-timepoint (aref part-sol-vector layer local-pointer *ONSETTIME*)))
                           (if (>= (abs this-timepoint) first-timepoint)
                               (if (< (abs this-timepoint) second-timepoint)
                                   (setf timepoints (append timepoints (list this-timepoint)))
                                 (return timepoints))))
                      finally (return timepoints)))
          :test #'(lambda (x y) (> x y)))) ;remove pauses

(defun get-rhythms-from-vector-between-timepoints (layer first-timepoint second-timepoint index)
  "The first timepoint is included in the answer (if it exists).The second timepoint is included in the answer as a possible onset for a new duration. Offset is 1, layer start at time 1 (not 0). Last offset in vector is not included. Tot-length is number of events (including pauses). pauses are NOT filtered out."
  (onsets-to-ratios
   (let ((timepoints nil)
         (tot-length-layer (get-number-of-rhythms-and-pauses-at-index layer index)))
     (loop for local-pointer from 1 to (1+ tot-length-layer)
           do (let ((this-timepoint (aref part-sol-vector layer local-pointer *ONSETTIME*)))
                (if (>= (abs this-timepoint) first-timepoint)
                    (if (<= (abs this-timepoint) second-timepoint)
                        (setf timepoints (append timepoints (list this-timepoint)))
                      (return (append timepoints (list this-timepoint))))))
           finally (return timepoints)))
    ))

;;;;;
(defun get-nrs-for-rhythms-from-vector-between-timepoints (layer first-timepoint second-timepoint index)
  "The first timepoint is included in the answer (if it exists).The second timepoint is included in the answer as a possible onset for a new duration. Offset is 1, layer start at time 1 (not 0). Last offset in vector is not included.Nrs (in the answer) start from 1, and pauses are not counted."
   (let ((nths-for-rhythms nil)
         (tot-length-layer (get-number-of-rhythms-and-pauses-at-index layer index)))
     (loop for local-pointer from 1 to (1+ tot-length-layer)
           do (let ((this-timepoint (aref part-sol-vector layer local-pointer *ONSETTIME*)))
                (if (>= (abs this-timepoint) first-timepoint)
                    (if (<= (abs this-timepoint) second-timepoint)
                        (setf nths-for-rhythms (append nths-for-rhythms (list (aref part-sol-vector layer local-pointer *#-RHYTHM-EVENT*))))
                      (return nths-for-rhythms))))
           finally (return nths-for-rhythms))))
    
;(get-nrs-for-rhythms-from-vector-between-timepoints 1 15/8 16/8 45)
;(get-number-of-rhythms-and-pauses-at-index 1 6)
;(aref part-sol-vector 1 18 *#-RHYTHM-EVENT* )

(defun get-onsets-from-vector-between-timepoints-include-pause (layer first-timepoint second-timepoint tot-length-layer)
  "The first timepoint is included in the answer (if it exists).The second timepoint is not included in the answer. Offset is 1, layer start at time 1 (not 0). Last offset in vector is not included. Tot-length is number of events (including pauses). Pauses are included."
  (let ((timepoints nil))
    (loop for local-pointer from 1 to tot-length-layer 
          do (let ((this-timepoint (aref part-sol-vector layer local-pointer *ONSETTIME*)))
               (if (>= (abs this-timepoint) first-timepoint)
                   (if (< (abs this-timepoint) second-timepoint)
                       (setf timepoints (append timepoints (list this-timepoint)))
                     (return timepoints))))
          finally (return timepoints))))



(defun get-durations-at-index (layer index)
  (let ((start-local-pointer (aref pointers-vector layer index *ONSETTIME* *STARTPOINTER*))
        (stop-local-pointer (aref pointers-vector layer index *ONSETTIME* *ENDPOINTER*)))
    (if start-local-pointer
        (get-durations-from-vector layer start-local-pointer stop-local-pointer)
      nil)
      ))

(defun get-durations-upto-index (layer index)
  (let ((start-local-pointer 1)
        (stop-local-pointer (aref pointers-vector layer index *ONSETTIME* *ENDPOINTER*)))
    (if stop-local-pointer
        (get-durations-from-vector layer start-local-pointer stop-local-pointer)
      nil)
    ))

;;;;

(defun get-one-rhythmlayers-rhythmeventnumber (layer stop-local-pointer)
  "This can be used to figure out pauses"
  (loop for local-pointer from 1 to stop-local-pointer
        collect (aref part-sol-vector layer local-pointer *#-RHYTHM-EVENT*)))


(defun get-one-rhythmlayers-rhythmeventnumber-at-index (layer index)
  "This can be used to figure out pauses"
  (let ((stop-local-pointer (aref pointers-vector layer index *ONSETTIME* *ENDPOINTER*)))
    (if stop-local-pointer
        (get-one-rhythmlayers-rhythmeventnumber layer stop-local-pointer)
      nil)))

;;;;
(defun get-one-rhythmlayers-pointers (layer index)
  (remove nil
          (remove-duplicates (loop for i from 1 to index 
                                   collect (list (aref pointers-vector layer i *ONSETTIME* *STARTPOINTER*)
                                                 (aref pointers-vector layer i *ONSETTIME* *ENDPOINTER*))) :test 'equal)
          :test #'(lambda (x y) (equal x (first y)))))

(defun get-n-last-rhythmcells (layer index nn)
  (let ((pointers (reverse (get-one-rhythmlayers-pointers layer index))))
    (if (< nn (length pointers))
        (reverse (loop for n from 0 to (1- nn)
                       collect (get-durations-from-vector layer (first (nth n pointers)) (second (nth n pointers)))))
      (reverse (loop for n from 0 to (1- (length pointers))
                       collect (get-durations-from-vector layer (first (nth n pointers)) (second (nth n pointers)))))
      )))

(defun get-startpoint-all-rhythmcells (layer index)
  (let ((pointers (reverse (get-one-rhythmlayers-pointers layer index))))
    (if pointers
        (apply 'append (reverse (loop for pointer in pointers
                       collect (get-onsets-from-vector layer (first pointer) (first pointer)))))
      nil
      )))
;(get-startpoint-all-rhythmcells 0 20)
;;;


;;;;;
(defun get-number-of-rhythms-at-index (layer index)
  "Count notes in one layer (rhythm events independant of pitch) excluding pauses up to index"
  (let ((stop-local-pointer (aref pointers-vector layer index *ONSETTIME* *ENDPOINTER*)))
      (aref part-sol-vector layer (1- stop-local-pointer) *#-RHYTHM-EVENT*)))

;get-number-of-rhythms-at-index corrected: (1- stop-local-pointer)

(defun get-number-of-rhythms-and-pauses-at-index (layer index)
  "Count notes and pauses in one layer (rhythm events independant of pitch) up to index"
    (1- (aref pointers-vector layer index *ONSETTIME* *ENDPOINTER*)))

;(aref pointers-vector 0 6 *ONSETTIME* *ENDPOINTER*)
(defun get-total-duration-rhythms-at-index (layer index)
  (let ((stop-local-pointer (aref pointers-vector layer index *ONSETTIME* *ENDPOINTER*)))
    (1- (abs (aref part-sol-vector layer stop-local-pointer *ONSETTIME*)))))   ;1- to compensate for offset in vector

;;;;;
(defun get-timesign-at-index (index)
  (let ((local-pointer (aref pointers-vector *TIMESIGNLAYER* index *ONSETTIME* *STARTPOINTER*)))
    (aref part-sol-timegridvector *TIMESIGN* local-pointer)))

(defun get-timesigns-upto-index (index)
  (let ((all-local-pointers (remove nil (remove-duplicates 
                                         (loop for this-index from 1 to index
                                               collect (aref pointers-vector *TIMESIGNLAYER* this-index *ONSETTIME* *STARTPOINTER*))))))
    
    (if all-local-pointers
        (loop for i from 0 to (1- (length all-local-pointers))
              collect (aref part-sol-timegridvector *TIMESIGN* (nth i all-local-pointers)))
      '(nil))
    ))


(defun get-timepoints-at-measures-upto-index (index)
  (let ((all-local-pointers (remove nil (remove-duplicates 
                                         (loop for this-index from 1 to index
                                               collect (aref pointers-vector *TIMESIGNLAYER* this-index *ONSETTIME* *STARTPOINTER*))))))
    
    (if all-local-pointers
        (loop for i from 0 to (1- (length all-local-pointers))
              collect (aref part-sol-timegridvector *GRIDPOINTS* (nth i all-local-pointers)))
      '(nil))
    ))

;(get-timesigns-upto-index 2)
;no last startpoint for measure that does not exist.

(defun timesigns-exist? (index)
  (if (aref pointers-vector *TIMESIGNLAYER* index *ONSETTIME* *STARTPOINTER*) t nil))

;(timesigns-exist? 3)


(defun get-timepoints-at-beats-upto-index (index)
  (let* ((measures-startpoints (get-timepoints-at-measures-upto-index index))
         (timesigns (get-timesigns-upto-index index))
         (measurs-durtion-beatlist (mapcar #'(lambda (timesign) 
                                               (make-list (1- (car timesign)) :initial-element (/ 1 (cadr timesign))))
                                           timesigns)))
   (apply 'append (mapcar #'(lambda (durationlist measure-offset) (ratios-to-onsets-with-offset measure-offset durationlist)) measurs-durtion-beatlist measures-startpoints))))

(defun get-timepoints-at-beats-with-endpoint-upto-index (index)
  "If no timesigns exist '(1) will be returned"
  (if (timesigns-exist? index)
  (let* ((measures-startpoints (get-timepoints-at-measures-upto-index index))
         (timesigns (get-timesigns-upto-index index))
         (measurs-durtion-beatlist (mapcar #'(lambda (timesign) 
                                               (make-list (1- (car timesign)) :initial-element (/ 1 (cadr timesign))))
                                           timesigns))
         (tot-dur-measures (get-total-duration-timesigns-at-index index)))
    (append (apply 'append (mapcar #'(lambda (durationlist measure-offset) 
                                       (ratios-to-onsets-with-offset measure-offset durationlist)) measurs-durtion-beatlist measures-startpoints)) 
            (list (1+ tot-dur-measures))))
    '(1)))


;;;!!!!!


(defun get-timegrid-layer (index)
  (let ((stop-pointer (aref pointers-vector *TIMESIGNLAYER* index *GRIDPOINTS* *ENDPOINTER*)))
    (loop for local-pointer from 1 to stop-pointer
          collect (aref part-sol-timegridvector *GRIDPOINTS* local-pointer))))

;(aref pointers-vector *TIMESIGNLAYER* 3 *GRIDPOINTS* *ENDPOINTER*)
;;;
;This seems to give the startpoint for the last existing measure.
(defun get-total-duration-timesigns-at-index (index)
  (let ((local-pointer (aref pointers-vector *TIMESIGNLAYER* index *ONSETTIME* *ENDPOINTER*)))
    (1- (aref part-sol-timegridvector *GRIDPOINTS* local-pointer))))    ;1- to compensate for offset in vector


;;;;;

(defun get-pitches-from-vector (layer start-local-pointer stop-local-pointer)
  (loop for local-pointer from start-local-pointer to stop-local-pointer
        collect (aref part-sol-vector layer local-pointer *PITCH*)))

(defun get-pitches-at-index (layer index)
  (let ((start-local-pointer (aref pointers-vector layer index *PITCH* *STARTPOINTER*))
        (stop-local-pointer (aref pointers-vector layer index *PITCH* *ENDPOINTER*)))
    (if start-local-pointer
        (get-pitches-from-vector layer start-local-pointer stop-local-pointer)
      nil)
      ))




(defun get-last-pitch-at-index (layer index)
  (let ((local-pointer (aref pointers-vector layer index *PITCH* *ENDPOINTER*)))
    (if local-pointer
        (car (get-pitches-from-vector layer local-pointer local-pointer))
      nil)
      ))

(defun get-pitch-before-last-at-index (layer index)
  (let ((local-pointer (1- (aref pointers-vector layer index *PITCH* *ENDPOINTER*))))
    (if (and local-pointer (plusp local-pointer))
        (car (get-pitches-from-vector layer local-pointer local-pointer))
      nil)
      ))


;(aref pointers-vector 0 2 *PITCH* *ENDPOINTER*)


(defun get-pitches-upto-index (layer index)
  (let ((start-local-pointer 1)
        (stop-local-pointer (aref pointers-vector layer index *PITCH* *ENDPOINTER*)))
    (if stop-local-pointer
        (get-pitches-from-vector layer start-local-pointer stop-local-pointer)
      nil)
    ))



(defun get-number-of-pitches-at-index (layer index)
  (aref pointers-vector layer index *PITCH* *ENDPOINTER*))

;;;;;;;;;;


