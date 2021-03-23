(in-package :GeneticAlgorithm)




;; Box for the genetic algorithm
(PWGLdef combine-fitness-fcns ((weight 1) (fitness-fcn ())
                               &rest (weight-fcn-list 1)
                              )
    "
This function additively combines any amount of fitness functions into a single fitness function, which is usable by the genetic algorithm. The functions can be weighted to vary the importance of each function.

The fitness-fcn parameter (and parameters directly underneath it when the box is expanded) should be passed a function that returns an integer given a candidate solution in the form of a list containing elements from the genetic algorithm's search space. For example, this function could take the form of a PWGL abstract box with one input (for the potential solution) and one output (an integer representing fitness of that solution). By sending the output of this box to the genetic algorithm's fitness-fcn input, the genetic algorithm will try to find a solution that maximes the fitness functions (when weighted and added together).

The weight parameter (and parameters directly underneath it when the box is expanded) should be given a number that represents the \"importance\" of the function beside it. A negative weight would indicate that the function should be minimized rather than maximized. However, for consistency, using only positive weights is recommended.

See the Genetic Algorithm library tutorial under \"PWGL Help\" for further information."
    (:groupings '(2) :extension-pattern '(2))
    (combine-fitness weight fitness-fcn weight-fcn-list)
)


