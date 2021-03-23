(in-package :MOTIFEXTRACTION)

;; define a user menu
(ccl::add-PWGL-user-menu 
 '(:menu-component
   ("MotifExtraction"
    ((motif-extraction)
     ("utilities"
       (filter-results)
       (print-patterns)
       (sort-patterns)
       (get-singletons)
       (convert-to-pattern-freq-pairs)
       )
     ;("fitness functions"
       ;(fitness-from-freq)
       ;(fitness-from-freq-length)
       ;)
     ))))