(in-package :RSMLIB)


(eval-when (:load-toplevel :execute)
  
  (ccl::add-PWGL-user-menu 
   ' ("RSMlib"
       ("FeatureStractor" (:menu-component (get-face-values s-profile time-point-extractor interonset-interval-vector rhythmSC-values rhythmSC-profile)))
       ("SimilarityMeasures"  (:menu-component (classic-edit-distance weighted-edit-distance RO-distance weighted-RO-distance euclidean-distance interval-difference-vector)))
       ("Generators"  (:menu-component (p-match p-match-scale time-point-translator)))
       ("Weightings"  (:menu-component (weighted-average))))))


