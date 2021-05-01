(in-package :PW-AIS)

;===============================================================;
;;; OPERATIONS ;;;

(PWGLDef Q-AIS ((AIS '(0 1 3 2 7 10 8 4 11 5 9 6)))
 "Returns Q-AIS."
()(operation-q AIS))

(PWGLDef I-AIS ((AIS '(0 1 3 2 7 10 8 4 11 5 9 6)))
 "Returns I-AIS."
()(inversion AIS))

(PWGLDef R-AIS ((AIS '(0 1 3 2 7 10 8 4 11 5 9 6) ))
"Returns R-AIS."
()(retrograde AIS))

(PWGLDef RI-AIS ((AIS '(0 1 3 2 7 10 8 4 11 5 9 6)))
"Returns RI-AIS."
()(inversion (retrograde AIS)))

(PWGLDef M-AIS ((AIS '(0 1 3 2 7 10 8 4 11 5 9 6)))
 "Returns M-AIS."
()(m-5 AIS))

(PWGLDef IM-AIS ((AIS '(0 1 3 2 7 10 8 4 11 5 9 6)))
 "Returns IM-AIS."
()(inversion (m-5 AIS)))

(PWGLDef QR-AIS ((AIS '(0 1 3 2 7 10 8 4 11 5 9 6) ))
 "Returns QR-AIS."
()(retrograde (operation-q AIS)))

(PWGLDef 0-AIS ((AIS '(0 1 3 2 7 10 8 4 11 5 9 6)))
 "Returns OPERATION-0-AIS (exchange 3 for 9)."
 ()(operation-0 AIS))

 (PWGLDef CONSTELLATION ((AIS '(0 1 3 2 7 10 8 4 11 5 9 6)))
"
Returns the Constellation of the AIS:
|   P  |  I  |  IM  |  M  |
|   R  | RI  | RIM  | RM  |
|   QR |QRI  |QRIM  |QRM  |
|   Q  | QI  | QIM  | QM  |
"
 ()(make-constellation AIS))
;===============================================================;
;;; UTILS ;;;

(PWGLDef AIS->CHORD ((AIS-list '((0 1 3 2 7 10 8 4 11 5 9 6) (0 1 3 2 9 5 10 4 7 11 8 6))) (lowest-note 36))
 "Returns a list of chords in midicents, transposed to the lowest note <midi>."
() (cond ((and (list-of-listp AIS-list)(numberp lowest-note))
          (mapcar #'(lambda (input1)
           (get-ais-chord input1 lowest-note)) AIS-list))
		 ((and (list-of-listp AIS-list)(listp lowest-note))
		  (mapcar #'(lambda (input1 input2)
		   (get-ais-chord input1 input2)) AIS-list lowest-note))
		 ((and (listp AIS-list)(numberp lowest-note))
		  (get-ais-chord AIS-list lowest-note))
   (t (values))))

(PWGLDef m->pc ((midi '(65 64 72 69 79 74 80 73 75 66 70 59)))
 "Midi to pitch class."
()(mod12 midi))

(PWGLDef pc->m ((pcs '(0 1 3 2 7 10 8 4 11 5 9 6)))
"Pitch class to midi."
()(g+ 60 pcs))

(PWGLDef intervals-mod12 ((AIS '(5 4 0 9 7 2 8 1 3 6 10 11)))
"Calculates the intervals mod12 of an AIS."
()(mod12 (x->dx AIS)))

(PWGLDef AIS->normal ((AIS '(0 1 3 2 7 10 8 4 11 5 9 6)))
 "Transposes an AIS to its normal form."
()(t-0 AIS))

(PWGLDef AIS->prime ((AIS '(0 1 3 2 7 10 8 4 11 5 9 6)))
 "Calculates the prime form of an AIS."
()(let* ((normal-form (t-0 AIS))
       (first-interval (- (second normal-form) (first normal-form))))
   (cond ((< first-interval (- 12 first-interval))
          (write normal-form))
   (t (write (inversion normal-form))))))
