(in-package mc)

(defun contrasts-lev.1 (sequence)
  "The Analysis of the Contrasts, formulated by Hervé Riviére  and Frederic Voisin, and implemented in the OpenMusic Morphologie Library, is a model able to describe the becoming of the form in the time.
It points out the hierarchic relation created by the temporal sequence of the events: in fact, for  the mnemonic activity, each event is datum point for every following event and datum point for the previous ones.
The numerical transcription carried out through the Analysis of Contrasts describes the entry order of the events in the time.
We could define the numerical transcription created using the analysis of contrasts as morphological structure of the entry order of the events.
From this starting point it is possible to identify the presence of internal patterns and analyse their potential capacity to describe and re-establish the form in its original status.

exemple: Contrasts-lev.1 (a d f g f) ------> (1 2 3 4 3)
"

  (let ((elements (remove-duplicates sequence :from-end t)))
    (mapcar #'(lambda (x) (1+ (position x elements))) sequence)))


(defun contrasts-all-lev (sequence)

  "The Analysis of the Contrasts, formulated by Hervé Riviére  and Frederic Voisin, and implemented in the OpenMusic Morphologie Library, is a model able to describe the becoming of the form in the time.
It points out the hierarchic relation created by the temporal sequence of the events: in fact, for  the mnemonic activity, each event is datum point for every following event and datum point for the previous ones.
The numerical transcription carried out through the Analysis of Contrasts describes the entry order of the events in the time.
We could define the numerical transcription created using the analysis of contrasts as morphological structure of the entry order of the events.
From this starting point it is possible to identify the presence of internal patterns and analyse their potential capacity to describe and re-establish the form in its original status.

exemple: Contrasts-all-lev (a d f g f) ------> ((1 2 3 4 3) (1 2 3 2) (1 2 1) (1 2))"

  (mapcon #'(lambda (list) (list (contrasts-lev.1 list))) sequence))



(defun new-old-analysis (sequence)
  "The analysis of contrasts, which is the function at heart of the Morphologie Library developed by Jacopo Baboni Schilingi and Frederic Voisin, identifies the occurrences within any sequence of events.
Such analysis is of quantitative type, and has considerable development potentialities towards a qualitative description of the processes that put in relation morphologic structure of the message, mnemonic–perceptive activity and psychic response.
The hierarchies that the analysis of contrasts describes become qualitatively pertinent to the mnemonic activity.
We have called New/Old Analysis the function that describes the newness level of an event in relation to the context in which it appears.
The importance of such a function is crucial, because it describes from the point of view of the psychic response the different newness level of the single event in the time.
The steps to define New/Old Analysis are three:

1. Measurement of the distances:
it allows to quantify the local distance between the different events in relation to their first appearance in the time.

\(defun distances (sequence)
  (mapcar #' (lambda (x) (x->dx x)) (Contrasts-all-lev sequence)))

2. Attribution of different weights to the datum points:
this step is crucial, because it strengthens the global hierarchy among the various analysis level in relation to the time parameter.

\(defun weights (sequence)
  (mapcar #' (lambda (x) (apply '+ x))
          (Contrasts-all-lev sequence)))

3. Application of weights to the distances:
this  further  step  is  just  the application of different weights - obtained considering every time one of the events as datum point (global parameter, ex. nr. 3) 
- to the distances between the various contiguous events (local parameter). 

\(defun Contrasts-lev.1*weights (sequence)
  (mapcar #' (lambda (x y) (om* y x))
          (distances sequence) (weights sequence)))

;--------

\(defun Contrasts-all-lev*weights (sequence)
  (reverse (mapcar #' (lambda (xx) (apply '+ xx))
          (mat-trans (mapcar #' (lambda (x) (reverse x)) (Contrasts-lev.1*weights sequence))))))

A theoretical problem we have faced is the relation between the object we have analysed and the previous and following events.
Any events chain perceived as belonging to a whole and complete organism stays anyway in relation with the previous and following sequential chain.
In case of performance of a music piece, the silence acts as a frame of the structure,  and, being a frame, it becomes organic element of the structure analysed.
It is worth to underline that even in case of extrapolation, like in the here quoted examples (a thematic fragment, a subject of a fugue, etc.),
the object is perceived as an unit, and therefore the silence places it in a well defined mental space.

\(x-append 'symbol-silence-start sequence 'symbol-silence-end)
"

  (let* ((sequence-whit-silence-start-end (append '(symbol-silence-start) sequence '(symbol-silence-end)))
         (contrasts-all-lev (contrasts-all-lev sequence-whit-silence-start-end))
	 (distances (mapcar #'(lambda (contr) (my-x->dx contr)) contrasts-all-lev))
	 (weights (mapcar #'(lambda (x) (apply '+ x)) contrasts-all-lev))

	 (distances*weights
	  (loop for dist in distances
                for weight in weights
                collect (mapcar #'(lambda (d) (* d weight)) dist)))

         (reverse-distances*weights (mapcar 'reverse distances*weights))

	 (contrasts-all-lev*weights
	  (loop for n from (1- (length (car reverse-distances*weights))) downto 1
                         collect (apply '+ (remove nil (mapcar #'(lambda (x) (nth n x)) reverse-distances*weights))))))
    
    contrasts-all-lev*weights))


(defun my-x->dx (list)
  (loop for x in list
        for y in (cdr list) 
        collect (- y x)))


(defun energy-prof-morph-analysis (sequence)
            "The step that allows to transform the New/Old Analysis function into a model able to simulate the psychic response of the perceptive act to the morphologic structure occurs using three functions.
Then, to this the three functions apply allowing to define the energy profile.
1. In the first passage, the transformation into absolute abs value contains all the relations with reference to the first element of the chain.
At this point, the data don't represent the ageing degree of the events anymore, but they are mere distance (it doesn't matter if they are old or new, they are to be intended nearly as physical distance between the various data stored  in space/memory) related to a virtual point zero (a kind of possible present)
2. In the second passage, the use of the local derivative, implemented in OpenMusic under the name of x-->dx, the contiguous relations are again pointed out, and the distance identified in the first  passage is assimilated to the energy needed to cover the contiguous distances in the space/memory
3 - Finally, the transformation into absolute  abs  value,  because  of  the transformation of the distances into energy, brings all the data back to positive values.
"
            (let* ((analysis-old-new (cons '0 (new-old-analysis sequence))))
              (loop for x in analysis-old-new
                    for y in (cdr analysis-old-new) 
                    collect (abs (- (abs y) (abs x))))
              ))




;;;;
(defun start-section-new-old (section weights-from-analysis)
  "This function does a new/old analysis of a sequence but uses weigths from another analysis. The idea is to let the weights 
from a pre-existing analysis influence the result in order to search for a sequence matching the pre-existing old/new analysis.
Last value will be included even though an ending pause is not added (see theory) - this extra pause would only affects the weights.
IMPORTANT:The number of weights has to be more or equal to the number of distances (i.e. elements in seq + 1)"
  (let* ((sequence-whit-silence-start (append '(symbol-silence-start) section))
         (contrasts-all-lev (contrasts-all-lev sequence-whit-silence-start))
         (distances (mapcar #'(lambda (contr) (my-x->dx contr)) contrasts-all-lev))
         (distances*weights
	   (loop for dist in distances
                       for weight in weights-from-analysis
                       collect (mapcar #'(lambda (d) (* d weight)) dist))) ; if weights-from-analysis are less than found values, the analysis wil be wrong
         (reverse-distances*weights (mapcar 'reverse distances*weights))
         (contrasts-all-lev*weights
	  (loop for n from (1- (length (car reverse-distances*weights))) downto 0 ; downto 0 (and not downto 1) will include last value as well
                collect (apply '+ (remove nil (mapcar #'(lambda (x) (nth n x)) reverse-distances*weights))))))
    contrasts-all-lev*weights))

;(start-section-new-old '(1 2 3 4 5 6) '(10 100 1000))

(defun weights-from-new-old (seq)
  (let* ((sequence-whit-silence-start-end (append '(symbol-silence-start) seq '(symbol-silence-end)))
         (contrasts-all-lev (contrasts-all-lev sequence-whit-silence-start-end))
	 (distances (mapcar #'(lambda (contr) (my-x->dx contr)) contrasts-all-lev))
	 (weights (mapcar #'(lambda (x) (apply '+ x)) contrasts-all-lev)))
    weights))


(defun compare-analysis (new-analysis reference-analysis tolerance%)
  "Simply compares two list of values and returns true if they do not deviate more than the tolerance (0 = exact match, 0.5 = +/- 50 %).
IMPORTANT: new-analysis can not be longer than reference-analysis (this will generate a wrong answer).
New-analysis may be shorter than reference-analysis."
  (loop for new in new-analysis
        for ref in reference-analysis
        do (if (= ref 0) (progn (setf ref 0.01) (setf new (+ new 0.01)))) ; to avoid division by zero
        until (> (abs (1- (/ new ref))) tolerance%)
        finally  (return (<= (abs (1- (/ new ref))) tolerance%))
        ))


(defun combined-analysis (section ref-weights ref-analysis length-ref-analysis)
"Since length of re-analysis is known, this is calculated outside the search."
  (let* ((section-length (length section))
         (length-remaining-from-ref-seq (- length-ref-analysis section-length)))
    (if (plusp length-remaining-from-ref-seq)
        (append (start-section-new-old section ref-weights)
                (last ref-analysis length-remaining-from-ref-seq))
      (start-section-new-old (nbutlast section (- length-remaining-from-ref-seq)) ref-weights))));;;;;;; nbutlast to allow free values after analysis end


;;;The rule is not optimized to on check the new pitches - it rechecks from the beginning of the sequence
(defun new-old-rule (layer reference-sequence deviation%)
  (let* ((ref-analysis (new-old-analysis reference-sequence))
         (ref-weights (weights-from-new-old reference-sequence))
         (length-ref-analysis (length ref-analysis)))
  #'(lambda (indexx x) (if (= (get-layer-nr x) layer)
                           (let* ((pitch-seq (get-pitches-upto-index layer indexx))
                                  (analysis (combined-analysis pitch-seq ref-weights ref-analysis length-ref-analysis)))
                             ;(system::pwgl-print (list (nth (1- (length pitch-seq)) (compare-analysis2 analysis ref-analysis)) pitch-seq))
                             (compare-analysis analysis ref-analysis deviation%))
                         t))))

;;;;;;;;only rough tendency

(defun compare-analysis-+-0 (new-analysis reference-analysis)
  "Simply compares two list of values and returns true if they signs are the same (+ or - or 0).
IMPORTANT: new-analysis can not be longer than reference-analysis (this will generate a wrong answer)."
  (loop for new in new-analysis
        for ref in reference-analysis
        until (not (cond
                    ((plusp new) (plusp ref))
                    ((minusp new) (minusp ref))
                    ((= 0 new) (= 0 ref))))
        finally (return (cond
                    ((plusp new) (plusp ref))
                    ((minusp new) (minusp ref))
                    ((= 0 new) (= 0 ref))))
        ))


(defun new-old-rule+-0 (layer reference-sequence)
  (let* ((ref-analysis (new-old-analysis reference-sequence))
         (ref-weights (weights-from-new-old reference-sequence))
         (length-ref-analysis (length ref-analysis)))
    #'(lambda (indexx x) (if (= (get-layer-nr x) layer)
                             (let* ((pitch-seq (get-pitches-upto-index layer indexx))
                                    (analysis (combined-analysis pitch-seq ref-weights ref-analysis length-ref-analysis)))
                             
                               (compare-analysis-+-0 analysis ref-analysis))
                           t))))


;;;;;;Rule for energy profile

(defun energy-prof-from-new-old-analysis (new-old-analysis)
            (let* ((analysis-old-new (cons '0 new-old-analysis)))
              (loop for x in analysis-old-new
                    for y in (cdr analysis-old-new) 
                    collect (abs (- (abs y) (abs x))))
              ))


(defun compare-analysis-absolute-value (new-analysis reference-analysis deviation)
  "Simply compares two list of values and returns true if they do not deviate more than the tolerance (0 = exact match, 0.5 = +/- 50 %).
IMPORTANT: new-analysis can not be longer than reference-analysis (this will generate a wrong answer)."
  (loop for new in new-analysis
        for ref in reference-analysis 
        until (> (abs (- new ref)) deviation)
        finally  (return (<= (abs (- new ref)) deviation))
        ))


(defun pitch-energy-profile-rule (layer reference-sequence deviation%)
  "deviation% is deviation compared to max energy in profile"
  (let* ((length-ref-seq (length reference-sequence))
         (ref-new-old-analysis (new-old-analysis reference-sequence))
         (ref-weights (weights-from-new-old reference-sequence))
         (length-ref-new-old-analysis (length ref-new-old-analysis))
         (ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile)))
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                             (let ((pitch-seq (get-pitches-upto-index layer indexx)))
                               (if (<= (length pitch-seq) length-ref-seq)
                                   (let* ((new-old-analysis (combined-analysis pitch-seq ref-weights ref-new-old-analysis length-ref-new-old-analysis))
                                          (energy-profile (energy-prof-from-new-old-analysis new-old-analysis)))
                                     (compare-analysis-absolute-value energy-profile ref-energy-profile (* deviation% max-energy)))
                                 t))
                           t))))

;;;;This is an experiment September 2009
;  
(defun get-every-2nd (list)
  (loop for n from 0 to (/ (length list) 2)
        collect (nth (* 2 n) list)))

(defun double-every-2nd (list)
  (apply 'append
         (loop for x in list
               collect (list x x))))

(defun pitch-energy-profile-repeat-rule (layer reference-sequence deviation%)
  "deviation% is deviation compared to max energy in profile
This version will repeatdly apply the same energy-profie on
the new sequences."
  (let* ((length-ref-seq (length reference-sequence))
         (ref-new-old-analysis (new-old-analysis reference-sequence))
         (ref-weights (weights-from-new-old reference-sequence))
         (length-ref-new-old-analysis (length ref-new-old-analysis))
         (ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile)))
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                             (let ((pitch-seq (get-pitches-upto-index layer indexx)))
                               (eval (append '(and) 
                                             (loop for n from 0 to (1- (length pitch-seq)) by (1- length-ref-seq)  ;(1- length-ref-seq) will create overlaps in sequences by one element 
                                                   collect (let* ((pitch-subseq (filter-subseq n (1- (+ n length-ref-seq)) pitch-seq))
                                                                  (new-old-analysis (combined-analysis pitch-subseq ref-weights ref-new-old-analysis length-ref-new-old-analysis))
                                                                  (energy-profile (energy-prof-from-new-old-analysis new-old-analysis)))
                                                             (compare-analysis-absolute-value energy-profile ref-energy-profile (* deviation% max-energy)))
                                                   ))))
                           t))))


(defun pitch-energy-profile-segments-rule (layer reference-sequence1 seq1-repeat reference-sequence2 seq2-repeat deviation%)
  "deviation% is deviation compared to max energy in profile
This version will repeatdly apply the same energy-profie on
the new sequences."
  (let* ((length-ref-seq1 (length reference-sequence1))
         (ref1-new-old-analysis (new-old-analysis reference-sequence1))
         (ref1-weights (weights-from-new-old reference-sequence1))
         (length-ref1-new-old-analysis (length ref1-new-old-analysis))
         (ref1-energy-profile (energy-prof-morph-analysis reference-sequence1))
         (max-energy1 (apply 'max ref1-energy-profile))

         (length-ref-seq2 (length reference-sequence2))
         (ref2-new-old-analysis (new-old-analysis reference-sequence2))
         (ref2-weights (weights-from-new-old reference-sequence2))
         (length-ref2-new-old-analysis (length ref2-new-old-analysis))
         (ref2-energy-profile (energy-prof-morph-analysis reference-sequence2))
         (max-energy2 (apply 'max ref2-energy-profile)))

    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                             (let ((pitch-seq (get-pitches-upto-index layer indexx)))
                               (eval (append '(and) 
                                             (loop for n from 0 to (1- seq1-repeat) 
                                                   collect (let* ((pitch-subseq (filter-subseq (* n (1- length-ref-seq1)) (* (1+ n) (1- length-ref-seq1)) pitch-seq))
                                                                  (new-old-analysis (combined-analysis pitch-subseq ref1-weights ref1-new-old-analysis length-ref1-new-old-analysis))
                                                                  (energy-profile (energy-prof-from-new-old-analysis new-old-analysis)))
                                                             (compare-analysis-absolute-value energy-profile ref1-energy-profile (* deviation% max-energy1))))
                                             (loop for n from 0 to (1- seq2-repeat) 
                                                   collect (let* ((pitch-subseq (filter-subseq (+ (* seq1-repeat (1- length-ref-seq1)) (* n (1- length-ref-seq2)))
                                                                                               (+ (* seq1-repeat (1- length-ref-seq1)) (* (1+ n) (1- length-ref-seq2)) )
                                                                                               pitch-seq))
                                                                  (new-old-analysis (combined-analysis pitch-subseq ref2-weights ref2-new-old-analysis length-ref2-new-old-analysis))
                                                                  (energy-profile (energy-prof-from-new-old-analysis new-old-analysis)))
                                                             (compare-analysis-absolute-value energy-profile ref2-energy-profile (* deviation% max-energy1)))
                                                   ))))
                           t))))


(defun pitch-energy-profile-3segments-rule (layer reference-sequence1 seq1-repeat reference-sequence2 seq2-repeat reference-sequence3 seq3-repeat deviation%)
  "deviation% is deviation compared to max energy in profile
This version will repeatdly apply the same energy-profie on
the new sequences."
  (let* ((length-ref-seq1 (length reference-sequence1))
         (ref1-new-old-analysis (new-old-analysis reference-sequence1))
         (ref1-weights (weights-from-new-old reference-sequence1))
         (length-ref1-new-old-analysis (length ref1-new-old-analysis))
         (ref1-energy-profile (energy-prof-morph-analysis reference-sequence1))
         (max-energy1 (system::pwgl-print (apply 'max ref1-energy-profile)))

         (length-ref-seq2 (length reference-sequence2))
         (ref2-new-old-analysis (new-old-analysis reference-sequence2))
         (ref2-weights (weights-from-new-old reference-sequence2))
         (length-ref2-new-old-analysis (length ref2-new-old-analysis))
         (ref2-energy-profile (energy-prof-morph-analysis reference-sequence2))
         (max-energy2 (system::pwgl-print (apply 'max ref2-energy-profile)))

         (length-ref-seq3 (length reference-sequence3))
         (ref3-new-old-analysis (new-old-analysis reference-sequence3))
         (ref3-weights (weights-from-new-old reference-sequence3))
         (length-ref3-new-old-analysis (length ref3-new-old-analysis))
         (ref3-energy-profile (energy-prof-morph-analysis reference-sequence3))
         (max-energy3 (apply 'max ref3-energy-profile)))

    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                             (let ((pitch-seq (get-pitches-upto-index layer indexx)))
                               (eval (append '(and) 
                                             (loop for n from 0 to (1- seq1-repeat) 
                                                   collect (let* ((pitch-subseq (filter-subseq (* n (1- length-ref-seq1)) (* (1+ n) (1- length-ref-seq1)) pitch-seq))
                                                                  (new-old-analysis (combined-analysis pitch-subseq ref1-weights ref1-new-old-analysis length-ref1-new-old-analysis))
                                                                  (energy-profile (energy-prof-from-new-old-analysis new-old-analysis)))
                                                             (compare-analysis-absolute-value energy-profile ref1-energy-profile (* deviation% max-energy1))))
                                             (loop for n from 0 to (1- seq2-repeat) 
                                                   collect (let* ((pitch-subseq (filter-subseq (+ (* seq1-repeat (1- length-ref-seq1)) (* n (1- length-ref-seq2)))
                                                                                               (+ (* seq1-repeat (1- length-ref-seq1)) (* (1+ n) (1- length-ref-seq2)) )
                                                                                               pitch-seq))
                                                                  (new-old-analysis (combined-analysis pitch-subseq ref2-weights ref2-new-old-analysis length-ref2-new-old-analysis))
                                                                  (energy-profile (energy-prof-from-new-old-analysis new-old-analysis)))
                                                             (compare-analysis-absolute-value energy-profile ref2-energy-profile (* deviation% max-energy2)))
                                                   )
                                             (loop for n from 0 to (1- seq3-repeat) 
                                                   collect (let* ((pitch-subseq (filter-subseq (+ (* seq1-repeat (1- length-ref-seq1)) 
                                                                                                  (* seq2-repeat (1- length-ref-seq2))
                                                                                                  (* n (1- length-ref-seq3)))
                                                                                               (+ (* seq1-repeat (1- length-ref-seq1)) 
                                                                                                  (* seq2-repeat (1- length-ref-seq2))
                                                                                                  (* (1+ n) (1- length-ref-seq3)) )
                                                                                               pitch-seq))
                                                                  (new-old-analysis (combined-analysis pitch-subseq ref3-weights ref3-new-old-analysis length-ref3-new-old-analysis))
                                                                  (energy-profile (energy-prof-from-new-old-analysis new-old-analysis)))
                                                             (compare-analysis-absolute-value energy-profile ref3-energy-profile (* deviation% max-energy3)))
                                                   ))))
                           t))))


;(eval (append '(and) '(t t t)))
;(filter-subseq 8 10 '(0 1 2 3 4 5 6 7))
(defun filter-subseq (start stop list)
  "returns a subseq of list. If stop is larger than the length of the list, stop will be the last value."
  (remove nil
          (loop for n from start to stop
                collect (nth n list))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun rhythm-energy-profile-rule (layer reference-sequence deviation%)
  "deviation% is deviation compared to max energy in profile"
  (let* ((length-ref-seq (length reference-sequence))
         (ref-new-old-analysis (new-old-analysis reference-sequence))
         (ref-weights (weights-from-new-old reference-sequence))
         (length-ref-new-old-analysis (length ref-new-old-analysis))
         (ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile)))
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'rhythmcell))
                             (let ((rhythm-seq (get-durations-upto-index layer indexx)))
                               (if (<= (length rhythm-seq) length-ref-seq)
                                   (let* ((new-old-analysis (combined-analysis rhythm-seq ref-weights ref-new-old-analysis length-ref-new-old-analysis))
                                          (energy-profile (energy-prof-from-new-old-analysis new-old-analysis)))
                                     (compare-analysis-absolute-value energy-profile ref-energy-profile (* deviation% max-energy)))
                                 t))
                           t))))



(defun pitch-peak-rule (layer reference-sequence peakrule)
  (let* ((ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile))
         (ref-peak-position (position max-energy ref-energy-profile)))
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                             (let* ((pitch-seq (get-pitches-upto-index layer indexx))
                                    (pitch-seq-length (length pitch-seq)))
                               (if (>= (1- pitch-seq-length) ref-peak-position)
                                   (funcall peakrule (nth ref-peak-position pitch-seq))
                                 t))
                           t))))

(defun rhythm-peak-rule (layer reference-sequence peakrule)
  (let* ((ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile))
         (ref-peak-position (position max-energy ref-energy-profile)))
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'rhythmcell))
                             (let* ((rhythm-seq (get-durations-upto-index layer indexx))
                                    (rhythm-seq-length (length rhythm-seq)))
                               (if (>= (1- rhythm-seq-length) ref-peak-position)
                                   (funcall peakrule (nth ref-peak-position rhythm-seq))
                                 t))
                           t))))

(defun pitch-peak-rule2 (layer reference-sequence peakrule)
  "This rule compares the peak variable to the preceeding variables. Peak rule must have two inputs."
  (let* ((ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile))
         (ref-peak-position (position max-energy ref-energy-profile)))
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                             (let* ((pitch-seq (get-pitches-upto-index layer indexx))
                                    (pitch-seq-length (length pitch-seq)))
                               (if (>= (1- pitch-seq-length) ref-peak-position)
                                   (funcall peakrule (nth ref-peak-position pitch-seq) (before-nth ref-peak-position pitch-seq))
                                 t))
                           t))))


(defun rhythm-peak-rule2 (layer reference-sequence peakrule)
  "This rule compares the peak variable to the preceeding variables. Peak rule must have two inputs."
  (let* ((ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile))
         (ref-peak-position (position max-energy ref-energy-profile)))
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'rhythmcell))
                             (let* ((rhythm-seq (get-durations-upto-index layer indexx))
                                    (rhythm-seq-length (length rhythm-seq)))
                               (if (>= (1- rhythm-seq-length) ref-peak-position)
                                   (funcall peakrule (nth ref-peak-position rhythm-seq) (before-nth ref-peak-position rhythm-seq))
                                 t))
                           t))))


(defun before-nth (nth seq)
"almost like nbutlast - before-nth does not include nth"
  (loop for n from 0 to (1- nth)
        collect (nth n seq)))



(defun pitch-before-peak-rule (layer reference-sequence beforepeakrule)
  (let* ((ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile))
         (ref-peak-position (position max-energy ref-energy-profile)))
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                             (let* ((pitch-seq (get-pitches-upto-index layer indexx))
                                    (pitch-seq-length (length pitch-seq)))
                               (if (>= (1- pitch-seq-length) ref-peak-position)
                                   t
                                 (funcall beforepeakrule (remove nil (before-nth ref-peak-position pitch-seq)))))
                           t))))


(defun rhythm-before-peak-rule (layer reference-sequence beforepeakrule)
  (let* ((ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile))
         (ref-peak-position (position max-energy ref-energy-profile)))
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'rhythmcell))
                             (let* ((rhythm-seq (get-durations-upto-index layer indexx))
                                    (rhythm-seq-length (length rhythm-seq)))
                               (if (>= (1- rhythm-seq-length) ref-peak-position)
                                   t
                                 (funcall beforepeakrule (remove nil (before-nth ref-peak-position rhythm-seq)))))
                           t))))

;(compare-analysis22  '(1 2 3 4) '(1 2 3) 0)



;;;this is a tool to analyze how the searchengine took the decision
(defun display-process-deviation (ref-seq seq)
  (let* ((length-ref-seq (length ref-seq))
         (ref-new-old-analysis (new-old-analysis ref-seq))
         (ref-weights (weights-from-new-old ref-seq))
         (length-ref-new-old-analysis (length ref-new-old-analysis))
         (ref-energy-profile (energy-prof-morph-analysis ref-seq))
         (new-old-analysis (combined-analysis seq ref-weights ref-new-old-analysis length-ref-new-old-analysis))
         (energy-profile (energy-prof-from-new-old-analysis new-old-analysis)))
    (loop for n from 0 to (1- (length seq))
          collect (mapcar '-
                          (energy-prof-from-new-old-analysis
                           (system::pwgl-print  (combined-analysis 
                            (loop for m from 0 to n
                                  collect (nth m seq))
                            ref-weights
                            ref-new-old-analysis
                            length-ref-new-old-analysis)))
                          ref-energy-profile))))

;(display-process-deviation '(60 64 67 71 67 60 67 64 60 67 60 67 64 60) '(60 67 72 64 60 72 60 60 60 60 60 60 72 64))


;(measure-info?  10 (ccl::mk-menu-subview :menu-list '(":exclude-time-info" ":include-measure-offset"":include-beat-offset")))

(system::PWGLDef energy-profile-rule ((layernr 0)(seq-type?  1 (ccl::mk-menu-subview :menu-list '(":pitch" ":rhythm")))
                                      (ref-seq nil)(deviation% 20)
                                      &optional
                                      (1stpeak? () (ccl::mk-menu-subview :menu-list '(":only-max" ":1st-peak")))
                                      (peakrule () (ccl::mk-menu-subview :menu-list '(":=" ":>" ":<" ":member" ":not-member" ":max" ":min")))
                                      (peakvalue 79)
                                      (before-peakrule  () (ccl::mk-menu-subview :menu-list '(":/=" ":>" ":<" ":member" ":not-member")))
                                      (before-peakvalue 77))
    "The rule checks that a sequene follow a given energy profile of a reference 
sequence. After the length of the reference sequence any value is accepted (the
rule is not valid after this point).

Optional you can define how the value at the peak of the energy profile 
should be. The peak can either be at the maximum energy, or at the point 
where the value at the maximum energy first occurs (1st-peak, this might 
more likely have a solution in some cases).

Optional you can define the characteristic of all elements before the peak 
above."
    (:groupings '(2 2) :extension-pattern '(3 2) :x-proportions '((0.2 0.8) (0.4 0.4) (0.3 0.3 0.2) (0.4 0.4)) :w 0.7)
  (let* ((energy-prof-rule (cond ((equal seq-type? :pitch)
                                  (pitch-energy-profile-rule layernr ref-seq (/ deviation% 100)))
                                 ((equal seq-type? :rhythm)
                                  (rhythm-energy-profile-rule layernr ref-seq (/ deviation% 100)))))

         ;;;set type of peak rule to use
         (pitch-peak-rule1 (cond ((equal 1stpeak? :only-max) 'pitch-peak-rule)
                                 ((equal 1stpeak? :1st-peak) '1st-pitch-peak-rule)))
         (pitch-peak-rule2 (cond ((equal 1stpeak? :only-max) 'pitch-peak-rule2)
                                 ((equal 1stpeak? :1st-peak) '1st-pitch-peak-rule2)))
         (pitch-before-peak-rule (cond ((equal 1stpeak? :only-max) 'pitch-before-peak-rule)
                                       ((equal 1stpeak? :1st-peak) '1st-pitch-before-peak-rule)))
         (rhythm-peak-rule1 (cond ((equal 1stpeak? :only-max) 'rhythm-peak-rule)
                                  ((equal 1stpeak? :1st-peak) '1st-rhythm-peak-rule)))
         (rhythm-peak-rule2 (cond ((equal 1stpeak? :only-max) 'rhythm-peak-rule2)
                                  ((equal 1stpeak? :1st-peak) '1st-rhythm-peak-rule2)))
         (rhythm-before-peak-rule (cond ((equal 1stpeak? :only-max) 'rhythm-before-peak-rule)
                                       ((equal 1stpeak? :1st-peak) '1st-rhythm-before-peak-rule)))

         ;;;call the peak rule
         (peakdesign-rules (cond ((equal seq-type? :pitch)
                                  (list (cond ((equal peakrule :=)
                                               (funcall pitch-peak-rule1 layernr ref-seq #'(lambda (x) (= x peakvalue))))
                                              ((equal peakrule :>)
                                               (funcall pitch-peak-rule1 layernr ref-seq #'(lambda (x) (> x peakvalue))))
                                              ((equal peakrule :<)
                                               (funcall pitch-peak-rule1 layernr ref-seq #'(lambda (x) (< x peakvalue))))
                                              ((equal peakrule :member)
                                               (funcall pitch-peak-rule1 layernr ref-seq #'(lambda (x) (member x peakvalue))))
                                              ((equal peakrule :not-member)
                                               (funcall pitch-peak-rule1 layernr ref-seq #'(lambda (x) (not (member x peakvalue)))))
                                              ((equal peakrule :max)
                                               (funcall pitch-peak-rule2 layernr ref-seq #'(lambda (x l) (> x (apply 'max l)))))
                                              ((equal peakrule :min)
                                               (funcall pitch-peak-rule2 layernr ref-seq #'(lambda (x l) (< x (apply 'min l))))
                                               ))
                                        (cond ((equal before-peakrule :<)
                                               (funcall pitch-before-peak-rule layernr ref-seq #'(lambda (l) (loop for x in l
                                                                                                           do (if (>= x before-peakvalue)
                                                                                                                  (return nil))
                                                                                                           finally (return t)))))
                                              ((equal before-peakrule :>)
                                               (funcall pitch-before-peak-rule layernr ref-seq #'(lambda (l) (loop for x in l
                                                                                                           do (if (<= x before-peakvalue)
                                                                                                                  (return nil))
                                                                                                           finally (return t)))))
                                              ((equal before-peakrule :/=)
                                               (funcall pitch-before-peak-rule layernr ref-seq #'(lambda (l) (not (member before-peakvalue l)))))
                                              ((equal before-peakrule :not-member)
                                               (funcall pitch-before-peak-rule layernr ref-seq #'(lambda (l) (loop for x in l
                                                                                                           do (if (member x before-peakvalue)
                                                                                                                  (return nil))
                                                                                                           finally (return t)))))
                                              ((equal before-peakrule :member)
                                               (funcall pitch-before-peak-rule layernr ref-seq #'(lambda (l) (subsetp l before-peakvalue))))
                                              )))
                                 ((equal seq-type? :rhythm) 
                                  (system::pwgl-print rhythm-peak-rule1)
                                  (list (cond ((equal peakrule :=)
                                               (funcall rhythm-peak-rule1 layernr ref-seq #'(lambda (x) (= x peakvalue))))
                                              ((equal peakrule :>)
                                               (funcall rhythm-peak-rule1 layernr ref-seq #'(lambda (x) (> x peakvalue))))
                                              ((equal peakrule :<)
                                               (funcall rhythm-peak-rule1 layernr ref-seq #'(lambda (x) (< x peakvalue))))
                                              ((equal peakrule :member)
                                               (funcall rhythm-peak-rule1 layernr ref-seq #'(lambda (x) (member x peakvalue))))
                                              ((equal peakrule :not-member)
                                               (funcall rhythm-peak-rule1 layernr ref-seq #'(lambda (x) (not (member x peakvalue)))))
                                              ((equal peakrule :max)
                                               (funcall rhythm-peak-rule2 layernr ref-seq #'(lambda (x l) (> x (apply 'max l)))))
                                              ((equal peakrule :min)
                                               (funcall rhythm-peak-rule2 layernr ref-seq #'(lambda (x l) (< x (apply 'min l))))
                                               ))
                                        (cond ((equal before-peakrule :<)
                                               (funcall rhythm-before-peak-rule layernr ref-seq #'(lambda (l) (loop for x in l
                                                                                                            do (if (>= x before-peakvalue)
                                                                                                                   (return nil))
                                                                                                            finally (return t)))))
                                              ((equal before-peakrule :>)
                                               (funcall rhythm-before-peak-rule layernr ref-seq #'(lambda (l) (loop for x in l
                                                                                                            do (if (<= x before-peakvalue)
                                                                                                                   (return nil))
                                                                                                            finally (return t)))))
                                              ((equal before-peakrule :/=)
                                               (funcall rhythm-before-peak-rule layernr ref-seq #'(lambda (l) (not (member before-peakvalue l)))))
                                              ((equal before-peakrule :not-member)
                                               (funcall rhythm-before-peak-rule layernr ref-seq #'(lambda (l) (loop for x in l
                                                                                                            do (if (member x before-peakvalue)
                                                                                                                   (return nil))
                                                                                                            finally (return t)))))
                                              ((equal before-peakrule :member)
                                               (funcall rhythm-before-peak-rule layernr ref-seq #'(lambda (l) (subsetp l before-peakvalue)))))
                                        )))))
    (remove nil (cons energy-prof-rule peakdesign-rules))))




;;;;experiments below


(defun 1st-pitch-peak-rule (layer reference-sequence peakrule)
  "This rule checks for the energy peak in the reference sequence. Then it checks if the
pitch at the reference peak exist earlier in the reference sequence (and uses this position instead 
if it exist). This is the position where the peakrule will be applied in the solution."
  (let* ((ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile))
         (ref-peak-position (position max-energy ref-energy-profile))
         (ref-contrast-seq (contrasts-lev.1 reference-sequence))
         (peak-contrast (nth ref-peak-position ref-contrast-seq))
         (first-ref-peak-value (position peak-contrast ref-contrast-seq)))
    (system::pwgl-print first-ref-peak-value)
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                             (let* ((pitch-seq (get-pitches-upto-index layer indexx))
                                    (pitch-seq-length (length pitch-seq)))
                               (if (>= (1- pitch-seq-length) first-ref-peak-value)
                                   (funcall peakrule (nth first-ref-peak-value pitch-seq))
                                 t))
                           t))))

(defun 1st-rhythm-peak-rule (layer reference-sequence peakrule)
  (let* ((ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile))
         (ref-peak-position (position max-energy ref-energy-profile))
         (ref-contrast-seq (contrasts-lev.1 reference-sequence))
         (peak-contrast (nth ref-peak-position ref-contrast-seq))
         (first-ref-peak-value (position peak-contrast ref-contrast-seq)))
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'rhythmcell))
                             (let* ((rhythm-seq (get-durations-upto-index layer indexx))
                                    (rhythm-seq-length (length rhythm-seq)))
                               (if (>= (1- rhythm-seq-length) first-ref-peak-value)
                                   (funcall peakrule (nth first-ref-peak-value rhythm-seq))
                                 t))
                           t))))


(defun 1st-pitch-peak-rule2 (layer reference-sequence peakrule)
  "This rule compares the peak variable to the preceeding variables. Peak rule must have two inputs."
  (let* ((ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile))
         (ref-peak-position (position max-energy ref-energy-profile))
         (ref-contrast-seq (contrasts-lev.1 reference-sequence))
         (peak-contrast (nth ref-peak-position ref-contrast-seq))
         (first-ref-peak-value (position peak-contrast ref-contrast-seq)))
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                             (let* ((pitch-seq (get-pitches-upto-index layer indexx))
                                    (pitch-seq-length (length pitch-seq)))
                               (if (>= (1- pitch-seq-length) first-ref-peak-value)
                                   (funcall peakrule (nth first-ref-peak-value pitch-seq) (before-nth first-ref-peak-value pitch-seq))
                                 t))
                           t))))


(defun 1st-rhythm-peak-rule2 (layer reference-sequence peakrule)
  "This rule compares the peak variable to the preceeding variables. Peak rule must have two inputs."
  (let* ((ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile))
         (ref-peak-position (position max-energy ref-energy-profile))
         (ref-contrast-seq (contrasts-lev.1 reference-sequence))
         (peak-contrast (nth ref-peak-position ref-contrast-seq))
         (first-ref-peak-value (position peak-contrast ref-contrast-seq)))
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'rhythmcell))
                             (let* ((rhythm-seq (get-durations-upto-index layer indexx))
                                    (rhythm-seq-length (length rhythm-seq)))
                               (if (>= (1- rhythm-seq-length) first-ref-peak-value)
                                   (funcall peakrule (nth first-ref-peak-value rhythm-seq) (before-nth first-ref-peak-value rhythm-seq))
                                 t))
                           t))))


(defun 1st-pitch-before-peak-rule (layer reference-sequence beforepeakrule)
  (let* ((ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile))
         (ref-peak-position (position max-energy ref-energy-profile))
         (ref-contrast-seq (contrasts-lev.1 reference-sequence))
         (peak-contrast (nth ref-peak-position ref-contrast-seq))
         (first-ref-peak-value (position peak-contrast ref-contrast-seq)))
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                             (let* ((pitch-seq (get-pitches-upto-index layer indexx))
                                    (pitch-seq-length (length pitch-seq)))
                               (if (>= (1- pitch-seq-length) first-ref-peak-value)
                                   t
                                 (funcall beforepeakrule (remove nil (before-nth first-ref-peak-value pitch-seq)))))
                           t))))


(defun 1st-rhythm-before-peak-rule (layer reference-sequence beforepeakrule)
  (let* ((ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile))
         (ref-peak-position (position max-energy ref-energy-profile))
         (ref-contrast-seq (contrasts-lev.1 reference-sequence))
         (peak-contrast (nth ref-peak-position ref-contrast-seq))
         (first-ref-peak-value (position peak-contrast ref-contrast-seq)))
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'rhythmcell))
                             (let* ((rhythm-seq (get-durations-upto-index layer indexx))
                                    (rhythm-seq-length (length rhythm-seq)))
                               (if (>= (1- rhythm-seq-length) first-ref-peak-value)
                                   t
                                 (funcall beforepeakrule (remove nil (before-nth first-ref-peak-value rhythm-seq)))))
                           t))))



;;---------------- Shanghai experiments


(defun pitch-energy-profile-mod12-rule (layer reference-sequence deviation%)
  "deviation% is deviation compared to max energy in profile"

  (setf reference-sequence (mapcar #'(lambda (p) (mod p 12)) reference-sequence))
  (let* ((length-ref-seq (length reference-sequence))
         (ref-new-old-analysis (new-old-analysis reference-sequence))
         (ref-weights (weights-from-new-old reference-sequence))
         (length-ref-new-old-analysis (length ref-new-old-analysis))
         (ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile)))
    #'(lambda (indexx x) (if (and (= (get-layer-nr x) layer) (typep x 'pitchcell))
                             (let ((pitch-seq (mapcar #'(lambda (p) (mod p 12)) (get-pitches-upto-index layer indexx))))
                               (if (<= (length pitch-seq) length-ref-seq)
                                   (let* ((new-old-analysis (combined-analysis pitch-seq ref-weights ref-new-old-analysis length-ref-new-old-analysis))
                                          (energy-profile (energy-prof-from-new-old-analysis new-old-analysis)))
                                     (compare-analysis-absolute-value energy-profile ref-energy-profile (* deviation% max-energy)))
                                 t))
                           t))))




(system::PWGLDef energy-profile-mod12-rule ((layernr 0)(seq-type?  1 (ccl::mk-menu-subview :menu-list '(":pitch" ":rhythm")))
                                            (ref-seq nil)(deviation% 20)
                                            &optional
                                            (1stpeak? () (ccl::mk-menu-subview :menu-list '(":only-max" ":1st-peak")))
                                            (peakrule () (ccl::mk-menu-subview :menu-list '(":=" ":>" ":<" ":member" ":not-member" ":max" ":min")))
                                            (peakvalue 79)
                                            (before-peakrule  () (ccl::mk-menu-subview :menu-list '(":/=" ":>" ":<" ":member" ":not-member")))
                                            (before-peakvalue 77))
    "The rule checks that a sequene follow a given energy profile of a reference 
sequence. After the length of the reference sequence any value is accepted (the
rule is not valid after this point).

Optional you can define how the value at the peak of the energy profile 
should be. The peak can either be at the maximum energy, or at the point 
where the value at the maximum energy first occurs (1st-peak, this might 
more likely have a solution in some cases).

Optional you can define the characteristic of all elements before the peak 
above."
    (:groupings '(2 2) :extension-pattern '(3 2) :x-proportions '((0.2 0.8) (0.4 0.4) (0.3 0.3 0.2) (0.4 0.4)) :w 0.7)
  (let* ((energy-prof-rule (cond ((equal seq-type? :pitch)
                                  (pitch-energy-profile-mod12-rule layernr ref-seq (/ deviation% 100)))
                                 ((equal seq-type? :rhythm)
                                  (rhythm-energy-profile-rule layernr ref-seq (/ deviation% 100)))))

         ;;;set type of peak rule to use
         (pitch-peak-rule1 (cond ((equal 1stpeak? :only-max) 'pitch-peak-rule)
                                 ((equal 1stpeak? :1st-peak) '1st-pitch-peak-rule)))
         (pitch-peak-rule2 (cond ((equal 1stpeak? :only-max) 'pitch-peak-rule2)
                                 ((equal 1stpeak? :1st-peak) '1st-pitch-peak-rule2)))
         (pitch-before-peak-rule (cond ((equal 1stpeak? :only-max) 'pitch-before-peak-rule)
                                       ((equal 1stpeak? :1st-peak) '1st-pitch-before-peak-rule)))
         (rhythm-peak-rule1 (cond ((equal 1stpeak? :only-max) 'rhythm-peak-rule)
                                  ((equal 1stpeak? :1st-peak) '1st-rhythm-peak-rule)))
         (rhythm-peak-rule2 (cond ((equal 1stpeak? :only-max) 'rhythm-peak-rule2)
                                  ((equal 1stpeak? :1st-peak) '1st-rhythm-peak-rule2)))
         (rhythm-before-peak-rule (cond ((equal 1stpeak? :only-max) 'rhythm-before-peak-rule)
                                        ((equal 1stpeak? :1st-peak) '1st-rhythm-before-peak-rule)))

         ;;;call the peak rule
         (peakdesign-rules (cond ((equal seq-type? :pitch)
                                  (list (cond ((equal peakrule :=)
                                               (funcall pitch-peak-rule1 layernr ref-seq #'(lambda (x) (= x peakvalue))))
                                              ((equal peakrule :>)
                                               (funcall pitch-peak-rule1 layernr ref-seq #'(lambda (x) (> x peakvalue))))
                                              ((equal peakrule :<)
                                               (funcall pitch-peak-rule1 layernr ref-seq #'(lambda (x) (< x peakvalue))))
                                              ((equal peakrule :member)
                                               (funcall pitch-peak-rule1 layernr ref-seq #'(lambda (x) (member x peakvalue))))
                                              ((equal peakrule :not-member)
                                               (funcall pitch-peak-rule1 layernr ref-seq #'(lambda (x) (not (member x peakvalue)))))
                                              ((equal peakrule :max)
                                               (funcall pitch-peak-rule2 layernr ref-seq #'(lambda (x l) (> x (apply 'max l)))))
                                              ((equal peakrule :min)
                                               (funcall pitch-peak-rule2 layernr ref-seq #'(lambda (x l) (< x (apply 'min l))))
                                               ))
                                        (cond ((equal before-peakrule :<)
                                               (funcall pitch-before-peak-rule layernr ref-seq #'(lambda (l) (loop for x in l
                                                                                                                   do (if (>= x before-peakvalue)
                                                                                                                          (return nil))
                                                                                                                   finally (return t)))))
                                              ((equal before-peakrule :>)
                                               (funcall pitch-before-peak-rule layernr ref-seq #'(lambda (l) (loop for x in l
                                                                                                                   do (if (<= x before-peakvalue)
                                                                                                                          (return nil))
                                                                                                                   finally (return t)))))
                                              ((equal before-peakrule :/=)
                                               (funcall pitch-before-peak-rule layernr ref-seq #'(lambda (l) (not (member before-peakvalue l)))))
                                              ((equal before-peakrule :not-member)
                                               (funcall pitch-before-peak-rule layernr ref-seq #'(lambda (l) (loop for x in l
                                                                                                                   do (if (member x before-peakvalue)
                                                                                                                          (return nil))
                                                                                                                   finally (return t)))))
                                              ((equal before-peakrule :member)
                                               (funcall pitch-before-peak-rule layernr ref-seq #'(lambda (l) (subsetp l before-peakvalue))))
                                              )))
                                 ((equal seq-type? :rhythm) 
                                  (system::pwgl-print rhythm-peak-rule1)
                                  (list (cond ((equal peakrule :=)
                                               (funcall rhythm-peak-rule1 layernr ref-seq #'(lambda (x) (= x peakvalue))))
                                              ((equal peakrule :>)
                                               (funcall rhythm-peak-rule1 layernr ref-seq #'(lambda (x) (> x peakvalue))))
                                              ((equal peakrule :<)
                                               (funcall rhythm-peak-rule1 layernr ref-seq #'(lambda (x) (< x peakvalue))))
                                              ((equal peakrule :member)
                                               (funcall rhythm-peak-rule1 layernr ref-seq #'(lambda (x) (member x peakvalue))))
                                              ((equal peakrule :not-member)
                                               (funcall rhythm-peak-rule1 layernr ref-seq #'(lambda (x) (not (member x peakvalue)))))
                                              ((equal peakrule :max)
                                               (funcall rhythm-peak-rule2 layernr ref-seq #'(lambda (x l) (> x (apply 'max l)))))
                                              ((equal peakrule :min)
                                               (funcall rhythm-peak-rule2 layernr ref-seq #'(lambda (x l) (< x (apply 'min l))))
                                               ))
                                        (cond ((equal before-peakrule :<)
                                               (funcall rhythm-before-peak-rule layernr ref-seq #'(lambda (l) (loop for x in l
                                                                                                                    do (if (>= x before-peakvalue)
                                                                                                                           (return nil))
                                                                                                                    finally (return t)))))
                                              ((equal before-peakrule :>)
                                               (funcall rhythm-before-peak-rule layernr ref-seq #'(lambda (l) (loop for x in l
                                                                                                                    do (if (<= x before-peakvalue)
                                                                                                                           (return nil))
                                                                                                                    finally (return t)))))
                                              ((equal before-peakrule :/=)
                                               (funcall rhythm-before-peak-rule layernr ref-seq #'(lambda (l) (not (member before-peakvalue l)))))
                                              ((equal before-peakrule :not-member)
                                               (funcall rhythm-before-peak-rule layernr ref-seq #'(lambda (l) (loop for x in l
                                                                                                                    do (if (member x before-peakvalue)
                                                                                                                           (return nil))
                                                                                                                    finally (return t)))))
                                              ((equal before-peakrule :member)
                                               (funcall rhythm-before-peak-rule layernr ref-seq #'(lambda (l) (subsetp l before-peakvalue)))))
                                        )))))
    (remove nil (cons energy-prof-rule peakdesign-rules))))