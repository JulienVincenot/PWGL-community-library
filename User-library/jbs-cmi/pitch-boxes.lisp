;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;==============================================================================================
;;;                                JBS - CMI    2009    
;;;==============================================================================================
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;       JBS-CMI for PWGL

;;; Copyright (c) 2009, Jacopo Baboni Schilingi.  All rights reserved.
;;; Copyright (c) 2007, Kilian Sprotte.  All rights reserved.

;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:

;;;   * Redistributions of source code must retain the above copyright
;;;     notice, this list of conditions and the following disclaimer.

;;;   * Redistributions in binary form must reproduce the above
;;;     copyright notice, this list of conditions and the following
;;;     disclaimer in the documentation and/or other materials
;;;     provided with the distribution.

;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED
;;; OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
;;; GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;;; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;
(in-package :ccl)
(defvar wood '(64 67 74 71 77))

(defvar -4-5-a '((60 61 62 64) (61 62 63 65) (62 63 64 66) (63 64 65 67) (64 65 66 68)
                 (65 66 67 69) (66 67 68 70) (67 68 69 71) (68 69 70 72) (69 70 71 73)
                 (70 71 72 74) (71 72 73 75)))

(defvar -4-5-b '((60 61 63 64) (61 62 64 65) (62 63 65 66) (63 64 66 67) (64 65 67 68)
                 (65 66 68 69) (66 67 69 70) (67 68 70 71) (68 69 71 72) (69 70 72 73)
                 (70 71 73 74) (71 72 74 75)))

(defvar -4-5-c '((60 62 63 64) (61 63 64 65) (62 64 65 66) (63 65 66 67) (64 66 67 68)
                 (65 67 68 69) (66 68 69 70) (67 69 70 71) (68 70 71 72) (69 71 72 73)
                 (70 72 73 74) (71 73 74 75)))

(defvar -3-6-a '((60 61 62 67) (61 62 63 68) (62 63 64 69) (63 64 65 70) (64 65 66 71)
                 (65 66 67 72) (66 67 68 73) (67 68 69 74) (68 69 70 75) (69 70 71 76)
                 (70 71 72 77) (71 72 73 78)))

(defvar -3-6-b '((60 61 66 67) (61 62 67 68) (62 63 68 69) (63 64 69 70) (64 65 70 71)
                 (65 66 71 72) (66 67 72 73) (67 68 73 74) (68 69 74 75) (69 70 75 76)
                 (70 71 76 77) (71 72 77 78)))

(defvar o-a '((60 61 63 67) (61 62 64 68) (62 63 65 69) (63 64 66 70) (64 65 67 71)
              (65 66 68 72) (66 67 69 73) (67 68 70 74) (68 69 71 75) (69 70 72 76)
              (70 71 73 77) (71 72 74 78)))

(defvar o-b '((60 61 64 66) (61 62 65 67) (62 63 66 68) (63 64 67 69) (64 65 68 70)
              (65 66 69 71) (66 67 70 72) (67 68 71 73) (68 69 72 74) (69 70 73 75)
              (70 71 74 76) (71 72 75 77)))

(defvar o-c '((60 62 65 66) (61 63 66 67) (62 64 67 68) (63 65 68 69) (64 66 69 70)
              (65 67 70 71) (66 68 71 72) (67 69 72 73) (68 70 73 74) (69 71 74 75)
              (70 72 75 76) (71 73 76 77)))

(defvar o-d '((60 64 66 67) (61 65 67 68) (62 66 68 69) (63 67 69 70) (64 68 70 71)
              (65 69 71 72) (66 70 72 73) (67 71 73 74) (68 72 74 75) (69 73 75 76)
              (70 74 76 77) (71 75 77 78)))

(defvar -4-a '((60 61 62 63 65) (61 62 63 64 66) (62 63 64 65 67) (63 64 65 66 68)
               (64 65 66 67 69) (65 66 67 68 70) (66 67 68 69 71) (67 68 69 70 72)
               (68 69 70 71 73) (69 70 71 72 74) (70 71 72 73 75) (71 72 73 74 76)))

(defvar -4-b '((60 61 62 64 65) (61 62 63 65 66) (62 63 64 66 67) (63 64 65 67 68)
               (64 65 66 68 69) (65 66 67 69 70) (66 67 68 70 71) (67 68 69 71 72)
               (68 69 70 72 73) (69 70 71 73 74) (70 71 72 74 75) (71 72 73 75 76)))

(defvar -4-c '((60 61 63 64 65) (61 62 64 65 66) (62 63 65 66 67) (63 64 66 67 68)
               (64 65 67 68 69) (65 66 68 69 70) (66 67 69 70 71) (67 68 70 71 72)
               (68 69 71 72 73) (69 70 72 73 74) (70 71 73 74 75) (71 72 74 75 76)))

