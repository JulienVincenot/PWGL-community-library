(in-package :MATRIX)

;; define a user menu
(ccl::add-PWGL-user-menu 
 '(:menu-component
   ("Matrices"
    (("PCS"  (s-info n-info s-invar s-transform closed-chains print-partitions))
     ("CMs"  
      (("Generators"  (cm-roman cm-type1a cm-type1b cm-type2 cm-op-cycles cm-chains))
       ("Transformers"  (cm-rot-diag cm-rot-90 cm-swap-rows cm-swap-columns cm-swap-elem cm-swap-all cm-swap-all-seq cm-tni cm-invar-position cm-invar-row cm-invar-column cm-add))
       ("Printers"  (cm-score cm-print cm-norm-print))))))))
