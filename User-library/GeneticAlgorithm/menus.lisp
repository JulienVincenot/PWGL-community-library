(in-package :GeneticAlgorithm)

;; define a user menu
(ccl::add-PWGL-user-menu 
 '(:menu-component
   ("GeneticAlgorithm"
    ((Genetic-Algorithm)
     (combine-fitness-fcns)
     (true-false-rules-to-fitness) 
     ("additions" (wildcard-loop conv-jbsrule))
     ))))