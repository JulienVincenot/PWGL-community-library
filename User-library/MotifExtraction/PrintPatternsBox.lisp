(in-package :MOTIFEXTRACTION)



;; Box for MotifExtraction
(PWGLdef print-patterns (  (patternList ()) )
                           
"print-patterns Box.

This box prints out a list of RepeatingPattern Objects, as returned by the motif-extraction box, to the standard output stream.

Each RepeatingPattern Object in the input list is printed out in the following form:
{Pattern: (X), Frequency: y, Positions: (Z)}

Where X is the pattern (motif), y is its frequency of occurence, and Z is the list of positions where it occurs.

INPUTS:
patternList - a list of RepeatingPattern Objects.

OUTPUTS:
Prints (to the standard output stream) each RepeatingPattern object in the input list.
"
    (:groupings '(1)) 

    (loop while (not (null patternList)) do
	 (printPattern (car patternList))
	 (format t "~%")
	 (setq patternList (cdr patternList))
    )
)

