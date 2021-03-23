(in-package :ASDF)

(defsystem "MotifExtraction"

  :description "Efficiently extracts frequently occuring themes/motifs from a set of sequences."
  :long-description "This library uses an algorithm known as the \"String-Join\" method to extract the non-trivial, frequently occuring motifs from a set of sequences. A motif must occur twice or more in the set of input sequences to be found by the algorithm. A motif is considered trivial if it is a substring of a longer motif with the same frequency of occurence."
  :version "1.0"
  :author "Alan Nagelberg"
  :licence ""
  :maintainer "Alan Nagelberg"

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  (
   (:FILE "package")
   (:FILE "RepeatingPattern")
   (:FILE "RPList")
   (:FILE "RPTreeNode")
   (:FILE "RPTree")
   (:FILE "MotifExtraction")
   (:FILE "MotifExtractionBox")
   (:FILE "FilterResultsBox")
   (:FILE "PrintPatternsBox")
   (:FILE "SortPatternsBox")
   (:FILE "GetSingletonsBox")
   (:FILE "ConvertToPatternFreqPairBox")
   ;(:FILE "FitnessFunctionBoxes")
   (:FILE "menus")))