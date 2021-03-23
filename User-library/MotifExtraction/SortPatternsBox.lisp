(in-package :MOTIFEXTRACTION)



;; Box for MotifExtraction
(PWGLdef sort-patterns (  (patternList ()) 
			  (sortBy () (ccl::mk-menu-subview :menu-list '(("Sort by length" nil) ("Sort by frequency" t)))) 
			  (ascendDescend () (ccl::mk-menu-subview :menu-list '(("Descending" nil) ("Ascending" t)))))
                           
"sort-patterns Box.

This box sorts a list of RepeatingPattern Objects, as returned by the motif-extraction box. This box is non-desctructive (it makes a copy of the input list).

INPUTS:
patternList - The list of patterns to sort.
sortBy - determines where to sort the patterns by pattern length or by frequency of occurrence.
ascendDescend - specifies whether the list should be sorted in descending or ascending order

OUTPUTS:
A sorted list of RepeatingPattern Objects.
"
    (:groupings '(1 1 1) :w 0.5) 

    (let ((patternListCopy (copy-list patternList))
	  (key ())
	  (order ())
	  )

      (if key (setq key #'getFreq) (setq key #'getPatternLength) )
      (if ascendDescend (setq order #'<) (setq order #'>) )

      (sort patternListCopy order :key key)
      
    )
)

