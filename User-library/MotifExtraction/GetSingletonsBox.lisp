(in-package :MOTIFEXTRACTION)


;; Box for MotifExtraction
(PWGLdef get-singletons (  (string0 ()) &rest (strings ())  ) 

                           
"get-singletons Box.

This box retrieves only the singletons (elements that occur once or more) from a list of inputs. Note that the motif-extraction box provides this same functionality, however if you wish to only retrieve the singletons (without finding all motifs), this box can be used.

INPUTS:
string0 - the first input list from which to find singletons
strings - the rest of the input lists from which to find singletons

OUTPUTS:
A list containing the singletons found in the input lists.
"
    (:groupings '(1))
    ;(find_RP1 string)
    ;(printPattern (testStringJoin string1 string2 pos1 pos2 order))
    ;(testBuildTree string1)
    ;(mapcar #'printPattern (findRepeatingPatterns (append (list string0) strings)))
    (mapcar #'(lambda (x) (car (getPattern x)) ) (getPatterns (find_RP1_set (append (list string0) strings))))
)

