(in-package :FDSDB_XXth_CT)

;; some box examples with value input-boxes, button input-boxes and menu input-boxes

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menu Dodecaphony --> Schoenberg ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(PWGLDef Retrograde ((series 'series))
"Retrograde.
Performs the retrograde of the input series."
() (reverse series))

(PWGLDef Inverse ((series 'series))
"Inverse.
Performs the inverse of the input series."
() (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1)))

(PWGLDef Retrograde-Inverse ((series 'series))
"Retrograde-Inverse.
Performs the retrograde inverse of the input series"
() (reverse (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1))))

(PWGLDef Canonical-Forms ((series 'series)(choose 0))
"Canonical-Forms.
Performs all the canonical forms of the input series. In the second argument 0 = Original, 1 = Retrograde, 2 = Inverse and 3 = Retrograde Inverse."
() (let* ((original series)
(retrograde (reverse series))
(inverse (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1)))
(inverse-retrograde (reverse (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1)))))
(pw::posn-match (list original retrograde inverse inverse-retrograde) choose)))

(PWGLDef Chromatic-Transpositions ((series 'series))
"Chromatic-Transpositions.
Performs all the ascending chromatic transpositions of the input series."
() (pw::cartesian (pw::arithm-ser 0 1 11) (first (list series)) #'+))

(PWGLDef Ordered-Transpositions ((series 'series))
"Ordered-Transpositions.
Performs all the ordered transpositions of the input series. Ordered transpositions are those ones that follow the order of the pitches of the input series. So the first transposition starts from the first pitch of the input series, the second transposition starts from the second pitch of the input series and so on."
() (mapcar #'pw::dx->x series
(repeat 12 (pw::x->dx series))))

(PWGLDef 12Tone-Matrix-PCS ((series 'series))
"12Tone-Matrix-PCS.
Builds the 12Tone matrix using Pitch-classes for representing the pitches.
A 12Tone matrix is a matrix in which on every line, from left to right, you can find Original series (all transpositions), and on every comumn, from top to down, the Inverse ones (all transpositions)."
() (system::matrix-constructor '((1 2 3 4 5 6 7 8 9 10 11 12) (1 2 3 4 5 6 7 8 9 10 11 12)) (pw::g-mod (mapcar #'pw::dx->x (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1)) (repeat 12 (pw::x->dx series))) 12)))

(PWGLDef 12Tone-Matrix-MIDIS ((series 'series))
"12Tone-Matrix-MIDIS.
Builds the 12Tone matrix using MIDI numbers for representing the pitches.
A 12Tone matrix is a matrix in which on every line, from left to right, you can find Original series (all transpositions), and on every comumn, from top to down, the Inverse ones (all transpositions)."
() (system::matrix-constructor '((1 2 3 4 5 6 7 8 9 10 11 12) (1 2 3 4 5 6 7 8 9 10 11 12)) (mapcar #'pw::dx->x (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1)) (repeat 12 (pw::x->dx series)))))

(PWGLDef 12Tone-Matrix-NOTENAME ((series 'series))
"12Tone-Matrix-NOTENAME.
Builds the 12Tone matrix using the name of notes for representing the pitches.
A 12Tone matrix is a matrix in which on every line, from left to right, you can find Original series (all transpositions), and on every comumn, from top to down, the Inverse ones (all transpositions)."
() (system::matrix-constructor '((1 2 3 4 5 6 7 8 9 10 11 12) (1 2 3 4 5 6 7 8 9 10 11 12)) (pw::midi->notename (mapcar #'pw::dx->x (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1)) (repeat 12 (pw::x->dx series))))))

(PWGLDef Random-Series ((series 'series))
"Random-Series.
Create a random 12 tone series."
() (pw::g+ (pw::permut-random '(0 1 2 3 4 5 6 7 8 9 10 11)) 60))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menu Dodecaphony --> Berg ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(PWGLDef All-Interval-Series ()
"All-Interval-Series.
A series that contains all intervals without repetitions.
This example requires some hand modification, putting some pitches into different octave register to have a real All-Interval series"
() (pw::g+ 60 (pw::nth-random (system::pmc '((0) (1 2 3 4 5 7 8 9 10 11) (1 2 3 4 5 7 8 9 10 11) (1 2 3 4 5 7 8 9 10 11) (1 2 3 4 5 7 8 9 10 11) (1 2 3 4 5 7 8 9 10 11) (1 2 3 4 5 7 8 9 10 11) (1 2 3 4 5 7 8 9 10 11) (1 2 3 4 5 7 8 9 10 11) (1 2 3 4 5 7 8 9 10 11) (1 2 3 4 5 7 8 9 10 11) (6)) '((* ?1 (?IF (NOT (MEMBER ?1 (REST RL)))) "no pitch-class dups") (* ?1 ?2 (?IF (system::UNIQUE-INT? (system::MOD12 (- ?2 ?1)) (REST RL) :KEY (FUNCTION system::MOD12))) "no (modulo 12) interval duplicates 2")) :sols-mode :all))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menu Dodecaphony --> Webern ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(PWGLDef 6+6_H+TH ()
"6+6_H+TH.
Two chromatic hexachords, the second a transposition of the first."
() (let ((series (pw::permut-random '(0 1 2 3 4 5)))) (pw::g+ 60
(pw::x-append series (pw::g+ 6 series)))))

(PWGLDef 6+6_H+RH ()
"6+6_H+RH.
Two chromatic hexachords, the second a transposed retrograde of the first."
() (let ((series (pw::permut-random '(0 1 2 3 4 5)))) (pw::g+ 60 (pw::x-append series (reverse (pw::g+ 6 series))))))

(PWGLDef 6+6_H+IH ()
"6+6_H+IH.
Two chromatic hexachords, the second a transposed inverse of the first."
() (let* ((series (pw::permut-random '(0 1 2 3 4 5)))
(inverted (system::substitute-list '(11 10 9 8 7 6) '(0 1 2 3 4 5) series))) (pw::g+ 60 (pw::x-append series inverted))))

(PWGLDef 6+6_H+RIH ()
"6+6_H+RIH.
Two chromatic hexachords, the second a transposed retrograde inverse of the first."
() (let* ((series (pw::permut-random '(0 1 2 3 4 5)))
(inverted (system::substitute-list '(11 10 9 8 7 6) '(0 1 2 3 4 5) series))) (pw::g+ 60 (pw::x-append series (reverse inverted)))))

(PWGLDef H+TH ()
"H+TH.
Two basilarly non-chromatic hexachords, the second a transposition of the first."
() (let 
((series (pw::g+ 60 (pw::flat (pw::permut-random
(list (pw::nth-random '(0 6))
      (pw::nth-random '(1 7))
      (pw::nth-random '(2 8))
      (pw::nth-random '(3 9))
      (pw::nth-random '(4 10))
      (pw::nth-random '(5 11))))))))
(pw::x-append series (pw::g+ 6 series))))

(PWGLDef H+RH ()
"H+RH.
Two basilarly non-chromatic hexachords, the second a transposed retrograde of the first."
() (let 
((series (pw::g+ 60 (pw::flat (pw::permut-random
(list (pw::nth-random '(0 6))
      (pw::nth-random '(1 7))
      (pw::nth-random '(2 8))
      (pw::nth-random '(3 9))
      (pw::nth-random '(4 10))
      (pw::nth-random '(5 11))))))))
(pw::x-append series (reverse (pw::g+ 6 series)))))

(PWGLDef H+IH ()
"H+IH.
Two basilarly non-chromatic hexachords, the second a transposed inversion of the first."
() (let*
((series (pw::permut-random '(0 1 2 3 4 5)))
(inverse (system::substitute-list '(11 10 9 8 7 6) '(0 1 2 3 4 5) series))
(positions (list (pw::nth-random '(0 6))(pw::nth-random '(1 7))(pw::nth-random '(2 8))(pw::nth-random '(3 9))(pw::nth-random '(4 10))(pw::nth-random '(5 11)))))
(pw::posn-match (pw::g+ 60 (pw::x-append series inverse)) (pw::flat (list positions (pw::g-mod (pw::g+ 6 positions) 12))))
))

(PWGLDef H+RIH ()
"H+RIH.
Two basilarly non-chromatic hexachords, the second a transposed retrograde inversion of the first."
() (let*
((series (pw::permut-random '(0 1 2 3 4 5)))
(inverse (system::substitute-list '(11 10 9 8 7 6) '(0 1 2 3 4 5) series))
(positions (list (pw::nth-random '(0 6))(pw::nth-random '(1 7))(pw::nth-random '(2 8))(pw::nth-random '(3 9))(pw::nth-random '(4 10))(pw::nth-random '(5 11)))))
(pw::x-append (first (system::group-lst
(pw::posn-match (pw::g+ 60 (pw::x-append series inverse)) (pw::flat (list positions (pw::g-mod (pw::g+ 6 positions) 12)))) 6))
(reverse (second (system::group-lst
(pw::posn-match (pw::g+ 60 (pw::x-append series inverse)) (pw::flat (list positions (pw::g-mod (pw::g+ 6 positions) 12)))) 6))))
))

(PWGLDef 4+4+4_O+O+O ()
"4+4+4_O+O+O.
Three chromatic tetrachords. Last twos transpositions of the first one."
() (let
((series (pw::permut-random '(0 1 2 3))))
(pw::g+ 60 (pw::x-append series (pw::g+ 4 series) (pw::g+ 8 series)))))

(PWGLDef 4+4+4_O+R+R ()
"4+4+4_O+R+R.
Three chromatic tetrachords, last twos transposed retrograde of the first."
() (let
((series (pw::permut-random '(0 1 2 3))))
(pw::g+ 60 (pw::x-append series (reverse (pw::g+ 4 series)) (reverse (pw::g+ 8 series))))))

(PWGLDef 4+4+4_O+I+I ()
"4+4+4_O+I+I.
Three chromatic tetrachords, last twos transposed inverse of the first."
() (let*
((series (pw::permut-random '(0 1 2 3)))
(inverse (system::substitute-list '(7 6 5 4) '(0 1 2 3) series)))
(pw::g+ 60 (pw::x-append series inverse (pw::g+ 4 inverse)))))

(PWGLDef 4+4+4_O+RI+RI ()
"4+4+4_O+RI+RI.
Three chromatic tetrachords, last twos transposed retrograde inverse of the first."
() (let*
((series (pw::permut-random '(0 1 2 3)))
(inverse (system::substitute-list '(7 6 5 4) '(0 1 2 3) series)))
(pw::g+ 60 (pw::x-append series (reverse inverse) (reverse (pw::g+ 4 inverse))))))

(PWGLDef 4+4+4_O+R+RI ()
"4+4+4_O+R+RI
Three chromatic tetrachords, second one transposed retrograde and last one transposed retrograde inverse of the first."
() (let*
((series (pw::permut-random '(0 1 2 3)))
(inverse (system::substitute-list '(7 6 5 4) '(0 1 2 3) series)))
(pw::g+ 60 (pw::x-append series (pw::g+ 4 (reverse series)) (reverse (pw::g+ 4 inverse))))))

(PWGLDef 4+4+4_O+RI+R ()
"4+4+4_O+RI+R.
Three chromatic tetrachords, second one transposed retrograde inverse and last one transposed retrograde of the first."
() (let*
((series (pw::permut-random '(0 1 2 3)))
(inverse (system::substitute-list '(7 6 5 4) '(0 1 2 3) series)))
(pw::g+ 60 (pw::x-append series (reverse inverse) (reverse (pw::g+ 8 series))))))

(PWGLDef 4+4+4_O+I+R ()
"4+4+4_O+I+R.
Three chromatic tetrachords, the second one transposed inverse and last one transposed retrograde of the first."
() (let*
((series (pw::permut-random '(0 1 2 3)))
(inverse (system::substitute-list '(7 6 5 4) '(0 1 2 3) series)))
(pw::g+ 60 (pw::x-append series inverse (reverse (pw::g+ 8 series))))))

(PWGLDef 4+4+4_O+R+I ()
"4+4+4_O+R+I.
Three chromatic tetrachords, the second one transposed retrograde and last one transposed inverse of the first."
() (let*
((series (pw::permut-random '(0 1 2 3)))
(inverse (system::substitute-list '(7 6 5 4) '(0 1 2 3) series)))
(pw::g+ 60 (pw::x-append series (pw::g+ 4 (reverse series)) (pw::g+ 4 inverse)))))

(PWGLDef 4+4+4_O+I+RI ()
"4+4+4_O+I+RI.
Three chromatic tetrachords, the second one transposed inverse and last one transposed retrograde inverse of the first."
() (let*
((series (pw::permut-random '(0 1 2 3)))
(inverse (system::substitute-list '(7 6 5 4) '(0 1 2 3) series)))
(pw::g+ 60 (pw::x-append series inverse (reverse (pw::g+ 4 inverse))))))

(PWGLDef 4+4+4_O+RI+I ()
"4+4+4_O+RI+I.
Three chromatic tetrachords, the second one transposed retrograde inverse and last one transposed inverse of the first."
() (let*
((series (pw::permut-random '(0 1 2 3)))
(inverse (system::substitute-list '(7 6 5 4) '(0 1 2 3) series)))
(pw::g+ 60 (pw::x-append series (reverse inverse) (pw::g+ 4 inverse)))))

(PWGLDef Te+TTe+TTe ()
"Te+TTe+TTe.
Three basilarly non-chromatic tetrachords. Last twos are transpositions of the first one."
() (let 
((series (pw::g+ 60 (pw::flat (pw::permut-random
(list (pw::nth-random '(0 4 8))
      (pw::nth-random '(1 5 9))
      (pw::nth-random '(2 6 10))
      (pw::nth-random '(3 7 11))))))))
(pw::x-append series (pw::g+ 4 series) (pw::g+ 8 series))))

(PWGLDef Te+TRTe+TRTe ()
"Te+TRTe+TRTe.
Three basilarly non-chromatic tetrachords. Last twos are transposed retrograde of the first."
() (let 
((series (pw::g+ 60 (pw::flat (pw::permut-random
(list (pw::nth-random '(0 4 8))
      (pw::nth-random '(1 5 9))
      (pw::nth-random '(2 6 10))
      (pw::nth-random '(3 7 11))))))))
(pw::x-append series (reverse (pw::g+ 4 series)) (reverse (pw::g+ 8 series)))))

(PWGLDef Te+TRTe+TTe ()
"Te+TRTe+TTe.
Three basilarly non-chromatic tetrachords. Last twos are transposed retrograde and transposed original of the first."
() (let 
((series (pw::g+ 60 (pw::flat (pw::permut-random
(list (pw::nth-random '(0 4 8))
      (pw::nth-random '(1 5 9))
      (pw::nth-random '(2 6 10))
      (pw::nth-random '(3 7 11))))))))
(pw::x-append series (reverse (pw::g+ 4 series)) (pw::g+ 8 series))))

(PWGLDef Te+TTe+TRTe ()
"Te+TTe+TRTe.
Three basilarly non-chromatic tetrachords. Last twos are transposed origiinal and transposed retrograde of the first."
() (let 
((series (pw::g+ 60 (pw::flat (pw::permut-random
(list (pw::nth-random '(0 4 8))
      (pw::nth-random '(1 5 9))
      (pw::nth-random '(2 6 10))
      (pw::nth-random '(3 7 11))))))))
(pw::x-append series (pw::g+ 4 series) (reverse (pw::g+ 8 series)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menu Dodecaphony --> Babbitt ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:

(PWGLDef Babbitt-bichord-ints ((series 'series))
"Babbitt-bichord-ints.
Counts the interval of contiguous bichords (odd and even bichords)."
()
(list (pw::posn-match (pw::x->dx series) (pw::arithm-ser 0 2 11))
(pw::posn-match (pw::x->dx series) (pw::arithm-ser 1 2 10))))

(PWGLDef Babbitt-Rule1 ((series 'series)(first_bichord 0)(second_bichord 0))
"Babbitt-Rule1.
See tutorial."
(:groupings '(1 1 1))
(list (pw::g+ series (- (pw::posn-match series first_bichord) (pw::posn-match series second_bichord)))
(pw::g+ series (- 12 (- (pw::posn-match series first_bichord) (pw::posn-match series second_bichord))))))

(PWGLDef Babbitt-Rule2 ((series 'series)(interval 1))
"Babbitt-Rule2.
See tutorial."
(:groupings '(1 1))
(list
(pw::g+ interval series)
(pw::g+ (- 12 interval) series)
(pw::g+ 60 (intersection (first (pw::g-mod (system::group-lst series 6) 12)) (second (pw::g-mod (system::group-lst (pw::g+ interval series) 6) 12))))
(pw::g+ 60 (intersection (first (pw::g-mod (system::group-lst series 6) 12)) (second (pw::g-mod (system::group-lst (pw::g+ (- 12 interval) series) 6) 12))))
(pw::g+ 60 (intersection (second (pw::g-mod (system::group-lst series 6) 12)) (first (pw::g-mod (system::group-lst (pw::g+ interval series) 6) 12))))
(pw::g+ 60 (intersection (second (pw::g-mod (system::group-lst series 6) 12)) (first (pw::g-mod (system::group-lst (pw::g+ (- 12 interval) series) 6) 12))))
))

(PWGLDef Babbitt-Rule3 ((series 'series)(interval 1))
"Babbitt-Rule3.
See tutorial."
(:groupings '(1 1))
(list series (pw::g+ (pw::g- (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1)) 12) interval)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menu Serial Post Serial Music --> Babbitt ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;;;;;;;

(PWGLDef Time-points ((series 'series) (factor 0.25))
"Time-points.
Converts a series into a rhythmic series according to the 'time-points' Babbitt's technique as described in Brian Bemman and David Meredith paper."
() (let*
((intseries (pw::x->dx (subst 12 0 (pw::x-append series (car series)))))
(durs (loop for i in intseries collect (if (< i 0) (+ 12 i) i)))
(durs2 (pw::g* durs factor))
)
(ksquant::simple2score (ksquant::pitches-durs2simple 60 durs2))
))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menu Serial Post Serial Music --> Boulez ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;;;;;;


(PWGLDef O-Matrix-Pitches ((series 'series))
"O-Matrix-Pitches.
Converts a series into a matrix of original series ordered transpositions, in which every pitch is represented by its pitch-class number plus one."
() (system::matrix-constructor '((1 2 3 4 5 6 7 8 9 10 11 12) (1 2 3 4 5 6 7 8 9 10 11 12))
(pw::g+ (pw::g-mod (mapcar #'pw::dx->x series
(repeat 12 (pw::x->dx series))) 12) 1)))

(PWGLDef O-Matrix-Pitches-Mod ((series 'series)(module 1))
"O-Matrix-Pitches-Mod.
Converts a series into a matrix of original series ordered transpositions, in which every pitch is represented by its pitch-class number plus one, according to the module value choosen."
() (system::matrix-constructor '((1 2 3 4 5 6 7 8 9 10 11 12) (1 2 3 4 5 6 7 8 9 10 11 12))
(pw::g+ (pw::g-mod (mapcar #'pw::dx->x series
(repeat 12 (pw::x->dx series))) module) 1)))

(PWGLDef I-Matrix-Pitches ((series 'series))
"I-Matrix-Pitches.
Converts a series into a matrix of iniverse series ordered transpositions, in which every pitch is represented by its pitch-class number plus one."
()(system::matrix-constructor '((1 2 3 4 5 6 7 8 9 10 11 12) (1 2 3 4 5 6 7 8 9 10 11 12))
(pw::g+ (pw::g-mod (mapcar #'pw::dx->x (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1)) (repeat 12 (pw::x->dx (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1))))) 12) 1)))

(PWGLDef I-Matrix-Pitches-Mod ((series 'series)(module 1))
"I-Matrix-Pitches-Mod.
Converts a series into a matrix of inverse series ordered transpositions, in which every pitch is represented by its pitch-class number plus one, according to the module value choosen."
() (system::matrix-constructor '((1 2 3 4 5 6 7 8 9 10 11 12) (1 2 3 4 5 6 7 8 9 10 11 12))
(pw::g+ (pw::g-mod (mapcar #'pw::dx->x (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1)) (repeat 12 (pw::x->dx (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1))))) module) 1)))

(PWGLDef O-Matrix-Durs ((series 'series)(factor 1)(scope 'scope))
"O-Matrix-Durs.
Converts the original series matrix into 12 corresponding series of durations, according to the selected factor, where 1 = quarter, 0.5 or 1/2 = quaver and so on."
() (pw::gquantify (pw::g*
(pw::g+ (pw::g-mod (mapcar #'pw::dx->x series (repeat 12 (pw::x->dx series))) 12) 1) factor) scope))

(PWGLDef O-Matrix-Durs-Mod ((series 'series)(factor 1)(module 1)(scope 'scope))
"O-Matrix-Durs-Mod.
Converts the original series matrix into 12 corresponding series of durations, according to the selected factor, where 1 = quarter, 0.5 or 1/2 = quaver and so on. The values are modified by the selected module value."
(:groupings '(2 2))
() (pw::gquantify (pw::g* (pw::g+ (pw::g-mod (mapcar #'pw::dx->x series
(repeat 12 (pw::x->dx series))) module) 1) factor) scope))

(PWGLDef I-Matrix-Durs ((series 'series)(factor 1)(scope 'scope))
"I-Matrix-Durs.
Converts the inverse series matrix into 12 corresponding series of durations, according to the selected factor, where 1 = quarter, 0.5 or 1/2 = quaver and so on."
() (pw::gquantify (pw::g* (pw::g+ (pw::g-mod (mapcar #'pw::dx->x (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1)) (repeat 12 (pw::x->dx (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1))))) 12) 1) factor) scope))

(PWGLDef I-Matrix-Durs-Mod ((series 'series)(factor 1)(module 1)(scope 'scope))
"I-Matrix-Durs-Mod.
Converts the inverse series matrix into 12 corresponding series of durations, according to the selected factor, where 1 = quarter, 0.5 or 1/2 = quaver and so on. The values are modified by the selected module value."
(:groupings '(2 2))
() (pw::gquantify (pw::g* (pw::g+ (pw::g-mod (mapcar #'pw::dx->x (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1)) (repeat 12 (pw::x->dx (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1))))) module) 1) factor) scope))

(PWGLDef O-Matrix-Amps ((series 'series))
"O-Matrix-Amps.
Converts the original series matrix into amplitude series, according to the ordered values pppp, ppp, pp, p, quasi p, mp, mf, quasi f, f, ff, fff, ffff."
() (system::matrix-constructor '((1 2 3 4 5 6 7 8 9 10 11 12) (1 2 3 4 5 6 7 8 9 10 11 12)) (system::group-lst (system::substitute-list '(PPPP PPP PP P QUASI-P MP MF QUASI-F F FF FFF FFFF) '(1 2 3 4 5 6 7 8 9 10 11 12) (pw::flat (pw::g+ (pw::g-mod (mapcar #'pw::dx->x series (repeat 12 (pw::x->dx series))) 12) 1))) 12)))

(PWGLDef O-Matrix-Amps-Mod ((series 'series)(module 1))
"O-Matrix-Amps-Mod.
Converts the original series matrix into amplitude series, according to the ordered values pppp, ppp, pp, p, quasi p, mp, mf, quasi f, f, ff, fff, ffff. The values are modified by the selected module value."
() (system::matrix-constructor '((1 2 3 4 5 6 7 8 9 10 11 12) (1 2 3 4 5 6 7 8 9 10 11 12)) (system::group-lst (system::substitute-list '(PPPP PPP PP P QUASI-P MP MF QUASI-F F FF FFF FFFF) '(1 2 3 4 5 6 7 8 9 10 11 12) (pw::flat (pw::g+ (pw::g-mod (mapcar #'pw::dx->x series (repeat 12 (pw::x->dx series))) module) 1))) 12)))

(PWGLDef I-Matrix-Amps ((series 'series))
"I-Matrix-Amps:
Converts the inverse series matrix into amplitude series, according to the ordered values pppp, ppp, pp, p, quasi p, mp, mf, quasi f, f, ff, fff, ffff."
() (system::matrix-constructor '((1 2 3 4 5 6 7 8 9 10 11 12) (1 2 3 4 5 6 7 8 9 10 11 12)) (system::group-lst (system::substitute-list '(PPPP PPP PP P QUASI-P MP MF QUASI-F F FF FFF FFFF) '(1 2 3 4 5 6 7 8 9 10 11 12) (pw::flat (pw::g+ (pw::g-mod (mapcar #'pw::dx->x (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1)) (repeat 12 (pw::x->dx (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1))))) 12) 1))) 12)))

(PWGLDef I-Matrix-Amps-Mod ((series 'series)(module 1))
"I-Matrix-Amps-Mod.
Converts the original series matrix into amplitude series, according to the ordered values pppp, ppp, pp, p, quasi p, mp, mf, quasi f, f, ff, fff, ffff. The values are modified by the selected module value."
() (system::matrix-constructor '((1 2 3 4 5 6 7 8 9 10 11 12) (1 2 3 4 5 6 7 8 9 10 11 12)) (system::group-lst (system::substitute-list '(PPPP PPP PP P QUASI-P MP MF QUASI-F F FF FFF FFFF) '(1 2 3 4 5 6 7 8 9 10 11 12) (pw::flat (pw::g+ (pw::g-mod (mapcar #'pw::dx->x (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1)) (repeat 12 (pw::x->dx (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1))))) module) 1))) 12)))

(PWGLDef Generic-mapping ((series 'series)(user-list 'user-list))
"Generic-mapping.
Maps the series matrix into a user defined series of values."
() (system::matrix-constructor '((1 2 3 4 5 6 7 8 9 10 11 12) (1 2 3 4 5 6 7 8 9 10 11 12))
(system::group-lst (system::substitute-list user-list '(1 2 3 4 5 6 7 8 9 10 11 12) (pw::flat (pw::g+ (pw::g-mod (mapcar #'pw::dx->x series (repeat 12 (pw::x->dx series))) 12) 1))) 12)))

(PWGLDef Generic-mapping-Mod ((series 'series)(user-list 'user-list)(module 1))
"Generic-mapping-Mod.
Maps the series matrix into a user defined series of values with module restrictions."
() (system::matrix-constructor '((1 2 3 4 5 6 7 8 9 10 11 12) (1 2 3 4 5 6 7 8 9 10 11 12)) (system::group-lst (system::substitute-list user-list '(1 2 3 4 5 6 7 8 9 10 11 12) (pw::flat (pw::g+ (pw::g-mod (mapcar #'pw::dx->x (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1)) (repeat 12 (pw::x->dx (pw::dx->x (first series) (pw::g* (pw::x->dx series) -1))))) module) 1))) 12)))

(PWGLDef Demultiplied-Rhythms ((proportions 'proportions)(beat-length 1)(scope 'scope))
"Demultiplied-Rhythms.
Generate 4 levels of demultiplied rhythms according to the same proportions. See tutorial."
(:groupings '(1 1 1))
() (pw::gquantify
(list
;; livello 1
(pw::flat (pw::cartesian proportions (/ beat-length (first (last (pw::cumul-sum proportions)))) #'*)) 
;; livello 2
(pw::flat (iterate (for i in (pw::flat (pw::cartesian proportions (/ beat-length (first (last (pw::cumul-sum proportions)))) #'*))) (collect (pw::flat (pw::cartesian proportions (/ i (first (last (pw::cumul-sum proportions)))) #'*)))))
;; livello 3
(pw::flat (iterate (for i in (pw::flat (iterate (for i in (pw::flat (pw::cartesian proportions (/ beat-length (first (last (pw::cumul-sum proportions)))) #'*))) (collect (pw::flat (pw::cartesian proportions (/ i (first (last (pw::cumul-sum proportions)))) #'*)))))) (collect (pw::flat (pw::cartesian proportions (/ i (first (last (pw::cumul-sum proportions)))) #'*)))))
;; livello 4
(pw::flat (iterate (for i in (pw::flat (iterate (for i in (pw::flat (iterate (for i in (pw::flat (pw::cartesian proportions (/ beat-length (first (last (pw::cumul-sum proportions)))) #'*))) (collect (pw::flat (pw::cartesian proportions (/ i (first (last (pw::cumul-sum proportions)))) #'*)))))) (collect (pw::flat (pw::cartesian proportions (/ i (first (last (pw::cumul-sum proportions)))) #'*)))))) (collect (pw::flat (pw::cartesian proportions (/ i (first (last (pw::cumul-sum proportions)))) #'*)))))) scope))

(PWGLDef Demultiplied-Rhythms2 ((proportions1 '(2 3))(proportions2 '(3 2))(proportions3 '(1 2 1))(proportions4 '(2 2))(beat-length 1)(scope 'scope))
"Demultiplied-Rhythms2.
Generate 4 levels of demultiplied rhythms according to the selected proportions. See tutorial."
(:groupings '(1 1 1 1 1 1))
() (pw::gquantify (list
;; livello 1
(pw::flat (pw::cartesian proportions1 (/ beat-length (first (last (pw::cumul-sum proportions1)))) #'*))
;; livello 2
(pw::flat (iterate
(for i in (pw::flat (pw::cartesian proportions1 (/ beat-length (first (last (pw::cumul-sum proportions1)))) #'*)))
(collect (pw::flat (pw::cartesian proportions2 (/ i (first (last (pw::cumul-sum proportions2)))) #'*)))))
;; livello 3
(pw::flat (iterate
(for i in
(pw::flat (iterate
(for i in (pw::flat (pw::cartesian proportions1 (/ beat-length (first (last (pw::cumul-sum proportions1)))) #'*)))
(collect (pw::flat (pw::cartesian proportions2 (/ i (first (last (pw::cumul-sum proportions2)))) #'*))))))
(collect (pw::flat (pw::cartesian proportions3 (/ i (first (last (pw::cumul-sum proportions3)))) #'*)))))
;; livello 4
(pw::flat (iterate
(for i in
(pw::flat (iterate
(for i in
(pw::flat (iterate
(for i in (pw::flat (pw::cartesian proportions1 (/ beat-length (first (last (pw::cumul-sum proportions1)))) #'*)))
(collect (pw::flat (pw::cartesian proportions2 (/ i (first (last (pw::cumul-sum proportions2)))) #'*))))))
(collect (pw::flat (pw::cartesian proportions3 (/ i (first (last (pw::cumul-sum proportions3)))) #'*))))))
(collect (pw::flat (pw::cartesian proportions4 (/ i (first (last (pw::cumul-sum proportions4)))) #'*)))))
) scope)
)

(PWGLDef Chord-Multiplication ((chord1 'chord1)(chord2 'chord2))
"Chord-Multiplication.
Famous Boulez's multiplication of chords. See tutorial."
() (pw::rem-dups (pw::sort-list (pw::flat (iterate (for i in chord2) (collect (pw::dx->x i (pw::x->dx chord1))))))))

(PWGLDef PDA ((initial-pitch 60)(base-dur 1/4))
"PDA.
Pitch-Duration-Association. 12 chromatic scales are associated to the same 12 chromatic durations with unit the selected base duration. See tutorial.
BUGS: on some system this function has reported errors."
() (let*
((pitches (iterate (for i from initial-pitch to (+ 11 initial-pitch)) (collect (pw::dx->x i (pw::create-list 11 1)))))
(durs (repeat 11 (pw::g* base-dur (pw::arithm-ser 1 1 11)))))
(ksquant::simple2score (iterate (for a in pitches) (for b in durs) (collect (ksquant::simple-change-type :part (ksquant::pitches-durs2simple a b)))))))

(PWGLDef Melody-expansion ((chord 'chord)(factor 1))
"Melody-expansion.
Melody intervals proprotional expansion (or reduction)."
() (pw::approx-midi (pw::dx->x (first chord) (pw::g* (pw::x->dx chord) factor)) 4))

(PWGLDef Derive ((chord 'chord))
"Derive.
Pitches development used in Boulez's Derive. See tutorial."
() (iterate
(for a in (iterate
(for i in  (pw::arithm-ser 0 1 (- (length chord) 1)))
(collect (pw::permut-circ chord i))))
(for b in (pw::cumul-sum (pw::x-append 0 (pw:x->dx chord))))
(collect (pw::g- a b)))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menu Serial Post Serial Music --> Carter ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;;;;;;

(PWGLDef Symmetric-Chords ((initial-pch 60))
"Symmetric-Chords.
Creates symmetric chords like in Carter's Night Fantasies. That is chords that have inverted intervals, ascending and descending from a tritone interval. The tritone interval is given by initial pitch and six halftones up."
() (let*
((permutazioni (system::all-permutations '(1 2 3 4 5)))
(serie1 (pw::nth-random permutazioni))
(serie2 (iterate (for i in serie1) (collect (- 12 i))))
(serie3 (pw::mat-trans (list serie1 serie2)))
(serie4 (iterate (for i in serie3) (collect (pw::permut-random i))))
(serie5 (pw::mat-trans serie4))
(serie6 (first serie5))
(serie7 (iterate (for i in (second serie5)) (collect (* -1 i)))))
(pw::x-append (pw::dx->x initial-pch serie7) (pw::dx->x (+ 6 initial-pch) serie6))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menu Serial Post Serial Music --> Ligeti ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;;;;;;

(PWGLDef LuxAeterna ((num-notes 20)(num-voices 4)(maxdur 40)(mindur 10))
"LuxAeterna.
Creates a texture similar to Lux Aeterna."
() (let*
((melodia (pw::dx->x 65 (iterate (for i from 1 to num-notes) (collect (pw::nth-random '(-2 -1 1 2))))))
(durate (iterate (for i from 1 to num-voices) (collect (iterate (for i from 1 to num-notes) (collect (pw::g/ (pw::nth-random (pw::arithm-ser maxdur -1 mindur)) 10)))))))
(ksquant::simple2score (iterate (for i in durate) (collect (ksquant::simple-change-type :part (ksquant::pitches-durs2simple melodia i)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menu Serial Post Serial Music --> Maderna ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;;;;;;;

(PWGLDef Latin-Squares-3X3 ((seed1 1)(seed2 2)(seed3 8))
"Latin-Squares-3X3.
Builds a random Latin Square of dimension 3X3."
() (let*
((k (pw::g-random seed1 seed2))
(n (+ (* 4 k) seed3)))
(system::matrix-constructor '((- - -)(- - -)) (list (- n k)(+ n (* 4 k))(- n (* 3 k))(- n (* 2 k)) n (+ n (* 2 k))(+ n (* 3 k))(- n  (* 4 k))(+ n k)))))

(PWGLDef Latin-Squares-4X4 ((seed1 1)(seed2 2)(seed3 8)(seed4 2))
"Latin-Squares-4X4.
Builds a random Latin Square of dimension 4X4."
() (let*
((k (pw::g-random seed1 seed2))
(n1 (+ (* 7 k) seed3))
(n2 (+ (* 7 k) seed4)))
(system::matrix-constructor '((- - - -)(- - - -))
(list
(+ n2 (* 4 k))(- n1 (* 5 k))(- n1 (* 6 k))(+ n2 (* 7 k))
 n1 (+ n2 (* 1 k))(+ n2 (* 2 k))(- n1 (* 3 k))
(+ n2 (* 3 k))(- n1 (* 2 k))(- n1 (* 1 k)) n2 
(- n1 (* 7 k))(+ n2 (* 6 k))(+ n2 (* 5 k))(- n1 (* 4 k))))))

(PWGLDef Latin-Squares-5X5 ((seed1 1)(seed2 2)(seed3 5))
"Latin-Squares-5X5.
Builds a random Latin Square of dimension 5X5."
() (let*
((k (pw::g-random seed1 seed2))
(n (+ (* 12 k) seed3)))
(system::matrix-constructor '((- - - - -)(- - - - -))
(list
(- n (* 2 k))(+ n (* 11 k))(- n (* 6 k))(+ n (* 7 k))(- n (* 10 k))
(- n (* 9 k))(- n  (* 1 k))(+ n  (* 12 k))(- n  (* 5 k))(+ n  (* 3 k))
(+ n  (* 4 k))(- n  (* 8 k)) n (+ n  (* 8 k))(- n  (* 4 k))
(- n  (* 3 k))(+ n  (* 5 k))(- n  (* 12 k))(+ n  (* 1 k))(+ n  (* 9 k))
(+ n  (* 10 k))(- n  (* 7 k))(+ n  (* 6 k))(- n  (* 11 k))(+ n  (* 2 k))))))

(PWGLDef Latin-Squares-6X6 ((seed1 1)(seed2 2)(seed3 1)(seed4 2))
"Latin-Squares-6X6.
Builds a random Latin Square of dimension 6X6."
() (let*
((k (pw::g-random seed1 seed2))
(n1 (+ (* 17 k) seed3))
(n2 (+ (* 17 k) seed4)))
(system::matrix-constructor '((- - - - - -)(- - - - - -))
(list
(+ n2 (* 12 k))(- n1 (* 13 k))(- n1 (* 14 k))(+ n2 (* 14 k))(- n1 (* 16 k))(+ n2 (* 17 k))
(- n1 (* 6 k))(- n1 (* 7 k))(+ n2 (* 8 k))(+ n2 (* 9 k))(- n1 (* 10 k))(+ n2 (* 6 k))
n1 (+ n2 (* 1 k))(+ n2 (* 2 k))(+ n2 (* 3 k))(- n1 (* 1 k))(- n1 (* 5 k))
n2 (- n1 (* 4 k))(- n1 (* 3 k))(- n1 (* 2 k))(+ n2 (* 4 k))(+ n2 (* 5 k))
(+ n2 (* 11 k))(+ n2 (* 10 k))(- n1 (* 9 k))(- n1 (* 8 k))(+ n2 (* 7 k))(- n1 (* 11 k))
(- n1 (* 17 k))(+ n2 (* 13 k))(+ n2 (* 15 k))(- n1 (* 15 k))(+ n2 (* 16 k))(- n1 (* 12 k))))))

(PWGLDef Latin-Squares-7X7 ((seed1 1)(seed2 2)(seed3 3))
"Latin-Squares-7X7.
Builds a random Latin Square of dimension 7X7."
() (let*
((k (pw::g-random seed1 seed2))
(n (+ (* 24 k) seed3)))
(system::matrix-constructor '((- - - - - - -)(- - - - - - -))
(list
(- n (* 3 k))(+ n (* 22 k))(- n (* 9 k))(+ n (* 16 k))(- n (* 15 k))(+ n (* 10 k))(- n (* 21 k))
(- n (* 20 k))(- n (* 2 k))(+ n (* 23 k))(- n (* 8 k))(+ n (* 17 k))(- n (* 14 k))(+ n (* 4 k))
(+ n (* 5 k))(- n (* 19 k))(- n (* 1 k))(+ n (* 24 k))(- n (* 7 k))(+ n (* 11 k))(- n (* 13 k))
(- n (* 12 k))(+ n (* 6 k))(- n (* 18 k)) n (+ n (* 18 k))(- n (* 6 k))(+ n (* 12 k))
(+ n (* 13 k))(- n (* 11 k))(+ n (* 7 k))(- n (* 24 k))(+ n (* 1 k))(+ n (* 19 k))(- n (* 5 k))
(- n (* 4 k))(+ n (* 14 k))(- n (* 17 k))(+ n (* 8 k))(- n (* 23 k))(+ n (* 2 k))(+ n (* 20 k))
(+ n (* 21 k))(- n (* 10 k))(+ n (* 15 k))(+ n (* 16 k))(+ n (* 9 k))(- n (* 22 k))(+ n (* 3 k))))))

(PWGLDef Latin-Squares-8X8 ((seed1 1)(seed2 2)(seed3 1)(seed4 3))
"Latin-Squares-8X8.
Builds a random Latin Square of dimension 8X8."
() (let*
((k (pw::g-random seed1 seed2))
(n1 (+ (* 31 k) seed3))
(n2 (+ (* 31 k) seed4)))
(system::matrix-constructor '((- - - - - - - -)(- - - - - - - -))
(list
(+ n2 (* 24 k))(- n1 (* 25 k))(- n1 (* 26 k))(+ n2 (* 27 k))(+ n2 (* 28 k))(- n1 (* 29 k))(- n1 (* 30 k))(+ n2 (* 31 k))
(- n1 (* 16 k))(+ n2 (* 17 k))(+ n2 (* 18 k))(- n1 (* 19 k))(- n1 (* 20 k))(+ n2 (* 21 k))(+ n2 (* 22 k))(- n1 (* 23 k))
(+ n2 (* 8 k))(- n1 (* 9 k))(- n1 (* 10 k))(+ n2 (* 11 k))(+ n2 (* 12 k))(- n1 (* 13 k))(- n1 (* 14 k))(+ n2 (* 15 k))
n1 (+ n2 (* 1 k))(+ n2 (* 2 k))(- n1 (* 3 k))(- n1 (* 4 k))(+ n2 (* 5 k))(+ n2 (* 6 k))(- n1 (* 7 k))
(+ n2 (* 7 k))(- n1 (* 6 k))(- n1 (* 5 k))(+ n2 (* 4 k))(+ n2 (* 3 k))(- n1 (* 2 k))(- n1 (* 1 k)) n2
(- n1 (* 15 k))(+ n2 (* 14 k))(+ n2 (* 13 k))(- n1 (* 12 k))(- n1 (* 11 k))(+ n2 (* 10 k))(+ n2 (* 9 k))(- n1 (* 23 k))
(+ n2 (* 23 k))(- n1 (* 22 k))(- n1 (* 21 k))(+ n2 (* 10 k))(+ n2 (* 19 k))(- n1 (* 18 k))(- n1 (* 17 k))(+ n2 (* 16 k))
(- n1 (* 31 k))(+ n2 (* 30 k))(+ n2 (* 29 k))(- n1 (* 28 k))(- n1 (* 27 k))(+ n2 (* 26 k))(+ n2 (* 25 k))(- n1 (* 24 k))))))

(PWGLDef Latin-Squares-9X9 ((seed1 1)(seed2 2)(seed3 3))
"Latin-Squares-9X9.
Builds a random Latin Square of dimension 9X9."
() (let*
((k (pw::g-random seed1 seed2))
(n (+ (* 40 k) seed3)))
(system::matrix-constructor '((- - - - - - - - -)(- - - - - - - - -))
(list
(- n (* 4 k))(+ n (* 37 k))(- n (* 12 k))(+ n (* 29 k))(- n (* 20 k))(+ n (* 21 k))(- n (* 28 k))(+ n (* 13 k))(- n (* 36 k))
(- n (* 35 k))(- n (* 3 k))(+ n (* 38 k))(- n (* 11 k))(+ n (* 30 k))(- n (* 19 k))(+ n (* 22 k))(- n (* 27 k))(+ n (* 5 k))
(+ n (* 6 k))(- n (* 34 k))(- n (* 2 k))(+ n (* 39 k))(- n (* 10 k))(+ n (* 31 k))(- n (* 18 k))(+ n (* 14 k))(- n (* 26 k))
(- n (* 25 k))(+ n (* 7 k))(- n (* 33 k))(- n (* 1 k))(+ n (* 40 k))(- n (* 9 k))(+ n (* 23 k))(- n (* 17 k))(+ n (* 15 k))
(+ n (* 16 k))(- n (* 24 k))(+ n (* 8 k))(- n (* 23 k)) n (+ n (* 32 k))(- n (* 8 k))(+ n (* 24 k))(- n (* 16 k))
(- n (* 15 k))(+ n (* 17 k))(- n (* 23 k))(+ n (* 9 k))(- n (* 40 k))(+ n (* 1 k))(+ n (* 33 k))(- n (* 7 k))(+ n (* 25 k))
(+ n (* 26 k))(- n (* 14 k))(+ n (* 18 k))(- n (* 31 k))(+ n (* 10 k))(- n (* 39 k))(+ n (* 2 k))(- n (* 34 k))(- n (* 6 k))
(- n (* 5 k))(+ n (* 27 k))(- n (* 22 k))(+ n (* 19 k))(- n (* 30 k))(+ n (* 11 k))(- n (* 38 k))(+ n (* 3 k))(+ n (* 35 k))
(+ n (* 36 k))(- n (* 13 k))(+ n (* 28 k))(- n (* 21 k))(+ n (* 20 k))(- n (* 29 k))(+ n (* 12 k))(- n (* 37 k))(+ n (* 4 k))))))

(PWGLDef Latin-Squares-10X10 ((seed1 1)(seed2 3)(seed3 1)(seed4 5))
"Latin-Squares-10X10.
Builds a random Latin Square of dimension 10X10."
() (let*
((k (pw::g-random seed1 seed2))
(n1 (+ (* 49 k) seed3))
(n2 (+ (* 49 k) seed4)))
(system::matrix-constructor '((- - - - - - - - - -)(- - - - - - - - - -))
(list
(- n1 (* 40 k))(+ n2 (* 41 k))(+ n2 (* 42 k))(- n1 (* 43 k))(+ n2 (* 44 k))(- n1 (* 44 k))(- n1 (* 46 k))(+ n2 (* 47 k))(+ n2 (* 48 k))(- n1 (* 49 k))
(+ n2 (* 30 k))(- n1 (* 31 k))(+ n2 (* 37 k))(+ n2 (* 36 k))(- n1 (* 35 k))(- n1 (* 34 k))(+ n2 (* 33 k))(+ n2 (* 32 k))(- n1 (* 38 k))(- n1 (* 30 k))
(+ n2 (* 20 k))(+ n2 (* 21 k))(- n1 (* 27 k))(- n1 (* 26 k))(+ n2 (* 25 k))(+ n2 (* 24 k))(- n1 (* 23 k))(- n1 (* 22 k))(+ n2 (* 28 k))(- n1 (* 20 k))
(- n1 (* 10 k))(- n1 (* 11 k))(+ n2 (* 17 k))(+ n2 (* 16 k))(- n1 (* 15 k))(- n1 (* 14 k))(+ n2 (* 13 k))(+ n2 (* 12 k))(- n1 (* 18 k))(+ n2 (* 10 k))
n1 (+ n2 (* 1 k))(+ n2 (* 2 k))(+ n2 (* 3 k))(- n1 (* 4 k))(- n1 (* 5 k))(+ n2 (* 6 k))(+ n2 (* 7 k))(- n1 (* 1 k))(- n1 (* 9 k))
n2 (- n1 (* 8 k))(- n1 (* 7 k))(- n1 (* 6 k))(+ n2 (* 5 k))(+ n2 (* 4 k))(- n1 (* 3 k))(- n1 (* 2 k))(+ n2 (* 8 k))(+ n2 (* 9 k))
(+ n2 (* 19 k))(+ n2 (* 18 k))(- n1 (* 12 k))(- n1 (* 13 k))(+ n2 (* 14 k))(+ n2 (* 15 k))(- n1 (* 16 k))(- n1 (* 17 k))(+ n2 (* 11 k))(- n1 (* 19 k))
(- n1 (* 29 k))(- n1 (* 28 k))(+ n2 (* 22 k))(+ n2 (* 23 k))(- n1 (* 24 k))(- n1 (* 25 k))(+ n2 (* 26 k))(+ n2 (* 27 k))(- n1 (* 21 k))(+ n2 (* 29 k))
(- n1 (* 39 k))(+ n2 (* 38 k))(- n1 (* 32 k))(- n1 (* 33 k))(+ n2 (* 34 k))(+ n2 (* 35 k))(- n1 (* 36 k))(- n1 (* 37 k))(+ n2 (* 31 k))(+ n2 (* 39 k))
(+ n2 (* 49 k))(- n1 (* 41 k))(- n1 (* 42 k))(+ n2 (* 43 k))(- n1 (* 45 k))(+ n2 (* 45 k))(+ n2 (* 46 k))(- n1 (* 47 k))(- n1 (* 48 k))(+ n2 (* 40 k))))))

(PWGLDef Latin-Squares-11X11 ((seed1 1)(seed2 2)(seed3 4))
"Latin-Squares-11X11.
Builds a random Latin Square of dimension 11X11."
() (let*
((k (pw::g-random seed1 seed2))
(n (+ (* 60 k) seed3)))
(system::matrix-constructor '((- - - - - - - - - - -)(- - - - - - - - - - -))
(list
(- n (* 5 k))(+ n (* 56 k))(- n (* 15 k))(+ n (* 46 k))(- n (* 25 k))(+ n (* 36 k))(- n (* 35 k))(+ n (* 26 k))(- n (* 45 k))(+ n (* 16 k))(- n (* 55 k))
(- n (* 54 k))(- n (* 4 k))(+ n (* 57 k))(- n (* 14 k))(+ n (* 47 k))(- n (* 24 k))(+ n (* 37 k))(- n (* 34 k))(+ n (* 27 k))(- n (* 44 k))(+ n (* 6 k))
(+ n (* 7 k))(- n (* 53 k))(- n (* 3 k))(+ n (* 58 k))(- n (* 13 k))(+ n (* 48 k))(- n (* 23 k))(+ n (* 38 k))(- n (* 33 k))(+ n (* 17 k))(- n (* 43 k))
(- n (* 42 k))(+ n (* 8 k))(- n (* 52 k))(- n (* 2 k))(+ n (* 59 k))(- n (* 12 k))(+ n (* 49 k))(- n (* 22 k))(+ n (* 28 k))(- n (* 32 k))(+ n (* 18 k))
(+ n (* 19 k))(- n (* 41 k))(+ n (* 9 k))(- n (* 51 k))(- n (* 1 k))(+ n (* 60 k))(- n (* 11 k))(+ n (* 39 k))(- n (* 21 k))(+ n (* 29 k))(- n (* 31 k))
(- n (* 30 k))(+ n (* 20 k))(- n (* 40 k))(+ n (* 10 k))(- n (* 50 k)) n (+ n (* 50 k))(- n (* 10 k))(+ n (* 40 k))(- n (* 20 k))(+ n (* 30 k))
(+ n (* 31 k))(- n (* 29 k))(+ n (* 21 k))(- n (* 39 k))(+ n (* 11 k))(- n (* 60 k))(+ n (* 1 k))(+ n (* 51 k))(- n (* 9 k))(+ n (* 41 k))(- n (* 19 k))
(- n (* 18 k))(+ n (* 32 k))(- n (* 28 k))(+ n (* 22 k))(- n (* 49 k))(+ n (* 12 k))(- n (* 59 k))(+ n (* 2 k))(+ n (* 52 k))(- n (* 8 k))(+ n (* 42 k))
(+ n (* 43 k))(- n (* 17 k))(+ n (* 33 k))(- n (* 38 k))(+ n (* 23 k))(- n (* 48 k))(+ n (* 13 k))(- n (* 58 k))(+ n (* 3 k))(+ n (* 53 k))(- n (* 7 k))
(- n (* 6 k))(+ n (* 44 k))(- n (* 27 k))(+ n (* 34 k))(- n (* 37 k))(+ n (* 24 k))(- n (* 47 k))(+ n (* 14 k))(- n (* 57 k))(+ n (* 4 k))(+ n (* 54 k))
(+ n (* 55 k))(- n (* 16 k))(+ n (* 45 k))(- n (* 26 k))(+ n (* 35 k))(- n (* 36 k))(+ n (* 25 k))(- n (* 46 k))(+ n (* 15 k))(- n (* 56 k))(+ n (* 5 k))))))

(PWGLDef Latin-Squares-12X12 ((seed1 1)(seed2 3)(seed3 1)(seed4 5))
"Latin-Squares-12X12.
Builds a random Latin Square of dimension 12X12."
() (let*
((k (pw::g-random seed1 seed2))
(n1 (+ (* 71 k) seed3))
(n2 (+ (* 71 k) seed4)))
(system::matrix-constructor '((- - - - - - - - - - - -)(- - - - - - - - - - - -))
(list
(+ n2 (* 60 k))(- n1 (* 61 k))(- n1 (* 62 k))(+ n2 (* 63 k))(+ n2 (* 64 k))(- n1 (* 65 k))(- n1 (* 66 k))(+ n2 (* 67 k))(+ n2 (* 68 k))(- n1 (* 69 k))(- n1 (* 70 k))(+ n2 (* 71 k))
(- n1 (* 48 k))(+ n2 (* 49 k))(+ n2 (* 50 k))(- n1 (* 51 k))(- n1 (* 52 k))(+ n2 (* 53 k))(+ n2 (* 54 k))(- n1 (* 55 k))(- n1 (* 56 k))(+ n2 (* 57 k))(+ n2 (* 58 k))(- n1 (* 59 k))
(+ n2 (* 36 k))(- n1 (* 37 k))(- n1 (* 38 k))(+ n2 (* 39 k))(+ n2 (* 40 k))(- n1 (* 41 k))(- n1 (* 42 k))(+ n2 (* 43 k))(+ n2 (* 44 k))(- n1 (* 45 k))(- n1 (* 46 k))(+ n2 (* 47 k))
(- n1 (* 24 k))(+ n2 (* 25 k))(+ n2 (* 26 k))(- n1 (* 27 k))(- n1 (* 28 k))(+ n2 (* 29 k))(+ n2 (* 30 k))(- n1 (* 31 k))(- n1 (* 32 k))(+ n2 (* 33 k))(+ n2 (* 34 k))(- n1 (* 35 k))
(+ n2 (* 12 k))(- n1 (* 13 k))(- n1 (* 14 k))(+ n2 (* 15 k))(+ n2 (* 16 k))(- n1 (* 17 k))(- n1 (* 18 k))(+ n2 (* 19 k))(+ n2 (* 20 k))(- n1 (* 21 k))(- n1 (* 22 k))(+ n2 (* 23 k))
n1 (+ n2 (* 1 k))(+ n2 (* 2 k))(- n1 (* 3 k))(- n1 (* 4 k))(+ n2 (* 5 k))(+ n2 (* 6 k))(- n1 (* 7 k))(- n1 (* 8 k))(+ n2 (* 9 k))(+ n2 (* 10 k))(- n1 (* 11 k))
(+ n2 (* 11 k))(- n1 (* 10 k))(- n1 (* 9 k))(+ n2 (* 8 k))(+ n2 (* 7 k))(- n1 (* 6 k))(- n1 (* 5 k))(+ n2 (* 4 k))(+ n2 (* 3 k))(- n1 (* 2 k))(- n1 (* 1 k)) n2
(- n1 (* 23 k))(+ n2 (* 22 k))(+ n2 (* 21 k))(- n1 (* 20 k))(- n1 (* 19 k))(+ n2 (* 18 k))(+ n2 (* 17 k))(- n1 (* 16 k))(- n1 (* 15 k))(+ n2 (* 14 k))(+ n2 (* 13 k))(- n1 (* 12 k))
(+ n2 (* 35 k))(- n1 (* 34 k))(- n1 (* 33 k))(+ n2 (* 32 k))(+ n2 (* 31 k))(- n1 (* 30 k))(- n1 (* 29 k))(+ n2 (* 28 k))(+ n2 (* 27 k))(- n1 (* 26 k))(- n1 (* 25 k))(+ n2 (* 24 k))
(- n1 (* 47 k))(+ n2 (* 46 k))(+ n2 (* 45 k))(- n1 (* 44 k))(- n1 (* 43 k))(+ n2 (* 42 k))(+ n2 (* 41 k))(- n1 (* 40 k))(- n1 (* 39 k))(+ n2 (* 38 k))(+ n2 (* 37 k))(- n1 (* 36 k))
(+ n2 (* 59 k))(- n1 (* 58 k))(- n1 (* 57 k))(+ n2 (* 56 k))(+ n2 (* 55 k))(- n1 (* 54 k))(- n1 (* 53 k))(+ n2 (* 52 k))(+ n2 (* 51 k))(- n1 (* 50 k))(- n1 (* 49 k))(+ n2 (* 48 k))
(- n1 (* 71 k))(+ n2 (* 70 k))(+ n2 (* 69 k))(- n1 (* 68 k))(- n1 (* 67 k))(+ n2 (* 66 k))(+ n2 (* 65 k))(- n1 (* 64 k))(- n1 (* 63 k))(+ n2 (* 62 k))(+ n2 (* 61 k))(- n1 (* 60 k))))))

(PWGLDef Latin-Squares-3X3-list ((seed1 1)(seed2 2)(seed3 8))
"Latin-Squares-3X3-list.
Outputs a random Latin Square of dimension 3X3 in form of list of values."
() (let*
((k (pw::g-random seed1 seed2))
(n (+ (* 4 k) seed3)))
(system::group-lst (list (- n k)(+ n (* 4 k))(- n (* 3 k))(- n (* 2 k)) n (+ n (* 2 k))(+ n (* 3 k))(- n  (* 4 k))(+ n k)) 3)))

(PWGLDef Latin-Squares-4X4-list ((seed1 1)(seed2 2)(seed3 8)(seed4 2))
"Latin-Squares-4X4-list.
Outputs a random Latin Square of dimension 4X4 in form of list of values."
() (let*
((k (pw::g-random seed1 seed2))
(n1 (+ (* 7 k) seed3))
(n2 (+ (* 7 k) seed4)))
(system::group-lst
(list
(+ n2 (* 4 k))(- n1 (* 5 k))(- n1 (* 6 k))(+ n2 (* 7 k))
 n1 (+ n2 (* 1 k))(+ n2 (* 2 k))(- n1 (* 3 k))
(+ n2 (* 3 k))(- n1 (* 2 k))(- n1 (* 1 k)) n2 
(- n1 (* 7 k))(+ n2 (* 6 k))(+ n2 (* 5 k))(- n1 (* 4 k))) 4)))

(PWGLDef Latin-Squares-5X5-list ((seed1 1)(seed2 2)(seed3 5))
"Latin-Squares-5X5-list.
Outputs a random Latin Square of dimension 5X5 in form of list of values."
() (let*
((k (pw::g-random seed1 seed2))
(n (+ (* 12 k) seed3)))
(system::group-lst
(list
(- n (* 2 k))(+ n (* 11 k))(- n (* 6 k))(+ n (* 7 k))(- n (* 10 k))
(- n (* 9 k))(- n  (* 1 k))(+ n  (* 12 k))(- n  (* 5 k))(+ n  (* 3 k))
(+ n  (* 4 k))(- n  (* 8 k)) n (+ n  (* 8 k))(- n  (* 4 k))
(- n  (* 3 k))(+ n  (* 5 k))(- n  (* 12 k))(+ n  (* 1 k))(+ n  (* 9 k))
(+ n  (* 10 k))(- n  (* 7 k))(+ n  (* 6 k))(- n  (* 11 k))(+ n  (* 2 k))) 5)))

(PWGLDef Latin-Squares-6X6-list ((seed1 1)(seed2 2)(seed3 1)(seed4 2))
"Latin-Squares-6X6-list.
Outputs a random Latin Square of dimension 6X6 in form of list of values."
() (let*
((k (pw::g-random seed1 seed2))
(n1 (+ (* 17 k) seed3))
(n2 (+ (* 17 k) seed4)))
(system::group-lst
(list
(+ n2 (* 12 k))(- n1 (* 13 k))(- n1 (* 14 k))(+ n2 (* 14 k))(- n1 (* 16 k))(+ n2 (* 17 k))
(- n1 (* 6 k))(- n1 (* 7 k))(+ n2 (* 8 k))(+ n2 (* 9 k))(- n1 (* 10 k))(+ n2 (* 6 k))
n1 (+ n2 (* 1 k))(+ n2 (* 2 k))(+ n2 (* 3 k))(- n1 (* 1 k))(- n1 (* 5 k))
n2 (- n1 (* 4 k))(- n1 (* 3 k))(- n1 (* 2 k))(+ n2 (* 4 k))(+ n2 (* 5 k))
(+ n2 (* 11 k))(+ n2 (* 10 k))(- n1 (* 9 k))(- n1 (* 8 k))(+ n2 (* 7 k))(- n1 (* 11 k))
(- n1 (* 17 k))(+ n2 (* 13 k))(+ n2 (* 15 k))(- n1 (* 15 k))(+ n2 (* 16 k))(- n1 (* 12 k))) 6)))

(PWGLDef Latin-Squares-7X7-list ((seed1 1)(seed2 2)(seed3 3))
"Latin-Squares-7X7-list.
Outputs a random Latin Square of dimension 6X6 in form of list of values."
() (let*
((k (pw::g-random seed1 seed2))
(n (+ (* 24 k) seed3)))
(system::group-lst
(list
(- n (* 3 k))(+ n (* 22 k))(- n (* 9 k))(+ n (* 16 k))(- n (* 15 k))(+ n (* 10 k))(- n (* 21 k))
(- n (* 20 k))(- n (* 2 k))(+ n (* 23 k))(- n (* 8 k))(+ n (* 17 k))(- n (* 14 k))(+ n (* 4 k))
(+ n (* 5 k))(- n (* 19 k))(- n (* 1 k))(+ n (* 24 k))(- n (* 7 k))(+ n (* 11 k))(- n (* 13 k))
(- n (* 12 k))(+ n (* 6 k))(- n (* 18 k)) n (+ n (* 18 k))(- n (* 6 k))(+ n (* 12 k))
(+ n (* 13 k))(- n (* 11 k))(+ n (* 7 k))(- n (* 24 k))(+ n (* 1 k))(+ n (* 19 k))(- n (* 5 k))
(- n (* 4 k))(+ n (* 14 k))(- n (* 17 k))(+ n (* 8 k))(- n (* 23 k))(+ n (* 2 k))(+ n (* 20 k))
(+ n (* 21 k))(- n (* 10 k))(+ n (* 15 k))(+ n (* 16 k))(+ n (* 9 k))(- n (* 22 k))(+ n (* 3 k))) 7)))

(PWGLDef Latin-Squares-8X8-list ((seed1 1)(seed2 4)(seed3 2)(seed4 4))
"Latin-Squares-8X8-list.
Outputs a random Latin Square of dimension 8X8 in the form of list of values."
() (let*
((k (pw::g-random seed1 seed2))
(n1 (+ (* 31 k) seed3))
(n2 (+ (* 31 k) seed4)))
(system::group-lst 
(list
(+ n2 (* 24 k))(- n1 (* 25 k))(- n1 (* 26 k))(+ n2 (* 27 k))(+ n2 (* 28 k))(- n1 (* 29 k))(- n1 (* 30 k))(+ n2 (* 31 k))
(- n1 (* 16 k))(+ n2 (* 17 k))(+ n2 (* 18 k))(- n1 (* 19 k))(- n1 (* 20 k))(+ n2 (* 21 k))(+ n2 (* 22 k))(- n1 (* 23 k))
(+ n2 (* 8 k))(- n1 (* 9 k))(- n1 (* 10 k))(+ n2 (* 11 k))(+ n2 (* 12 k))(- n1 (* 13 k))(- n1 (* 14 k))(+ n2 (* 15 k))
n1 (+ n2 (* 1 k))(+ n2 (* 2 k))(- n1 (* 3 k))(- n1 (* 4 k))(+ n2 (* 5 k))(+ n2 (* 6 k))(- n1 (* 7 k))
(+ n2 (* 7 k))(- n1 (* 6 k))(- n1 (* 5 k))(+ n2 (* 4 k))(+ n2 (* 3 k))(- n1 (* 2 k))(- n1 (* 1 k)) n2
(- n1 (* 15 k))(+ n2 (* 14 k))(+ n2 (* 13 k))(- n1 (* 12 k))(- n1 (* 11 k))(+ n2 (* 10 k))(+ n2 (* 9 k))(- n1 (* 23 k))
(+ n2 (* 23 k))(- n1 (* 22 k))(- n1 (* 21 k))(+ n2 (* 10 k))(+ n2 (* 19 k))(- n1 (* 18 k))(- n1 (* 17 k))(+ n2 (* 16 k))
(- n1 (* 31 k))(+ n2 (* 30 k))(+ n2 (* 29 k))(- n1 (* 28 k))(- n1 (* 27 k))(+ n2 (* 26 k))(+ n2 (* 25 k))(- n1 (* 24 k))) 8)))

(PWGLDef Latin-Squares-9X9-list ((seed1 1)(seed2 2)(seed3 3))
"Latin-Squares-9X9-list.
Outputs a random Latin Square of dimension 9X9 in the form of list of values."
() (let*
((k (pw::g-random seed1 seed2))
(n (+ (* 40 k) seed3)))
(system::group-lst
(list
(- n (* 4 k))(+ n (* 37 k))(- n (* 12 k))(+ n (* 29 k))(- n (* 20 k))(+ n (* 21 k))(- n (* 28 k))(+ n (* 13 k))(- n (* 36 k))
(- n (* 35 k))(- n (* 3 k))(+ n (* 38 k))(- n (* 11 k))(+ n (* 30 k))(- n (* 19 k))(+ n (* 22 k))(- n (* 27 k))(+ n (* 5 k))
(+ n (* 6 k))(- n (* 34 k))(- n (* 2 k))(+ n (* 39 k))(- n (* 10 k))(+ n (* 31 k))(- n (* 18 k))(+ n (* 14 k))(- n (* 26 k))
(- n (* 25 k))(+ n (* 7 k))(- n (* 33 k))(- n (* 1 k))(+ n (* 40 k))(- n (* 9 k))(+ n (* 23 k))(- n (* 17 k))(+ n (* 15 k))
(+ n (* 16 k))(- n (* 24 k))(+ n (* 8 k))(- n (* 23 k)) n (+ n (* 32 k))(- n (* 8 k))(+ n (* 24 k))(- n (* 16 k))
(- n (* 15 k))(+ n (* 17 k))(- n (* 23 k))(+ n (* 9 k))(- n (* 40 k))(+ n (* 1 k))(+ n (* 33 k))(- n (* 7 k))(+ n (* 25 k))
(+ n (* 26 k))(- n (* 14 k))(+ n (* 18 k))(- n (* 31 k))(+ n (* 10 k))(- n (* 39 k))(+ n (* 2 k))(- n (* 34 k))(- n (* 6 k))
(- n (* 5 k))(+ n (* 27 k))(- n (* 22 k))(+ n (* 19 k))(- n (* 30 k))(+ n (* 11 k))(- n (* 38 k))(+ n (* 3 k))(+ n (* 35 k))
(+ n (* 36 k))(- n (* 13 k))(+ n (* 28 k))(- n (* 21 k))(+ n (* 20 k))(- n (* 29 k))(+ n (* 12 k))(- n (* 37 k))(+ n (* 4 k))) 9)))

(PWGLDef Latin-Squares-10X10-list ((seed1 1)(seed2 3)(seed3 1)(seed4 5))
"Latin-Squares-10X10-list.
Outputs a random Latin Square of dimension 10X10 in theform of list of values."
() (let*
((k (pw::g-random seed1 seed2))
(n1 (+ (* 49 k) seed3))
(n2 (+ (* 49 k) seed4)))
(system::group-lst
(list
(- n1 (* 40 k))(+ n2 (* 41 k))(+ n2 (* 42 k))(- n1 (* 43 k))(+ n2 (* 44 k))(- n1 (* 44 k))(- n1 (* 46 k))(+ n2 (* 47 k))(+ n2 (* 48 k))(- n1 (* 49 k))
(+ n2 (* 30 k))(- n1 (* 31 k))(+ n2 (* 37 k))(+ n2 (* 36 k))(- n1 (* 35 k))(- n1 (* 34 k))(+ n2 (* 33 k))(+ n2 (* 32 k))(- n1 (* 38 k))(- n1 (* 30 k))
(+ n2 (* 20 k))(+ n2 (* 21 k))(- n1 (* 27 k))(- n1 (* 26 k))(+ n2 (* 25 k))(+ n2 (* 24 k))(- n1 (* 23 k))(- n1 (* 22 k))(+ n2 (* 28 k))(- n1 (* 20 k))
(- n1 (* 10 k))(- n1 (* 11 k))(+ n2 (* 17 k))(+ n2 (* 16 k))(- n1 (* 15 k))(- n1 (* 14 k))(+ n2 (* 13 k))(+ n2 (* 12 k))(- n1 (* 18 k))(+ n2 (* 10 k))
n1 (+ n2 (* 1 k))(+ n2 (* 2 k))(+ n2 (* 3 k))(- n1 (* 4 k))(- n1 (* 5 k))(+ n2 (* 6 k))(+ n2 (* 7 k))(- n1 (* 1 k))(- n1 (* 9 k))
n2 (- n1 (* 8 k))(- n1 (* 7 k))(- n1 (* 6 k))(+ n2 (* 5 k))(+ n2 (* 4 k))(- n1 (* 3 k))(- n1 (* 2 k))(+ n2 (* 8 k))(+ n2 (* 9 k))
(+ n2 (* 19 k))(+ n2 (* 18 k))(- n1 (* 12 k))(- n1 (* 13 k))(+ n2 (* 14 k))(+ n2 (* 15 k))(- n1 (* 16 k))(- n1 (* 17 k))(+ n2 (* 11 k))(- n1 (* 19 k))
(- n1 (* 29 k))(- n1 (* 28 k))(+ n2 (* 22 k))(+ n2 (* 23 k))(- n1 (* 24 k))(- n1 (* 25 k))(+ n2 (* 26 k))(+ n2 (* 27 k))(- n1 (* 21 k))(+ n2 (* 29 k))
(- n1 (* 39 k))(+ n2 (* 38 k))(- n1 (* 32 k))(- n1 (* 33 k))(+ n2 (* 34 k))(+ n2 (* 35 k))(- n1 (* 36 k))(- n1 (* 37 k))(+ n2 (* 31 k))(+ n2 (* 39 k))
(+ n2 (* 49 k))(- n1 (* 41 k))(- n1 (* 42 k))(+ n2 (* 43 k))(- n1 (* 45 k))(+ n2 (* 45 k))(+ n2 (* 46 k))(- n1 (* 47 k))(- n1 (* 48 k))(+ n2 (* 40 k))) 10)))

(PWGLDef Latin-Squares-11X11-list ((seed1 1)(seed2 2)(seed3 4))
"Latin-Squares-11X11-list.
Outputs a random Latin Square of dimension 11X11 in the form of list of values."
() (let*
((k (pw::g-random seed1 seed2))
(n (+ (* 60 k) seed3)))
(system::group-lst
(list
(- n (* 5 k))(+ n (* 56 k))(- n (* 15 k))(+ n (* 46 k))(- n (* 25 k))(+ n (* 36 k))(- n (* 35 k))(+ n (* 26 k))(- n (* 45 k))(+ n (* 16 k))(- n (* 55 k))
(- n (* 54 k))(- n (* 4 k))(+ n (* 57 k))(- n (* 14 k))(+ n (* 47 k))(- n (* 24 k))(+ n (* 37 k))(- n (* 34 k))(+ n (* 27 k))(- n (* 44 k))(+ n (* 6 k))
(+ n (* 7 k))(- n (* 53 k))(- n (* 3 k))(+ n (* 58 k))(- n (* 13 k))(+ n (* 48 k))(- n (* 23 k))(+ n (* 38 k))(- n (* 33 k))(+ n (* 17 k))(- n (* 43 k))
(- n (* 42 k))(+ n (* 8 k))(- n (* 52 k))(- n (* 2 k))(+ n (* 59 k))(- n (* 12 k))(+ n (* 49 k))(- n (* 22 k))(+ n (* 28 k))(- n (* 32 k))(+ n (* 18 k))
(+ n (* 19 k))(- n (* 41 k))(+ n (* 9 k))(- n (* 51 k))(- n (* 1 k))(+ n (* 60 k))(- n (* 11 k))(+ n (* 39 k))(- n (* 21 k))(+ n (* 29 k))(- n (* 31 k))
(- n (* 30 k))(+ n (* 20 k))(- n (* 40 k))(+ n (* 10 k))(- n (* 50 k)) n (+ n (* 50 k))(- n (* 10 k))(+ n (* 40 k))(- n (* 20 k))(+ n (* 30 k))
(+ n (* 31 k))(- n (* 29 k))(+ n (* 21 k))(- n (* 39 k))(+ n (* 11 k))(- n (* 60 k))(+ n (* 1 k))(+ n (* 51 k))(- n (* 9 k))(+ n (* 41 k))(- n (* 19 k))
(- n (* 18 k))(+ n (* 32 k))(- n (* 28 k))(+ n (* 22 k))(- n (* 49 k))(+ n (* 12 k))(- n (* 59 k))(+ n (* 2 k))(+ n (* 52 k))(- n (* 8 k))(+ n (* 42 k))
(+ n (* 43 k))(- n (* 17 k))(+ n (* 33 k))(- n (* 38 k))(+ n (* 23 k))(- n (* 48 k))(+ n (* 13 k))(- n (* 58 k))(+ n (* 3 k))(+ n (* 53 k))(- n (* 7 k))
(- n (* 6 k))(+ n (* 44 k))(- n (* 27 k))(+ n (* 34 k))(- n (* 37 k))(+ n (* 24 k))(- n (* 47 k))(+ n (* 14 k))(- n (* 57 k))(+ n (* 4 k))(+ n (* 54 k))
(+ n (* 55 k))(- n (* 16 k))(+ n (* 45 k))(- n (* 26 k))(+ n (* 35 k))(- n (* 36 k))(+ n (* 25 k))(- n (* 46 k))(+ n (* 15 k))(- n (* 56 k))(+ n (* 5 k))) 11)))

(PWGLDef Latin-Squares-12X12-list ((seed1 1)(seed2 3)(seed3 61)(seed4 65))
"Latin-Squares-12X12-list.
Outputs a random Latin Square of dimension 12X12 in the form of list of values."
() (let*
((k (pw::g-random seed1 seed2))
(n1 (+ (* 71 k) seed3))
(n2 (+ (* 71 k) seed4)))
(system::group-lst
(list
(+ n2 (* 60 k))(- n1 (* 61 k))(- n1 (* 62 k))(+ n2 (* 63 k))(+ n2 (* 64 k))(- n1 (* 65 k))(- n1 (* 66 k))(+ n2 (* 67 k))(+ n2 (* 68 k))(- n1 (* 69 k))(- n1 (* 70 k))(+ n2 (* 71 k))
(- n1 (* 48 k))(+ n2 (* 49 k))(+ n2 (* 50 k))(- n1 (* 51 k))(- n1 (* 52 k))(+ n2 (* 53 k))(+ n2 (* 54 k))(- n1 (* 55 k))(- n1 (* 56 k))(+ n2 (* 57 k))(+ n2 (* 58 k))(- n1 (* 59 k))
(+ n2 (* 36 k))(- n1 (* 37 k))(- n1 (* 38 k))(+ n2 (* 39 k))(+ n2 (* 40 k))(- n1 (* 41 k))(- n1 (* 42 k))(+ n2 (* 43 k))(+ n2 (* 44 k))(- n1 (* 45 k))(- n1 (* 46 k))(+ n2 (* 47 k))
(- n1 (* 24 k))(+ n2 (* 25 k))(+ n2 (* 26 k))(- n1 (* 27 k))(- n1 (* 28 k))(+ n2 (* 29 k))(+ n2 (* 30 k))(- n1 (* 31 k))(- n1 (* 32 k))(+ n2 (* 33 k))(+ n2 (* 34 k))(- n1 (* 35 k))
(+ n2 (* 12 k))(- n1 (* 13 k))(- n1 (* 14 k))(+ n2 (* 15 k))(+ n2 (* 16 k))(- n1 (* 17 k))(- n1 (* 18 k))(+ n2 (* 19 k))(+ n2 (* 20 k))(- n1 (* 21 k))(- n1 (* 22 k))(+ n2 (* 23 k))
n1 (+ n2 (* 1 k))(+ n2 (* 2 k))(- n1 (* 3 k))(- n1 (* 4 k))(+ n2 (* 5 k))(+ n2 (* 6 k))(- n1 (* 7 k))(- n1 (* 8 k))(+ n2 (* 9 k))(+ n2 (* 10 k))(- n1 (* 11 k))
(+ n2 (* 11 k))(- n1 (* 10 k))(- n1 (* 9 k))(+ n2 (* 8 k))(+ n2 (* 7 k))(- n1 (* 6 k))(- n1 (* 5 k))(+ n2 (* 4 k))(+ n2 (* 3 k))(- n1 (* 2 k))(- n1 (* 1 k)) n2
(- n1 (* 23 k))(+ n2 (* 22 k))(+ n2 (* 21 k))(- n1 (* 20 k))(- n1 (* 19 k))(+ n2 (* 18 k))(+ n2 (* 17 k))(- n1 (* 16 k))(- n1 (* 15 k))(+ n2 (* 14 k))(+ n2 (* 13 k))(- n1 (* 12 k))
(+ n2 (* 35 k))(- n1 (* 34 k))(- n1 (* 33 k))(+ n2 (* 32 k))(+ n2 (* 31 k))(- n1 (* 30 k))(- n1 (* 29 k))(+ n2 (* 28 k))(+ n2 (* 27 k))(- n1 (* 26 k))(- n1 (* 25 k))(+ n2 (* 24 k))
(- n1 (* 47 k))(+ n2 (* 46 k))(+ n2 (* 45 k))(- n1 (* 44 k))(- n1 (* 43 k))(+ n2 (* 42 k))(+ n2 (* 41 k))(- n1 (* 40 k))(- n1 (* 39 k))(+ n2 (* 38 k))(+ n2 (* 37 k))(- n1 (* 36 k))
(+ n2 (* 59 k))(- n1 (* 58 k))(- n1 (* 57 k))(+ n2 (* 56 k))(+ n2 (* 55 k))(- n1 (* 54 k))(- n1 (* 53 k))(+ n2 (* 52 k))(+ n2 (* 51 k))(- n1 (* 50 k))(- n1 (* 49 k))(+ n2 (* 48 k))
(- n1 (* 71 k))(+ n2 (* 70 k))(+ n2 (* 69 k))(- n1 (* 68 k))(- n1 (* 67 k))(+ n2 (* 66 k))(+ n2 (* 65 k))(- n1 (* 64 k))(- n1 (* 63 k))(+ n2 (* 62 k))(+ n2 (* 61 k))(- n1 (* 60 k))) 12)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menu Serial Post Serial Music --> Manzoni ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;;;;;;;

(PWGLDef Chord-Expansion ((chords-num '5)(chord 'chord)(factor 1))
"Chord-Expansion.
The intervals of contiguous pitches of the initial chord are expanded by the selected factor."
() (iterate (for i from 0 to chords-num)
(collect (pw::dx->x (first chord) (pw::g* (pw::g+ (pw::x->dx chord) i) factor))))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menu Serial Post Serial Music --> Messiaen ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;;;;;;;;

(PWGLDef Turangalila-mult ((factor 0.5)(num-ser 'num-ser)(scope 'scope))
"Turangalila-mult.
An initial numeric series is multiplied by the selected factor, generating different rhythmic figures."
(:groupings '(2 1))
() (pw::gquantify (pw::g* factor (system::group-lst num-ser 1)) scope)
)

(PWGLDef Turangalila-div ((num-ser 'num-ser)(initial-rtm '(0.5 0.5 0.5 0.5))(scope 'scope))
"Turangalila-div.
An initial rhythmic figure is fractioned according to the numbers of a selected numeric series."
(:groupings '(2 1))
() (pw::gquantify (system::g/ (pw::flat-low (iterate (for i in num-ser) (collect (pw::create-list i initial-rtm)))) num-ser) :barsls '(2 4) scope)
)

(PWGLDef LTM-1 ((transp 0)(mode 1))
"LTM-1.
Limited transposition modes. The user can select the mode (starting from 1) and the transposition in halftones."
() (pw::g+ 60 (pw::g+ transp (pw::posn-match (list
'(0 2 4 6 8 10 12)
'(0 1 3 4 6 7 9 10 12)
'(0 2 3 4 6 7 8 10 11 12)
'(0 1 2 5 6 7 8 11 12)
'(0 1 5 6 7 11 12)
'(0 2 4 5 6 8 10 11 12)
'(0 1 2 3 5 6 7 8 9 11 12)) (pw::g- mode 1)))))

(PWGLDef LTM-2 ((mode 1))
"LTM-2.
Limited transposition modes. The user can select the mode and all transpositions are given."
() (pw::posn-match (list
(pw::g+ 60 (iterate (for i from 0 to 1) (collect (pw::g+ i '(0 2 4 6 8 10 12)))))
(pw::g+ 60 (iterate (for i from 0 to 2) (collect (pw::g+ i '(0 1 3 4 6 7 9 10 12)))))
(pw::g+ 60 (iterate (for i from 0 to 3) (collect (pw::g+ i '(0 2 3 4 6 7 8 10 11 12)))))
(pw::g+ 60 (iterate (for i from 0 to 5) (collect (pw::g+ i '(0 1 2 5 6 7 8 11 12)))))
(pw::g+ 60 (iterate (for i from 0 to 5) (collect (pw::g+ i '(0 1 5 6 7 11 12)))))
(pw::g+ 60 (iterate (for i from 0 to 5) (collect (pw::g+ i '(0 2 4 5 6 8 10 11 12)))))
(pw::g+ 60 (iterate (for i from 0 to 5) (collect (pw::g+ i '(0 1 2 3 5 6 7 8 9 11 12)))))
)
(- mode 1)))

(PWGLDef NRR-User-defined ((factor 1/4)(num-ser 'num-ser)(scope 'scope))
"NRR-User-defined.
Non retrogradable rhythms according to a user selected numeric series and factor. The user has to select only the first half of series, the retrogradation is automatically peformed. So for example (1 2 3) becomes (1 2 3 2 1) or (1 2 3 4) becomes (1 2 3 4 3 2 1)."
(:groupings '(2 1))
() (pw::gquantify 
(pw::g* factor (pw::x-append num-ser (cdr (reverse num-ser)))) scope))

(PWGLDef NRR-User-Poly ((poly 4)(num-ser 'num-ser)(factor 1/4)(max-delay 1.0)(scope 'scope))
"NRR-User-Poly.
Polyphony generated with user selected proportionals non-retrogradable rhythms."
(:groupings '(2 2 1))
() (iterate (for a from 1 to poly) (collect
(pw::gquantify (pw::gdelay
(pw::g* factor (pw::x-append num-ser (cdr (reverse num-ser)))) (pw::g-random 0 max-delay)) scope))))

(PWGLDef NRR-Random-Monodic ((num-fig 6)(max 7)(factor 1/4)(scope 'scope))
"NRR-Random-Monodic.
Random generated monody with non-retrogradable rhythms proportional to prime numbers."
(:groupings '(3 1))
() (pw::gquantify
(let ((num-ser (iterate (for i from 1 to num-fig) (collect (pw::nth-random (pw::prime-ser max))))))
(if (oddp num-fig)
(pw::g* factor (pw::x-append num-ser (cdr (reverse num-ser))))
(pw::g* factor (pw::x-append num-ser (reverse num-ser)))
)) scope))

(PWGLDef NRR-Random-Polyphonic ((poly 4)(num-fig 6)(max 7)(factor 1/4)(max-delay 1.0)(scope 'scope))
"NRR-Random-Polyphonic.
Random generated polyphony with non-retrogradable rhythms proportional to prime numbers."
(:groupings '(3 2 1))
() (iterate (for a from 1 to poly) (collect
(pw::gquantify (pw::gdelay
(let ((num-ser (iterate (for i from 1 to num-fig) (collect (pw::nth-random (pw::prime-ser max))))))
(if (oddp num-fig)
(pw::g* factor (pw::x-append num-ser (cdr (reverse num-ser))))
(pw::g* factor (pw::x-append num-ser (reverse num-ser)))
))
(pw::g-random 0 max-delay))
scope))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Menu Serial Post Serial Music --> Xenakis ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;;;;;;;

(PWGLDef Sieves ((num1 5)(num2 7)(factor 0.25))
"Sieves.
Sieves theory."
(:groupings '(2 1))
() (let*
((mcm (system::lcm num1 num2))
(aritmser1 (pw::arithm-ser 0 num1 mcm))
(aritmser2 (pw::arithm-ser 0 num2 mcm))
)
(pw::g* (pw::x->dx (pw::sort-list (pw::x-union aritmser1 aritmser2))) factor)))

(PWGLDef Sieves-durs ((num1 5)(num2 7)(factor 0.25)(scope 'scope))
"Sieves-durs.
Sieves theory applied to durations."
(:groupings '(3 1))
() (let*
((mcm (system::lcm num1 num2))
(aritmser1 (pw::arithm-ser 0 num1 mcm))
(aritmser2 (pw::arithm-ser 0 num2 mcm))
)
(pw::gquantify (pw::g* (pw::x->dx (pw::sort-list (pw::x-union aritmser1 aritmser2))) factor) scope)))

(PWGLDef Sieves-pchs ((num1 7)(num2 17)(initial-pch 36)(factor 0.5))
"Sieves-pchs.
Sieves theory applied to pitches."
(:groupings '(3 1))
() (let*
((mcm (system::lcm num1 num2))
(aritmser1 (pw::arithm-ser 0 num1 mcm))
(aritmser2 (pw::arithm-ser 0 num2 mcm)))
(pw::dx->x initial-pch (pw::g* (pw::x->dx (pw::sort-list (pw::x-union aritmser1 aritmser2))) factor))))

(PWGLDef Poisson-Matrix ((num-columns 28)(num-rows 7)(max 4)(density 0.6))
"Poisson-Matrix.
Builds a first phase Poisson matrix as in Achorripsis."
(:groupings '(2 2))
() (let*
((eventi (pw::arithm-ser 0 1 max))
(fattoriali (iterate (for i in eventi) (collect (fac i))))
(num-cells (pw::g* num-columns num-rows))
(num-events (pw::g-round (pw::g* num-cells (iterate (for i in eventi) (for k in fattoriali) (collect (* (expt 2.7182 (* -1 density)) (/ (expt density i) k)))))))
(cell-values (iterate (for i in eventi) (for k in num-events) (collect (pw::create-list k i)))))
(system::matrix-constructor (list (pw::arithm-ser 1 1 num-columns) (pw::arithm-ser 1 1 num-rows)) (system::group-lst (pw::permut-random (pw::flat cell-values)) num-columns))))

(PWGLDef Poisson-list ((num-columns 28)(num-rows 7)(max 4)(density 0.6))
"Poisson-list.
Builds a first phase Poisson matrix as in Achorripsis."
(:groupings '(2 2))
() (let*
((eventi (pw::arithm-ser 0 1 max))
(fattoriali (iterate (for i in eventi) (collect (fac i))))
(num-cells (pw::g* num-columns num-rows))
(num-events (pw::g-round (pw::g* num-cells (iterate (for i in eventi) (for k in fattoriali) (collect (* (expt 2.7182 (* -1 density)) (/ (expt density i) k)))))))
(cell-values (iterate (for i in eventi) (for k in num-events) (collect (pw::create-list k i)))))
(system::group-lst (pw::permut-random (pw::flat cell-values)) num-columns)))

;;;;;;;;;;;;;;;
;; Menu PCST ;;
;;;;;;;;;;;;;;;

(PWGLDef PC-T-Invariants ((set1 'set1)(set2 'set2))
"PC-T-Invariants.
Invariants between two Pitch-class sets."
() (system::matrix-constructor (list set1 set2)
(pw::mat-trans (pw::g-mod (iterate (for i in set1) (collect (pw::g- i set2))) 12))))

(PWGLDef PC-T-Invariants-stat ((set1 'set1)(set2 'set2))
"PC-T-Invariants-stat.
Statistic of invariants between two Pitch-class sets."
() (system::count-stats
(pw::flat (pw::mat-trans (pw::g-mod (iterate (for i in set1) (collect (pw::g- i set2))) 12)))))

(PWGLDef PC-IT-Invariants ((set1 'set1)(set2 'set2))
"PC-IT-Invariants.
Invariants between one Pitch-class set and the inverse of another Pitch-class set."
() (system::matrix-constructor (list set1 set2)
(pw::mat-trans (pw::g-mod (iterate (for i in set1) (collect (pw::g+ i set2))) 12))))

(PWGLDef PC-IT-Invariants-stat ((set1 'set1)(set2 'set2))
"PC-IT-Invariants-stat.
Statistic of invariants between one Pitch-class set and the inverse of another Pitch-class set."
() (system::count-stats
(pw::flat (pw::mat-trans (pw::g-mod (iterate (for i in set1) (collect (pw::g+ i set2))) 12)))))

(PWGLDef P-T-Invariants ((chord1 'chord1)(chord2 'chord2))
"P-T-Invariants.
Invariants between two Pitch sets (absolute pitches)."
() (let*
((chord1 (pw::sort-list (pw::g- chord1 60)))
(chord2 (pw::sort-list (pw::g- chord2 60))))
(system::matrix-constructor (list chord1 chord2)
(pw::mat-trans (iterate (for i in chord1) (collect (pw::g- i chord2)))))))

(PWGLDef P-T-Invariants-stat ((chord1 'chord1)(chord2 'chord2))
"P-T-Invariants-stat.
Statistic of invariants between two Pitch sets (absolute pitches)."
() (let*
((chord1 (pw::sort-list (pw::g- chord1 60)))
(chord2 (pw::sort-list (pw::g- chord2 60))))
(system::count-stats (pw::flat (pw::mat-trans (iterate (for i in chord1) (collect (pw::g- i chord2))))))))

(PWGLDef P-IT-Invariants ((chord1 'chord1)(chord2 'chord2))
"P-IT-Invariants.
Invariants between a Pitch set and the inversion of another Pitch set (absolute pitches)."
() (let*
((chord1 (pw::sort-list (pw::g- chord1 60)))
(chord2 (pw::sort-list (pw::g- chord2 60))))
(system::matrix-constructor (list chord1 chord2)
(pw::mat-trans (iterate (for i in chord1) (collect (pw::g+ i chord2)))))))

(PWGLDef P-IT-Invariants-stat ((chord1 'chord1)(chord2 'chord2))
"P-IT-Invariants-stat.
Statistic of invariants between a Pitch set and the absolute inversion of another Pitch set (absolute pitches)."
() (let*
((chord1 (pw::sort-list (pw::g- chord1 60)))
(chord2 (pw::sort-list (pw::g- chord2 60))))
(system::count-stats (pw::flat (pw::mat-trans (iterate (for i in chord1) (collect (pw::g+ i chord2))))))))

(PWGLDef Intersections-Tchord2-chord1 ((chord1 'chord1)(chord2 'chord2))
"Intersections-Tchord2-chord1.
Statistic of common absolute Pitches between two Pitch sets."
() (let*
((12transp (iterate (for i from 12 downto -12) (collect (pw::g+ (pw::sort-list chord2) i))))
(intersezione (iterate (for i in 12transp) (collect (pw::x-intersect chord1 i))))
(common-pchs (iterate (for i in intersezione) (collect (list (length i) i))))
(ser (pw::arithm-ser 12 -1 -12)))
(iterate (for i from 12 downto -12) (for a in common-pchs) (collect (append (list i) a)))))

(PWGLDef Intersections-ITchord2-chord1 ((chord1 'chord1)(chord2 'chord2))
"Intersections-ITchord2-chord1.
Statistic of common absolute Pitches between a Pitch set and the absolute inversion of another one."
() (let*
((invchord2 (iterate (for i in chord2) (collect (- 120 i))))
(12transp (iterate (for i from 12 downto -12) (collect (pw::g+ (pw::sort-list invchord2) i))))
(intersezione (iterate (for i in 12transp) (collect (pw::x-intersect chord1 i))))
(common-pchs (iterate (for i in intersezione) (collect (list (length i) i))))
(ser (pw::arithm-ser 12 -1 -12)))
(iterate (for i from 12 downto -12) (for a in common-pchs) (collect (append (list i) a)))))

(PWGLDef pc2dur-size ((prime-form 'prime-form)(beat-length 4)(scope 'scope))
"pc2dur-size.
Transformation from Pitch-classes into durations inside a user specified size (in beats)."
() (pw::gquantify (pw::gsize (pw::x->dx (pw::x-append prime-form 12)) beat-length) scope))

(PWGLDef pc2dur-factor ((prime-form 'prime-form)(factor 0.5)(scope 'scope))
"pc2dur-factor.
Transformation from Pitch-classes into durations according to a user selected factor. 1 = quarter, 0.5 = quaver and so on."
() (pw::gquantify (pw::g* (pw::x->dx (pw::x-append prime-form 12)) factor) scope))

(PWGLDef p2dur-size ((chord 'chord)(beat-length 4)(scope 'scope))
"p2dur-size.
Transformation from absolute pitches into durations inside a user specified size (in beats)."
() (pw::gquantify (pw::gsize (pw::g-abs (pw::x->dx chord)) beat-length) scope))

(PWGLDef p2dur-factor ((chord 'chord)(factor 0.125)(scope 'scope))
"p2dur-factor.
Transformation from absolute pitches into durations according to a user selected factor. 1 = quarter, 0.5 = quaver and so on."
() (pw::gquantify (pw::g* (pw::g-abs (pw::x->dx chord)) factor) scope))

(PWGLDef Imbrication ((input 'input)(num-el 3))
"Imbrication.
Progressive selection of 'num-el' contiguous elements."
() (iterate (for i from 0 to (- (length input) num-el)) (collect (pw::posn-match input (pw::arithm-ser (+ 0 i) 1 (- (+ i num-el) 1))))))

;;;;;;;;;;;;;;;;;
;; Menu Rhythm ;;
;;;;;;;;;;;;;;;;;

(PWGLDef Mensural_Canons ((delay 'delays)(mult 'mults)(durs 'durs)(scope 'scope))
"Mensural_Canons.
User defined mensural canons."
(:groupings '(1 1 1 1))
() (pw::gquantify
(iterate (for a in delay) (for b in mult) (collect (pw::gdelay (pw::g* b durs) a))) scope))

(PWGLDef Mensural_Canons_random ((poly 4)(mindel 0.0)(maxdel 2.0)(minmult 0.25)(maxmult 2)(durs 'durs)(scope 'scope))
"Mensural_Canons_random.
Random mensural canons."
(:groupings '(1 2 2 1 1))
() (let*
((listadelay (iterate (for i from 1 to poly) (collect (pw::g-random mindel maxdel))))
(listafattori (iterate (for i from 1 to poly) (collect (pw::g-random minmult maxmult)))))
(pw::gquantify (iterate (for i from 1 to poly) (for a in listadelay) (for b in listafattori) (collect (pw::gdelay (pw::g* durs b) a))) scope)))

(PWGLDef Phasing-size ((proportions 'proportions)(beat-length 4)(scope 'scope))
"Phasing-size.
All rotations proportional rhythms inside a user defined size (in beats)."
(:groupings '(1 1 1))
() (pw::gquantify
;; all-rotations
(iterate (for i in  (pw::arithm-ser 0 1 (- (length proportions) 1))) (collect (pw::gsize (pw::permut-circ proportions i) beat-length)))
;; end all-rotations
scope))

(PWGLDef Phasing-factor ((proportions 'proportions)(factor 0.25)(scope 'scope))
"Phasing-factor.
All rotations proportional rhythms according to a user defined multiplication factor."
(:groupings '(1 1 1))
() (pw::gquantify
;; all-rotations
(iterate (for i in  (pw::arithm-ser 0 1 (- (length proportions) 1))) (collect (pw::g* (pw::permut-circ proportions i) factor)))
;; end all-rotations
scope))

(PWGLDef RTM-frgm_no_pauses ((poly 4)(len 4)(min-frag 1)(max-frag 8))
"RTM-frgm_no_pauses.
Random fragmentation of beat unit generating a polyphony, without pauses."
(:groupings '(2 2))
() (iterate (for i from 1 to poly) (collect (pw::gquantify (iterate (for i in (iterate (for i from 1 to len) (collect (system::g-random min-frag max-frag)))) (pw::repeat i (collect (/ 1 i))))))))

(PWGLDef RTM-frgm_with_pauses ((poly 4)(len 4)(min-frag 1)(max-frag 8))
"RTM-frgm_with_pauses.
Random fragmentation of beat unit generating a polyphony, with random pauses."
(:groupings '(2 2))
() (iterate (for i from 1 to poly) (collect
(pw::gquantify
(let*
((rtms (iterate (for i in (iterate (for i from 1 to len) (collect (system::g-random min-frag max-frag)))) (pw::repeat i (collect (/ 1 i)))))
(pauses (iterate (for i from 1 to (length rtms)) (collect (* 100 (random 2))))))
(pw::x-append (list rtms) pauses))))))

(PWGLDef Rhythmic-windowing ((score 'score)(poly 4))
"Rhythmic-windowing.
Random pauses inside an input rhythmic monody."
() (iterate (for i from 1 to poly) (collect (pw::gquantify (append (list (car (pw::getr score))) (iterate (for i in (cdr (pw::getr score))) (collect (* i (random 2)))))))))

(PWGLDef Rhythmic-inversion ((score 'score)(scope 'scope))
"Rhythmic-inversion.
Rhyrhmic inversion: longest duration becomes shortest, next longest duration becomes next shortest and so on."
(:groupings '(1 1))
() (let*
((oldlist (pw::remove-duplicates (pw::sort-list (first (pw::getr score)))))
(newlist (reverse oldlist))
(data (first (pw::getr score))))
(pw::gquantify (system::substitute-list newlist oldlist data) scope)))

(PWGLDef Mono2Poly ((score 'score)(poly 3)(scope 'scope))
"Mono2Poly.
A monody is transformed into a polyphony dividing its attacks between the voices of polyphony."
(:groupings '(2 1))
() (let*
((ritmi (car (pw::getr score)))
(imbricazioni (iterate (for i from 0 to (- (length ritmi) poly)) (collect (pw::posn-match ritmi (pw::arithm-ser (+ 0 i) 1 (- (+ i poly) 1))))))
(durate (iterate (for i in imbricazioni) (collect (last (pw::cumul-sum i)))))
(delays (pw::dx->x 0 (pw::posn-match ritmi (pw::arithm-ser 0 1 (- poly 2)))))
(voci (pw::mat-trans (system::group-lst (pw::flat durate) poly))))
(pw::gquantify (iterate (for i from 1 to poly) (for k in voci) (for j in delays) (collect (pw::gdelay k j))) scope)))

(PWGLDef Num2RTMs-size ((num-ser 'num-ser)(size 8)(scope 'scope))
"Num2RTMs-size.
Rhythms proportional to a user defined numeric series inside a user defined size (in beats)."
(:groupings '(2 1))
() (iterate (for i in num-ser) (collect (pw::gquantify (pw::gsize i size) scope))))

(PWGLDef Num2RTMs-factor ((num-ser 'num-ser)(factor 0.25)(scope 'scope))
"Num2RTMs-factor.
Rhythms proportional to a user defined numeric series according to a user defined multiplication factor."
(:groupings '(2 1))
() (iterate (for i in num-ser) (collect (pw::gquantify (pw::g* factor i) scope))))

(PWGLDef Prime-size ((poly 4)(num-fig 6)(max 7)(size 8)(scope 'scope))
"Prime-size.
Random prime numbers proportional durations inside a user defined size."
(:groupings '(2 2 1))
() (iterate (for i from 1 to poly) (collect (pw::gquantify (pw::gsize 
(iterate (for i from 1 to num-fig) (collect (pw::nth-random (pw::prime-ser max)))) size) scope))))

(PWGLDef Prime-size-del ((poly 4)(num-fig 6)(max 7)(size 8)(mindel 0.0)(maxdel 1.0)(scope 'scope))
"Prime-size-del.
Random prime numbers proportional durations inside a user defined size, with random entry delays."
(:groupings '(2 2 2 1))
() (iterate (for i from 1 to poly) (collect (pw::gquantify (pw::gdelay (pw::gsize 
(iterate (for i from 1 to num-fig) (collect (pw::nth-random (pw::prime-ser max)))) size) (pw::g-random mindel maxdel)) scope))))

(PWGLDef Prime-factor ((poly 4)(num-fig 6)(max 7)(factor 0.25)(scope 'scope))
"Prime-factor.
Random prime numbers proportional durations according to a user defined multiplication factor."
(:groupings '(2 2 1))
() (iterate (for i from 1 to poly) (collect (pw::gquantify (pw::g* 
(iterate (for i from 1 to num-fig) (collect (pw::nth-random (pw::prime-ser max)))) factor) scope))))

(PWGLDef Prime-factor-del ((poly 4)(num-fig 6)(max 7)(factor 0.25)(list-del 'list-del)(scope 'scope))
"Prime-factor-del.
Random prime numbers proportional durations according to a user defined multiplication factor, with random entry delays."
(:groupings '(2 2 1 1))
() (iterate (for i from 1 to poly) (collect (pw::gquantify (pw::gdelay (pw::g* 
(iterate (for i from 1 to num-fig) (collect (pw::nth-random (pw::prime-ser max)))) factor) (pw::nth-random list-del)) scope))))

(PWGLDef Fibo-size ((poly 4)(num-fig 6)(seed1 0)(seed2 1)(max 7)(size 8)(scope 'scope))
"Fibo-size.
Random Fibonacci numbers proportional durations inside a user defined size."
(:groupings '(2 2 2 1))
() (iterate (for i from 1 to poly) (collect (pw::gquantify (pw::gsize 
(iterate (for i from 1 to num-fig) (collect (pw::nth-random (pw::fibo-ser seed1 seed2 max)))) size) scope))))

(PWGLDef Fibo-size-del ((poly 4)(num-fig 6)(seed1 0)(seed2 1)(max 7)(size 8)(mindel 0.0)(maxdel 1.0)(scope 'scope))
"Fibo-size-del.
Random Fibonacci numbers proportional durations inside a user defined size, with random entry delays."
(:groupings '(2 2 2 2 1))
() (iterate (for i from 1 to poly) (collect (pw::gquantify (pw::gdelay (pw::gsize 
(iterate (for i from 1 to num-fig) (collect (pw::nth-random (pw::fibo-ser seed1 seed2 max)))) size) (pw::g-random mindel maxdel)) scope))))

(PWGLDef Fibo-factor ((poly 4)(num-fig 6)(seed1 0)(seed2 1)(max 7)(factor 0.25)(scope 'scope))
"Fibo-factor.
Random Fibonacci numbers proportional durations according to a user defined multiplication factor."
(:groupings '(2 2 2 1))
() (iterate (for i from 1 to poly) (collect (pw::gquantify (pw::g* 
(iterate (for i from 1 to num-fig) (collect (pw::nth-random (pw::fibo-ser seed1 seed2 max)))) factor) scope))))

(PWGLDef Fibo-factor-del ((poly 4)(num-fig 6)(seed1 0)(seed2 1)(max 7)(factor 0.25)(list-del 'list-del)(scope 'scope))
"Fibo-factor-del.
Random Fibonacci numbers proportional durations according to a user defined multiplication factor, with random entry delays."
(:groupings '(2 2 2 1 1))
() (iterate (for i from 1 to poly) (collect (pw::gquantify (pw::gdelay (pw::g* 
(iterate (for i from 1 to num-fig) (collect (pw::nth-random (pw::fibo-ser seed1 seed2 max)))) factor) (pw::nth-random list-del)) scope))))

(PWGLDef Mosaic-Canons ((num-notes 4)(num-voices 4)(rtm-unit 0.25)(repetitions 4)(scope 'scope))
"Mosaic-Canons.
Builds a mosaic canon."
() (let*
((matrice (system::group-lst (pw::arithm-ser 0 1 (pw::g- (pw::g* num-notes num-voices) 1)) num-notes))
(etichette (list (pw::arithm-ser 1 1 num-notes) (pw::arithm-ser 1 1 num-voices)))
(dur1 (pw::rest (pw::mat-trans matrice)))
(dur2 (iterate (for i in dur1) (collect (pw::nth-random i))))
(dur3 (sort (pw::x-append 0 (pw::permut-random dur2) (pw::g* num-notes num-voices))  #'<))
(ritmi (pw::create-list num-voices (pw::g* rtm-unit (pw::flat (pw::create-list repetitions (pw::x->dx dur3))))))
(delays (pw::g* rtm-unit (first (pw::mat-trans matrice)))))
(pw::gquantify (iterate (for i in ritmi) (for k in delays) (collect (pw::gdelay i k)))scope)))

(PWGLDef Mosaic-Canons+Matrix ((num-notes 4)(num-voices 4)(rtm-unit 0.25)(repetitions 4)(scope 'scope)(choice 1))
"Mosaic-Canons+Matrix.
Builds a mosaic canon and permit to choice if visualizing the underlying matrix (choice 0) or to output the rhythmic sequence (choice 1)."
() (let*
((matrice (system::group-lst (pw::arithm-ser 0 1 (pw::g- (pw::g* num-notes num-voices) 1)) num-notes))
(etichette (list (pw::arithm-ser 1 1 num-notes) (pw::arithm-ser 1 1 num-voices)))
(dur1 (pw::rest (pw::mat-trans matrice)))
(dur2 (iterate (for i in dur1) (collect (pw::nth-random i))))
(dur3 (sort (pw::x-append 0 (pw::permut-random dur2) (pw::g* num-notes num-voices))  #'<))
(ritmi (pw::create-list num-voices (pw::g* rtm-unit (pw::flat (pw::create-list repetitions (pw::x->dx dur3))))))
(delays (pw::g* rtm-unit (first (pw::mat-trans matrice)))))
(pw::posn-match (list
(system::matrix-constructor (list (pw::arithm-ser 1 1 num-notes) (pw::arithm-ser 1 1 num-voices)) matrice)
(pw::gquantify (iterate (for i in ritmi) (for k in delays) (collect (pw::gdelay i k)))scope)) choice)))

;;;;;;;;;;;;;;;;
;; Menu Pitch ;;
;;;;;;;;;;;;;;;;

(PWGLDef Axis-inversion ((chord 'chord)(axis 67))
"Axis-inversion.
Absolute pitches inversion according to a user defined axis."
() (iterate (for i in chord) (collect (+ axis (- axis i)))))

(PWGLDef BPF-Axis-inversion ((chord 'chord)(bpf 'bpf)(minout 60)(maxout 72))
"BPF-Axis-inversion.
Absolute pitches inversion according to a BPF."
(:groupings '(2 2))
() (iterate (for i in chord) (for k in (pw::flat (pw::g-round (pw::g-scaling (system::pwgl-sample bpf (length chord)) minout maxout)))) (collect (+ k (- k i)))))

(PWGLDef Mask ((bpf 'bpf)(numpoints 10)(minin 36)(maxin 96)(iterations 1)(approx 2))
"Mask.
Random pitches masking."
(:groupings '(2 2 2))
() (let*
((primo (first (pw::g-scaling (system::pwgl-sample bpf numpoints) minin maxin)))
(secondo (second (pw::g-scaling (system::pwgl-sample bpf numpoints) minin maxin))))
(pw::flat (pw::approx-midi (iterate (for i in primo) (for k in secondo) (pw::repeat iterations (collect (pw::g-random k i)))) approx))))

;;;;;;;;;;;;;;;;;;;;
;; Menu Utilities ;;
;;;;;;;;;;;;;;;;;;;;

(PWGLDef score+chords ((score 'score)(chords 'chords))
"score+chords.
Merge the durations (only pitches, no pauses) of a score and the pitches of chords into a new score."
() (let*
((durate1 (grhythm::getr score))
(durate (iterate (for i in durate1) (collect (first i)))))
(ksquant::simple2score (iterate (for d in durate) (for p in chords) (collect (ksquant::simple-change-type :PART (ksquant::pitches-durs2simple p d)))))))

(PWGLDef chords2score ((chords 'chords))
"chords2score.
Transform a list of chords into a score: one voice for chord."
() (ksquant::simple2score (iterate (for i in chords) (collect (ksquant::simple-change-type :PART (ksquant::pitches-durs2simple i 1))))))

(PWGLDef in-permut ((input 'input))
"in-permut.
Applies internal permutation of sublists."
() (iterate (for i in input) (collect (pw::permut-random i))))

(PWGLDef in-repetition ((input 'input)(times 3))
"in-repetition.
Repeats sublists."
() (iterate (for i in input) (collect (pw::flat (pw::create-list times i)))))

(PWGLDef in-sorting ((input 'input)(test '<))
"in-sorting.
Sorts sublists of input list. Second argument set ascending or descending order, with values < or >."
() (iterate (for i in input) (collect (pw::sort-list i test ))))





