(in-package MC)

;
;(get-ordernr-for-onsets-from-vector-at-timepoints layer timepoints tot-length-layer) from pitch-rule-interface.lisp (for chord)
;;;;;;;

;(defun get-timepoint-one-duration-before-start-for-pitchcell (layer index start-nth-pitch)
;  (let ((local-pointer (get-localpointer-at-nthrhythm layer index start-nth-pitch)))
;    (if local-pointer (car (get-onsets-from-vector layer (1- local-pointer) (1- local-pointer)))
;      nil)))

;(get-number-of-rhythms-and-pauses-at-index 0 3)
;(get-onsets-from-vector 0 9 9)
;(get-durations-from-vector 0 7 10)
;(minusp 0)
;(get-ordernr-for-onsets-from-vector-at-timepoints 0 '(1 9/8) 8)


(defun mel-interval-for-dur (index x testfn-duration testfn-interval)
  "This function filters out gracenotes: intervals are checked on real durations. Rests break intervals (i.e. at rest any interval is possible)."
  (typecase x 
    (rhythmcell (let* ((this-layer (get-layer-nr x))
                       (number-of-events-before-this-cell (get-number-of-rhythms-and-pauses-at-index this-layer (1- index)))
                       (number-of-events-including-this-cell (get-number-of-rhythms-and-pauses-at-index this-layer index))
                       (this-rhythmcell (get-rhythmcell x))
                       (this-ordernrs (loop for n from (1+ number-of-events-before-this-cell) to number-of-events-including-this-cell
                                            collect n))
                       preceeding-duration
                       preceeding-ordernr
                       durations
                       ordernrs
                       ordernr-pairs
                       pitch-pairs)
                  (if (> number-of-events-before-this-cell 0)
                      (let ((preceeding-duration&n (loop for n from number-of-events-before-this-cell downto 1
                                                         do (let ((dur (get-durations-from-vector this-layer n 
                                                                                                  (1+ n))))
                                                              (if (/= (car dur) 0) (return (list dur n)))))))
                        (setf preceeding-duration (car preceeding-duration&n))
                        (setf preceeding-ordernr (cdr preceeding-duration&n))))


                  (setf this-ordernrs (remove nil (loop for n in this-ordernrs
                                                        for dur in this-rhythmcell
                                                        collect (if (/= dur 0) n nil))))
                  (setf this-rhythmcell (remove 0 this-rhythmcell))

                  (setf durations (append preceeding-duration this-rhythmcell))
                  (setf ordernrs (append preceeding-ordernr this-ordernrs))


                  ;mark rests
                  (setf durations (mapcar #'(lambda (dur1 dur2) (if (and (not (minusp dur1)) (not (minusp dur2))) dur1 nil)) durations (cdr durations)))
                  (setf ordernr-pairs (mapcar #'(lambda (dur nth nth+1) (if dur (list nth nth+1) nil)) durations ordernrs (cdr ordernrs)))


                  ;remove rests
                  (setf durations (remove nil durations))
                  (setf ordernr-pairs (remove nil ordernr-pairs))
                  

                  (setf pitch-pairs (mapcar #'(lambda (pair) (append (get-pitch-for-localpointer-rhythm&pause this-layer index (first pair));;;NONONO does not include pauses
                                                                     (get-pitch-for-localpointer-rhythm&pause this-layer index (second pair))))
                                            ordernr-pairs))
                  ;(system::pwgl-print pitch-pairs)

                  (if (car pitch-pairs)
                      (let ((intervals (mapcar #'(lambda (pair) (if (second pair) (- (second pair) (first pair)) nil)) pitch-pairs)))
                        (eval (append '(and) (mapcar #'(lambda (i d) 
                                                         (if i
                                                             (if (funcall testfn-duration d) (funcall testfn-interval (abs i)) t)
                                                           t))
                                                     intervals durations))))
                    t)
                  ))


    (pitchcell (let* ((this-layer (get-layer-nr x))
                      (number-of-pitches-before-this-cell (get-number-of-pitches-at-index this-layer (1- index)))
                      (number-of-pitches-including-this-cell (get-number-of-pitches-at-index this-layer index))
                      (number-of-durations-without-pauses-in-layer (get-number-of-rhythms-at-index this-layer index))
                      (number-of-durations-including-pauses-in-layer (get-number-of-rhythms-and-pauses-at-index this-layer index))
                      (this-pitchcell (get-pitchcell x))
                      this-rhythms
                      (this-ordernrs (loop for n from number-of-pitches-before-this-cell to (1- number-of-pitches-including-this-cell)
                                           collect n))


                      preceeding-ordernr

                      end-pointer
                      rhythms
                      durations
                      pitches
                      int-dur-pairs
                      pitch-durs
                      )
                 (if (and (>= number-of-durations-without-pauses-in-layer number-of-pitches-before-this-cell) (/= number-of-durations-without-pauses-in-layer 0))
                     (progn
                       (if (> number-of-pitches-before-this-cell 0)
                           (setf preceeding-ordernr (loop for n from (get-localpointer-at-nthrhythm this-layer index (1- number-of-pitches-before-this-cell)) downto 1
                                                          do (let ((dur (get-durations-from-vector this-layer n (1+ n))))
                                                               (if (/= (car dur) 0) (return n))))))

  
                       (setf end-pointer (get-localpointer-at-nthrhythm this-layer index (1- number-of-pitches-including-this-cell)));last-pitch
                       (if (not end-pointer) (setf end-pointer number-of-durations-including-pauses-in-layer)
                         (min end-pointer;last-pitch
                              number-of-durations-including-pauses-in-layer))
                       
                      ; (setf end-pointer (min (get-localpointer-at-nthrhythm this-layer index (1- number-of-pitches-including-this-cell));last-pitch
                      ;                        number-of-durations-including-pauses-in-layer))

                       ;this is to manage first event as a grace note:
                       (if (not preceeding-ordernr) 
                           (if (/= number-of-pitches-before-this-cell 0)
                               (setf preceeding-ordernr (get-localpointer-at-nthrhythm this-layer index (1- number-of-pitches-before-this-cell)))
                             (setf preceeding-ordernr 1)))
                       (setf rhythms (get-durations-from-vector this-layer preceeding-ordernr (1+ end-pointer)))

                       (setf pitches (get-pitches-for-localpointers-rhythm&pause this-layer index preceeding-ordernr end-pointer))

                       ;mark nonassigned and pauses with nil
                       (setf pitch-durs (loop for dur in rhythms
                                              for p in pitches
                                              collect (if (and dur p)
                                                          (list p dur)
                                                        nil)))

                       ;remove gracenotes
                       (setf pitch-durs (remove 'g (loop for pitch-dur in pitch-durs
                                                         collect (if (and pitch-dur (= (second pitch-dur) 0))
                                                                     'g
                                                                   pitch-dur
                                                                   ))))                                        
                       (setf int-dur-pairs (remove nil (loop for pitch-dur1 in pitch-durs
                                                             for pitch-dur2 in (cdr pitch-durs)
                                                             collect (if (and pitch-dur1 pitch-dur2)
                                                                         (list (- (first pitch-dur2) (first pitch-dur1)) 
                                                                               (second pitch-dur1))
                                                                       nil))))
                                                                   
                       (if int-dur-pairs
                           (eval (append '(and) (mapcar #'(lambda (int-dur-pair) 
                                                            (if (funcall testfn-duration (second int-dur-pair)) (funcall testfn-interval (abs (first int-dur-pair))) t))
                                                        int-dur-pairs)))
                         t))
                   t)
                 ))
    (t t)))
                     
          
;********
(defun mel-interval-for-gracenotes (index x testfn-duration testfn-interval)
  "Accepts any duration, but includes gracenotes as valid durations."
  (typecase x 
    (rhythmcell (let* ((this-layer (get-layer-nr x))
                       (number-of-events-before-this-cell (get-number-of-rhythms-and-pauses-at-index this-layer (1- index)))
                       (number-of-events-including-this-cell (get-number-of-rhythms-and-pauses-at-index this-layer index))
                       (this-rhythmcell (get-rhythmcell x))
                       (this-ordernrs (loop for n from (1+ number-of-events-before-this-cell) to number-of-events-including-this-cell
                                            collect n))
                       preceeding-duration
                       preceeding-ordernr
                       durations
                       ordernrs
                       ordernr-pairs
                       pitch-pairs)

                  (if (> number-of-events-before-this-cell 0)
                      (progn
                        (setf preceeding-duration (get-durations-from-vector this-layer number-of-events-before-this-cell (1+ number-of-events-before-this-cell)))
                        (setf preceeding-ordernr (list number-of-events-before-this-cell))))



                  (setf durations (append preceeding-duration this-rhythmcell))
                  (setf ordernrs (append preceeding-ordernr this-ordernrs))


                  ;mark rests
                  (setf durations (mapcar #'(lambda (dur1 dur2) (if (and (not (minusp dur1)) (not (minusp dur2))) dur1 nil)) durations (cdr durations)))
                  (setf ordernr-pairs (mapcar #'(lambda (dur nth nth+1) (if dur (list nth nth+1) nil)) durations ordernrs (cdr ordernrs)))


                  ;remove rests
                  (setf durations (remove nil durations))
                  (setf ordernr-pairs (remove nil ordernr-pairs))
                  

                  (setf pitch-pairs (mapcar #'(lambda (pair) (append (get-pitch-for-localpointer-rhythm&pause this-layer index (first pair))
                                                                     (get-pitch-for-localpointer-rhythm&pause this-layer index (second pair))))
                                            ordernr-pairs))

                  (if (car pitch-pairs)
                      (let ((intervals (mapcar #'(lambda (pair) (if (second pair) (- (second pair) (first pair)) nil)) pitch-pairs)))
                        (eval (append '(and) (mapcar #'(lambda (i d) 
                                                         (if i
                                                             (if (funcall testfn-duration d) (funcall testfn-interval (abs i)) t)
                                                           t))
                                                     intervals durations))))
                    t)
                  ))
    (pitchcell (let* ((this-layer (get-layer-nr x))
                      (number-of-pitches-before-this-cell (get-number-of-pitches-at-index this-layer (1- index)))
                      (number-of-pitches-including-this-cell (get-number-of-pitches-at-index this-layer index))
                      (number-of-durations-without-pauses-in-layer (get-number-of-rhythms-at-index this-layer index))
                      (number-of-durations-including-pauses-in-layer (get-number-of-rhythms-and-pauses-at-index this-layer index))
                      (this-pitchcell (get-pitchcell x))
                      this-rhythms
                      (this-ordernrs (loop for n from number-of-pitches-before-this-cell to (1- number-of-pitches-including-this-cell)
                                           collect n))
                      preceeding-ordernr
                      end-pointer
                      rhythms
                      durations
                      pitches
                      int-dur-pairs
                      pitch-durs
                      )

                 (if (and (>= number-of-durations-without-pauses-in-layer number-of-pitches-before-this-cell) (/= number-of-durations-without-pauses-in-layer 0))
                     (progn
                       (if (> number-of-pitches-before-this-cell 0)
                           (setf preceeding-ordernr (get-localpointer-at-nthrhythm this-layer index (1- number-of-pitches-before-this-cell)))
                         (setf preceeding-ordernr 1))

  
                       (setf end-pointer (get-localpointer-at-nthrhythm this-layer index (1- number-of-pitches-including-this-cell)));last-pitch
                       (if (not end-pointer) (setf end-pointer number-of-durations-including-pauses-in-layer)
                         (setf end-pointer (min end-pointer;last-pitch
                                                number-of-durations-including-pauses-in-layer)))
                     
                       (setf rhythms (get-durations-from-vector this-layer preceeding-ordernr (1+ end-pointer)))
                       (setf pitches (get-pitches-for-localpointers-rhythm&pause this-layer index preceeding-ordernr end-pointer))

                       (setf int-dur-pairs (remove nil (loop for dur in rhythms
                                                             for p1 in pitches
                                                             for p2 in (cdr pitches)
                                                             collect (if (and dur p1 p2)
                                                                         (list (- p2 p1) dur)
                                                                       nil))))
                                                                   
                       (if int-dur-pairs
                           (eval (append '(and) (mapcar #'(lambda (int-dur-pair) 
                                                            (if (funcall testfn-duration (second int-dur-pair)) (funcall testfn-interval (abs (first int-dur-pair))) t))
                                                        int-dur-pairs)))
                         t))
                   t)
                 ))
    (t t)))

;********

(defun mel-interval-for-dur-break-at-gracenotes (index x testfn-duration testfn-interval)
  (typecase x 
    (rhythmcell (let* ((this-layer (get-layer-nr x))
                       (number-of-events-before-this-cell (get-number-of-rhythms-and-pauses-at-index this-layer (1- index)))
                       (number-of-events-including-this-cell (get-number-of-rhythms-and-pauses-at-index this-layer index))
                       (this-rhythmcell (get-rhythmcell x))
                       (this-ordernrs (loop for n from (1+ number-of-events-before-this-cell) to number-of-events-including-this-cell
                                            collect n))
                       preceeding-duration
                       preceeding-ordernr
                       durations
                       ordernrs
                       ordernr-pairs
                       pitch-pairs)

                  (if (> number-of-events-before-this-cell 0)
                      (progn
                        (setf preceeding-duration (get-durations-from-vector this-layer number-of-events-before-this-cell (1+ number-of-events-before-this-cell)))
                        (setf preceeding-ordernr (list number-of-events-before-this-cell))))



                  (setf durations (append preceeding-duration this-rhythmcell))
                  (setf ordernrs (append preceeding-ordernr this-ordernrs))


                  ;mark rests and gracenotes
                  (setf durations (mapcar #'(lambda (dur1 dur2) (if (and (plusp dur1) (plusp dur2)) dur1 nil)) durations (cdr durations)))
                  (setf ordernr-pairs (mapcar #'(lambda (dur nth nth+1) (if dur (list nth nth+1) nil)) durations ordernrs (cdr ordernrs)))


                  ;remove rests
                  (setf durations (remove nil durations))
                  (setf ordernr-pairs (remove nil ordernr-pairs))
                  

                  (setf pitch-pairs (mapcar #'(lambda (pair) (append (get-pitch-for-localpointer-rhythm&pause this-layer index (first pair))
                                                                     (get-pitch-for-localpointer-rhythm&pause this-layer index (second pair))))
                                            ordernr-pairs))
                  ;(system::pwgl-print pitch-pairs)

                  (if (car pitch-pairs)
                      (let ((intervals (mapcar #'(lambda (pair) (if (second pair) (- (second pair) (first pair)) nil)) pitch-pairs)))
                        (eval (append '(and) (mapcar #'(lambda (i d) 
                                                         (if i
                                                             (if (funcall testfn-duration d) (funcall testfn-interval (abs i)) t)
                                                           t))
                                                     intervals durations))))
                    t)
                  ))
    (pitchcell (let* ((this-layer (get-layer-nr x))
                      (number-of-pitches-before-this-cell (get-number-of-pitches-at-index this-layer (1- index)))
                      (number-of-pitches-including-this-cell (get-number-of-pitches-at-index this-layer index))
                      (number-of-durations-without-pauses-in-layer (get-number-of-rhythms-at-index this-layer index))
                      (number-of-durations-including-pauses-in-layer (get-number-of-rhythms-and-pauses-at-index this-layer index))
                      (this-pitchcell (get-pitchcell x))
                      this-rhythms
                      (this-ordernrs (loop for n from number-of-pitches-before-this-cell to (1- number-of-pitches-including-this-cell)
                                           collect n))
                      preceeding-ordernr
                      end-pointer
                      rhythms
                      durations
                      pitches
                      int-dur-pairs
                      pitch-durs
                      )

                 (if (and (>= number-of-durations-without-pauses-in-layer number-of-pitches-before-this-cell) (/= number-of-durations-without-pauses-in-layer 0))
                     (progn
                       (if (> number-of-pitches-before-this-cell 0)
                           (setf preceeding-ordernr (get-localpointer-at-nthrhythm this-layer index (1- number-of-pitches-before-this-cell)))
                         (setf preceeding-ordernr 1))

  
                       (setf end-pointer (get-localpointer-at-nthrhythm this-layer index (1- number-of-pitches-including-this-cell)));last-pitch
                       (if (not end-pointer) (setf end-pointer number-of-durations-including-pauses-in-layer)
                         (setf end-pointer (min end-pointer;last-pitch
                                                number-of-durations-including-pauses-in-layer)))
                     
                       (setf rhythms (get-durations-from-vector this-layer preceeding-ordernr (1+ end-pointer)))
                       (setf pitches (get-pitches-for-localpointers-rhythm&pause this-layer index preceeding-ordernr end-pointer))
                       ;;now i have to remove gracenotes!!!!!!

                       (setf int-dur-pairs (remove nil (loop for dur1 in rhythms
                                                             for dur2 in (cdr rhythms)
                                                             for p1 in pitches
                                                             for p2 in (cdr pitches)
                                                             collect (if (and (and dur1 p1 p2) (/= 0 dur1) (if dur2 (/= 0 dur2) t))
                                                                         (list (- p2 p1) dur1)
                                                                       nil))))

                                                                   
                       (if int-dur-pairs
                           (eval (append '(and) (mapcar #'(lambda (int-dur-pair) 
                                                            (if (funcall testfn-duration (second int-dur-pair)) (funcall testfn-interval (abs (first int-dur-pair))) t))
                                                        int-dur-pairs)))
                         t))
                   t)
                 ))
    (t t)))


;;;*************** FROM RULES
;(defun testfunction-equal (chord-at-duration chord)
;  (equal chord-at-duration chord))
;
;(defun testfunction-member (chord-at-duration chords)
;  (if (member chord-at-duration chords :test 'equal) t nil))
;
;(defun testfunction-lowregister (chord-at-duration treshold)
;  (if (listp chord-at-duration)
;      (not (member treshold chord-at-duration :test '<=))
;    (> treshold chord-at-duration)))
;
;(defun testfunction-highregister (chord-at-duration treshold)
;  (if (listp chord-at-duration)
;      (not (member treshold chord-at-duration :test '>=))
;    (< treshold chord-at-duration)))
;
;(defun testfunction-exist (chord-at-duration pitch)
;  (if (listp chord-at-duration)
;      (if (member pitch chord-at-duration) t nil)
;    (= pitch chord-at-duration)))
;;;**********

(defun testfun-for-int (testfn testvalue)
  #'(lambda (x) (funcall testfn x testvalue)))

(defun testfun-for-dur (testfn testvalue)
  #'(lambda (x) (funcall testfn testvalue x)))

(defun rule-melodic-interval-for-duration (testfn-duration testfn-interval durs intervals layer-nr)
  (if (not (typep layer-nr 'list)) (setf layer-nr (list layer-nr)))
  (loop for n from 0 to (1- (length layer-nr))
        collect (let ((this-layer (nth n layer-nr)))
                  #'(lambda (indexx x) (if (= (get-layer-nr x) this-layer) (mel-interval-for-dur indexx x 
                                                                                                 (testfun-for-dur testfn-duration durs) 
                                                                                                 (testfun-for-int testfn-interval intervals))
                                         t)))))


(defun rule-melodic-interval-for-gracenotes (testfn-duration testfn-interval durs intervals layer-nr)
  (if (not (typep layer-nr 'list)) (setf layer-nr (list layer-nr)))
  (loop for n from 0 to (1- (length layer-nr))
        collect (let ((this-layer (nth n layer-nr)))
                  #'(lambda (indexx x) (if (= (get-layer-nr x) this-layer) (mel-interval-for-gracenotes indexx x 
                                                                                                        (testfun-for-dur testfn-duration durs) 
                                                                                                        (testfun-for-int testfn-interval intervals))
                                         t)))))

(defun rule-melodic-interval-for-dur-break-at-gracenotes (testfn-duration testfn-interval durs intervals layer-nr)
  (if (not (typep layer-nr 'list)) (setf layer-nr (list layer-nr)))
  (loop for n from 0 to (1- (length layer-nr))
        collect (let ((this-layer (nth n layer-nr)))
                  #'(lambda (indexx x) (if (= (get-layer-nr x) this-layer) (mel-interval-for-dur-break-at-gracenotes indexx x 
                                                                                                        (testfun-for-dur testfn-duration durs) 
                                                                                                        (testfun-for-int testfn-interval intervals))
                                         t)))))