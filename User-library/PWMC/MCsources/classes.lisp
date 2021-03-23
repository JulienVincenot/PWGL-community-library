(in-package MC)

;classes for search variables

(defclass layer ()
  ((layer :type integer :initform nil :reader get-layer-nr :writer set-layer-nr)))
(defclass variabledur (layer)
  ((variabledur :type ratio :initform 0 :reader get-variabledur :writer set-variabledur)))
(defclass rhythmcell (variabledur)
  ((rhythmcell :type list :initform '() :reader get-rhythmcell :writer set-rhythmcell)
   (local-onset-without-pauses :type list :initform '() :reader get-local-onset-without-pauses :writer set-local-onset-without-pauses)
   (pauses-included? :type boolean :initform nil :reader get-pauses-included? :writer set-pauses-included?)))
(defclass pitchcell (layer)
  ((pitchcell :type list :initform nil :reader get-pitchcell :writer set-pitchcell)
   (nr-of-events :type integer :initform nil :reader get-nr-of-events :writer set-nr-of-events)
   (chords-included? :type boolean :initform nil :reader get-chords-included? :writer set-chords-included?)))
(defclass timesign (variabledur)
  ((timesign :type list :initform '() :reader get-timesign :writer set-timesign)
   (low :type integer :initform nil :reader get-low :writer set-low)))
(defclass pitchmotifcell (pitchcell)
  ((motif-intervals :type list :initform nil :reader get-motif-intervals :writer set-motif-intervals)))


