(in-package :PW-AIS)

(defvar *PW-AIS-path* 
 (make-pathname :directory 
  (append (pathname-directory (asdf:component-pathname (asdf:find-system "PW-AIS")))
          (list "AIS"))))
		  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; THANKS TO CHARLES NEIMOG WHO FOUND THIS ON REEDIT

(defun list-of-listp (thing) (and (listp thing) (every #'listp thing)))
(deftype list-of-lists () '(satisfies list-of-listp))	 
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; FROM OPENMUSIC
	 
(defun subs-posn (lis1 posn val)
 (let ((copy (copy-list lis1)))
  (if (listp posn)
    (loop for item in posn
        for i = 0 then (+ i 1) do
        (setf (nth item copy) (if (listp val) (nth i val) val)))
  (setf (nth posn copy) val))
 copy))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; BASIC-FUNCTIONS ;;;
      
(defun string-to-list (str) ; Solution by Banjocat - stackoverflow.com
        (if (not (streamp str))
           (string-to-list (make-string-input-stream str))
           (if (listen str)
               (cons (read str) (string-to-list str))
               nil)))

(defun read-text-file (string) 
(let ((stream (open (merge-pathnames *PW-AIS-path* (parse-namestring (concatenate 'string string ".txt"))))))
(string-to-list stream))) 

(defun subtraction (input-lists)
 (mapcar #'(lambda (input1)
   (g- input1 (first input1))) input-lists))

(defun get-ais-chord (AIS low)
 (dx->x low (mod12 (x->dx AIS))))

(defun operation-q (AIS)
(let* ((rotations-AIS (mapcar #'(lambda (input1)
                       (permut-circ AIS input1)) (arithm-ser 1 1 (- (length AIS) 1))))
        (transp-to-zero (mod12 (subtraction rotations-AIS)))) 
(flat (loop
     for list in transp-to-zero
     for y = (last-elem list)
     when (= 6 y)
     collect list))))
	 
(defun qrmi (AIS)
(retrograde (operation-q (inversion (m-5 AIS)))))

(defun inversion (AIS)
 (mapcar #' (lambda (input1)
    (mod input1 12)) (g- 12 AIS)))

(defun retrograde (AIS)  
(let ((reverse-AIS (reverse AIS)))
 (mapcar #' (lambda (input1)
  (mod input1 12)) (g- reverse-AIS (first reverse-AIS)))))

(defun m-5 (AIS)
(mapcar #'(lambda (input1)
  (mod (g* 5 input1) 12)) AIS))

(defun operation-0 (AIS)
(subs-posn AIS (list (position 3 AIS) (position 9 AIS)) '(9 3)))

(defun t-0 (AIS)
   (mod12 (g- AIS (first AIS))))

(defun all-rotations (PCS)
 (mapcar #'(lambda (input1)
     (permut-circ PCS input1)) (arithm-ser 0 1 (- (length PCS) 1))))
	 
(defun select-link-chords (AIS)
(let* ((all-intervals (intervals-mod12 AIS))
     (AIS-rotations (all-rotations all-intervals))
     (7-rotations (firstn 7 (mapcar #'(lambda (input)
                             (firstn 5 input)) AIS-rotations)))
     (forte-names (mapcar #'(lambda (input)
                   (sc-name (mod12 (dx->x 0 input)))) 7-rotations))
     (tests (mapcar #'(lambda (input)
            (or (equal input 'system::6-Z17A)
                (equal input 'system::6-Z17B))) forte-names)))
(first (loop for test in tests
         when (equal t test)
               collect test))))
			   (defun P-I-IM-M (AIS)
			    (list AIS
			          (inversion AIS)
			          (im-ais AIS)
			          (m-ais AIS)))

(defun make-constellation-no-dup (AIS)
(let ((P-R-QR-Q (list AIS
                     (r-ais AIS)
                     (qr-ais AIS)
                     (q-ais AIS))))
(remove-dup  
 (system::flat-once (mapcar #'P-I-IM-M P-R-QR-Q))
  'equal 
   1)))

(defun make-constellation (AIS)
(let ((P-R-QR-Q (list AIS
                    (r-ais AIS)
                    (qr-ais AIS)
                    (q-ais AIS))))
  
(flat-once (mapcar #'P-I-IM-M P-R-QR-Q))))

(defun remove-constellation (constellation ais-list)
(let ((new-ais-list 
      (remove-if #'(lambda (input) 
                   (equal (first constellation) input))
                   ais-list)))
(if (= 0 (length constellation))
    (write new-ais-list)
    (remove-constellation (cdr constellation) new-ais-list))))
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;; FROM-OM

(defun remove-dup (list test depth)
(if (<= depth 1)
(remove-duplicates list :test test)
(mapcar #'(lambda (x) (remove-dup x test (1- depth))) list)))
		
(defun tristan-positions (input1 input2) ;;;FROM-OM-TRISTAN
 (let ((index 0) res)
   (dolist (n input1)
     (if (eq input2 n)  (push index res)) 
     (setq index (1+ index)))
   (nreverse res)))
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	

(defun select-ais (ais-list nth-elem)
(let* ((nth-elements (mapcar #'(lambda (input)
                     (nth nth-elem input)) ais-list))
       (select-min 
        (posn-match ais-list 
                   (tristan-positions nth-elements
                                      (list-min nth-elements)))))
(if (= 1 (length select-min)) 
         (write select-min)
    (select-ais select-min (1+ nth-elem)))))

(defun select-min-ais (ais-list)
(flat-once (select-ais ais-list 0)))

(defun select-SAISs (AIS-list)
(let* ((first-constellation (make-constellation-no-dup (first AIS-list)))
        (select-min (select-min-ais first-constellation))
        (remove-min (remove-if #'(lambda (input)
                              (equal select-min input)) first-constellation))
        (partial-results (x-append 
                                 (remove-constellation remove-min (cdr ais-list))
                                 (list select-min))))
(if (= (length ais-list) (length partial-results))
         (write ais-list)
    (select-SAISs partial-results))))

(defun remove-r-ri (AIS-list init-first)
(let* ((remove-r (remove-if #'(lambda (input)
                          (equal (r-ais (first ais-list)) input)) (cdr ais-list)))
         (remove-ri (remove-if #'(lambda (input)
                          (equal (ri-ais (first ais-list)) input)) remove-r))
          (results (x-append remove-ri
                            (list (first ais-list)))))   
(if (equal init-first (second AIS-list))
   (write results)
   (remove-r-ri results init-first))))

(defun select-link-2 (partial-solution)
(let* ((rotations (all-rotations partial-solution))
        (first-7 (firstn 7
                    (mapcar #'(lambda (input)
                     (firstn 6 input)) rotations)))
        (forte-names (mapcar #'(lambda (input)
                              (sc-name input)) first-7))
        (results (remove-if-not #'(lambda (input)
                  (or (equal input 'system::6-Z17A)
                      (equal input 'system::6-Z17B))) forte-names)))
(equal (length results) 2)))
	 
;===============================================================;
;;; ALL ;;;

(defun normal-AIS ()
"Returns all 3856 normal form AIS."
(read-text-file "3856-AIS"))

(defun prime-AIS ()
"Returns all 1928 prime form AIS."
(read-text-file "1928-AIS"))

(defun normal-R-invariant ()
"Returns all normal form R invariant AIS."
(read-text-file "normal-R-invariant"))

(defun prime-R-invariant ()
"Returns all prime form R invariant AIS."
(read-text-file "prime-R-invariant"))

(defun normal-QI-invariant ()
"Returns all normal form QI invariant AIS."
(read-text-file "normal-QI-invariant"))

(defun prime-QI-invariant ()
"Returns all prime form QI invariant AIS."
(read-text-file "prime-QI-invariant"))

(defun normal-QRMI-invariant ()
"Returns all normal form QRMI invariant AIS."
(read-text-file "normal-QRMI-invariant"))

(defun prime-QRMI-invariant ()
"Returns all prime form QRMI invariant AIS."
(read-text-file "prime-QRMI-invariant"))

(defun LINK-CHORDS ()
"Returns all 192 LINK-CHORDS."
(read-text-file "LINK-CHORDS"))

(defun LINK-TWO-INSTANCES ()
"Returns all 44 LINK-CHORDS with two instances of the all-trichord hexachord."
(read-text-file "LINK-CHORDS-TWO-INSTANCES"))

;(defun LINK-RI-invariant ()
;"Returns all four R or RI invariant LINK-CHORDS."
;(read-text-file "LINK-RI-invariant"))

(defun SAISs ()
"Returns all 267 shorter listing of source-AISs (SAISs)."
(read-text-file "SAISs"))

(defun MYSTERY-AIS ()
"Returns two Mysterious AIS."
(read-text-file "MYSTERY"))
