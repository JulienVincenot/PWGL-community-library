(in-package :MOTIFEXTRACTION)


;; Box for MotifExtraction
(PWGLdef motif-extraction (  (string0 ()) (minFreq 2) &rest (strings ())  ) 
			   ; (string1) (string2) (pos1) (pos2) (order 7) )
                           
"motif-extraction Box.

This Box extracts all of the non-trivial motifs (sublists) in the given set of input lists that occur minFreq times or more, along with the frequency of occurence of these motifs.

Only non-trivial motifs are returned. A motif is considered trivial if it is a substring of a larger motif with the same frequency of occurence.

The output list of motifs returned is a list of RepeatingPattern Objects. Each RepeatingPattern Object contains the motif itself (a list), its frequency of occurence (an integer), and a list of the starting positions of this motif in the input lists. The starting position of each list is taken as 1+(length of all previous lists).

The raw motif-frequency pairs can be accessed using the convert-to-pattern-freq-pairs box. Any other boxes from this library should be applied to the list of RepeatingPattern objects (rather than converting them to a raw list first).

In addition to outputting the complete list of non-trivial motifs in the form of a list of RepeatingPattern Objects, the box also outputs the set of the longest non-trivial motifs (longest motifs which are not substrings of any other motif), as well as the singletons (a list of elements that occur in the set of input lists at least once). The singletons could be used as the search space in a Genetic Algorithm, for example.

INPUTS:
string0 - the first list from which to look for motifs
strings - the rest of the lists from which to look for motifs
minFreq - the minimum frequency of occurence required for a motif to be considered \"frequent\".

OUTPUTS:
Motifs - The complete set of non-trivial motifs that occur twice or more in input set of lists.
Longest - The set of motifs which are not substrings of any longer motifs.
Singletons - A list containing any elements that occur at least once in the set of input strings.
"
    (:class 'ccl::PWGL-values-box :outputs (list "Motifs" "Longest" "Singletons") :groupings '(2) :x-proportions '((2 1)) :extension-pattern '(1) :w 0.7)
    ;(find_RP1 string)
    ;(printPattern (testStringJoin string1 string2 pos1 pos2 order))
    ;(testBuildTree string1)
    ;(mapcar #'printPattern (findRepeatingPatterns (append (list string0) strings)))
;   (let* ((RPObjects (findRepeatingPatterns (append (list string0) strings)))
;	  (singletons (mapcar #'(lambda (x) (car (getPattern x)) ) (getPatterns (find_RP1_set (append (list string0) strings;)))))
;	   )
     ;  (values RPObjects singletons)
    ;)
    (if (or (not (integerp minFreq)) (< minFreq 2) )
	(error "Error: The minFreq value in the motif-extraction box must be an integer greater than or equal to 2."))
    (findRepeatingPatterns (append (list string0) strings) minFreq)
)

