(in-package studioflat)

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

;;;;;;

(defun weights-from-new-old (seq)
  (let* ((sequence-whit-silence-start-end (append '(symbol-silence-start) seq '(symbol-silence-end)))
         (contrasts-all-lev (contrasts-all-lev sequence-whit-silence-start-end))
	 (distances (mapcar #'(lambda (contr) (my-x->dx contr)) contrasts-all-lev))
	 (weights (mapcar #'(lambda (x) (apply '+ x)) contrasts-all-lev)))
    weights))

(defun combined-analysis (section ref-weights ref-analysis length-ref-analysis)
"Since length of re-analysis is known, this is calculated outside the search."
  (let* ((section-length (length section))
         (length-remaining-from-ref-seq (- length-ref-analysis section-length)))
    (if (plusp length-remaining-from-ref-seq)
        (append (start-section-new-old section ref-weights)
                (last ref-analysis length-remaining-from-ref-seq))
      (start-section-new-old (nbutlast section (- length-remaining-from-ref-seq)) ref-weights))))


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


(defun energy-prof-from-new-old-analysis (new-old-analysis)
            (let* ((analysis-old-new (cons '0 new-old-analysis)))
              (loop for x in analysis-old-new
                    for y in (cdr analysis-old-new) 
                    collect (abs (- (abs y) (abs x))))
              ))


(defun compare-analysis-absolute-value (new-analysis reference-analysis deviation)
  "Simply compares two list of values and returns true if they do not deviate more than the tolerance (given as an absolute difference).
IMPORTANT: new-analysis can not be longer than reference-analysis (this will generate a wrong answer)."
 ; (print (list 'debug-morph-rule reference-analysis new-analysis))
  (loop for new in new-analysis
        for ref in reference-analysis 
        until (> (abs (- new ref)) deviation)
        finally  (return (<= (abs (- new ref)) deviation))
        ))

(defun energy-profile-logic-statement (pitch-seq ref-energy-profile length-ref-seq ref-weights ref-new-old-analysis length-ref-new-old-analysis deviation%*max-energy)
  "This is the logic statement for a rule"
  (if (<= (length pitch-seq) length-ref-seq)
      (let* ((new-old-analysis (combined-analysis pitch-seq ref-weights ref-new-old-analysis length-ref-new-old-analysis))
             (energy-profile (energy-prof-from-new-old-analysis new-old-analysis)))
        (compare-analysis-absolute-value energy-profile ref-energy-profile deviation%*max-energy))
    t))



(defun energy-profile-rule (reference-sequence deviation%)
  "Ruke for approximation of an energy profile. A reference sequence is used as a model.
deviation% is deviation compared to max energy in the energy profile of the reference profile."
  (let* ((length-ref-seq (length reference-sequence))
         (ref-new-old-analysis (new-old-analysis reference-sequence))
         (ref-weights (weights-from-new-old reference-sequence))
         (length-ref-new-old-analysis (length ref-new-old-analysis))
         (ref-energy-profile (energy-prof-morph-analysis reference-sequence))
         (max-energy (apply 'max ref-energy-profile))
         (deviation%*max-energy (* deviation% max-energy)))
    (list '* (list (read-from-string "?if") (list 'energy-profile-logic-statement (read-from-string "l") (list 'quote ref-energy-profile) length-ref-seq 
                              (list 'quote ref-weights) (list 'quote ref-new-old-analysis) length-ref-new-old-analysis deviation%*max-energy)))))




(system::PWGLDef pmc-energy-profile-rule ((ref-seq nil)(deviation% 20))
    "The rule checks that a sequene follows a given energy profile of a reference 
sequence. After the length of the reference sequence any value is accepted 
(the rule is not valid after this point).

You can define amaximum deviation from the reference sequence: 0.10 means 
that you allow 10% deviation from the peak of the energy profile. For 
example an enegy peak of 220 in the reference sequence allows the peak in the 
sequence to be between 198 - 242. It also means that any value will have to 
be in the range +/- 22 (i.e. 10%) from the original curve. "
    (:groupings '(2) :x-proportions '((0.5 0.5)))
  (energy-profile-rule ref-seq deviation%))