(defvar -4-d '((60 62 63 64 65) (61 63 64 65 66) (62 64 65 66 67) (63 65 66 67 68)
               (64 66 67 68 69) (65 67 68 69 70) (66 68 69 70 71) (67 69 70 71 72)
               (68 70 71 72 73) (69 71 72 73 74) (70 72 73 74 75) (71 73 74 75 76)))

(defvar crom-up '(60 61 62 63 64 65 66 67 68 69 70 71))

(defvar crom-down '(71 70 69 68 67 66 65 64 63 62 61 60))

(defvar 4-up '((60 65 70 75 68 73 78 71 64 69 62 67) 
                (61 66 71 76 69 74 79 72 65 70 63 68)
                (61 66 71 76 69 74 79 72 65 70 63 68) 
                (62 67 72 77 70 75 80 73 66 71 64 69)
                (63 68 73 78 71 76 81 74 67 72 65 70) 
                (64 69 74 79 72 77 82 75 68 73 66 71)
                (65 70 75 80 73 78 83 76 69 74 67 72) 
                (66 71 76 81 74 79 84 77 70 75 68 73)
                (67 72 77 82 75 80 85 78 71 76 69 74) 
                (68 73 78 83 76 81 86 79 72 77 70 75)
                (69 74 79 84 77 82 87 80 73 78 71 76) 
                (70 75 80 85 78 83 88 81 74 79 72 77)
                (71 76 81 86 79 84 89 82 75 80 73 78)
                ))

(defvar 4< '((36 41 46 51 56 61 66 71 76 81 86 91 96) 
              (37 42 47 52 57 62 67 72 77 82 87 92 97) 
              (38 43 48 53 58 63 68 73 78 83 88 93 98) 
              (39 44 49 54 59 64 69 74 79 84 89 94 99) 
              (40 45 50 55 60 65 70 75 80 85 90 95 1) 
              (41 46 51 56 61 66 71 76 81 86 91 96 101) 
              (42 47 52 57 62 67 72 77 82 87 92 97 102) 
              (43 48 53 58 63 68 73 78 83 88 93 98 103) 
              (44 49 54 59 64 69 74 79 84 89 94 99 104) 
              (45 50 55 60 65 70 75 80 85 90 95 1 105) 
              (46 51 56 61 66 71 76 81 86 91 96 101 106) 
              (47 52 57 62 67 72 77 82 87 92 97 102 107)
              ))

(defvar 5-up '((60 67 74 69 76 71 66 61 68 63 70 65) 
                (61 68 75 70 77 60 67 62 69 64 71 66) 
                (62 69 76 71 78 61 68 63 70 65 60 67) 
                (63 70 77 72 67 62 69 64 71 66 61 68) 
                (64 71 78 73 68 63 70 65 60 67 62 69) 
                (65 72 79 74 69 64 71 66 61 68 63 70) 
                (66 73 68 75 70 65 60 67 62 69 64 71) 
                (67 74 69 76 71 66 61 68 63 70 65 60) 
                (68 75 70 77 60 67 62 69 64 71 66 61) 
                (69 76 71 78 61 68 63 70 65 60 67 62) 
                (70 77 72 67 62 69 64 71 66 61 68 63) 
                (71 78 73 68 63 70 65 60 67 62 69 64)
                ))

(defvar 5< '((36 43 50 57 64 71 78 85 92 99 106 113 120) 
              (37 44 51 58 65 72 79 86 93 1 107 114 121) 
              (38 45 52 59 66 73 80 87 94 101 108 115 122) 
              (39 46 53 60 67 74 81 88 95 102 109 116 123) 
              (40 47 54 61 68 75 82 89 96 103 110 117 124) 
              (41 48 55 62 69 76 83 90 97 104 111 118 125) 
              (42 49 56 63 70 77 84 91 98 105 112 119 126) 
              (43 50 57 64 71 78 85 92 99 106 113 120 127) 
              (44 51 58 65 72 79 86 93 1 107 114 121 128) 
              (45 52 59 66 73 80 87 94 101 108 115 122 129) 
              (46 53 60 67 74 81 88 95 102 109 116 123 130) 
              (47 54 61 68 75 82 89 96 103 110 117 124 131)
              ))

(defvar octphone '((60 61 63 64 66 67 69 70) 
                   (61 62 64 65 67 68 70 71) 
                   (62 63 65 66 68 69 71 72)))

(defvar enphone '((60 61 62 64 65 66 68 69 70) 
                  (61 62 63 65 66 67 69 70 71)
                  (62 63 64 66 67 68 70 71 72) 
                  (63 64 65 67 68 69 71 72 73)
                  ))

