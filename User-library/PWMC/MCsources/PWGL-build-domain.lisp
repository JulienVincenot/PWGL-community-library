(in-package MC)
;;Adapted for the pwgl environment

(defun repeat-domain  (self num) 
  (let (rep)
    (loop for i from 1 to num do
          (push self rep))
    (reverse rep)))

(defun mcify-symbols (tree)
  (cond
    ((null tree)
     nil)
    ((consp tree)
     (cons (mcify-symbols (car tree))
	   (mcify-symbols (cdr tree))))
    ;; convert symbols that are not keywords
    ((and (symbolp tree) (not (keywordp tree)))
     (intern (symbol-name tree) #.(find-package "MC")))	
    (t tree)))

(defun extract-motifs (list-of-pitchcells-and-motifs)
  (remove nil (mapcar #'(lambda (cell) (if (eq (car cell) 'm) (cdr cell) nil)) (mcify-symbols list-of-pitchcells-and-motifs))))


(defun extract-pitchcells (list-of-pitchcells-and-motifs)
  (remove nil (mapcar #'(lambda (cell) (if (eq (car cell) 'm) nil cell)) (mcify-symbols list-of-pitchcells-and-motifs))))

(defun myprint (list) (print list))

(system::PWGLDef build-domain ((measurelayer nil) (nr-search-variables 10) (rhythmlayer0 nil) (pitchlayer0 nil) &optional (rhythmlayer1 nil)(pitchlayer1 nil) (rhythmlayer2 nil)(pitchlayer2 nil) (rhythmlayer3 nil)(pitchlayer3 nil) (rhythmlayer4 nil)(pitchlayer4 nil) (rhythmlayer5 nil)(pitchlayer5 nil) (rhythmlayer6 nil)(pitchlayer6 nil) (rhythmlayer7 nil)(pitchlayer7 nil) (rhythmlayer8 nil)(pitchlayer8 nil) (rhythmlayer9 nil)(pitchlayer9 nil))
        "This function takes lists of time signatures, pitches and durations and 
formats them into a domain readable by the multi-pmc inside the PWMC library.

Pitches can either be single pitches, single chords, pitch/chord motifs, 
or transposable pitch motifs (i.e. melodic profiles). Durations
can either be single durations or rhythm motifs.

For more information about the domain, see the PWMC tutorial."
        (:groupings '(2 2)  :extension-pattern '(2 2 2 2 2 2 2 2 2) :x-proportions '((0.5 (:fix 0.15))(0.5 0.5)))
  (unlock-rlayers)
  (unlock-players)
  (loop for n from 1 to nr-search-variables
        collect
       (append
        (if measurelayer
            (create-mdomain measurelayer))
        (if rhythmlayer0
            (if (typep rhythmlayer0 'function)
                (funcall rhythmlayer0 0)
              (create-rdomain 0 rhythmlayer0)))
        (if pitchlayer0
            (if (typep pitchlayer0 'function)
                (funcall pitchlayer0 0)
              (let ((pitchcells (extract-pitchcells pitchlayer0))
                    (motifcells (extract-motifs pitchlayer0)))
                (append (if pitchcells (create-pdomain  0 pitchcells))
                        (if motifcells (create-pmdomain 0 motifcells))))))
        (if rhythmlayer1
            (if (typep rhythmlayer1 'function)
                (funcall rhythmlayer1 1)
              (create-rdomain 1 rhythmlayer1)))
        (if pitchlayer1
            (if (typep pitchlayer1 'function)
                (funcall pitchlayer1 1)
              (let ((pitchcells (extract-pitchcells pitchlayer1))
                    (motifcells (extract-motifs pitchlayer1)))
                (append (if pitchcells (create-pdomain  1 pitchcells))
                        (if motifcells (create-pmdomain 1 motifcells))))))
        (if rhythmlayer2
            (if (typep rhythmlayer2 'function)
                (funcall rhythmlayer2 2)
              (create-rdomain 2 rhythmlayer2)))
        (if pitchlayer2
            (if (typep pitchlayer2 'function)
                (funcall pitchlayer2 2)
              (let ((pitchcells (extract-pitchcells pitchlayer2))
                    (motifcells (extract-motifs pitchlayer2)))
                (append (if pitchcells (create-pdomain  2 pitchcells))
                        (if motifcells (create-pmdomain 2 motifcells))))))
        (if rhythmlayer3
            (if (typep rhythmlayer3 'function)
                (funcall rhythmlayer3 3)
              (create-rdomain 3 rhythmlayer3)))
        (if pitchlayer3
            (if (typep pitchlayer3 'function)
                (funcall pitchlayer3 3)
              (let ((pitchcells (extract-pitchcells pitchlayer3))
                    (motifcells (extract-motifs pitchlayer3)))
                (append (if pitchcells (create-pdomain  3 pitchcells))
                        (if motifcells (create-pmdomain 3 motifcells))))))
        (if rhythmlayer4
            (if (typep rhythmlayer4 'function)
                (funcall rhythmlayer4 4)
              (create-rdomain 4 rhythmlayer4)))
        (if pitchlayer4
            (if (typep pitchlayer4 'function)
                (funcall pitchlayer4 4)
              (let ((pitchcells (extract-pitchcells pitchlayer4))
                    (motifcells (extract-motifs pitchlayer4)))
                (append (if pitchcells (create-pdomain  4 pitchcells))
                        (if motifcells (create-pmdomain 4 motifcells))))))
        (if rhythmlayer5
            (if (typep rhythmlayer5 'function)
                (funcall rhythmlayer5 5)
              (create-rdomain 5 rhythmlayer5)))
        (if pitchlayer5
            (if (typep pitchlayer5 'function)
                (funcall pitchlayer5 5)
              (let ((pitchcells (extract-pitchcells pitchlayer5))
                    (motifcells (extract-motifs pitchlayer5)))
                (append (if pitchcells (create-pdomain  5 pitchcells))
                        (if motifcells (create-pmdomain 5 motifcells))))))
        (if rhythmlayer6
            (if (typep rhythmlayer6 'function)
                (funcall rhythmlayer6 6)
              (create-rdomain 6 rhythmlayer6)))
        (if pitchlayer6
            (if (typep pitchlayer6 'function)
                (funcall pitchlayer6 6)
              (let ((pitchcells (extract-pitchcells pitchlayer6))
                    (motifcells (extract-motifs pitchlayer6)))
                (append (if pitchcells (create-pdomain  6 pitchcells))
                        (if motifcells (create-pmdomain 6 motifcells))))))
        (if rhythmlayer7
            (if (typep rhythmlayer7 'function)
                (funcall rhythmlayer7 7)
              (create-rdomain 7 rhythmlayer7)))
        (if pitchlayer7
            (if (typep pitchlayer7 'function)
                (funcall pitchlayer7 7)
              (let ((pitchcells (extract-pitchcells pitchlayer7))
                    (motifcells (extract-motifs pitchlayer7)))
                (append (if pitchcells (create-pdomain  7 pitchcells))
                        (if motifcells (create-pmdomain 7 motifcells))))))
         (if rhythmlayer8
            (if (typep rhythmlayer8 'function)
                (funcall rhythmlayer8 8)
              (create-rdomain 8 rhythmlayer8)))
        (if pitchlayer8
            (if (typep pitchlayer8 'function)
                (funcall pitchlayer8 8)
              (let ((pitchcells (extract-pitchcells pitchlayer8))
                    (motifcells (extract-motifs pitchlayer8)))
                (append (if pitchcells (create-pdomain  8 pitchcells))
                        (if motifcells (create-pmdomain 8 motifcells))))))
         (if rhythmlayer9
            (if (typep rhythmlayer9 'function)
                (funcall rhythmlayer9 9)
              (create-rdomain 9 rhythmlayer9)))
        (if pitchlayer9
            (if (typep pitchlayer9 'function)
                (funcall pitchlayer9 9)
              (let ((pitchcells (extract-pitchcells pitchlayer9))
                    (motifcells (extract-motifs pitchlayer9)))
                (append (if pitchcells (create-pdomain  9 pitchcells))
                        (if motifcells (create-pmdomain 9 motifcells)))))))
       ))
