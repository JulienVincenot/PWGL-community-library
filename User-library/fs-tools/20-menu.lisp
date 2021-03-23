
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                    ;;;
;;;                        FS-TOOLS for PWGL                           ;;;
;;;                                                                    ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                                    ;;;
;;;                                                                    ;;;
;;; Copyright (c) 2016, Filippo Saya. All rights reserved.             ;;;
;;;                                                                    ;;;
;;; Redistribution and use in source and binary forms, with or without ;;;
;;; modification, are permitted provided that the following conditions ;;;
;;; are met:                                                           ;;;
;;;                                                                    ;;;
;;;   * Redistributions of source code must retain the above copyright ;;;
;;;     notice, this list of conditions and the following disclaimer.  ;;;
;;;                                                                    ;;;
;;;   * Redistributions in binary form must reproduce the above        ;;;
;;;     copyright notice, this list of conditions and the following    ;;;
;;;     disclaimer in the documentation and/or other materials         ;;;
;;;     provided with the distribution.                                ;;;
;;;                                                                    ;;;
;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED  ;;;
;;; OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED  ;;;
;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ;;;
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY    ;;;
;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL ;;;
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE  ;;;
;;; GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS      ;;;
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,       ;;;
;;; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING          ;;;
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS ;;;
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.       ;;;
;;;                                                                    ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                       ;;;;;;;;;;;;                                                                   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MENU ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                                                       ;;;;;;;;;;;;                                                                   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(in-package :fs-tools)



(ccl::add-PWGL-user-menu 
 '(:menu-component
   ("FS-Tools"
    


    ("Arithmetic"
     ((:menu-component
       (round&remainder))
      (:menu-component
       (list-lcm     
        list-gcd))))
    


    ("Predicate"
     
     ("Equality"
      (all-equalp
       poly-equality
       set-equal))
     
     ("Length"
      (single
       length-p
       eq-length     
       longer))
     
     ("Position"
      (before
       after))
     
     ("Repetition"
      ((:menu-component
        (atleast
         atmost))
       (:menu-component
        (item-repeat-p
         local-repeat-p)))))
    
    
    
    ("List"
     
     ("Tree"
      (deep-mapcar
       apply-tree-struct
       max-depth
       list!!))
     
     ("Index"
      ((:menu-component
        (c-r))
       (:menu-component
        (get-index
         get-first-n-index))     
       (:menu-component
        (get-index-if
         get-first-n-index-if))     
       (:menu-component
        (index-subst
         index-remove
         index-repeat
         mapindex))
       (:menu-component
        (deep-nth
         get-deep-index
         ;get-deep-index-if
         ;get-first-n-deep-index-if
         deep-index-subst
         ;deep-index-remove
         ;mapdeepindex
         ))      
       (:menu-component
        (append-index
         ;append-deep-index
         ))))
     
     ("Modify"
      ((:menu-component
        (fill-nil))
       (:menu-component
        (;deep-remove     ;se non esiste già
         deep-remove-if))
       (:menu-component
        (resize-list
         align-to-min-length
         align-to-max-length))))
     
     ("Selection"
      (first-most
       all-most
       best
       nearest ;spostare in Number?
       ))
     
     ("Group & Split"
      ((:menu-component       
        (group-list-ending-with-element
         group-starting-if
         ;group-ending-if
         group-by-length))     
       (:menu-component       
        (split-if))))
     
     ("Count"
      ((:menu-component
        (count-equals
         count-consec-equals
         count-common-items))       
       (:menu-component
        (item-intervals
         intrv-betw-equals))      
       (:menu-component
        (map-length)))))
     


    ("Number"
     ((:menu-component
      (sort-by-nth
       deep-sort))
      (:menu-component
       (interval
        fit-to-limits
        repeat-until-sum
        cut-on-sum
        integer-scaling/sum
        sum-consec-same-signum-n))      
      (:menu-component
       (around-ser
        join-points))
      (:menu-component
       (min-max-rnd
        rnd-list
        rnd-list-of-lists
        rnd-length-rnd-list-of-lists))))
    


     ("String"
     ((:menu-component
       (nullstring))
      (:menu-component
       (firstring
        restring
        lastring
        butlastring))))
    


    ("Morphology"
     ((:menu-component
       (find-peaks ;spostare in number?
        near-interval-range)) ;;spostare in number? è simile a nearest e sono in 2 menu diversi!!
      (:menu-component
       (bpf->list))))
    
    

    )))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; END OF FILE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


