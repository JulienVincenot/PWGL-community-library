(in-package :RSMLIB)



;; EXTRACTORS

;; face values

(PWGLDef get-face-values ((score ()))
         "Takes the output of a Score Editor and translates the rhythmic information from tree representation to ratio mode. Note that this function returns values without specify if they are rests or notes.
Other possibilities for extract rhythmic information out of a score without the ENP tree structure are using the KSQuant library and GRhythm library."
         ()
  (let ((chords (ccl::collect-ENP-objects score :chord)));I put ccl because it doesnt recognize it
    (loop for c in chords collect (ccl::face-value c))))


;; for use this as input we can use gquantify from GRhythm
;; the output of get-face-values has to be multiplied by 4
;; This function has problems, it doesnt recognize rest, neither does recognize tied notes
;; This object doesnt make any difference between rests and notes




;; profile

(PWGLDef s-profile ((sequence '(60 61 65 63)))
                    "Simple-Profile. Returns a profile out of any numerical input. Assigns 0 to the smaller and n-1 to the bigger value and return a list or this numerical values in the place of appearance. The profile representation of rhythms for analyses purposes was presented in (Marvin 1991).
The output of s-profile can be feed to many of the similarity measures functions of this library like classic-edit-distance, for instance."
                    ()
  (let* ((serie (sort (remove-duplicates (copy-list sequence)) #'<)))
    (loop for x in sequence collect (ccl::position x serie))))






;; time-point


(PWGLDef time-point-extractor ((seq '(1/4 1/8 1/8 1/2))) ;elimino start y lo hago que comience en 0 siempre
         "The time-point set theory was first presented by (Babbitt 1962). (Wuorinen 1979) explains the theory in a more comprehensive way. Basically, out of a given numerical set representing the pitch content of a 12 tone row can be set a rhythmic position within a bar in a given time measure and with a given subdivision definition. The idea can work also with non-12 tone sets, and also can be used in a sort of reverse engine returning a list of positions of the events within a bar. 
Time-point-extractor returns a time-point set out of any given rhythmic design."
         ()
  (pw::g-mod (pw::dx->x 0 (interonset-interval-vector seq)) (denominator (pw::g-min seq))))


;; interonset

(PWGLDef interonset-interval-vector((face-values '(1/4 1/8 1/8 1/2)))
         "Returns an inter-onset interval vector out of a given rhythmic design. Its output is meant to be the input of the Euclidean distance (Gouyon, Fabien & Dixon, Simon 2005) but this vector can be measured with another similarity measures like classic-edit-distance for instance."
         ()
  (pw::g-round (butlast (pw::g/ face-values (pw::g-min face-values)))))



;; Rhythm set class

(PWGLDef rhythmSC-values((seq '(1/4 1/8 1/8 1/2)))
         "Rhythmic Set Class. The Rhythm Set Class theory was presented by (Pearsall 1997) and it is a way of representing rhythmic groups in a similar way to the representations of the intervallic content made by the Pitch Set Class theory, to handle the similarities among groups in the rhythm domain. rhythmSC returns a list of lists where each list displays the number of times the value appears and the value itself."
         ()
  (let* ((list-s (sort (copy-list seq) #'<))
         (list-c (loop for c in (remove-duplicates list-s)
                       collect (count c list-s))))
    (mapcar #'list list-c (remove-duplicates list-s))))



(PWGLDef rhythmSC-profile ((seq '(1/4 1/8 1/8 1/2))) ;; requires s-profile
         "Rhythmic-Set-Class-Profile. The Rhythm Set Class theory was presented by (Pearsall 1997) and it is a way of representing rhythmic groups in a similar way to the representations of the intervallic content made by the Pitch Set Class theory, to handle the similarities among groups in the rhythm domain. rhythmSC-profile returns a list of lists where each list display the number of times the value appears and the profile representation value (Marvin 1991)."
         ()
  (let* ((list-s (sort (copy-list seq) #'<))
         (list-c (loop for c in (remove-duplicates list-s)
                       collect (count c list-s))))
    (mapcar #'list list-c (remove-duplicates (sort (s-profile seq) #'<)))))


;; MEASURES

;; Edit Distance

(PWGLDef classic-edit-distance ((s1 '(1 2 3 4 5)) (s2 '(1 2 3 6 5)))
         "The Edit distance (also known as Hamming distance or Damerau–Levenshtein) is a well-known dissimilarity measure used in many fields from spell checking algorithms to robotic visuals (Extended Hamming Distance), it was presented by    (Damerau, F.J. 1964). David Huron in his HUNDRUM for his simil command uses a version of the Edit distance normalized converting it in a Similarity measure (Orpen&Huron 1992). 
Classic-edit-distance returns a numerical value in which 1.00 stands for a perfect match. The value is calculated according to the number of changes that must be done in the first design in order to make it the same as the second one, having each change a defined penalty value.
Either KSQuant, face-values. enp-tree structure, profile or rSC can be used as input."
         ()
  (let* ((width (1+ (length s1)))
         (height (1+ (length s2)))
         (d (make-array (list height width))))
    (dotimes (x width)
      (setf (aref d 0 x) x))
    (dotimes (y height)
      (setf (aref d y 0) y))
    (dotimes (x (length s1))
      (dotimes (y (length s2))
        (setf (aref d (1+ y) (1+ x))
              (min (1+ (aref d y (1+ x)))
                   (1+ (aref d (1+ y) x))
                   (+ (aref d y x)
                      (if (equal (elt s1 x) (elt s2 y))
                          0
                        1))))))
    (pw::g-round (pw::g-power 0.5772157 (pw::g/ (aref d (1- height) (1- width)) (+ (length s1) (length s2)))) 2)))



(PWGLDef weighted-edit-distance ((s1 '(1 2 3 4 5)) (s2 '(1 2 3 6 5)))
         "The Edit distance (also known as Hamming distance or Damerau–Levenshtein) is a well-known dissimilarity measure used in many fields from spell checking algorithms to robotic visuals (Extended Hamming Distance), it was presented by    (Damerau, F.J. 1964). David Huron in his HUNDRUM for his simil command uses a version of the Edit distance normalized converting it in a Similarity measure (Orpen&Huron 1992). 
Weighted-Edit-Distance, based on the classic-edit-distance, returns a numerical value in which 1.00 stands for a perfect match. The value is calculated according to the number of changes that must be done in the first design in order to make it the same as the second one attending to where the changes happen giving different penalty values.
Either KSQuant, face-values. enp-tree structure, profile or rSC can be used as input."
         ()
  (let* ((width (1+ (length s1)))
         (height (1+ (length s2)))
         (d (make-array (list height width)))
         (differ-pos (ccl::positions T (loop for x in s1
                                             for y in s2
                                             collect (not (equal x y)))))
         (longitud (/ (length s1) 3)))
    (dotimes (x width)
      (setf (aref d 0 x) x))
    (dotimes (y height)
      (setf (aref d y 0) y))
    (dotimes (x (length s1))
      (dotimes (y (length s2))
        (setf (aref d (1+ y) (1+ x))
              (min (1+ (aref d y (1+ x)))
                   (1+ (aref d (1+ y) x))
                   (+ (aref d y x)
                      (if (equal (elt s1 x) (elt s2 y))
                          0
                        1))))))
    (s-normalization s1 s2 (pw::g+ (count T (loop for b in differ-pos collect (> longitud b))) (aref d (1- height) (1- width))))))



;; Ratcliff/Obershelp


(PWGLDef RO-distance ((list1 '(1 7 3 4)) (list2 '(1 2 3 4))) ;  doesnt work properly with profile as input
         "Ratcliff/Obershelp algorithm is used in the field of spell checking and belongs to the subcategory of pattern matching with errors (Black, Paul E. 2004). It is used as an easier and faster to compute spell-checking algorithms. In the rhythmic domain works and it is suitable for compare rhythmic sequences of different length.  It returns 1.00 for a perfect match calculating the number of matching characters divided by the total number of characters in the two strings.
Either KSQuant, face-values. enp-tree structure, profile or rSC can be used as input."
         ()
  (let* ((ll (+ (length list1) (length list1))))
  (pw::g-round (pw::g-scaling (/ (loop while (and list1 list2)
       sum
       (cond 
        ((and (equal (first list1) (first list2))
              (equal (second list1) (second list2)))
         (prog1 2  ;<----- WEIGHT FOR PAIR (1)
           (pop list1) (pop list1)
           (pop list2) (pop list2)))
        ((equal (first list1) (first list2)) 
         (prog1 0.5  ;<----- WEIGHT FOR SINGLE MATCH (0.5)
           (pop list1)
           (pop list2)))
        (T (prog1 0   ;<----- WEIGHT FOR NO MATCH
             (pop list1)
             (pop list2))))) ll) 0.0 1.0 0 1/2) 2)))


(PWGLDef weighted-RO-distance ((list1 '(1 7 3 4)) (list2 '(1 2 3 4))) ;  doesnt work properly with profile as input
         "Ratcliff/Obershelp algorithm is used in the field of spell checking and belongs to the subcategory of pattern matching with errors (Black, Paul E. 2004). It is used as an easier and faster to compute spell-checking algorithms. In the rhythmic domain works and it is suitable for compare rhythmic sequences of different length.  
Weighted-ro-distance, based on ro-distance, it returns 1.00 for a perfect match calculating the number of matching characters divided by the total number of characters in the two strings, considering if the matches are consecutive or not, and the position in the rhythmic design where the matches happen.
Either KSQuant, face-values. enp-tree structure, profile or rSC can be used as input."
         ()
  (let ((coincidencias (remove NIL (loop for x in list1 
                                         append
                                         (loop for y in list2
                                               collect (if (eq x y) (position x list1)))))))
  
 
    (pw::g-round (pw::g-scaling (/ (+     
                                    (* 0.5 (count T (loop for eme in (pw::x->dx coincidencias) collect (= 1 eme)))) ;; ads 0.5 if the coincidences are continuous


                                    (* 0.5 (count T (loop for ene in coincidencias collect (<= ene (/ 1/3 (length list1)))))) ;; adds 0.5 if the coincidences happen within the first 1/3 of the list
                                    (loop for x in list1 
                                          for y in list2
                                          when (equal x y) sum 0.5)) (+ (length list1) (length list2))) 0.0 1.0 0 1/2) 2))) ;ro-d itself



;; Euclidean 

(PWGLDef euclidean-distance ((L1 '(1 7 3 4)) (L2 '(1 2 3 4))) ; doesnt work properly with profile as input
         "The Euclidean distance (Euclidean interval vector distance) is another common similarity measure used in the field of music information retrieval (Gouyon, Fabien & Dixon, Simon 2005), (Paulus, Jouni & Klapuri, Anssi 2002), (London 2005).
Returns a numerical value in which 1.00 stands for a perfect match. This measure calculates the similarity based on the inter-onset intervallic information."
         ()
  (let* ((vector1 (rsmlib::interonset-interval-vector L1))
          (vector2 (rsmlib::interonset-interval-vector L2))
         (L3 (pw::g-power (mapcar #'- vector1 vector2) 2)))
    (s-normalization vector1 vector2 (sqrt (apply #'+ L3)))))

;; Interval difference vector

(PWGLDef interval-difference-vector ((L1 '(1 7 3 4)) (L2 '(1 2 3 4))) ;  doesnt work properly with profile as input
         "This measure is used in melodic similarity research (Gouyon, Fabien & Dixon, Simon 2005), (Paulus, Jouni & Klapuri, Anssi 2002). 
The Interval-difference-vector distance returns a numerical value in which 1.00 stands for a perfect match. This measure calculates the similarity based on the inter-onset intervallic information."
         ()
  (let* ((vector1 (rsmlib::interonset-interval-vector L1))
          (vector2 (rsmlib::interonset-interval-vector L2))
         (maxi-vector (mapcar #'max vector1 vector2))
         (min-vector (mapcar #'min vector1 vector2)))
    (s-normalization vector1 vector2 (pw::g-round (pw::g- (apply #'+ (pw::g/ maxi-vector min-vector)) (length vector1)) 2))))



;; normalization

(defun s-normalization (s1 s2 measure) ; Huron, simil
  (pw::g-round (pw::g-power 0.5772157 (pw::g/ measure (+ (length s1) (length s2)))) 2))



;; GENERATORS


;; profile

(PWGLDef p-match((profile '(0 2 3 1)) (new-sequence'(60 61 63 65)))
         "The same as we can get a profile out of a given rhythmic design, we can in a sort of reverse-engine generate a rhythmic design out of a given profile giving the rhythmic values that will be sorted according to the profile. P-match applies a given profile to a given sequence of the same length."
         ()
  (pw::posn-match (sort new-sequence #'<) profile))


(PWGLDef p-match-scale ((profile '(0 2 3 1)) (new-sequence'(60 61 63 65 66)))
         "This object behaves the same as p-match but this time the profile and the rhythmic sequence don’t have to be of the same length. P-match-scale applies a given profile to a given sequence of any length."
         ()
  (let* ((scaled-profile (pw::g-round (pw::g-scaling profile 0 (1- (length new-sequence)))))
         (copy-new-sequence (copy-list new-sequence)))
    (pw::posn-match (sort copy-new-sequence #'<) scaled-profile)))




;; Time-point

(PWGLDef time-point-translator ((time-point-set '(0 7 8 12 15)) (base-value 1/16) (modulus 16))
         "Generates a rhythmic design out of a given time-point set according to a given base value and a modulus as presented by (Wuorinen 1979)."
         ()
  (pw::g* (pw::g-mod (pw::x->dx time-point-set) modulus) base-value))


;; WEIGHT

(defun weighted-average(&rest list)
  (pw::g-round (apply #'+ (mapcar #'(lambda(x) (apply #'* x)) list)) 2))