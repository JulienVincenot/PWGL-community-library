(in-package :GeneticAlgorithm)




;; Box for the genetic algorithm
(PWGLdef true-false-rules-to-fitness ((weight 1) (trueFalseRule ())
                               &rest (weight-TFrule-list 1)
                              )
    "
This function additively combines any amount of true-false rules into a single fitness function, which is usable by the genetic algorithm. Each true-false rule is weighted. If a given true-false rule evaluates to true (non-nil), then its corresponding weight is added to the total fitness. If a rule evaluates to false (nil), it contributes no value to the total fitness.

This box is useful if you have a large number of true-false rules that would be difficult to satisfy simultaneously. It allows you to find a \"best effort\" solution, and give more weight to certain rules. The output of this box can be sent to the combine-fitness-fcns box to use your true-false rules in conjunction with other fitness functions (heuristic rules), or it can be sent directly to the genetic algorithm box's fitness-fcn input.

The trueFalseRule parameter (and every parameter directly below it when the box is expanded) should be passed a function . For example, this function could be a PWGL abstract box in lambda mode with one input representing the candidate solution, and one true or false output.

The weight parameter (and every parameter directly below it when the box is expanded) represents the \"importance\" of the rule directly beside it in the box. When a rule is true, its weight is added to the total fitness, when a rule is false, it contributes nothing to the total fitness.
See the Genetic Algorithm library tutorial under \"PWGL Help\" for further information."
    (:groupings '(2) :extension-pattern '(2))

    (tfRulesToFitness weight trueFalseRule weight-TFrule-list)
)

