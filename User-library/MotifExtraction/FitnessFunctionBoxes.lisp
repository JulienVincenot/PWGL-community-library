(in-package :MOTIFEXTRACTION)



;; Box for MotifExtraction
(PWGLdef fitness-from-freq ( (patternList ()) 
			     )
                           
    "Fitness function documentation."
    (:groupings '(1)) 

     #'(lambda (x)

	(let ((currPattern ())
	     (fitnessVal 1)
	     )   
      
	(setf fitnessVal 1)
        (loop while (not (null patternList)) do
	   ;(print "candidate: ") (print candidate)
	   (setf currPattern (car patternList))

	   (if (search (getPattern currPattern) x :test #'equal)
	       (setf fitnessVal (+ fitnessVal (getFreq currPattern)) )
	   )

	   (setq patternList (cdr patternList))
        )
        fitnessVal
      )
    )
)

;; Box for MotifExtraction
(PWGLdef fitness-from-freq-length ( (patternList ()) 
			     )
                           
    "Print Patterns Box Documentation."
    (:groupings '(1)) 

     #'(lambda (x)

	(let ((currPattern ())
	     (fitnessVal 1)
	     )     
      
        (loop while (not (null patternList)) do
	   ;(print "candidate: ") (print candidate)
	   (setq currPattern (car patternList))

	   (if (search (getPattern currPattern) x :test #'equal)
	       (setq fitnessVal (+ fitnessVal (getFreq currPattern) (getPatternLength currPattern)) )
	   )

	   (setq patternList (cdr patternList))
        )
        fitnessVal
      )
    )
)