(defvar pentaton-a '((60 61 65 69 70) 
                     (61 62 66 70 71) 
                     (62 63 67 71 72) 
                     (63 64 68 72 73) 
                     (64 65 69 73 74) 
                     (65 66 70 74 75) 
                     (66 67 71 75 76) 
                     (67 68 72 76 77) 
                     (68 69 73 77 78) 
                     (69 70 74 78 79) 
                     (70 71 75 79 68) 
                     (71 72 76 68 69)
                     ))

(defvar pentaton-b '((60 61 63 65 66) 
                     (61 62 64 66 67) 
                     (62 63 65 67 68) 
                     (63 64 66 68 69) 
                     (64 65 67 69 70) 
                     (65 66 68 70 71) 
                     (66 67 69 71 72) 
                     (67 68 70 72 73) 
                     (68 69 71 73 74) 
                     (69 70 72 74 75) 
                     (70 71 73 75 76) 
                     (71 72 74 76 77)
                     ))

(defvar octotone '((60 62 64 65 66 68 70 71) 
                   (61 63 65 66 67 69 71 72) 
                   (62 64 66 67 68 70 72 73) 
                   (63 65 67 68 69 71 73 74) 
                   (64 66 68 69 70 72 74 75) 
                   (65 67 69 70 71 73 75 76)
                   ))

(defvar eptatone-a '((60 63 64 65 67 68 69 72) 
                     (61 64 65 66 68 69 70 73) 
                     (62 65 66 67 69 70 71 74) 
                     (63 66 67 68 70 71 72 75) 
                     (64 67 68 69 71 72 73 76) 
                     (65 68 69 70 72 73 74 77) 
                     (66 69 70 71 73 74 75 78) 
                     (67 70 71 72 74 75 76 79) 
                     (68 71 72 73 75 76 77 68) 
                     (69 72 73 74 76 77 78 69) 
                     (70 73 74 75 77 78 79 70) 
                     (71 74 75 76 78 79 68 71)
                     ))

(defvar eptatone-b '((60 61 62 65 67 70 71 72) 
                    (61 62 63 66 68 71 72 73) 
                    (62 63 64 67 69 72 73 74) 
                    (63 64 65 68 70 73 74 75) 
                    (64 65 66 69 71 74 75 76) 
                    (65 66 67 70 72 75 76 77) 
                    (66 67 68 71 73 76 77 78) 
                    (67 68 69 72 74 77 78 79) 
                    (68 69 70 73 75 78 79 68) 
                    (69 70 71 74 76 79 68 69) 
                    (70 71 72 75 77 68 69 70) 
                    (71 72 73 76 78 69 70 71)
                    ))

(defvar openton-5 '((36 38 40 42 43 45 47 49 50 52 54 56 
                      57 59 61 63 64 66 68 70 71 73 75 77 
                      78 68 70 72 73 75 77 55 56 58 60 62 
                      63 65 43 45 46 48 50 52 53 43 45 47 
                      36)
                     (36 37 39 40 42 43 44 46 47 49 50 51 
                      53 54 56 57 58 60 61 63 64 65 67 68 
                      70 71 72 74 75 77 78 79 69 70 72 73 
                      74 76 77 55 56 57 59 60 62 63 64 66 
                      43 45 46 47 49 50 52 53 54 44 45 47 
                      36)
                     (36 38 39 41 42 43 45 46 48 49 50 52 
                      53 55 56 57 59 60 62 63 64 66 67 69 
                      70 71 73 74 76 77 78 68 69 71 72 73 
                      75 76 78 55 56 58 59 61 62 63 65 66 
                      44 45 46 48 49 51 52 53 43 44 46 47 
                      36)
                     ))

(defvar openton-4 '((36 38 40 41 43 45 46 48 50 51 53 55 
                      56 58 60 61 63 65 66 68 70 71 73 75 
                      76 78 68 69 71 73 74 76 78 55 57 59 
                      60)
                     (36 37 39 40 41 42 44 45 46 47 49 50 
                      51 52 54 55 56 57 59 60 61 62 64 65 
                      66 67 69 70 71 72 74 75 76 77 79 68 
                      69 70 72 73 74 75 77 78 55 56 58 59 
                      60)
                     (36 37 39 41 42 44 46 47 49 51 52 54 
                      56 57 59 61 62 64 66 67 69 71 72 74 
                      76 77 79 69 70 72 74 75 77 55 56 58 
                      60)
                     ))

