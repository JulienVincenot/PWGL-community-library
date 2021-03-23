(in-package :ccl)

#|
Each *NOTE* has the complete syntax
(<midicents> <velocity> <tie?> (graphic ...) (breakpoints ...) (slots
...) <flags>)
for a bach.score note, and
(<midicents> <duration> <velocity> (graphic ...) (breakpoints ...)
(slots ...) <flags>)
for a bach.roll note, so you see that they are pretty much the same.

"Graphic" has the form
(graphic <screen_midicents> <screen_accidental>)
i.e. the midicents of the (diatonic) note on the screen (ignoring the
accidental!) and the accidental, as a fraction: 1/2 = #, -1/2 = b and
so on.

"Breakpoints" has the form
(breakpoints (<x1> <y1> <slope1>) (<x2> <y2> <slope2>) ... )
where
the x's are between 0. (start of the note) and 1. (end of the note duration),
the y's are the midicent deplacement with respect to the note's
midicents (e.g., a glissando of 1 tone upwards would have y = 200)
the slope refers to the slope of the "previous" segment of curve
(slope1 thus is ignored) and is between -1 and 1; where 0. = linear
gliss.
The first element has ALWAYS to be (0. 0. 0.), I know, it's silly but
it makes sense... And the last element has always to be (1.
<something> <something>)

"Slots" has the form
(slots (<slot_number> <slot_content>) (<slot_number> <slot_content>) ...)
<slot_content> might be just a number (for float-typed or int-typed
slots) or a list of numbers (for float-list or int-list slots) or a
text (for text slots) or a list of file paths (for file-type slots,
use a final integer to say which one of the files in the list is
"active") or might be something like:
<slot_content> = (<x1> <y1> <slope1>) (<x2> <y2> <slope2>) (<x2> <y2>
<slope2>)...
for function-typed slots, and finally for a spatialization slot:
<slot_content> = (<x1> <r1> <angle1> <type1>) (<x2> <r2> <angle2>
<type2>) (<x3> <r3> <angle3> <type3>)...
In these case, x is always 0. to 1. The angles are in degrees. Types
are 0 (circular interpolation) or 1 (segment-interpolation)

Slots types are defined in the slotinfo header: if you want I can tell
you more about this. Maybe that's too fast for slots: if you need
something more, just ask! I'll be glad to answer more properly.

An example to give you the idea: one note can be:

( 6871.428711 127 0    // midicents = 6871..., velocity = 127, and NOT tied
   ( graphic 7100 -1 )  // it is shown as a B double flat
   ( breakpoints ( 0. 0. 0. ) ( 0.634644 -13.897791 0. ) ( 1.
-1485.714233 0. ) )  // has a 2-pieces glissando
   ( slots ( 1 ( 0. 0. 0. ) ( 0.429276 102.809525 -0.528571 ) ( 1. 0.
0. ) )  // has something in slot 1 (a breakptcurve)
             ( 4 0.623881 0.383486 ) ) // has something in slot 4 (a
list of floats)
 0 ) // non muted, non locked
|#

