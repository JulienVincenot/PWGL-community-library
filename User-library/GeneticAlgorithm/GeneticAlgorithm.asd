(in-package :ASDF)

(defsystem "GeneticAlgorithm"

  :description "Perform stochastic optimization using a genetic algorithm."
  :long-description "This library uses a genetic algorithm to produce a list of a specified length that adheres to a user specified heuristic \"fitness function\". Genetic algorithms are good at intellegently searching for an optimal solution by mimicking biological evolution."
  :version "1.1"
  :author "Alan Nagelberg"
  :licence ""
  :maintainer "Alan Nagelberg"

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  (
   (:FILE "package")
   (:file "utilities")
   (:FILE "GeneticAlgorithm")
   (:file "combineFitnessFcns")
   (:file "trueFalseToFitness")
   ;; define your boxes and other lisp functions
   (:file "GeneticAlgorithmBox")
   (:file "combineFitnessFcnsBox")
   (:file "trueFalseToFitnessBox")
   ;; specify the entries in the popup-menu, which is used to add
   ;; boxes to a patch (right-click)

   (:file "additions")
   (:file "menus")
      
  )
)