(defvar piram-> '((36 47 57 66 74 81 87 92 96 99 101 102) 
                  (37 48 58 67 75 82 88 93 97 1 102 103) 
                  (38 49 59 68 76 83 89 94 98 101 103 104) 
                  (39 50 60 69 77 84 90 95 99 102 104 105) 
                  (40 51 61 70 78 85 91 96 1 103 105 106) 
                  (41 52 62 71 79 86 92 97 101 104 106 107) 
                  (42 53 63 72 80 87 93 98 102 105 107 108) 
                  (43 54 64 73 81 88 94 99 103 106 108 109) 
                  (44 55 65 74 82 89 95 1 104 107 109 110) 
                  (45 56 66 75 83 90 96 101 105 108 110 111) 
                  (46 57 67 76 84 91 97 102 106 109 111 112) 
                  (47 58 68 77 85 92 98 103 107 110 112 113)
                  ))

(defvar piram-< '((36 37 39 42 46 51 57 64 72 81 91 102) 
                  (37 38 40 43 47 52 58 65 73 82 92 103) 
                  (38 39 41 44 48 53 59 66 74 83 93 104) 
                  (39 40 42 45 49 54 60 67 75 84 94 105) 
                  (40 41 43 46 50 55 61 68 76 85 95 106) 
                  (41 42 44 47 51 56 62 69 77 86 96 107) 
                  (42 43 45 48 52 57 63 70 78 87 97 108) 
                  (43 44 46 49 53 58 64 71 79 88 98 109) 
                  (44 45 47 50 54 59 65 72 80 89 99 110) 
                  (45 46 48 51 55 60 66 73 81 90 1 111) 
                  (46 47 49 52 56 61 67 74 82 91 101 112) 
                  (47 48 50 53 57 62 68 75 83 92 102 113)
                  ))

(defvar majour-scale '(
                         (60 62 64 65 67 69 71 ) 
                         (61 63 65 66 68 70 72 ) 
                         (62 64 66 67 69 71 73 ) 
                         (63 65 67 68 70 72 74 ) 
                         (64 66 68 69 71 73 75 ) 
                         (65 67 69 70 72 74 76 ) 
                         (66 68 70 71 73 75 77 ) 
                         (67 69 71 72 74 76 78 ) 
                         (68 70 72 73 75 77 79 ) 
                         (69 71 73 74 76 78 68 ) 
                         (70 72 74 75 77 79 69 ) 
                         (71 73 75 76 78 68 70 )))

(defvar minor-scale '(
                       (60 62 63 65 67 68 70 ) 
                       (61 63 64 66 68 69 71 ) 
                       (62 64 65 67 69 70 72 ) 
                       (63 65 66 68 70 71 73 ) 
                       (64 66 67 69 71 72 74 ) 
                       (65 67 68 70 72 73 75 ) 
                       (66 68 69 71 73 74 76 ) 
                       (67 69 70 72 74 75 77 ) 
                       (68 70 71 73 75 76 78 ) 
                       (69 71 72 74 76 77 79 ) 
                       (70 72 73 75 77 78 68 ) 
                       (71 73 74 76 78 79 69 )))

(defvar minor-triad '((60 63 67) (61 64 68) (62 65 69) (63 66 70) 
                 (64 67 71) (65 68 72) (66 69 73) (67 70 74) 
                 (68 71 75) (69 72 76) (70 73 77) (71 74 78)))

(defvar major-triad '((60 64 67) (61 65 68) (62 66 69) (63 67 70) 
                   (64 68 71) (65 69 72) (66 70 73) (67 71 74) 
                   (68 72 75) (69 73 76) (70 74 77) (71 75 78)))
;
;===================================     Package    =============================================
;
(in-package :jbs-cmi)
;==========================  MENU   ===============
;
;(define-menu jbs-cmi :print-name "JBS-Cmi")
;(in-menu jbs-cmi)
;
;
;=================================      PITCH      ======================================
;
;
;================================================================================================
;=============================   harmonic-fields menu   =========================================
;================================================================================================
;
(define-menu pitch :in jbs-cmi)
(in-menu pitch)
;
;;;==============================================================================================
;                                            FIELDS
;;;==============================================================================================
;
(define-box harmonic-fields ((field nil))
  "This function allows you to define as defvar variables some list of chords and to recall them in three different ways.
First you have to define a set of chords.

Here is an example: 
(defvar major-triad '((60 64 67) (61 65 68) (62 66 69) (63 67 70) 
                   (64 68 71) (65 69 72) (66 70 73) (67 71 74) 
                   (68 72 75) (69 73 76) (70 74 77) (71 75 78)))

Then you can recall the whole classes of chords with their 12 transpositions, just typing the class name.


