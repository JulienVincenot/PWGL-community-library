(in-package :ccl)

(add-PWGL-user-menu 
   '("Viuhka"
      (:menu-component (mk-viuhka make-viuhka-bpfs))  
      (:menu-component (v-params i-params )); v-empty
      (:menu-component (v-function2))))