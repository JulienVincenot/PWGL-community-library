(in-package MC)

;;;RULES 

;;;***************
(defun testfunction-equal (chord-at-duration chord)
  (equal chord-at-duration chord))

(defun testfunction-not-equal (chord-at-duration chord)
  (not (equal chord-at-duration chord)))

(defun testfunction-member (chord-at-duration chords)
  (if (member chord-at-duration chords :test 'equal) t nil))

(defun testfunction-lowregister (chord-at-duration treshold)
  (if (listp chord-at-duration)
      (not (member treshold chord-at-duration :test '<=))
    (> treshold chord-at-duration)))

(defun testfunction-highregister (chord-at-duration treshold)
  (if (listp chord-at-duration)
      (not (member treshold chord-at-duration :test '>=))
    (< treshold chord-at-duration)))

(defun testfunction-exist (chord-at-duration pitch)
  (if (listp chord-at-duration)
      (if (member pitch chord-at-duration) t nil)
    (= pitch chord-at-duration)))

;;;**************GENERAL RULE
(defun  pitch-at-dur (layer index this-object chord duration testfunctionpitch testfunctionduration)
  (typecase this-object 
    (rhythmcell (let* ((rhythmcell-without-pauses (remove 0 (get-rhythmcell this-object) :test '>))
                      (number-of-rhythms-before-this-cell (get-number-of-rhythms-at-index layer (1- index)))
                      (position-in-cell nil)
                      (chord-at-duration nil)
                      (pitches-at-rhythms (get-pitches-for-rhythms layer index number-of-rhythms-before-this-cell 
                                                                   (+ number-of-rhythms-before-this-cell
                                                                      (1- (length rhythmcell-without-pauses))))))
                  (if rhythmcell-without-pauses
                      (every #'(lambda (x) (equal t x)) ;this is like applying AND, checks that all elements in the list are true
                             (loop for position-in-cell from 0 to (1- (length rhythmcell-without-pauses))
                                   collect (let ((chord-at-duration (nth position-in-cell pitches-at-rhythms)))
                                             (if chord-at-duration
                                                 (if (funcall testfunctionduration duration (nth position-in-cell rhythmcell-without-pauses)) 
                                                     (funcall testfunctionpitch chord-at-duration chord)  ;test
                                                   t)
                                               t))))
                    t);if only pauses in cell
                  ))                               
    (pitchcell (let* ((pitchcell (get-pitchcell this-object))
                      (number-of-pitches-before-this-cell (get-number-of-pitches-at-index layer (1- index)))
                      (cell-length (get-nr-of-events this-object))
                      (rhythm-for-pitches-without-pauses (remove 0  (get-rhythm-for-pitches layer index 
                                                                                            number-of-pitches-before-this-cell 
                                                                                            (+ number-of-pitches-before-this-cell (1- cell-length)))
                                                                 :test '>))
                     (duration-at-pitch nil))
                 (every #'(lambda (x) (equal t x)) ;this is like applying AND, checks that all elements in the list are true
                        (loop for position-in-cell from 0 to (1- cell-length)
                              collect (let ((duration-at-chord (nth position-in-cell rhythm-for-pitches-without-pauses)))
                                        (if duration-at-chord
                                            (if (funcall testfunctionduration duration duration-at-chord)
                                                (funcall testfunctionpitch (nth position-in-cell pitchcell) chord) ;test
                                              t)
                                          t))))
                 ))                            
    (t t)))


;;;**********
(defun  pitch-at-dur-rule (layer chord duration testfunctionpitch testfunctionduration)
  #'(lambda (indexx x) (if (= (get-layer-nr x) layer) 
                           (pitch-at-dur layer indexx x chord duration testfunctionpitch testfunctionduration)
                         t)))

;;;************************
(defun testfunction-r= (duration duration-at-pitch)
  (= duration-at-pitch duration))

(defun testfunction-r-not= (duration duration-at-pitch)
  (/= duration-at-pitch duration))

(defun testfunction-rmember (durations duration-at-pitch)
  (if (member duration-at-pitch durations) t nil))

(defun testfunction-longdurations (treshold duration-at-pitch)
    (< treshold duration-at-pitch))

(defun testfunction-shortdurations (treshold duration-at-pitch)
    (> treshold duration-at-pitch))

;;;***********


(defun  dur-at-pitch (layer index this-object duration chord testfunctiondur testfunctionpitch)
  "Obs: pitch or chord"
  (typecase this-object 
    (rhythmcell (let* ((rhythmcell-without-pauses (remove 0 (get-rhythmcell this-object) :test '>))
                      (number-of-rhythms-before-this-cell (get-number-of-rhythms-at-index layer (1- index)))
                      (position-in-cell nil)
                      (chord-at-duration nil)
                      (pitches-at-rhythms (get-pitches-for-rhythms layer index number-of-rhythms-before-this-cell 
                                                                   (+ number-of-rhythms-before-this-cell
                                                                      (1- (length rhythmcell-without-pauses))))))
                  (if rhythmcell-without-pauses
                      (every #'(lambda (x) (equal t x)) ;this is like applying AND, checks that all elements in the list are true
                             (loop for position-in-cell from 0 to (1- (length rhythmcell-without-pauses))
                                   collect (let ((chord-at-duration (nth position-in-cell pitches-at-rhythms)))
                                             (if chord-at-duration
                                                 (if (funcall testfunctionpitch chord-at-duration chord)
                                                     (funcall testfunctiondur duration (nth position-in-cell rhythmcell-without-pauses))
                                                   t)
                                               t))))
                    t);if only pauses in cell
                  ))                               
    (pitchcell (let* ((pitchcell (get-pitchcell this-object))
                      (number-of-pitches-before-this-cell (get-number-of-pitches-at-index layer (1- index)))
                      (cell-length (get-nr-of-events this-object))
                      (rhythm-for-pitches-without-pauses (remove 0  (get-rhythm-for-pitches layer index 
                                                                                            number-of-pitches-before-this-cell 
                                                                                            (+ number-of-pitches-before-this-cell (1- cell-length)))
                                                                 :test '>))
                     (duration-at-pitch nil))
                 (every #'(lambda (x) (equal t x)) ;this is like applying AND, checks that all elements in the list are true
                        (loop for position-in-cell from 0 to (1- cell-length)
                              collect (let ((duration-at-chord (nth position-in-cell rhythm-for-pitches-without-pauses)))
                                        (if duration-at-chord
                                            (if (funcall testfunctionpitch (nth position-in-cell pitchcell) chord)
                                                (funcall testfunctiondur duration duration-at-chord) ;test
                                              t)
                                          t))))
                 ))                            
    (t t)))


;;************

(defun  dur-at-pitch-rule (layer duration chord testfunctiondur testfunctionpitch)
  #'(lambda (indexx x) (if (= (get-layer-nr x) layer) 
                           (dur-at-pitch layer indexx x duration chord testfunctiondur testfunctionpitch)
                         t)))