But you cane also recall one class with a specific transposition value. This value belongs to the modulo 12 pitch result.
For instance : (major-triad 11)

Or you can set a specific order to recall some transpositions of the two classes of chords.

Here is an example : ((major-triad  11) (o-a 1) (major-triad 2) (o-d 7)).

I've defined some classes chosen by my own taste: these calsses come out of E. Carter, K. Stockhausen, I. Fedele, and some of myself.

Here they are:


(defvar wood '(64 67 74 71 77))

(defvar -4-5-a '((60 61 62 64) (61 62 63 65) (62 63 64 66) (63 64 65 67) (64 65 66 68)
                 (65 66 67 69) (66 67 68 70) (67 68 69 71) (68 69 70 72) (69 70 71 73)
                 (70 71 72 74) (71 72 73 75)))

(defvar -4-5-b '((60 61 63 64) (61 62 64 65) (62 63 65 66) (63 64 66 67) (64 65 67 68)
                 (65 66 68 69) (66 67 69 70) (67 68 70 71) (68 69 71 72) (69 70 72 73)
                 (70 71 73 74) (71 72 74 75)))

(defvar -4-5-c '((60 62 63 64) (61 63 64 65) (62 64 65 66) (63 65 66 67) (64 66 67 68)
                 (65 67 68 69) (66 68 69 70) (67 69 70 71) (68 70 71 72) (69 71 72 73)
                 (70 72 73 74) (71 73 74 75)))

(defvar -3-6-a '((60 61 62 67) (61 62 63 68) (62 63 64 69) (63 64 65 70) (64 65 66 71)
                 (65 66 67 72) (66 67 68 73) (67 68 69 74) (68 69 70 75) (69 70 71 76)
                 (70 71 72 77) (71 72 73 78)))

(defvar -3-6-b '((60 61 66 67) (61 62 67 68) (62 63 68 69) (63 64 69 70) (64 65 70 71)
                 (65 66 71 72) (66 67 72 73) (67 68 73 74) (68 69 74 75) (69 70 75 76)
                 (70 71 76 77) (71 72 77 78)))

(defvar o-a '((60 61 63 67) (61 62 64 68) (62 63 65 69) (63 64 66 70) (64 65 67 71)
              (65 66 68 72) (66 67 69 73) (67 68 70 74) (68 69 71 75) (69 70 72 76)
              (70 71 73 77) (71 72 74 78)))

(defvar o-b '((60 61 64 66) (61 62 65 67) (62 63 66 68) (63 64 67 69) (64 65 68 70)
              (65 66 69 71) (66 67 70 72) (67 68 71 73) (68 69 72 74) (69 70 73 75)
              (70 71 74 76) (71 72 75 77)))

(defvar o-c '((60 62 65 66) (61 63 66 67) (62 64 67 68) (63 65 68 69) (64 66 69 70)
              (65 67 70 71) (66 68 71 72) (67 69 72 73) (68 70 73 74) (69 71 74 75)
              (70 72 75 76) (71 73 76 77)))

(defvar o-d '((60 64 66 67) (61 65 67 68) (62 66 68 69) (63 67 69 70) (64 68 70 71)
              (65 69 71 72) (66 70 72 73) (67 71 73 74) (68 72 74 75) (69 73 75 76)
              (70 74 76 77) (71 75 77 78)))

(defvar -4-a '((60 61 62 63 65) (61 62 63 64 66) (62 63 64 65 67) (63 64 65 66 68)
               (64 65 66 67 69) (65 66 67 68 70) (66 67 68 69 71) (67 68 69 70 72)
               (68 69 70 71 73) (69 70 71 72 74) (70 71 72 73 75) (71 72 73 74 76)))

(defvar -4-b '((60 61 62 64 65) (61 62 63 65 66) (62 63 64 66 67) (63 64 65 67 68)
               (64 65 66 68 69) (65 66 67 69 70) (66 67 68 70 71) (67 68 69 71 72)
               (68 69 70 72 73) (69 70 71 73 74) (70 71 72 74 75) (71 72 73 75 76)))

(defvar -4-c '((60 61 63 64 65) (61 62 64 65 66) (62 63 65 66 67) (63 64 66 67 68)
               (64 65 67 68 69) (65 66 68 69 70) (66 67 69 70 71) (67 68 70 71 72)
               (68 69 71 72 73) (69 70 72 73 74) (70 71 73 74 75) (71 72 74 75 76)))

(defvar -4-d '((60 62 63 64 65) (61 63 64 65 66) (62 64 65 66 67) (63 65 66 67 68)
               (64 66 67 68 69) (65 67 68 69 70) (66 68 69 70 71) (67 69 70 71 72)
               (68 70 71 72 73) (69 71 72 73 74) (70 72 73 74 75) (71 73 74 75 76)))

