;;; arch-tag: BEFEE33F-6827-4F6C-99E8-4DFFBEE4A942
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     COSNTRAINTS  TOOLS      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(in-package :jbs-constraints)

(define-menu utilities :in jbs-constraints)
(in-menu utilities)

(defun list! (thing)
  (if (listp thing) thing (list thing)))
;;;
;;;
;;;==========================================================================================
;;;==========================       collect-rules           =================================
;;;==========================================================================================
;;;

(define-box collect-rules ((r1 nil) &rest more-rules)
  "Collect the rules and seperate true/false from heuristic rules. Use the two outputs in order to connect to the pmc-engine"    
  :outputs 2
  (let* ((therules (remove nil (cons r1 more-rules)))
	 (tf-rules (remove-if #'(lambda (x) (eql :heuristic (first x))) therules))
	 (h-rules (remove-if #'(lambda (x) (eql :true/false (first x))) therules)))
    (values (mapcar #'rest tf-rules) (mapcar #'rest h-rules))))
;;;
;;;
;;;==========================================================================================
;;;==========================       collect-script-rules           =================================
;;;==========================================================================================
;;;
(define-box collect-script-rules ((r1 nil) &rest more-rules)
  "Collect the rules for the enp-script. Use the two outputs in order to connect to the pmc-engine"    
  (remove nil (cons r1 more-rules)))
;
;;;==========================================================================================
;;;=============================            MK-?1        ====================================
;;;==========================================================================================
;;;


(define-box make-?1 ((list (1 2 3)))
  "It creates a list of constraints candidates like ?1 ?2 ?3..."
  (if (atom list)
      (intern (format nil "?~D" list) :ccl)
    (loop for i in list
          collect (intern (format nil "?~D" i) :ccl))))

(define-box make-?1-from-to ((from 1) (to 2))
  "It creates a list of constraints candidates like ?from ... ?to"    
  (assert (<= from to))
  (loop for i from from to to
        collect (intern (format nil "?~D" i) :ccl)))

;;;
;;;
;;;==========================================================================================
;;;=============================            MK-i1        ====================================
;;;==========================================================================================
;;;
(define-box make-i1 ((list (1 2 3)))
  "It creates a list of i1 i2 i3 accordingly with the list of number you put in list."    
  (if (atom list)
      (intern (format nil "I~D" list) :ccl)
    (loop for i in list
          collect (intern (format nil "I~D" i) :ccl))))


(define-box make-i1-from-to ((from 1) (to 2))
  "It creates a list of constraints candidates like ?from ... ?to"    
  (assert (<= from to))
  (loop for i from from to to
        collect (intern (format nil "I~D" i) :ccl)))
;;;
;;;
;;;==========================================================================================
;;;===========================       MK-linear-candidates     ===============================
;;;==========================================================================================
;;;
(define-box mk-linear-candidates ((lista (1 2 3)) (how-many 2))
  "it creates a list of candidates having for each element of list, with a positive and
negative step indicated in 'how-many. Be careful the increasing or decreasing step is always 1."   
  (let ((ris nil))
    (dolist (y lista (nreverse ris))
      (push (pw::sort-list (pw::x-append (jbs-constraints::arithm-ser-stop y 1 how-many)
					 (rest (jbs-constraints::arithm-ser-stop y -1 how-many)))) ris))))


;;;
;;;
;;;==========================================================================================
;;;============================       MK-range-candidates     ===============================
;;;==========================================================================================
;;;
(define-box mk-range-candidates ((lista (1 2 3)) (how-many 2) (step 2))
  "it creates a list of candidates having for each element of list, with a positive and
negative step indicated in 'step and in the range indicated in 'range."   
  (let ((ris nil))
    (dolist (y lista (nreverse ris))
      (push (pw::sort-list (pw::x-append (jbs-constraints::arithm-ser-stop y step how-many)
					 (rest (jbs-constraints::arithm-ser-stop y (* step -1) how-many)))) ris))))

;;;
;;;
;;;==========================================================================================
;;;==========================       MK-chain-candidates     =================================
;;;==========================================================================================
;;;

(define-box mk-chain-candidates ((list (60 61 62)) (groups 3))
  "FROM MIKAEL LAUSRON : it creates a list of candidates that share a high level of common elements.
In list you put all the range of candidates. In groups how many sub group you want to create."    
  (ccl::group-to-chain list groups))

;;;
;;;
;;;==========================================================================================
;;;==========================       MK-pitch-candidates     =================================
;;;==========================================================================================
;;;

(define-box mk-pitch-candidates ((pitch (60 62 64 65)) (octave 1))
  "It creates a list of pitches entered in 'pitch for number of octaves indicate in 'octave.
If you put 1 you will obtain one octave lower and upper of the original one."    
  (let* ((ris nil)
	 (calcolo (my-arithm-ser 0 (* 12 octave) 12))
	 (calcolaccio (pw::g* calcolo -1))
	 (calcoletto (pw::x-append calcolo calcolaccio)))
    (dolist (y calcoletto (pw::sort-list (pw::remove-duplicates (pw::flat (nreverse ris)))))
      (push (pw::g+ y pitch) ris))))



;;;
;;;
;;;==========================================================================================
;;;================        MK-picth-candidates-not-symmetric      ===========================
;;;==========================================================================================
;;;

(define-box mk-pitch-candidates-not-symmetric ((pitch (60 61 62)) (down 1) (up 2))
  "It creates a list of pitch candidates. In pitch you put the note yuo want to be repeated.
In down and up you indicate how many octaves you want the pitch to be transponsed down and in up."    
  (let* ((ris nil)
	 (calcolo-up (my-arithm-ser 0 (* 12 up) 12))
	 (calcolo-down (my-arithm-ser 0 (* 12 down) 12))
	 (calcolaccio (pw::g* calcolo-down -1))
	 (calcoletto (pw::x-append calcolo-up calcolaccio)))
    (dolist (y calcoletto (pw::sort-list (pw::remove-duplicates (pw::flat (nreverse ris)))))
      (push (pw::g+ y pitch) ris))))



;;;
;;;
;;;==========================================================================================
;;;==========================        logic-or-condition           ===========================
;;;==========================================================================================
;;;
(define-box logic-or-condition (&rest rules)
                                
  :class score-pmc-box
  "It is an exensible box. TO BE CONTINUED..."
  (let* ((ris nil)
         (calcolo (dolist (y rules (nreverse ris))
                    (push (second (first (last y))) ris)))
         (inizio (butlast (first rules)))
         (if??? 'ccl::?if))
     `(,.inizio (,if??? (or ,.calcolo)))))

;;;
;;;
;;;==========================================================================================
;;;==========================        s-pmc-or-condition           =================================
;;;==========================================================================================
;;;
(define-box s-pmc-or-condition ((rule1 ())
                                (rule2 ()))
  :class score-pmc-box
  ":or condition from Laurson..."
  `(:or ,rule1 ,rule2))
;;;
;;;
;;;==========================================================================================
;;;=============        Extract pitches from Score-Editor           =========================
;;;==========================================================================================
;;;
(define-box pitch-extract-from-Score-Editor ((complex-list ((((((60)))))))
                                             (mensural-or-not? :mensural))
  "This function extracts pitches from a Score-Editor in the chord format. That means that the 
output for a songle note will be like this (60) and for a chord like this (60 62 69)"
  :non-generic t  
  :menu (mensural-or-not? (1 "mensural") (2 "non-mensural"))
  :class score-pmc-box

  (let* ((ris nil)
         (format-list (pw::flat-once (pw::flat-once (first (first complex-list)))))
         (calculation (dolist (x format-list (pw::flat-once (nreverse ris)))
                        (push (if (atom (first x))
                                  (list x)
                                x)
                              ris))))
    (case mensural-or-not?
      (1 
       (mapcar #'(lambda (x) (ccl::sort< x)) calculation))
      (2 (pw::flat complex-list)))))

;; at the end
(install-menu jbs-constraints)
