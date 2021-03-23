(in-package :GENETICALGORITHM)



(defun runGA (searchSpace length poolSize fitness-fcn crossProb mutProb elitism terminationType terminationParam)
"
This box uses a genetic algorithm (GA) to optimize a list of a specified length based on a user defined fitness function. Elements of the list are members of the user-defined search space. When evaluated, this box returns the best solution found by the genetic algorithm.

A genetic algorithm is a form of \"hill climbing\" algorithm used to attempt to find a global maximum (or minimum) in large search spaces. In a musical context, it can be used to find passages that maximally satisfy a set of (potentially complex) heuristic rules, known as the \"fitness function\", which indicates how \"good\" (or \"fit\") a given solution is. Using the \"true-false-rules-to-fitness\" box, simple true/false rules can be combined into a heuristic rule. The genetic algorithm cannot guarentee that the absolute global maximum is found, but the algorithm excels at finding \"good\" solutions, relatively efficiently. See the Genetic Algorithm library tutorial under \"PWGL Help\" for further information.

Inputs:
======

searchSpace - A list of all possible elements that the solution may use.

length - The length (number of elements) of the desired solution.

poolSize - The size of the mating pool used in the genetic algorithm.

fitness-fcn - The user defined fitness function, for example a PWGL abstract box. The function should take one input, represent a candidate solution (a list of length \"length\"), and provide a numeric output representing the fitness of the solution. See boxes combine-fitness-fcns and true-false-rules-to-fitness for more information.

crossProb - The probability of crossover occuring between two selected candidate solutions.

mutProb - The probability of any given element in a candidate solution being mutated to a different element in the search space.

elitism - Specifies whether or not to use elitism in the genetic algorthim.

terminationType - Lets you specify how the GA should terminate. When set to \"Terminate on Fitness Level\", the algorithm stops once the fitness of the best solution is equal to or greater than the fitness level specified by the input terminationParam. When set to \"Terminate on Num. Generations\", the algorithm stops after a number of generations specified by terminationParam have been iterated through. When set to \"Terminate on Fitness Plateau\", the algorithm stops once the fitness plateaus. In this case terminationParam specifies the number of consecutive generations with no improvement in fitness to indicate the plateau.

terminationParam - Determines the condition for termination, depending on the value of terminationType (see terminationType above for more info). This parameter should be a positive number."

; define local variables
(let (parent1 ; parent from one generation to the next
      parent2 ; the other parent
      child1 ; child for the next generation
      child2 ; 2nd child for the next generation
      currMatingPool ; list of the species in the current mating pool
      nextMatingPool ; list of species in the next mating pool
      (generationCount 0) ; counts the number of generations
      (consecSameBestFitness 0) ; consecutive number of generations with the same best fitness in the mating pool
      (prevBestFitness most-negative-fixnum)
      (currBestFitness (1+ most-negative-fixnum))
      (fitnessSum 0)
      (timeoutCount 0)
      ;(fitnessMin) ; min. fitness in a mating pool
      ;(fitnessMax) ; max fitness in a mating pool
      termCondition
     )

;; Candidate solutions will be paired with their fitness, so the 
;; format of a specimen (candidate solution) is:
;; ((element1 element2 ... ) fitnessValue)
;; fitnessValue should remain nil until evaluated
;; it will only be of numeric form


;; check the validity of the input parameters, raise errors as neccesary:
;; (if (and (integerp length) (plusp length)) (error "Length must be a positive integer."))


;; specimenGreaterThan funciton is a predicate function 
;; which is used to sort species (candidate solutions)
;; by fitness.
(defun specimenGreaterThan (specimen1 specimen2)
   (> (second specimen1) (second specimen2))
)

;; sumFitness function sums together the fitness of 
;; all species in a mating pool.
(defun sumFitness (matingPool)
   (let (( minimumFitness (second (car (last matingPool))) ))

     (sum-list (mapcar #'(lambda (x) (- x minimumFitness) ) (second (transpose matingPool)) ) )
   )
)



;; determineTerm function determines the termination condition to use
(defun determineTermination ()
    (cond 
        ((= (eval terminationType) TERM_ON_FITNESS_LEVEL)
            #'(lambda () (>= currBestFitness terminationParam))
        )
        ((= (eval terminationType) TERM_ON_NUM_GENERATIONS)
            #'(lambda () (>= generationCount terminationParam))
        )
        ((= (eval terminationType) TERM_ON_FITNESS_PLATEAU)
            #'(lambda () (>= consecSameBestFitness terminationParam))
        )     
    ) ; end cond
)

;; store the termination condition
(setq termCondition (determineTermination))

;; terminate? function checks if the GA should terminate
;; based on the termination condition
(defun terminate? ()
    (funcall termCondition)
)   


;; function updateTermVariables updates the variables
;; neccesary for determining if the termination condition is met
(defun updateTermVariables ()
(setq prevBestFitness currBestFitness
      currBestFitness (second (first currMatingPool))
      generationCount (1+ generationCount))

(if (= prevBestFitness currBestFitness) 
    (setq consecSameBestFitness (1+ consecSameBestFitness)) 
    (setq consecSameBestFitness 0))
) ; end updateTermVariables



;; rouletteWheelSelect function - given the total
;; sum of all fitness values in currMatingPool, uses
;; roulette wheel selection to select a candidate solution
;; from currMatingPool, returns a single list representing
;; the candidate solution (fitness portion is NOT returned)
#|(defun rouletteWheelSelect (fitnessSum)
    (let ( 
      (randFitnessNum (random fitnessSum))
      (currFitnessSum 0)
      (tempMatingPool currMatingPool)   
      returnSpecimen
      )


      
      (loop while (<= currFitnessSum randFitnessNum) do
         (setq returnSpecimen (first tempMatingPool)
          currFitnessSum (+ currFitnessSum (second returnSpecimen)))
         (setq tempMatingPool (cdr tempMatingPool))
      )

      ;; return the selected specimen
      (first returnSpecimen)
      

    ) ; end let
)
|#

;; rouletteWheelSelect function - given the total sum
;; of fitness in currMatingPool, uses
;; roulette wheel selection to select a candidate solution
;; from currMatingPool, returns a single list representing
;; the candidate solution (fitness portion is NOT returned).
;; the currMatingPool list is assumed to be sorted by fitness
(defun rouletteWheelSelect (fitnessSum)
    (let ( 
      (randFitnessNum)
      (minFitness (second (car (last currMatingPool)))) ; min. fitness
      (currFitnessSum 0) ; min. fitness to start
      (tempMatingPool currMatingPool)   
      returnSpecimen
      )

      ; generate random number in fitness range

      (if (eql fitnessSum 0)
	  (setq returnSpecimen (nth (random (length tempMatingPool)) tempMatingPool))
	;else 
	(progn 
	  ;(print fitnessSum)
          (setq randFitnessNum (random fitnessSum))
          (loop while (<= currFitnessSum randFitnessNum) do
           (setq returnSpecimen (first tempMatingPool)
	       currFitnessSum (+ currFitnessSum (- (second returnSpecimen) minFitness) ) )
	   ;(print (length tempMatingPool))
           (setq tempMatingPool (cdr tempMatingPool))
          )
	)
      )

      ;; return the selected specimen
      (first returnSpecimen)
      

    ) ; end let
)



; crossover function - crosses over childA and childB
; using a ranomly chosen crossover point, returns a list
; containing the two new crossed over children
(defun crossover (childA childB)
    (let ( (crossoverPt (1+ (random   (1- length)))) )
      (list (append (subseq childA 0 crossoverPt) (subseq childB crossoverPt))
            (append (subseq childB 0 crossoverPt) (subseq childA crossoverPt)))
    ) ; end let
)

; mutate function - randomly mutates the child
; half of the time, a the mutation changes a randomly chosen
; element in the solution to another value in the search space,
; the other half of the time, the mutation swaps two values
; in the solution.
; NOTE THAT THIS MUTATION IS DESCTRUCTIVE! ie.  it alters the child
(defun mutate (child)
   (let ( (newChild ()) )
     (loop for i from 1 to length do
	  (setq newChild (cons (if (< (random 1.0) mutProb) 
                                      (nth (random (length searchSpace)) searchSpace) 
                                      (car child) )
                                newChild)
                child (cdr child)
          )
     ) ; end loop for
     (reverse newChild)
   ) ; end let
) ; end mutate


;; OLD VERSION OF MUTATE:
#|(defun mutate (child)
    (let ( (childCopy (copy-list child)) )
    (if (< (random 1.0) 0.5)
        ; perform change single element mutation
        (setf (nth (random (length childCopy)) childCopy)
                  (nth (random (length searchSpace)) searchSpace) )

        ; else perform swap mutation
        (let ((index1 (random (length childCopy)))
              (index2 (random (length childCopy))) 
               tempElement )
             ; ensure indeces are different
             (loop while (= index1 index2) do
                 (setq index2 (random (length childCopy)))
             )
             (setq tempElement (nth index1 childCopy))
             (setf (nth index1 childCopy) (nth index2 childCopy))
             (setf (nth index2 childCopy) tempElement)
        ) ; end let
    ) ; end if
    ; return the mutated child:
    childCopy
    ) ; end outer let
)
|#

;; -----------------------------
;; GENETIC ALGORITHM BEGINS HERE
;; -----------------------------

; Generate the initial random mating pool
(dotimes (j poolSize)

; set child1 to an empty list
(setq child1 ())

(dotimes (i length)
    (setq child1
       ;; append a random element from the search space to the child
       (cons
          (nth (random (length searchSpace)) searchSpace) child1
       )
    )
) ; end inner dotimes

;; add the fitness portion to the child1
(setq child1 (list child1 (funcall fitness-fcn child1)))

; add the new random child to the initial mating pool
(setq currMatingPool (cons child1 currMatingPool))

) ; end outer dotimes


; Sort the mating pool by fitness from highest to lowest
(setq currMatingPool (sort currMatingPool 'specimenGreaterThan))


;; now we have a mating pool full of randomly generated pieces,
;; sorted by fitness, from highest to lowest

; update termination condition variables
(updateTermVariables)
       
(let ((forLoopLimit (/ poolSize 2)))

; determine value of forLoopLimit
(if elitism
    (setq forLoopLimit (- forLoopLimit 2))
)

;; iterate to next generation until termination condition is met:
(loop while (not (terminate?)) do

    ; calculate the total fitness sum for use in roulette wheel selection
     ;(print "b4 fitnessSum")
     (setq fitnessSum (sumFitness currMatingPool))
     ;(print "after fitnessSum")

    ; find the min. fitness, and max fitness for use in roulette wheel selection
    ;(setq fitnessMin ()
	  ;fitnessMax ())

    ; determine if elitism is being used,
    ; and if so, copy the two most fit solutions into the next generation
    (cond (elitism 
          (setq child1 (first currMatingPool)
                child2 (second currMatingPool))
	  (setq nextMatingPool (cons child1 nextMatingPool)
	        nextMatingPool (cons child2 nextMatingPool))
        )
    ) ; end cond
    
    (loop for i from 1 to forLoopLimit do

	 (setq parent1 (rouletteWheelSelect fitnessSum)
	       parent2 (rouletteWheelSelect fitnessSum))

     ;(print "b4 roulette loop")
	 ;(print parent1)
	 ;(print parent2)
	 (setq timeoutCount 0)

	  ; ensure that the 2 parents aren't the same
	 (loop while (and (eq parent1 parent2) (< timeoutCount 10)) do
	      (setq parent2 (rouletteWheelSelect fitnessSum)
		    timeoutCount (1+ timeoutCount))
	      
	  )
     ;(print "after roulette loop")	      

	     	; create children from the two parents
	      (setq child1 (copy-list parent1)
		    child2 (copy-list parent2))

          	; crossover (probabilistic)
	      (if (< (random 1.0) crossProb)
	         	; perform crossover
		  (setq child1 (crossover child1 child2)
			child2 (second child1)
			child1 (first child1))
	      )

		; mutate child1 (probabilistic)
	      (setq child1 (mutate child1))
	      

        	; mutate child2 (probabilistic)
	      (setq child2 (mutate child2))

              ; calculate the fitness of each specimen and store it in the mating pool
              (setq child1 (list child1 (funcall fitness-fcn child1))
                    child2 (list child2 (funcall fitness-fcn child2)))

              ; add the new children to the mating pool
	      (setq nextMatingPool (cons child1 nextMatingPool)
	            nextMatingPool (cons child2 nextMatingPool))

    ) ; end for loop

    ; if the poolSize is odd, add one more child
    (cond (
       (oddp poolSize)
          (setq child1 (mutate (copy-list (rouletteWheelSelect fitnessSum))))
          (setq child1 (list child1 (funcall fitness-fcn child1)))
          (setq nextMatingPool (cons child1 nextMatingPool))
          )
    )

    ; update the currMatingPool, and reset the nextMatingPool
    (setq currMatingPool nextMatingPool)
          
    (setq nextMatingPool ())

    ; Sort the mating pool by fitness from highest to lowest
    (setq currMatingPool (sort currMatingPool #'specimenGreaterThan))

    ; update the termination condition variables
    (updateTermVariables)

) ; end while

) ; end let forLoopLimit

; Output information about this execution of the genetic algorithm
(print "GENETIC ALGORITHM SUMMARY:")
(print (concatenate 'string "Fitness of best solution: " (write-to-string currBestFitness)))
(print (concatenate 'string "Number of generations: " (write-to-string generationCount)))
(print (concatenate 'string "Latest number of consecutive generations with unchanged fitness: " (write-to-string consecSameBestFitness)))


; retrieve the most fit solution
(first (first currMatingPool))

;(setq child1 (first (first currMatingPool)))

;(list child1 (mutate child1))

;(list currMatingPool (rouletteWheelSelect fitnessSum) (rouletteWheelSelect fitnessSum) (rouletteWheelSelect fitnessSum) (rouletteWheelSelect fitnessSum))

) ; end let

)  ; end defun runGA