(defvar crom-up '(60 61 62 63 64 65 66 67 68 69 70 71))

(defvar crom-down '(71 70 69 68 67 66 65 64 63 62 61 60))

(defvar 4-up '((60 65 70 75 68 73 78 71 64 69 62 67) 
                (61 66 71 76 69 74 79 72 65 70 63 68)
                (61 66 71 76 69 74 79 72 65 70 63 68) 
                (62 67 72 77 70 75 80 73 66 71 64 69)
                (63 68 73 78 71 76 81 74 67 72 65 70) 
                (64 69 74 79 72 77 82 75 68 73 66 71)
                (65 70 75 80 73 78 83 76 69 74 67 72) 
                (66 71 76 81 74 79 84 77 70 75 68 73)
                (67 72 77 82 75 80 85 78 71 76 69 74) 
                (68 73 78 83 76 81 86 79 72 77 70 75)
                (69 74 79 84 77 82 87 80 73 78 71 76) 
                (70 75 80 85 78 83 88 81 74 79 72 77)
                (71 76 81 86 79 84 89 82 75 80 73 78)
                ))

(defvar 4< '((36 41 46 51 56 61 66 71 76 81 86 91 96) 
              (37 42 47 52 57 62 67 72 77 82 87 92 97) 
              (38 43 48 53 58 63 68 73 78 83 88 93 98) 
              (39 44 49 54 59 64 69 74 79 84 89 94 99) 
              (40 45 50 55 60 65 70 75 80 85 90 95 1) 
              (41 46 51 56 61 66 71 76 81 86 91 96 101) 
              (42 47 52 57 62 67 72 77 82 87 92 97 102) 
              (43 48 53 58 63 68 73 78 83 88 93 98 103) 
              (44 49 54 59 64 69 74 79 84 89 94 99 104) 
              (45 50 55 60 65 70 75 80 85 90 95 1 105) 
              (46 51 56 61 66 71 76 81 86 91 96 101 106) 
              (47 52 57 62 67 72 77 82 87 92 97 102 107)
              ))

(defvar 5-up '((60 67 74 69 76 71 66 61 68 63 70 65) 
                (61 68 75 70 77 60 67 62 69 64 71 66) 
                (62 69 76 71 78 61 68 63 70 65 60 67) 
                (63 70 77 72 67 62 69 64 71 66 61 68) 
                (64 71 78 73 68 63 70 65 60 67 62 69) 
                (65 72 79 74 69 64 71 66 61 68 63 70) 
                (66 73 68 75 70 65 60 67 62 69 64 71) 
                (67 74 69 76 71 66 61 68 63 70 65 60) 
                (68 75 70 77 60 67 62 69 64 71 66 61) 
                (69 76 71 78 61 68 63 70 65 60 67 62) 
                (70 77 72 67 62 69 64 71 66 61 68 63) 
                (71 78 73 68 63 70 65 60 67 62 69 64)
                ))

(defvar 5< '((36 43 50 57 64 71 78 85 92 99 106 113 120) 
              (37 44 51 58 65 72 79 86 93 1 107 114 121) 
              (38 45 52 59 66 73 80 87 94 101 108 115 122) 
              (39 46 53 60 67 74 81 88 95 102 109 116 123) 
              (40 47 54 61 68 75 82 89 96 103 110 117 124) 
              (41 48 55 62 69 76 83 90 97 104 111 118 125) 
              (42 49 56 63 70 77 84 91 98 105 112 119 126) 
              (43 50 57 64 71 78 85 92 99 106 113 120 127) 
              (44 51 58 65 72 79 86 93 1 107 114 121 128) 
              (45 52 59 66 73 80 87 94 101 108 115 122 129) 
              (46 53 60 67 74 81 88 95 102 109 116 123 130) 
              (47 54 61 68 75 82 89 96 103 110 117 124 131)
              ))

(defvar octphone '((60 61 63 64 66 67 69 70) 
                   (61 62 64 65 67 68 70 71) 
                   (62 63 65 66 68 69 71 72)))

(defvar enphone '((60 61 62 64 65 66 68 69 70) 
                  (61 62 63 65 66 67 69 70 71)
                  (62 63 64 66 67 68 70 71 72) 
                  (63 64 65 67 68 69 71 72 73)
                  ))

(defvar pentaton-a '((60 61 65 69 70) 
                     (61 62 66 70 71) 
                     (62 63 67 71 72) 
                     (63 64 68 72 73) 
                     (64 65 69 73 74) 
                     (65 66 70 74 75) 
                     (66 67 71 75 76) 
                     (67 68 72 76 77) 
                     (68 69 73 77 78) 
                     (69 70 74 78 79) 
                     (70 71 75 79 68) 
                     (71 72 76 68 69)
                     ))