(defparameter *breakpoints-sources* '(:notehead :glissando))

(defmethod enp-export-file-extension ((self (eql :bach)))
  "txt")

(defmethod enp-export-name ((format (eql :bach)))
  "bach (MaxMSP)")

(defmethod enp-export ((self score) (format (eql :bach)) (stream T))
  (pwgl2bach self))

(defun export-bach (self &optional opt-filename)
  (let ((filename (or opt-filename (capi:prompt-for-file "" 
                                                         :operation :save
                                                         :filters '("bach" "*.txt")))))
    (when filename
      (with-open-file (stream filename
                              :direction :output
                              :if-does-not-exist :create
                              :if-exists :supersede)
        (enp-export self :bach stream)))))

(defun import-bach (&optional opt-filename)
  (let ((filename (or opt-filename (capi:prompt-for-file "" 
                                                         :operation :open
                                                         :filters '("bach" "*.enp;*.txt")))))
    (when filename
      (let ((score (make-instance 'score)))
        (enp-import-as score :enp-score-notation filename)
        score))))

;********************************************************************************
; Bach specific expression (BPF)
;********************************************************************************

(create-expression bach-bpf (bpf)
  ()
  (:default-initargs
   :print-level :note-head
   :display-active-bpf-only-p T
   :internal-symbol :bach-bpf))

(defmethod draw-BPF-expression :around ((self bach-bpf) open-left-p open-right-p all-chords)
  (when (or (some #'(lambda(x) (selected-enp-object-p *current-enp-window* x)) (notation-objects self))
            (selected-enp-object-p *current-enp-window* self)
            (eq (input-object *current-enp-window*) self))
    (call-next-method)))

(defmethod calc-expression-print-position ((self note) (expression bach-bpf))
  (case (expression-print-level expression)
    (t (setf (expression-X-position expression) (X self)
             (expression-Y-position expression) (+ (Y self) 0.66)))))

;********************************************************************************
; helper functions & macros
;********************************************************************************

(defmacro with-parentheses (&body body)
  `(progn
     (format *enp-export-stream* "(")
     ,@body
     (format *enp-export-stream* ")")))

(defun emit(stuff)
  (format *enp-export-stream* "~a " stuff))

;********************************************************************************
; copy/paste
;********************************************************************************

(defmethod paste-ENP-object ((copied-object CONS) (object-type BACH-BPF) (target NOTE))
  )

;********************************************************************************

(defmethod user-definable-properties ((self note))
  ;; (lispworks-tools::class-initargs (find-class 'note))
  ;; :midi
  '(:color :kind :clef-number :x-offset :y-offset :duration :start-time :comment :constrained? 
    :chan :vel :offset-dur :note-head :enharmonic :expressions :offset-time :attack-p :bach-slots))

(defmethod user-definable-property ((self note) (prop (eql :bach-slots)) (value t) &key include exclude)
  (declare (ignore include exclude)))

(defmethod convert-ENP-Slot ((self enp-notation-object) (slot (eql :bach-slots)) values)
  #+NIL (when values
    (setf (bach-slots self)
          (loop for value in values
                collect
                (apply #'make-instance (bach-type-to-pwgl (car value))
                       (cdr values))))))

;********************************************************************************
; 
;********************************************************************************

(defmethod locked-p ((self T))
  0)

(defun bach-score-type (self)
  (if (every #'chord-sequence-p (collect-enp-objects self :voice))
      "roll"
    "score"))

(defmacro with-bach-score-type (score &body body)
  `(progn
     (emit (bach-score-type ,score))
     ,@body))

;********************************************************************************
;
;********************************************************************************

(defun voice2clef (voice)
  (let ((clef (clef-of voice (staff (super-notation-object voice)))))
    (typecase clef
      (treble-clef " G")
      (bass-clef " F")
      (t " G"))))

(defun clefs2bach (score)
  (with-parentheses
    (emit "clefs")
    (let ((voices (collect-enp-objects score :voice)))
      (mapcar #'emit (mapcar #'voice2clef voices)))))

;********************************************************************************
; pwgl2bach
;********************************************************************************

(defmethod pwgl2bach ((self expression))
  ())

(defmethod pwgl2bach ((self bach-bpf))
  (loop for break-point-function in (break-point-functions self)
        for slot-number from 1 do
    (with-parentheses
      (emit slot-number)
      (emit (pwgl2bach break-point-function)))))

(defmethod pwgl2bach ((self break-point-function))
  (let* ((points (points self))
         (xs (mapcar 'x points))
         (bpf-times (enp-scaling xs 0.0 1.0 (apply #'min xs) (apply #'max xs))))
    (loop while points 
          for point = (pop points)
          collect (list (float (pop bpf-times) 1.0) (float (y point) 1.0) (float (min (max (or (slope point) 0) 0) 1.0) 1.0)))))

(defun bach-graphic (self)
  (declare (ignore self))
  (with-parentheses
    (emit "graphic")))

(defun bach-breakpoints (self)
  (ccl::when-let (note-head (bpf-notehead-p (note-head self)))
    (with-parentheses
      (emit "breakpoints")
      (dolist (point (pwgl2bach (break-point-function note-head)))
        (emit (list (first point) (* (second point) 100) (third point)))))))

(defun bach-slots (self)
  (declare (ignore self))
  #+NIL 
  (with-parentheses
    (emit "slots")
    (dolist (expression (expressions self))
      (pwgl2bach expression))))

;********************************************************************************

(defmethod pwgl2bach ((self score))
  (with-bach-score-type self
    (clefs2bach self)
    (mapc #'pwgl2bach (collect-enp-objects self :voice)))
  self)

(defmethod pwgl2bach ((self voice))
  (with-parentheses
    (mapc #'pwgl2bach (collect-enp-objects self :measure))))

(defmethod pwgl2bach ((self chord-sequence))
  (with-parentheses
   (mapc #'pwgl2bach (collect-enp-objects self :chord))))

(defmethod pwgl2bach ((self time-signature))
  (emit (list (high self) (low self))))

(defmethod pwgl2bach ((self metronome))
  (emit (list (/ 1 (metronome-unit self)) (metronome-value self))))

(defmethod pwgl2bach ((self measure))
  (with-parentheses
    (with-parentheses
      (pwgl2bach (time-signature self))
      (with-parentheses (pwgl2bach (metronome self))))
    (dolist (beat (beat-objects self))
      (with-parentheses (pwgl2bach beat)))
    (emit (locked-p self))))

(defmethod pwgl2bach ((self Beat))
  (dolist (current-beat (sub-beat-list self))
    (if (sub-beat-list current-beat)
        (with-parentheses (pwgl2bach current-beat))
      (pwgl2bach (beat-chord current-beat)))))

(defmethod pwgl2bach ((self chord))
  (if (non-mensural-p self)
      (with-parentheses
       (emit (float (* (start-time self) 1000.0) 1.0))
       (mapc #'pwgl2bach (collect-enp-objects self :note))
       (emit (locked-p self)))
    (if (rest-p self)
        (emit (list (* (face-value self) -1) 0))
      (with-parentheses
       (emit (face-value self))
       (mapc #'pwgl2bach (collect-enp-objects self :note))
       (emit (locked-p self))))))

;;; (<midicents> <velocity> <tie?> (graphic ...) (breakpoints ...) (slots ...) <flags>)
;;; (<midicents> <duration> <velocity> (graphic ...) (breakpoints ...) (slots ...) <flags>)

#+NIL
(defun tied-for-bach-p (self)
  (let ((chord (super-notation-object self)))
    (and (tied-p (prev-item chord))
         (not (attack-p self)))))

(defun tied-for-bach-p (self)
  (let ((chord (super-notation-object self)))
    (and (next-item chord) 
         (tied-p (next-item chord)))))

(defmethod pwgl2bach ((self note))
  (if (non-mensural-p self)
      (with-parentheses
       (emit (float (* (midi self) 100) 1.0))
       (emit (float (* (real-duration self) 1000.0) 1.0))
       (emit (vel self))
       ;; the optional stuff
       (bach-graphic self)
       (bach-breakpoints self)
       (bach-slots self)
       (emit (locked-p self)))
    (with-parentheses
     (emit (float (* (midi self) 100) 1.0))
     (emit (vel self))
     (emit (if (tied-for-bach-p self) 1 0))
     ;; the optional stuff
     (bach-graphic self)
     (bach-breakpoints self)
     (bach-slots self)
     (emit (locked-p self)))))

