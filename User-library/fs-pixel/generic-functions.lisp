;;;       fs-pixel PWGL

;;; Copyright (c) 2011, Filippo Saya.  All rights reserved.
;;;

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

;;;==============================================================================================
;;;                                GENERIC-FUNCTIONS FOR fs-pixel    2011    
;;;==============================================================================================
;===================================     Package    =============================================
;
(in-package :fs-pixel)
;
;============================  subs-prof-list FROM BRIAN FERNEYHOUGH  ===============================================
;
(defvar *index* nil)

(defun subs-prof-list (list1 list2)
  (cond ((null list1) nil)
        ((atom list1) (nth (setf *index* (incf *index*)) list2))
        (t (cons ( subs-prof-list (first list1) list2) 
                 ( subs-prof-list(rest list1) list2)))))

(defun gl-subs (list1 list2)
  (setf *index* -1)
  (subs-prof-list list1 list2))

;;;==============================================================================================
;;;                                FOR    CROSSFADES   
;;;==============================================================================================
;
;============================  formattatore di parentesi  ===============================================
;
(define-box format-parenthesis ((my-list ((((((1))))) (((((2)))))))) 

  "this function formats score-editor parenthesis to reach to chord level"
  :non-generic t
  :class fs-box
  (pw::flat-low (pw::flat-low (first my-list))))
;
;============================  formattatore di parentesi  con nth ===============================================
;
(define-box format-parenthesis-nth ((score-pitches nil) (nths nil)) 

  "this function formats score-editor parenthesis to reach to chord level"
  :non-generic t
  :class fs-box
  (pw::flat-low (pw::flat-low (first (nth nths score-pitches)))))



;
;============================ trasforma nil in -1 single step ===============================================
;
(define-box change-nil-into-minus1-simple ((input 1)) 

            "questa doc la fai tu stasera"
            :non-generic t
            :class fs-box
            (if (equalp input nil)
                -1
              input))

;
;============================ trasforma nil in -1 inside a loop ===============================================
;
(define-box change-nil-into-minus1-inloop ((my-list (1 nil nil 1 nil pino nil pina))) 

            "questa doc la fai tu stasera"
            :non-generic t
            :class fs-box
            (iter 
             (for x in my-list) 
             (if (equalp x nil)
                 (collect -1)
               (collect x))))
;
;============================ trasforma nil in 0 inside a loop ===============================================
;
(define-box change-nil-into-zero-inloop ((my-list (1 nil nil 1 nil pino nil pina))) 

            "questa doc la fai tu stasera"
            :non-generic t
            :class fs-box
            (iter 
             (for x in my-list) 
             (if (equalp x nil)
                 (collect 0)
               (collect 1))))
;
;============================ trasforma nil in 0 inside a loop with grouping===============================================
;
(define-box change-nil-into-zero-inloop-grouped ((my-list (1 nil nil 1 nil pino nil pina))) 

  "questa doc la fai tu stasera"
  :non-generic t
  :class fs-box
  (jbs-cmi::GROUPING-INCLUDING-GIVEN-ELEMENT 
   (iter 
     (for x in my-list) 
     (if (equalp x nil)
         (collect 0)
       (collect 1))) 1))

;
;============================ crea pause (col -1) e note (comn 1) per Kilian ===============================================
;
(define-box create-1and+1-for-kilian ((my-list (1 nil nil 1 nil pino nil pina))) 

            "questa doc la fai tu stasera"
            :non-generic t
            :class fs-box
            (iter 
             (for x in my-list) 
             (if (equalp x -1)
                 (collect -1)
               (collect 1))))

;
;============================ crea pause (col -1) e note (comn 1) per Kilian ===============================================
;
(define-box first-n-of-minimum ((list1 (1 2 3 1 2 3 1 2 3)) (list2 (a s d a s d))) 

  "questa doc la fai tu stasera idem"
 
  (let* ((lungo1 (length list1))
         (lungo2 (length list2))
         (minimo (min lungo1 lungo2)))
              
    (list (jbs-cmi::first-n list1 minimo)
          (jbs-cmi::first-n list2 minimo))))

;
;============================ my-sample curve  ===============================================
;
(define-box my-sample ((curve nil) (howmany 10))

  "questa doc la fai tu stasera idem"
  
  (let ((curva (pw::g-round (pw:g-scaling (ccl::pwgl-sample curve howmany)
                                          0
                                          100))))
              
    (list (first (pw::g- 100 curva))
            (first curva))))

;
;============================ crea candidati curvi  ===============================================
;
(define-box crea-candidati-curvi ((lista1 nil) (lista2 nil)
                                  (curva1 nil) (curva2 nil))

  "questa doc la fai tu stasera idem"
  
  (let ((risultato nil))
    (dotimes (x (length lista1) (nreverse risultato))
      (push (pw::x-append (jbs-constraints::mio-repeat (nth x lista1) (nth x curva1))
                          (jbs-constraints::mio-repeat (nth x lista2) (nth x curva2))) risultato))))
                   






