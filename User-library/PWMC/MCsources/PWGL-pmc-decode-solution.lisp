(in-package MC)

;;;; PWGL functions below


(defun extra-pitches->PWGLtree (pitches tempo)
  (list (append (list :low 1 :metronome-value tempo :metronome-unit 1)
          (loop while pitches
                collect (if (numberp (car pitches))
                            (list 1 (list (list 1 :notes (list (list (pop pitches) :color *extra-pitch-color*)))))
                          (list 1 (list (list 1 :notes
                                              (mapcar #'(lambda (this-pitch) (list this-pitch :color *extra-pitch-color*))
                                                          (pop pitches)))))))
          (list :color *extra-pitchmeasure-color*))))



(defun last-pmcsolution-to-PWGLtree ()
  (let ((solutionlist (pmc-solutionlists-from-vectors 1)))
    (solutionlists-to-PWGLtree solutionlist)))
    

(defun solutionlists-to-PWGLtree (solutionlist supply-measures? tempo)
  (let* ((timesigns (pop solutionlist))
         (tot-length-measures 0)
         (extra-measures 0))
    (if (equal timesigns '(nil)) (setf timesigns nil) 
      (setf tot-length-measures (apply '+ (mapcar #'(lambda (timesign) (apply '/ timesign)) timesigns))))


;filter out empty staves after last used staff
    (setf solutionlist (reverse solutionlist))
    (loop for x in solutionlist
          while (equal x '(nil nil))
          do (pop solutionlist))
    (setf solutionlist (reverse solutionlist))
;;;
    
    (loop while solutionlist
          collect (let* ((this-voice-solutionlist (pop solutionlist))
                         (rhythm-seq (car this-voice-solutionlist))
                         (pitch-seq (cadr this-voice-solutionlist))
                         (tot-length-rhythmseq (apply '+ (mapcar 'abs rhythm-seq)))
                                  
                         (no-revents-without-pause (length (remove 0 rhythm-seq :test #'(lambda (x y) (> x y)))))
                         (no-pevents (length pitch-seq))) 
                    (if (and (< tot-length-measures tot-length-rhythmseq) supply-measures?)
                        (progn (setf extra-measures (- tot-length-rhythmseq tot-length-measures))
                          (if (/= (truncate extra-measures) extra-measures)
                              (setf extra-measures (1+ (truncate extra-measures))))
                          (setf timesigns (append timesigns (make-list extra-measures :initial-element '(4 4))))
                          ))
                    (if (> no-pevents no-revents-without-pause)
                        (list (append 
                               (simple->tree-one-layer rhythm-seq pitch-seq timesigns extra-measures tempo)
                               (extra-pitches->PWGLtree (last pitch-seq (- no-pevents no-revents-without-pause)) tempo)))
                      (list
                       (simple->tree-one-layer rhythm-seq pitch-seq timesigns extra-measures tempo)
                       ))
                      
                      )
            )))


(defun decode-pmc2 (solution tempo pitch? rhythm? measure?)
    "decode-pmc"
  (let ((solutionlist (pmc-solutionlists-from-vectors solution)))
    (if solutionlist
        (progn
          (setf measure? (if (equal measure? "full sequence") t nil))
          (if (or (equal pitch? "pitch w. rhythm")
                  (equal rhythm? "rhythm w. pitch"))

              (solutionlists-to-PWGLtree 
               (append (list (pop solutionlist))
                       (loop while solutionlist
                             collect (let* ((this-solutionlist (pop solutionlist))
                                            (rhythm-seq (car this-solutionlist))
                                            (pitch-seq (cadr this-solutionlist)))
   
                                       (if (and (equal pitch? "pitch w. rhythm")
                                                (collect-overflow-pitch rhythm-seq pitch-seq))
                                           (progn (system::pwgl-print "Pitchevents without corresponding rhythmevent truncated: ")
                                             (system::pwgl-print (collect-overflow-pitch rhythm-seq pitch-seq))
                                             (setf pitch-seq (remove-overflow-pitch rhythm-seq pitch-seq))))
                                       (if (and (equal rhythm? "rhythm w. pitch")
                                                (collect-overflow-rhythm rhythm-seq pitch-seq))
                                           (progn (system::pwgl-print "Rhythmevents without corresponding pitch truncated: ")
                                             (system::pwgl-print (collect-overflow-rhythm rhythm-seq pitch-seq))
                                             (setf rhythm-seq (remove-overflow-rhythm rhythm-seq pitch-seq))
                                             ))
                                       (list rhythm-seq pitch-seq))))
               measure? tempo)

            (solutionlists-to-PWGLtree solutionlist measure? tempo))
          ))))


;;;new march 08
(defun filter-pmc-solutionlist (solutionlist exclude)
  (let ((filtered-solutionlist nil))
    (loop for n from 0 to (1- (length solutionlist))
          do (if (not (member (1- n) exclude))
                 (setf filtered-solutionlist (append filtered-solutionlist (list (nth n solutionlist))))))
    filtered-solutionlist))


(defun decode-pmc3 (solution tempo pitch? rhythm? measure? exclude)
    "decode-pmc. exclude is a list of layernrs that should be removed rom the solution; 0 refers to layernr 0, i.e. the 2nd element of solutionlist, etc.
The decoded solution is not passed via the variable solution, but is picked from the vectors by pmc-solutionlists-from-vectors."
  (let ((solutionlist (pmc-solutionlists-from-vectors solution)))
    (setf solutionlist (filter-pmc-solutionlist solutionlist exclude))
    (if solutionlist
        (progn
          (setf measure? (if (equal measure? "full sequence") t nil))
          (if (or (equal pitch? "pitch w. rhythm")
                  (equal rhythm? "rhythm w. pitch"))

              (solutionlists-to-PWGLtree 
               (append (list (pop solutionlist))
                       (loop while solutionlist
                             collect (let* ((this-solutionlist (pop solutionlist))
                                            (rhythm-seq (car this-solutionlist))
                                            (pitch-seq (cadr this-solutionlist)))
   
                                       (if (and (equal pitch? "pitch w. rhythm")
                                                (collect-overflow-pitch rhythm-seq pitch-seq))
                                           (progn (system::pwgl-print "Pitchevents without corresponding rhythmevent truncated: ")
                                             (system::pwgl-print (collect-overflow-pitch rhythm-seq pitch-seq))
                                             (setf pitch-seq (remove-overflow-pitch rhythm-seq pitch-seq))))
                                       (if (and (equal rhythm? "rhythm w. pitch")
                                                (collect-overflow-rhythm rhythm-seq pitch-seq))
                                           (progn (system::pwgl-print "Rhythmevents without corresponding pitch truncated: ")
                                             (system::pwgl-print (collect-overflow-rhythm rhythm-seq pitch-seq))
                                             (setf rhythm-seq (remove-overflow-rhythm rhythm-seq pitch-seq))
                                             ))
                                       (list rhythm-seq pitch-seq))))
               measure? tempo)

            (solutionlists-to-PWGLtree solutionlist measure? tempo))
          ))))


;see further advanced_scoreboxes.lisp



;;;not used
(defun solutionlists-without-timesigns-to-PWGLtree (solutionlist)
  (let ((timesigns (pop solutionlist)))
    (loop while solutionlist
          collect (let* ((this-voice-solutionlist (pop solutionlist))
                         (rhythm-seq (car this-voice-solutionlist))
                         (pitch-seq (cadr this-voice-solutionlist))
                         (tot-length-rhythmseq (apply '+ (mapcar 'abs rhythm-seq)))
                         (tot-length-measures (if (= (truncate tot-length-rhythmseq) tot-length-rhythmseq)
                                                  tot-length-rhythmseq
                                                (1+ (truncate tot-length-rhythmseq))))
                         (no-revents-without-pause (length (remove 0 rhythm-seq :test #'(lambda (x y) (> x y)))))
                         (no-pevents (length pitch-seq))) 
                    (if (> no-pevents no-revents-without-pause)
                        (list (append 
                               (simple->tree-one-layer rhythm-seq pitch-seq (make-list tot-length-measures :initial-element '(4 4)) 0)
                               (extra-pitches->PWGLtree (last pitch-seq (- no-pevents no-revents-without-pause)))))
                      (list
                       (simple->tree-one-layer rhythm-seq pitch-seq (make-list tot-length-measures :initial-element '(4 4)) 0)
                       ))
            ))))




;;;not used
(defun solutionlists-to-PWGLtree2 (solutionlist)
  (let ((timesigns (pop solutionlist)))
    (if (equal timesigns '(nil)) (setf timesigns nil))
    (loop while solutionlist
          collect (let* ((this-voice-solutionlist (pop solutionlist))
                         (rhythm-seq (car this-voice-solutionlist))
                         (pitch-seq (cadr this-voice-solutionlist))                   
                         (no-revents-without-pause (length (remove 0 rhythm-seq :test #'(lambda (x y) (> x y)))))
                         (no-pevents (length pitch-seq))) 
                    (if (> no-pevents no-revents-without-pause)
                        (list (append 
                               (simple->tree-one-layer rhythm-seq pitch-seq timesigns 60)
                               (extra-pitches->PWGLtree (last pitch-seq (- no-pevents no-revents-without-pause)))))
                      (list
                       (simple->tree-one-layer rhythm-seq pitch-seq timesigns 60)
                       ))
            ))))