(defvar pentaton-b '((60 61 63 65 66) 
                     (61 62 64 66 67) 
                     (62 63 65 67 68) 
                     (63 64 66 68 69) 
                     (64 65 67 69 70) 
                     (65 66 68 70 71) 
                     (66 67 69 71 72) 
                     (67 68 70 72 73) 
                     (68 69 71 73 74) 
                     (69 70 72 74 75) 
                     (70 71 73 75 76) 
                     (71 72 74 76 77)
                     ))

(defvar octotone '((60 62 64 65 66 68 70 71) 
                   (61 63 65 66 67 69 71 72) 
                   (62 64 66 67 68 70 72 73) 
                   (63 65 67 68 69 71 73 74) 
                   (64 66 68 69 70 72 74 75) 
                   (65 67 69 70 71 73 75 76)
                   ))

(defvar eptatone-a '((60 63 64 65 67 68 69 72) 
                     (61 64 65 66 68 69 70 73) 
                     (62 65 66 67 69 70 71 74) 
                     (63 66 67 68 70 71 72 75) 
                     (64 67 68 69 71 72 73 76) 
                     (65 68 69 70 72 73 74 77) 
                     (66 69 70 71 73 74 75 78) 
                     (67 70 71 72 74 75 76 79) 
                     (68 71 72 73 75 76 77 68) 
                     (69 72 73 74 76 77 78 69) 
                     (70 73 74 75 77 78 79 70) 
                     (71 74 75 76 78 79 68 71)
                     ))

(defvar eptatone-b '((60 61 62 65 67 70 71 72) 
                    (61 62 63 66 68 71 72 73) 
                    (62 63 64 67 69 72 73 74) 
                    (63 64 65 68 70 73 74 75) 
                    (64 65 66 69 71 74 75 76) 
                    (65 66 67 70 72 75 76 77) 
                    (66 67 68 71 73 76 77 78) 
                    (67 68 69 72 74 77 78 79) 
                    (68 69 70 73 75 78 79 68) 
                    (69 70 71 74 76 79 68 69) 
                    (70 71 72 75 77 68 69 70) 
                    (71 72 73 76 78 69 70 71)
                    ))

(defvar openton-5 '((36 38 40 42 43 45 47 49 50 52 54 56 
                      57 59 61 63 64 66 68 70 71 73 75 77 
                      78 68 70 72 73 75 77 55 56 58 60 62 
                      63 65 43 45 46 48 50 52 53 43 45 47 
                      36)
                     (36 37 39 40 42 43 44 46 47 49 50 51 
                      53 54 56 57 58 60 61 63 64 65 67 68 
                      70 71 72 74 75 77 78 79 69 70 72 73 
                      74 76 77 55 56 57 59 60 62 63 64 66 
                      43 45 46 47 49 50 52 53 54 44 45 47 
                      36)
                     (36 38 39 41 42 43 45 46 48 49 50 52 
                      53 55 56 57 59 60 62 63 64 66 67 69 
                      70 71 73 74 76 77 78 68 69 71 72 73 
                      75 76 78 55 56 58 59 61 62 63 65 66 
                      44 45 46 48 49 51 52 53 43 44 46 47 
                      36)
                     ))

(defvar openton-4 '((36 38 40 41 43 45 46 48 50 51 53 55 
                      56 58 60 61 63 65 66 68 70 71 73 75 
                      76 78 68 69 71 73 74 76 78 55 57 59 
                      60)
                     (36 37 39 40 41 42 44 45 46 47 49 50 
                      51 52 54 55 56 57 59 60 61 62 64 65 
                      66 67 69 70 71 72 74 75 76 77 79 68 
                      69 70 72 73 74 75 77 78 55 56 58 59 
                      60)
                     (36 37 39 41 42 44 46 47 49 51 52 54 
                      56 57 59 61 62 64 66 67 69 71 72 74 
                      76 77 79 69 70 72 74 75 77 55 56 58 
                      60)
                     ))

(defvar piram-> '((36 47 57 66 74 81 87 92 96 99 101 102) 
                  (37 48 58 67 75 82 88 93 97 1 102 103) 
                  (38 49 59 68 76 83 89 94 98 101 103 104) 
                  (39 50 60 69 77 84 90 95 99 102 104 105) 
                  (40 51 61 70 78 85 91 96 1 103 105 106) 
                  (41 52 62 71 79 86 92 97 101 104 106 107) 
                  (42 53 63 72 80 87 93 98 102 105 107 108) 
                  (43 54 64 73 81 88 94 99 103 106 108 109) 
                  (44 55 65 74 82 89 95 1 104 107 109 110) 
                  (45 56 66 75 83 90 96 101 105 108 110 111) 
                  (46 57 67 76 84 91 97 102 106 109 111 112) 
                  (47 58 68 77 85 92 98 103 107 110 112 113)
                  ))

