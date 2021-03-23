(in-package :MOTIFEXTRACTION)


(PWGLdef convert-to-pattern-freq-pairs (  (patternList ()) )
                           
"convert-to-pattern-freq-pairs Box.

Convert a list of RepeatingPattern objects (as returned by motif-extraction) to a raw list of pattern-frequency pairs. This list takes the form:

((pattern1 frequency1) (pattern2 frequency2) ... ) 

INPUTS:
patternList - a list of RepeatingPattern objects

OUTPUTS:
A list of pattern-frequency pairs, in the form shown above.
"
    (:groupings '(1)) 

    (mapcar #'(lambda (x) (list (getPattern x) (getFreq x) )) patternList)
)