(define-box special-test-cosntraints ((list1 ((1 2 3) (a b c) (www zzz ttt)))
                                      (rules nil))
  ""
  :non-generic t
  :class fs-box

  (first (ccl::pmc list1 rules :rnd? t)))




(define-box kilian-format ((pitches nil) (durs nil))

(ksquant::SIMPLE2SCORE
 (ksquant::PITCHES-DURS2SIMPLE pitches durs)
 :time-signatures '(1 8)
 :metronomes '(2 160)
 :scale '1/8))



(define-box almost-crossfade-curve ((low-pix-score nil)
                                    (high-pix-score nil)
                                    (curve nil)
                                    (rules nil))
  "miiiiiiiiii devi un caffé..."

  :non-generic t
  :class fs-box

  
  (let* ((input1 low-pix-score)
         (input2 high-pix-score)
         (format-parentesis1 (fs-pixel::FORMAT-PARENTHESIS input1))
         (format-parentesis2 (fs-pixel::FORMAT-PARENTHESIS input2))
         (CHANGE-NIL-INTO-MINUS1-INLOOP1 (fs-pixel::CHANGE-NIL-INTO-MINUS1-INLOOP format-parentesis1))
         (CHANGE-NIL-INTO-MINUS1-INLOOP2 (fs-pixel::CHANGE-NIL-INTO-MINUS1-INLOOP format-parentesis2))
         (FIRST-N-OF-MINIMUM-local (fs-pixel::FIRST-N-OF-MINIMUM CHANGE-NIL-INTO-MINUS1-INLOOP1
                                                                 CHANGE-NIL-INTO-MINUS1-INLOOP2))
         (local-MY-SAMPLE (fs-pixel::MY-SAMPLE curve (length (first FIRST-N-OF-MINIMUM-local))))
         (local-CREA-CANDIDATI-CURVI (fs-pixel::CREA-CANDIDATI-CURVI (first FIRST-N-OF-MINIMUM-local)
                                                                     (second FIRST-N-OF-MINIMUM-local)
                                                                     (first local-MY-SAMPLE)
                                                                     (second local-MY-SAMPLE)))
         (local-SPECIAL-TEST-COSNTRAINTS (fs-pixel::SPECIAL-TEST-COSNTRAINTS local-CREA-CANDIDATI-CURVI rules))
         (local-kilian-format (fs-pixel::kilian-format (remove -1 local-SPECIAL-TEST-COSNTRAINTS)
                                                       (fs-pixel::CREATE-1AND+1-FOR-KILIAN local-SPECIAL-TEST-COSNTRAINTS))))
         
         
         local-kilian-format))
;;;==============================================================================================
;;;                                FOR    REVERBS   
;;;==============================================================================================
(define-box which-part ((pitch-from-pix nil) (which ":all"))
  ""
  :non-generic t
  :class fs-box
  (if (equalp which ':all)
      (pw::arithm-ser 0 1 (1- (length pitch-from-pix)))
    which))


;
;============================ Bypass  ===============================================
;
(define-box bypass ((pitch-from-pix nil) (which ":all"))
  ""
  :non-generic t
  :class fs-box
  (let ((ris nil)
        (calcolo (pw::x-xor (pw::arithm-ser 0 1 (1- (length pitch-from-pix))) which)))

    (dotimes (x (length calcolo) (nreverse ris))
     (push 
      (pw::x-append (nth x calcolo) 
                    (fs-pixel::kilian-format 
                     (pw::flat-low (pw::flat-low (remove nil (first (nth x pitch-from-pix)))))
                     (fs-pixel::create-1and+1-for-kilian (first (nth x pitch-from-pix))))) ris))))
;
;============================ Bypass  ===============================================
;
(define-box output ((which-output nil) (processed nil) (bypassed nil))
  ""
  :non-generic t
  :class fs-box

  (let ((calcolo (mapcar #'(lambda (x) (rest x)) (sort (pw::x-append processed bypassed) '< :key 'first))))
    (ccl::collect-enp-objects (cond ((equalp which-output ':all)
                                     calcolo)
                                    ((equalp which-output ':processed)
                                     (mapcar #'(lambda (x) (rest x)) (sort processed '< :key 'first)))
                                    ((listp which-output) (pw::posn-match calcolo which-output)))  ':part)))

;
;============================ condizione pause iniziali  ===============================================
;
(define-box condizioni-pause-iniziali ((lista nil))
  ""
  :non-generic t
  :class fs-box
          
 (if (zerop (first (first lista)))
     (rest lista)
   lista))
;
;============================ siamo qua  ===============================================
;
(define-box pre-tremolatore ((input nil))
   ""
  :non-generic t
  :class fs-box
  (let ((ris nil)
        (resto (rest (remove nil input))))
    (dotimes (x (1- (length (remove nil input))) (nreverse ris))
      (push (list (nth x resto)
                  (nth x (remove nil input))) ris))))
      
;
;============================ campionatore del limite  ===============================================
;
(define-box campionatore-limite ((input nil) (curva nil) (minmax nil))
  ""
  :non-generic t
  :class fs-box

  (pw::flat (pw::g-round (pw::g-scaling (ccl::pwgl-sample curva (1+ (length input)))
                                        (pw::g-min minmax)
                                        (pw::g-max minmax)))))
;
;============================ campionatore del limite  ===============================================
;
(define-box tremolatore-con-limitatore-curvo ((input1 nil) (input2 nil) (input3 nil))
   ""
  :non-generic t
  :class fs-box
  (let ((ris nil))
    (dotimes (x (length input1) (pw::flat-once (nreverse ris)))
      (push (pw::x-append 
             (pw::firstn (pw::g-min (pw::x-append (nth x input3) (length (nth x input1)))) 
                         (pw::flat-once 
                          (jbs-constraints::mio-repeat (nth x input2) 
                                                       (pw::g-min (pw::x-append (nth x input3) 
                                                                                (length (nth x input1)))))))
                                                                                  
     
             (jbs-constraints::mio-repeat -1 (pw::g- (length (nth x input1)) (pw::g-min (pw::x-append (nth x input3) (length (nth x input1)))))))
            ris))))
;
;============================ ma perché?  ===============================================
;
(define-box ma-perché? ((input1 nil))
  ""
  :non-generic t
  :class fs-box
  (remove 0 (list (pw::g* (length (if (zerop (first (first input1)))
                                      (first input1)
                                    nil)) -1))))
;
;============================ ma perché?  ===============================================
;
(define-box ma-dove-vado? ((input1 nil) (input2 nil) (input3 nil) (input4 nil) (input5 nil))
  ""
  :non-generic t
  :class fs-box
  
  
  (fs-pixel::kilian-format  
   (remove -1 
           (pw::x-append 
            (pw::x-append 
             (jbs-constraints::mio-repeat (first  (remove nil input3))
                                          (pw::g-min (pw::x-append input2
                                                                   (length (first input4)))))

             (jbs-constraints::mio-repeat -1          
                                          (pw::g- (length (first input4))
                                                  (pw::g-min (pw::x-append input2
                                                                           (length (first input4)))))))
            input1))

   (pw::x-append 
    input5
    (fs-pixel::create-1and+1-for-kilian   
     (pw::x-append 
      (pw::x-append 
       (jbs-constraints::mio-repeat (first  (remove nil input3))
                                    (pw::g-min (pw::x-append input2
                                                             (length (first input4)))))

       (jbs-constraints::mio-repeat -1          
                                    (pw::g- (length (first input4))
                                            (pw::g-min (pw::x-append input2
                                                                     (length (first input4)))))))
      input1)))))
;
;============================  dipende  ===============================================
;
(define-box quasi-reverb  ((input1 nil) (input2 nil) (input3 nil) (input4 nil))
  ""
  :non-generic t
  :class fs-box
  (let ((ris nil))
    (dolist (y (fs-pixel::which-part input1 input2) (nreverse ris))
      (push (pw::x-append y
                          (fs-pixel::ma-dove-vado? 
                           (fs-pixel::tremolatore-con-limitatore-curvo   ;tremolatore-con-limitatore-curvo input1
                            (rest (fs-pixel::condizioni-pause-iniziali (fs-pixel::change-nil-into-zero-inloop-grouped (fs-pixel::format-parenthesis-nth input1 y))))
                            (fs-pixel::pre-tremolatore (fs-pixel::format-parenthesis-nth input1 y))
                            (rest (fs-pixel::campionatore-limite (fs-pixel::pre-tremolatore (fs-pixel::format-parenthesis-nth input1 y))
                                                                 input3
                                                                 input4)))
                           (first (fs-pixel::campionatore-limite (fs-pixel::pre-tremolatore (fs-pixel::format-parenthesis-nth input1 y))
                                                                 input3
                                                                 input4)) ;input2
                           (fs-pixel::format-parenthesis-nth input1 y) ; input3
                           (fs-pixel::condizioni-pause-iniziali (fs-pixel::change-nil-into-zero-inloop-grouped (fs-pixel::format-parenthesis-nth input1 y))) ;input4
                           (fs-pixel::ma-perché? (fs-pixel::change-nil-into-zero-inloop-grouped (fs-pixel::format-parenthesis-nth input1 y)))
                           )) ris))))


;
;============================  dipende  ===============================================
;
(define-box quasi-fine  ((input1 nil) (input2 nil) (input3 nil) (input4 nil) (input5 nil))
  ""
  :non-generic t
  :class fs-box

  (fs-pixel::output 
   input5
   (fs-pixel::quasi-reverb input1 input2 input3 input4)
   (fs-pixel::bypass input1 (fs-pixel::which-part input1 input2))))