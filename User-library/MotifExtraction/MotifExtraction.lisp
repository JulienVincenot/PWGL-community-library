(in-package :MOTIFEXTRACTION)

;; ---------------------
;; find_RP1 (string)
;; ---------------------
;; PARAMETERS:
;; string - the input string (a list) from which to find the 
;;          length 1 repeating patterns
;;
;; DESCRIPTION:
;; Finds all repeating patterns of length 1 
;; in the given string (and their frequencies).
(defun find_RP1 (string)
  (let ((RP1 (make-instance 'RPList)) ; the list of length 1 patterns
       (position 0) ; position counter for the input string
       (newElement ()) ; new RepeatingPattern element to add to RPList
       (foundElement ()); for searching the RP1 list
       (patterns)
       )
    (loop while (not (null string)) do
	 (setf newElement ; make instance of the RepeatingPattern class for the current element of the string
		(make-instance 'RepeatingPattern :pattern (list (car string)) :positions (list position)  )
	       foundElement (findPattern RP1 newElement) ; search for the element
	 )
	 ; check if the element was found
	 (if (null foundElement)
	     ; the element wasn't found
	     (add RP1 newElement) ; add the element to the RPList
	         ; else, the element is already in the list, so add an occurence at this position
	         (setf foundElement (addOccurence foundElement position))
	 )
	 (setq position (1+ position) ; increment the position counter
	       string (cdr string)) ; remove first element from string
    )

    ; remove singletons with frequency 1
    (removeFreq1 RP1)

    RP1 ; return the list of length 1 repeating patterns

  )
)

;; ---------------------
;; find_RP1 (string)
;; ---------------------
;; PARAMETERS:
;; strings - the input strings, a list of lists from which to find the 
;;          length 1 repeating patterns
;;
;; DESCRIPTION:
;; Finds all repeating patterns of length 1 
;; in the given strings (lists). The starting position
;; of each list is the length of all previous lists with a "blank"
;; position inserted in between each.
(defun find_RP1_set (strings)
  (let ((RP1 (make-instance 'RPList)) ; the list of length 1 patterns
       (position 0) ; position counter for the input string
       (newElement ()) ; new RepeatingPattern element to add to RPList
       (foundElement ()); for searching the RP1 list
       (string ()) ; holds a string from the input list of strings
       (patterns)
       )

    (loop while (not (null strings)) do
      (setq string (car strings))
      (loop while (not (null string)) do
	 (setf newElement ; make instance of the RepeatingPattern class for the current element of the string
		(make-instance 'RepeatingPattern :pattern (list (car string)) :positions (list position)  )
	       foundElement (findPattern RP1 newElement) ; search for the element
	 )
	 ; check if the element was found
	 (if (null foundElement)
	     ; the element wasn't found
	     (add RP1 newElement) ; add the element to the RPList
	         ; else, the element is already in the list, so add an occurence at this position
	         (setf foundElement (addOccurence foundElement position))
	 )
	 (setq position (1+ position) ; increment the position counter
	       string (cdr string)) ; remove first element from string
      )
      (setq strings (cdr strings) ; get the next string
	    position (1+ position)) ; increment position once more to create a gap between strings
    )

    ; remove singletons with frequency 1
    ; (removeFreq1 RP1)

    RP1 ; return the list of length 1 repeating patterns

  )
)




(defun testStringJoin (string1 string2 pos1 pos2 order)

  (let ((RP1 (make-instance 'RepeatingPattern :pattern string1 :positions pos1))
	(RP2 (make-instance 'RepeatingPattern :pattern string2 :positions pos2)))
    (stringJoin RP1 RP2 order)
  )
)

;; ---------------------
;; find_RP2K (RP2Kminus1)
;; ---------------------
;; PARAMETERS:
;; RP2Kminus1 - The RPList of RepeatingPatterns of length 2^(k-1).
;; minFreq - the minimum frequency of occurrence of any pattern
;;
;; DESCRIPTION:
;; Finds all repeating patterns of length 2^k, given
;; the list of repeating patterns of length 2^(k-1) 
;; in the given string (and their frequencies). Returns 
;; null if no frequent patterns of length 2^k were formed.
(defun find_RP2K (RP2Kminus1 minFreq)
  (let ((RP2K (make-instance 'RPList)) ; the resulting list of patterns of length 2^k to return
	(tempPatterns1 (getPatterns RP2Kminus1)) ; list of patterns of length 2^(k-1)
	(tempPatterns2 (getPatterns RP2Kminus1)) ; list of patterns of length 2^(k-1)
	(newRP ()) ; new repeating pattern of length 2^k
	)

    ; string-join every pair of repeating patterns in RP2Kminus1
    (loop while (not (null tempPatterns1)) do
	 (loop while (not (null tempPatterns2)) do
	      ; do the string join operation of order 0:
	      (setq newRP (stringJoin (car tempPatterns1) (car tempPatterns2) 0))
	      ; add the new RepeatingPattern if it's frequency is greater than the min. freq
	      (if (>= (getFreq newRP) minFreq) (add RP2K newRP))
	      (setq tempPatterns2 (cdr tempPatterns2)) ; go to next element in tempPatterns2
	 )
	 (setq tempPatterns1 (cdr tempPatterns1)) ; go to next pair of elements
	 (setq tempPatterns2 (getPatterns RP2Kminus1))	 
    )
    RP2K
  )
)



;; ---------------------
;; find_longest_RP (RP2K)
;; ---------------------
;; PARAMETERS:
;; RP2Kminus1 - The RPList of RepeatingPatterns of length 2^(k-1).
;; minFreq - the minimum frequency of occurrence of any pattern
;;
;; DESCRIPTION:
;; Finds all repeating patterns of length 2^k, given
;; the list of repeating patterns of length 2^(k-1) 
;; in the given string (and their frequencies). Returns 
;; null if no frequent patterns of length 2^k were formed.
(defun find_longest_RP (RP2K minFreq)
  (let ((RPL (make-instance 'RPList)) ; the set of the longest repeating patterns
	(tempPatterns1 (getPatterns RP2K)) ; list of patterns of length 2^k
	(tempPatterns2 (getPatterns RP2K)) ; list of patterns of length 2^k
	(newRP ()) ; stores new repeating patterns
	(longestRP ()) ; stores the longest repeating pattern
	(m) ; used in the binary search
	(d) ; used in the binary search
	)

    ; order-m string-join every pair of repeating patterns in RP2K
    (loop while (not (null tempPatterns1)) do
	 (loop while (not (null tempPatterns2)) do

	      (setq m (/ (length (getPattern (car tempPatterns1))) 2) ; the order
		    d m);/ m 2)) ; used in the binary search
	      

	      (loop while (>= d 1) do
	          ; do the string join operation of order 0:
	          (setq newRP (stringJoin (car tempPatterns1) (car tempPatterns2) m))
		   (setq d (/ d 2))

	          ; check if the new RepeatingPattern's frequency is greater than min freq
	          (if (>= (getFreq newRP) minFreq) 
		      (setq longestRP newRP ; store longest RP
		            m (- m d)) ; set m to m + d
		      ; else
		      (setq m (+ m d)) ; set m to m - d
	          )
		  ;(format t "m = ~D, d = ~D~%" m d)
		  
	      )
	      (if (not (null longestRP)) 
		  (add RPL longestRP)
		  ;(if (not (isEmpty longestRP)) (add RPL longestRP))
	      )

	      (setq longestRP ()
	            tempPatterns2 (cdr tempPatterns2)) ; go to next element in tempPatterns2
	 )
	 (setq tempPatterns1 (cdr tempPatterns1)) ; go to next pair of elements
	 (setq tempPatterns2 (getPatterns RP2K))
    )
    RPL
  )
)


;; ---------------------
;; build_RP_Tree (RPLists)
;; ---------------------
;; PARAMETERS:
;; RP2KPatterns - A list of RPLists containing RP[1], RP[2], RP[3]... RP[2^k]
;; RPL - RP[L], the set of longest RepeatingPatterns.
;;
;; DESCRIPTION:
;; Builds an RPTree object given the RepeatingPattern objects in the input list.
;; (defun build_RP_Tree (RP2KPatterns RPL)

;; )


(defun test_find_longest_RP (string)
  (let ((RP1 ())
	(RP2K ())
        (RP2KList ())
	(RPL ()) )
 
    (setq RP1 (find_RP1 string)
	  RP2K RP1)
    (loop while (not (isEmpty RP2K)) do
	 (printList RP2K)
	 (setq  RP2KList (append RP2KList (list RP2K))
                RP2K (find_RP2K (car (last RP2KList))))
	 
    )

    (setq RPL (find_longest_RP (car (last RP2KList))))
    (printList RPL)
  )
)


(defun test_find_RP2K (string)
  (let ((list1 ())) 
    (setq list1 (find_RP1 string))
    (printList list1)
    (setq list1 (find_RP2K list1))
    (printList list1)
    (setq list1 (find_RP2K list1))
    (printList list1)
    (setq list1 (find_RP2K list1))
    (printList list1)
  )
)


;; ---------------------
;; findRepeatingPatterns (strings)
;; ---------------------
;; Finds all the nontrivial repeating patterns in the given 
;; strings, as well as their frequencies of occurrence.
(defun findRepeatingPatterns (strings minFreq)
  (let ((RP1 ())
	(Singletons)
	(RP2K ())
        (RP2KList ())
	(RPL ())
	(tree ()))
 
    (setq RP1 (find_RP1_set strings)
          Singletons (copy-list (getPatterns RP1)))
    (removeMinFreq RP1 minFreq) ; remove singletons with freq. less than minFreq
    (setq RP2K RP1)

    (loop while (not (isEmpty RP2K)) do
	 ;(printList RP2K)
	 (setq  RP2KList (append (list RP2K) RP2KList)
                RP2K (find_RP2K (car RP2KList) minFreq))
    )

    (setq RPL (find_longest_RP (car RP2KList) minFreq))
    ;(printList RPL)

    (setq tree (make-instance 'RPTree))
    (build_RP_Tree tree RP2KList RPL minFreq)
    ;(print "Built RP Tree:")
    ;(traverseAndPrint tree)
    ;(print " ")
    ;(print "Refined RP Tree:")
    (refine_RP_Tree tree)
    ;(traverseAndPrint tree)
    ;(print " ")
    ;(print "Complete tree:")
    (generate_nontrivial_RP tree)
    ;(traverseAndPrint tree)
    (makeRPList tree) ; return the list of RepeatingPatternObjects

    ; return the complete pattern list, the longest patterns (direct children of the root),
    ; and the singletons
    (values (makeRPList tree) (getRootsChildren tree) (mapcar #'(lambda (x) (car (getPattern x)) ) Singletons) )
  )
)

