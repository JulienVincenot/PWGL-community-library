(in-package MC)

;;;RULES INTERFACE
; all rules HAS to be in ONE and-statement to make sure engine updates vectors correctly for the local check
; If not, the pmc engine will first check the first rule, then the second, etc. vectors will not be correct
; in this way.

(defun first-pitch? (x indexx)
  "True if there are no pitches in the layer before the object"  
  (= 0 (get-number-of-pitches-at-index (get-layer-nr x) (1- indexx))))
;(get-number-of-pitches-at-index 0 2)

(defun rule-no-start-with-pitch-motif ()  ;THIS HAS TO BE THE SECOND RULE!!! FIRST PREVIOUS OBJECT HAS TO BE PUT IN VECTORS
                                            ;THEN THIS RULE HAS TO PUT PITCHES ON THE MOTIF. LAST THIS CELL HAS TO BE PUT IN VECTORS
  '(if (typep ?1 'pitchmotifcell)
       (if (first-pitch? ?1 (system::cur-index)) nil t)
     t))


;rules-to-pmc has to get a flat list of functions. The PWGL/OM function will do this.
(defun rules-to-pmc (rules)
  (let ((rulelist (append '(and) 
                          (list (rule-put-previous-object) ; this has to be first (bugfix July 07)
                                (rule-no-start-with-pitch-motif)
                                (rule-put-this-object))
                          (read-from-string "((mc::debugger-put-last-candidate (1- (CUR-INDEX)) (SECOND RL)))") ;see MCdebug.lisp for debug functions
                          (loop for rulex from 0 to (1- (length rules))
                                collect (list 'funcall (nth rulex rules) '(system::cur-index) '?1))
                          )))

    (clear-all-debug-vector) ;clear debug vectors before running pmc again
    (list 'system::* '?1
          (list 'system::?if rulelist))))

;;;RULES-STRATEGIES
;;PITCHCELL - MOTIFS

(defun rule-only-motifs (layer-nr)
  "The rule allows the first pitch to be a pitchcell, no others. Layer-nr may be a list of layers."
  (if (not (typep layer-nr 'list)) (setf layer-nr (list layer-nr)))
  (loop for n from 0 to (1- (length layer-nr))
        collect (let ((this-layer (nth n layer-nr)))
        #'(lambda (indexx x) (if (and (typep x 'pitchcell) (not (typep x 'pitchmotifcell)) (= (get-layer-nr x) this-layer))
                                 (first-pitch? x indexx)
                               t)))))

(defun rule-only-motifs-with-exception (layer-nr list-allowed-exceptions)
  "The rule allows the first pitch to be a pitchcell, no others. Layer-nr may be a list of layers."
  (if (not (typep layer-nr 'list)) (setf layer-nr (list layer-nr)))
  (loop for n from 0 to (1- (length layer-nr))
        collect (let ((this-layer (nth n layer-nr)))
        #'(lambda (indexx x) (if (and (typep x 'pitchcell) (not (typep x 'pitchmotifcell)) (= (get-layer-nr x) this-layer))
                                 (or (first-pitch? x indexx) (member (car (get-pitchcell x))  list-allowed-exceptions :test 'equal))
                               t)))))


(defun heuristic-rule-only-motifs (layer-nr)
  "The rule allows the first pitch to be a pitchcell, no others. Layer-nr may be a list of layers."
  (if (not (typep layer-nr 'list)) (setf layer-nr (list layer-nr)))
  (loop for n from 0 to (1- (length layer-nr))
        collect (let ((this-layer (nth n layer-nr)))
                  #'(lambda (indexx x) (if (and (typep x 'pitchcell)  (= (get-layer-nr x) this-layer))
                                           (if (first-pitch? x indexx) 
                                               (if (typep x 'pitchmotifcell) 0 1)
                                             (if (typep x 'pitchmotifcell) 1 0))
                                         0)))))

;;;RULES-STRATEGIES
;;PITCH - RHYTHM

(defun pitch-rhythm-eq-length (index this-object layer)
  (let ((nr-of-rhythms (get-number-of-rhythms-at-index layer (1- index)))
        (nr-of-pitches (get-number-of-pitches-at-index layer (1- index))))
    
  (typecase this-object 
    (rhythmcell (<= nr-of-rhythms nr-of-pitches))
    (pitchcell (>= nr-of-rhythms nr-of-pitches))
    (t t))))


(defun pitch-rhythm-eq-length-rule (layer)
  (if (not (typep layer 'list)) (setf layer (list layer)))
  (loop for n from 0 to (1- (length layer))
        
        collect (let ((this-layer (nth n layer)))
                  #'(lambda (indexx x) (if (= (get-layer-nr x) this-layer)
                                           (pitch-rhythm-eq-length indexx x this-layer)
                                         t)))))

;;;

(defun pitch-before-rhythm-eq-length (index this-object layer offset)
  (let ((nr-of-rhythms (get-number-of-rhythms-at-index layer (1- index)))
        (nr-of-pitches (get-number-of-pitches-at-index layer (1- index))))
    
  (typecase this-object 
    (rhythmcell (< nr-of-rhythms (- nr-of-pitches offset)))
    (pitchcell (>= nr-of-rhythms (- nr-of-pitches offset)))
    (t t))))


(defun pitch-before-rhythm-eq-length-rule (layer offset)
  (if (not (typep layer 'list)) (setf layer (list layer)))
  (loop for n from 0 to (1- (length layer))
        collect (let ((this-layer (nth n layer)))
                  #'(lambda (indexx x) (if (= (get-layer-nr x) this-layer) 
                                           (pitch-before-rhythm-eq-length indexx x this-layer offset)
                                         t)))))



;;;

(defun rhythm-before-pitch-eq-length (index this-object layer offset)
  (let ((nr-of-rhythms (get-number-of-rhythms-at-index layer (1- index)))
        (nr-of-pitches (get-number-of-pitches-at-index layer (1- index))))
    
  (typecase this-object 
    (rhythmcell (<= (- nr-of-rhythms offset) nr-of-pitches))
    (pitchcell (> (- nr-of-rhythms offset) nr-of-pitches))
    (t t))))


(defun rhythm-before-pitch-eq-length-rule (layer offset)
  (if (not (typep layer 'list)) (setf layer (list layer)))
  (loop for n from 0 to (1- (length layer))
        collect (let ((this-layer (nth n layer)))
                  #'(lambda (indexx x) (if (= (get-layer-nr x) this-layer) 
                                           (rhythm-before-pitch-eq-length indexx x this-layer offset)
                                         t)))))



;;BARLINES - RHYTHM

(defun measures-rhythm-eq-length (index this-object layer)
  (let ((tot-duration-rhythms (get-total-duration-rhythms-at-index layer (1- index)))
        (tot-duration-measures (get-total-duration-timesigns-at-index (1- index))))
    
  (typecase this-object 
    (rhythmcell (<= tot-duration-rhythms tot-duration-measures))
    (timesign (>= tot-duration-rhythms tot-duration-measures))
    (t t))))

(defun measures-rhythm-eq-length-rule (layer)
  (if (not (typep layer 'list)) (setf layer (list layer)))
  (loop for n from 0 to (1- (length layer))
        collect (let ((this-layer (nth n layer)))
                  #'(lambda (indexx x) (if (or (= (get-layer-nr x) this-layer) (= (get-layer-nr x) *TIMESIGNLAYER*))
                                           (measures-rhythm-eq-length indexx x this-layer)
                                         t)))))

;;;

(defun measures-before-rhythm-eq-length (index this-object layer offset)
  (let ((tot-duration-rhythms (get-total-duration-rhythms-at-index layer (1- index)))
        (tot-duration-measures (get-total-duration-timesigns-at-index (1- index)))) 
    
  (typecase this-object 
    (rhythmcell (< tot-duration-rhythms (- tot-duration-measures offset)))
    (timesign (>= tot-duration-rhythms (- tot-duration-measures offset)))
    (t t))))


(defun measures-before-rhythm-eq-length-rule (layer offset)
  (if (not (typep layer 'list)) (setf layer (list layer)))
  (loop for n from 0 to (1- (length layer))
        collect (let ((this-layer (nth n layer)))
                  #'(lambda (indexx x) (if (or (= (get-layer-nr x) this-layer) (= (get-layer-nr x) *TIMESIGNLAYER*)) 
                                           (measures-before-rhythm-eq-length indexx x this-layer offset)
                                         t)))))

;;;

(defun rhythm-before-measures-eq-length (index this-object layer offset)
  (let ((tot-duration-rhythms (get-total-duration-rhythms-at-index layer (1- index)))
        (tot-duration-measures (get-total-duration-timesigns-at-index (1- index)))) 
    
  (typecase this-object 
    (rhythmcell (<= (- tot-duration-rhythms offset) tot-duration-measures))
    (timesign (> (- tot-duration-rhythms offset) tot-duration-measures))
    (t t))))

(defun rhythm-before-measures-eq-length-rule (layer offset)
  (if (not (typep layer 'list)) (setf layer (list layer)))
  (loop for n from 0 to (1- (length layer))
        collect (let ((this-layer (nth n layer)))
                  #'(lambda (indexx x) (if (or (= (get-layer-nr x) this-layer) (= (get-layer-nr x) *TIMESIGNLAYER*)) 
                                           (rhythm-before-measures-eq-length indexx x this-layer offset)
                                         t)))))


;;RHYTHM BETWEEN LAYERS

(defun rhythm-rhythm-eq-length (index this-object layer1 layer2)
  (let ((tot-duration-rhythm1 (get-total-duration-rhythms-at-index layer1 (1- index)))
        (tot-duration-rhythm2 (get-total-duration-rhythms-at-index layer2 (1- index)))
        (this-layernr (get-layer-nr this-object)))
    
  (cond ((= this-layernr layer1) (<= tot-duration-rhythm1 tot-duration-rhythm2))
        ((= this-layernr layer2) (>= tot-duration-rhythm1 tot-duration-rhythm2))
        (t t))))


(defun rhythm-rhythm-eq-length-rule (layer1 layer2)
  #'(lambda (indexx x) (if (typep x 'rhythmcell) 
                           (rhythm-rhythm-eq-length indexx x layer1 layer2)
                         t)))




(defun rhythm-before-rhythm-eq-length (index this-object layer1 layer2 offset)
  (let ((tot-duration-rhythm1 (get-total-duration-rhythms-at-index layer1 (1- index)))
        (tot-duration-rhythm2 (get-total-duration-rhythms-at-index layer2 (1- index)))
        (this-layernr (get-layer-nr this-object)))
    
  (cond ((= this-layernr layer1) (<= (- tot-duration-rhythm1 offset) tot-duration-rhythm2))
        ((= this-layernr layer2) (> (- tot-duration-rhythm1 offset) tot-duration-rhythm2))
        (t t))))


(defun rhythm-before-rhythm-eq-length-rule (layer1 layer2 offset)
  #'(lambda (indexx x) (if (typep x 'rhythmcell) 
                           (rhythm-before-rhythm-eq-length indexx x layer1 layer2 offset)
                         t)))

;;PITCH BETWEEN LAYERS

(defun pitch-pitch-eq-length (index this-object layer1 layer2)
  (let ((nr-of-pitches1 (get-number-of-pitches-at-index layer1 (1- index)))
        (nr-of-pitches2 (get-number-of-pitches-at-index layer2 (1- index)))
        (this-layernr (get-layer-nr this-object)))
    
  (cond ((= this-layernr layer1) (>= nr-of-pitches2 nr-of-pitches1))
        ((= this-layernr layer2) (>= nr-of-pitches1 nr-of-pitches2))
        (t t))))

(defun pitch-pitch-eq-length-rule (layer1 layer2)
  #'(lambda (indexx x) (if (typep x 'pitchcell) 
                           (pitch-pitch-eq-length indexx x layer1 layer2)
                         t)))

(defun pitch-before-pitch-eq-length (index this-object layer1 layer2 offset)
  (let ((nr-of-pitches1 (get-number-of-pitches-at-index layer1 (1- index)))
        (nr-of-pitches2 (get-number-of-pitches-at-index layer2 (1- index)))
        (this-layernr (get-layer-nr this-object)))
    
    (cond ((= this-layernr layer1) (<= (- nr-of-pitches1 offset) nr-of-pitches2))
          ((= this-layernr layer2) (> (- nr-of-pitches1 offset) nr-of-pitches2))
          (t t))))

(defun pitch-before-pitch-eq-length-rule (layer1 layer2 offset)
  #'(lambda (indexx x) (if (typep x 'pitchcell) 
                           (pitch-before-pitch-eq-length indexx x layer1 layer2 offset)
                         t)))