(defvar piram-< '((36 37 39 42 46 51 57 64 72 81 91 102) 
                  (37 38 40 43 47 52 58 65 73 82 92 103) 
                  (38 39 41 44 48 53 59 66 74 83 93 104) 
                  (39 40 42 45 49 54 60 67 75 84 94 105) 
                  (40 41 43 46 50 55 61 68 76 85 95 106) 
                  (41 42 44 47 51 56 62 69 77 86 96 107) 
                  (42 43 45 48 52 57 63 70 78 87 97 108) 
                  (43 44 46 49 53 58 64 71 79 88 98 109) 
                  (44 45 47 50 54 59 65 72 80 89 99 110) 
                  (45 46 48 51 55 60 66 73 81 90 1 111) 
                  (46 47 49 52 56 61 67 74 82 91 101 112) 
                  (47 48 50 53 57 62 68 75 83 92 102 113)
                  ))

(defvar majour-scale '(
                         (60 62 64 65 67 69 71 ) 
                         (61 63 65 66 68 70 72 ) 
                         (62 64 66 67 69 71 73 ) 
                         (63 65 67 68 70 72 74 ) 
                         (64 66 68 69 71 73 75 ) 
                         (65 67 69 70 72 74 76 ) 
                         (66 68 70 71 73 75 77 ) 
                         (67 69 71 72 74 76 78 ) 
                         (68 70 72 73 75 77 79 ) 
                         (69 71 73 74 76 78 68 ) 
                         (70 72 74 75 77 79 69 ) 
                         (71 73 75 76 78 68 70 )))

(defvar minor-scale '(
                       (60 62 63 65 67 68 70 ) 
                       (61 63 64 66 68 69 71 ) 
                       (62 64 65 67 69 70 72 ) 
                       (63 65 66 68 70 71 73 ) 
                       (64 66 67 69 71 72 74 ) 
                       (65 67 68 70 72 73 75 ) 
                       (66 68 69 71 73 74 76 ) 
                       (67 69 70 72 74 75 77 ) 
                       (68 70 71 73 75 76 78 ) 
                       (69 71 72 74 76 77 79 ) 
                       (70 72 73 75 77 78 68 ) 
                       (71 73 74 76 78 79 69 )))

(defvar minor-triad '((60 63 67) (61 64 68) (62 65 69) (63 66 70) 
                 (64 67 71) (65 68 72) (66 69 73) (67 70 74) 
                 (68 71 75) (69 72 76) (70 73 77) (71 74 78)))

(defvar major-triad '((60 64 67) (61 65 68) (62 66 69) (63 67 70) 
                   (64 68 71) (65 69 72) (66 70 73) (67 71 74) 
                   (68 72 75) (69 73 76) (70 74 77) (71 75 78)))"
  :non-generic t
  :class cmi-box
  (let ((ris nil))
    
    (cond ((symbolp field)
           (eval field))
          ((and (listp field)
                (symbolp (first field)))
           (nth (second field) (eval (first field))))
          ((dolist (y field (nreverse ris))
             (push (nth (second y) (eval (first y))) ris))))))
;
;;;==============================================================================================
;                                    ANSWER
;;;==============================================================================================
;
(define-box answer ((subject (60 67 64 62 60)) (dominant 1))
  "2.2 - ANSWER

This function is a simplified reproduction of the tonal answer of the fugue.

In [subject] you put a melodic profile.

In [dominant] you define (as nth index) which note of the profile has to be considered as the dominant.

When you evaluate the ANSWER all the notes of the profile are transposed to the dominant, except the dominant, that is transposed on the tonic.

"
  :non-generic t
  :class cmi-box
  (cond ((< (- (nth dominant subject) (first subject)) 0)
         (subst (first subject)
                (nth dominant (mapcar #' (lambda (x) 
                                           (+ x (- (nth dominant subject) (first subject)))) subject))
                (mapcar #' (lambda (x) 
                             (+ x (- (nth dominant subject) (first subject)))) subject)))
        ((> (- (nth dominant subject) (first subject)) 0)
         (subst (+ 12 (first subject))
                (nth dominant (mapcar #' (lambda (x) 
                                           (+ x (- (nth dominant subject) (first subject)))) subject))
                (mapcar #' (lambda (x) 
                             (+ x (- (nth dominant subject) (first subject)))) subject)))))