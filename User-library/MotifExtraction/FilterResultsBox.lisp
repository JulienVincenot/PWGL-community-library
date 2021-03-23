(in-package :MOTIFEXTRACTION)


(defun filterPatternList (patternList
			  minLength useMinLength
			  maxLength useMaxLength
			  minFreq useMinFreq
			  maxFreq useMaxFreq)

  (remove-if #'(lambda (x) (or (and useMinLength (< (getPatternLength x) minLength) )
	                  (and useMaxLength (> (getPatternLength x) maxLength) )
	                  (and useMinFreq (< (getFreq x) minFreq) )
	                  (and useMaxFreq (> (getFreq x) maxFreq) ))
	       ) patternList)
)


;; Box for MotifExtraction
(PWGLdef filter-results (  (patternList ()) 
			   (minLength 0) (useMinLength () (ccl::mk-menu-subview :menu-list '(("off" nil) ("on" t))))
			   (maxLength 0) (useMaxLength () (ccl::mk-menu-subview :menu-list '(("off" nil) ("on" t))))
			   (minFreq 0) (useMinFreq () (ccl::mk-menu-subview :menu-list '(("off" nil) ("on" t))))
			   (maxFreq 0) (useMaxFreq () (ccl::mk-menu-subview :menu-list '(("off" nil) ("on" t))))
			   )
			   ; (string1) (string2) (pos1) (pos2) (order 7) )
                           
"filter-results Box.

Filters a list of RepeatingPattern Objects (as returned by the motif-extraction box) according to the specified parameters. The list can be filtered by setting a minimum/maximum pattern length, and/or a minimum/maximum frequency of occurnce of each RepeatingPattern object.

INPUTS:
patternList - the input list of RepeatingPattern Objects.
minLength - minimum length parameter
useMinLength - determines whether or not to use the minimum length filter.
maxLength - maximum length parameter
useMaxLength - determines whether or not to use the maximum length filter.
minFreq - minumum frequency parameter
useMinFreq - determines whether or not to use the minimum frequency filter.
maxFreq - maximum frequency parameter
useMaxFreq - determines whether or not to use the maximum frequency filter.

OUTPUTS:
A filtered list of RepeatingPattern Objects.
"
    (:groupings '(1 2 2 2 2) :w 0.5  :x-proportions '((1) 
						     (1 (:fix 0.2)) 
						     (1 (:fix 0.2)) 
						     (1 (:fix 0.2)) 
						     (1 (:fix 0.2)) ) )

    (filterPatternList patternList minLength useMinLength
		                   maxLength useMaxLength
		                   minFreq useMinFreq
		                   maxFreq useMaxFreq
				   )
)

