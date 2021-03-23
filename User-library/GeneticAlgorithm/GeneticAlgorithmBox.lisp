(in-package :GeneticAlgorithm)


;; constants for determining which type of termination to use
(defconstant TERM_ON_FITNESS_LEVEL 1) ; terminate when a certain fitness level is reached
(defconstant TERM_ON_NUM_GENERATIONS 2) ; terminate on a certain number of generations
(defconstant TERM_ON_FITNESS_PLATEAU 3) ; terminate once the fitness plateaus


;; Box for the genetic algorithm
(PWGLdef Genetic-Algorithm ((searchSpace '(1 2 3 4 5 6 7 8 9 10 11 12 13 14)) 
                           (length 14) (poolSize 50) (fitness-fcn ()) 
                           (crossProb 0.5) (mutProb 0.1) 
                  (elitism () (ccl::mk-menu-subview :menu-list '(("yes" t) ("no" nil))))
       (terminationType () (ccl::mk-menu-subview :menu-list '(("Termnate on Fitness Level" TERM_ON_FITNESS_LEVEL)
                                                              ("Terminate on Num. Generations" TERM_ON_NUM_GENERATIONS) 
                                                              ("Terminate on Fitness Plateau" TERM_ON_FITNESS_PLATEAU))))
                           (terminationParam 10) ) 
"
This box uses a genetic algorithm (GA) to optimize a list of a specified length based on a user defined fitness function. Elements of the list are members of the user-defined search space. When evaluated, this box returns the best solution found by the genetic algorithm.

A genetic algorithm is a form of \"hill climbing\" algorithm used to attempt to find a global maximum (or minimum) in large search spaces. In a musical context, it can be used to find passages that maximally satisfy a set of (potentially complex) heuristic rules, known as the \"fitness function\", which indicates how \"good\" (or \"fit\") a given solution is. Using the \"true-false-rules-to-fitness\" box, simple true/false rules can be combined into a heuristic rule. The genetic algorithm cannot guarentee that the absolute global maximum is found, but the algorithm excels at finding \"good\" solutions, relatively efficiently. See the Genetic Algorithm library tutorial under \"PWGL Help\" for further information.

Input Parameters:
===== ==========

searchSpace - A list of all possible elements that the solution may use.

length - The length (number of elements) of the desired solution.

poolSize - The size of the mating pool used in the genetic algorithm.

fitness-fcn - The user defined fitness function, for example a PWGL abstract box. The function should take one input, represent a candidate solution (a list of length \"length\"), and provide a numeric output representing the fitness of the solution. See boxes combine-fitness-fcns and true-false-rules-to-fitness for more information.

crossProb - The probability of crossover occuring between two selected candidate solutions.

mutProb - The probability of any given element in a candidate solution being mutated to a different element in the search space.

elitism - Specifies whether or not to use elitism in the genetic algorthim.

terminationType - Lets you specify how the GA should terminate. When set to \"Terminate on Fitness Level\", the algorithm stops once the fitness of the best solution is equal to or greater than the fitness level specified by the input terminationParam. When set to \"Terminate on Num. Generations\", the algorithm stops after a number of generations specified by terminationParam have been iterated through. When set to \"Terminate on Fitness Plateau\", the algorithm stops once the fitness plateaus. In this case terminationParam specifies the number of consecutive generations with no improvement in fitness to indicate the plateau.

terminationParam - Determines the condition for termination, depending on the value of terminationType (see terminationType above for more info). This parameter should be a positive number."

    (:w 0.7 :groupings '(1 3 3 1 1) )
    (runGA searchSpace length poolSize fitness-fcn crossProb mutProb elitism terminationType terminationParam)
)

; testing fitness function;
; #'(lambda (fitArg) (length (remove-duplicates fitArg)) )

