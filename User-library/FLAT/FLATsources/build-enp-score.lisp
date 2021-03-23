(in-package studioflat)

(defun map-chords-on-timepoints (chords timepoints)
  (let (durations)
    (if (and (not (listp chords)) (not (listp timepoints))) (setf timepoints (list timepoints)))
    (if (not (listp chords)) (setf chords (make-list (length timepoints) :initial-element chords)))
    (if (not (listp timepoints)) (setf timepoints (loop for n from 0 to (1- (length chords))
                                                        for  y = (* n timepoints)
                                                        collect y)))
    (if (= (length timepoints) 1) (setf timepoints (append timepoints (list (+ (car timepoints) 1)))))
    (setf durations (append (patch-work::x->dx timepoints) (last (patch-work::x->dx timepoints))))
    
    (ccl::make-score (list (loop for chord in chords
                                 for timepoint in timepoints
                                 for duration in durations
                                 collect (ccl::make-chord  (if (listp chord) chord (list chord)) :START-TIME timepoint :duration (* 0.99 duration)))))))




(system::PWGLdef chords-at-times->score ((chords '((60 64 67)(65 69 72))) (timepoints '(0 0.5)))
    "Format an enp-score from a list of pitches (or chords) and their timepoints 
(in seconds). If only a single pitch is given (i.e. not a list), this 
will be used at all timepoints If only one timepoint is given (i.e. not
a list) this will be used as the distance between all events."
    ()
  (map-chords-on-timepoints chords timepoints))