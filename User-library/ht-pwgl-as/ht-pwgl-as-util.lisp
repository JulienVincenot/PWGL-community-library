;****************************
;   OM-functions by Hans Tutschku 15/10/98 IRCAM
; Heavy modifications to adapt to AS 2.4.1 in Aril 2005

(in-package ht-pwgl-as)

(in-menu util)

;;***********************************************************************
;; fonction write-list de Mikhail Malt 

(define-box HT-PWGL-AS::write-lists  ((myfilename "toto.par") (donnees ((1 2) (3 4)  ))) 
"writes each sublist into a new line of a textfile"


  (let (fichier) 
  ;  (setf donnees (flat  donnees))
    ;;; modif jean : si un fichier est donné on met pas le dialogue
    (setq fichier 
          (if myfilename (pathname myfilename)
              (ompw-utils::choose-new-file-dialog  :directory myfilename :prompt "Save txt"))
          )
   (delete-file fichier)
    (when fichier
      (with-open-file  (fd fichier
                           :direction :output :if-exists :supersede 
                           :if-does-not-exist :create)
        (dotimes (n (length donnees))
          (dotimes (j (length (nth n donnees)))
            (format fd "~D "(nth j (nth n donnees))))
          (format fd "~A" #\Linefeed))
        ))
    ;;; modif jean : retourne le nom du fichier
    fichier
))

#|



;;***********************************************************************
;; fonction write-list de Mikhail Malt 

(om::defmethod! HT-PWGL-AS::write-lists2  ( (donnees list ) (myfilename string))
  :initvals '( '(1 2 3) "toto.par")
  :indoc '("list" "filename")
  :icon 999 
  :doc  "Cette boite rassemble les tables et notes pour les imprimer dans un fichier <file.sco>"
  (let (fichier) 
    ;(setf donnees (om::flat  donnees 1))
    (setq fichier (ccl:choose-new-file-dialog  :directory myfilename :prompt "Save txt"))
   (delete-file fichier)
    (when fichier
      (with-open-file  (fd fichier
                           :direction :output :if-exists :supersede 
                           :if-does-not-exist :create)
        (dotimes (n (length donnees))
          (dotimes (j (length (nth n donnees)))
            (format fd "~D "(nth j (nth n donnees))))
          (format fd "~A" #\Linefeed))
        ))))

;(HT-PWGL-AS::write-lists "dilat.par" '((1 2 3)(1 2)(1 2 3 4)(1 2 3 4 5)))

;;***********************************************************************


(om::defmethod! HT-PWGL-AS::write-lists3  ( (donnees list ) (myfilename string))
  :initvals '( '((1 2) (2323 3)) "G3-Daten02:toto.par")
  :indoc '("list" "filename")
  :icon 999 
  :doc  ""
  (let (fichier) 
    ;(setf donnees (om::flat  donnees 1))
    ;(setq fichier (ccl:choose-new-file-dialog  :directory myfilename :prompt "Save txt"))
    (setq fichier myfilename)
   (delete-file fichier)
    (when fichier
      (with-open-file  (fd fichier
                           :direction :output :if-exists :supersede 
                           :if-does-not-exist :create)
        (dotimes (n (length donnees))
          (dotimes (j (length (nth n donnees)))
            (format fd "~D "(nth j (nth n donnees))))
          (format fd "~A" #\Linefeed))
        )))
(om::string+ myfilename "     saved")
)


;********************************************************************************************
;functions by Mikhail Malt for BPF

(om::defmethod! HT-PWGL-AS::rang? ((liste list) (elem t))
  :initvals '( nil nil)
  :indoc '("liste" "elements")
  :icon 999 
  :doc  "les rangs de elem dans liste"
  (let ((aux nil) (index 0))
    (mapcar #'(lambda (z) 
                (progn (when (funcall 'equalp  z elem) (push index aux))
                                 (incf index))) liste)
    (reverse aux)))

;(HT-PWGL-AS::rang? '(1 (3 4) 6 7 8 9) '(3 4))

(om::defmethod! HT-PWGL-AS::linear-interpol (x1 x2 y1 y2 x0)
  :initvals '( 1 2 2 5 1.2)
  :indoc '("x1" "x2" "y1" "y2" "x0")
  :icon 999 
  :doc  "interpolation linèaire entre deux points dans le plan

          ^
          |
          |
        y2|..................*
          |                  .
        y0|............*     .
          |            .     .
        y1|......*     .     .
          |      .     .     .
          |      .     .     .
          |      .     .     .
          |______._____._____.______>
                 x1    x0    x2

"
  (if (= x1 x2) y1
      
      (+ y1
         (* (- y2 y1)
            (/ (- x0 x1)
               (- x2 x1))))))

;(HT-PWGL-AS::linear-interpol 1 2 2 5 1.2)


(om::defmethod! HT-PWGL-AS::x-around (x paires)
  :initvals '( nil nil)
  :indoc '("x" "paires")
  :icon 999 
  :doc  "trouve les paires en dessous et au dessus de x"
  (let* ((plus-grand  (find  x paires :test #'(lambda (x r) (<= x (first r)))))
         (rang (if (< (1- (first (rang?  paires  plus-grand ))) 0) 0
                   (1- (first (rang?  paires  plus-grand )))))
         (plus-petit (nth rang paires)))

    

    (list (if (< rang 0) plus-grand plus-petit) plus-grand)
))


;(find  2 '((-1 0) (1   4) (5 6)) :test #'(lambda (x r) (<= x (first r))))

;(find  x paires :test #'(lambda (x r) (<= x (first r))))

;(nth (1- (first (rang?  paires  plus-grand 'equalp))) paires)

;(HT-PWGL-AS::x-around 51 '((0 0) (41 3) (50 6) (69 5) (100 8)))

(om::defmethod! HT-PWGL-AS::f-transfer ((bpf om::bpf) (x0 number))
  :initvals '( '(1 2 3) 3.4)
  :indoc '("liste" "x0")
  :icon 999 
  :doc  "transfer avec interpolation linéaire"
  (let* ((paires (om::mat-trans
                  (om::list
                   (om::x-points bpf)
                   (om::y-points bpf))))
         (bornes  (x-around x0 paires)))
    (linear-interpol (caar bornes)            ; x1
                     (first (second bornes)) ; x2
                     (second (first bornes)) ; y1
                     (second (second bornes)) ; y2
                     x0)))
    

(om::defmethod! HT-PWGL-AS::f-transfer-l ((bpf om::bpf) (liste list))
  :initvals '( '(1 2 3) 3.4)
  :indoc '("liste" "x0")
  :icon 999 
  :doc  "transfer avec interpolation linéaire"
  (let ((liste (om::list! liste)))
    (mapcar #'(lambda (k) (HT-PWGL-AS::f-transfer bpf k)) liste)))


;********************************************************************************************
#|
(in-package AS)
(om::defmethod! HT-PWGL-AS::list-explode ((list list) 
                                (nlists integer)) 
  :initvals '('(1 2 3 4 5) 2) 
  :indoc '("list" "number") 
  :icon 999
  :doc "list-explode divides a list into <nlist> sublists of consecutives elements.  
For example, if list is (1 2 3 4 5 6 7 8 9), and ncol is 2, the result is ((1 2 3 4 5) 
(6 7 8 9)),
if list is (1 2 3 4 5 6 7 8 9), and ncol is 5, the result is: ((1 2) (3 4) (5 6) (7 8) (9)). 
If the number of divisions exceeds the number of elements in the list, the 
remaining divisions are returned as nil."
  
  (if (> nlists (length list)) 
    (setq list (append list (make-list (- nlists (length list)) :initial-element (first (last list))))))
  (if (<= nlists 1) list
      (let* ((length (length list))
             (low (floor length nlists))
             (high (ceiling length nlists))
             (step (if (< (abs (- length (* (1- nlists) high))) (abs (- length (* nlists low))))
                     high  low))
             (rest (mod length nlists))
             (end (- length 1 rest)) 
             (ser (om::arithm-ser 0  (1- step) 1))
             res)
        (om::for (i 0 step end)
          (push (remove () (om::posn-match list (om::om+ i ser))) res))
        (setq low (length (om::flat-once res)))
        (if (< low length) (setq res (cons (append (first res) (nthcdr low list)) (rest res))))
        (cond ((> (length res) nlists) 
               (nreverse (cons (nconc (second res) (first res)) (nthcdr 2 res))))
              ((< (length res) nlists)
               (when (= (length (first res)) 1)
                 (setq res (cons (nconc (second res) (first res)) (nthcdr 2 res))))
               (nreverse (nconc (nreverse (HT-PWGL-AS::list-explode (first res) (1+ (- nlists (length res)))))
                                (rest res))))
              (t (nreverse res))))))

;(HT-PWGL-AS::list-explode '(1 2 3 4 5 6) 3)

|#
;********************************************************************************************

(om::defmethod! HT-PWGL-AS::vel-db ((vel number)) ;formula from jimmys
  :initvals '('120) 
  :indoc '("MIDI-velodity") 
  :icon 999
  :doc "converts MIDI-velocity (0-127) to dB" 
  
  (om::om-round
   (om::om- 0 (om::om* 0.599694 (om::om- 126 (om::om- vel 1))))
   1)
  )

;(HT-PWGL-AS::vel-db 120) 

;********************************************************************************************
(om::defmethod! HT-PWGL-AS::vel-db-list ((vel list)) ;formula from jimmys
  :initvals '('(120 127 0 3 60)) 
  :indoc '("list") 
  :icon 999
  :doc "converts MIDI-velocity (0-127) to dB" 
  
  (om::om-round
   (om::om- 0 (om::om* 0.599694 (om::om- 126 (om::om- vel 1))))
   1)
  )

;(HT-PWGL-AS::vel-db-list '(127  0 3 60)) 

;********************************************************************************************
(om::defmethod! HT-PWGL-AS::db-vel ((dB number)) ;formula from jimmys
  :initvals '('-12) 
  :indoc '("list") 
  :icon 999
  :doc "converts dB to MIDI-velocity (0-127)" 
  
  (om::om-round
   (om::om+ 127 (om::om/ dB 0.599694 )))
  )
;********************************************************************************************
(om::defmethod! HT-PWGL-AS::db-vel-list ((dB list)
                                 (lowscale number)
                                 (highscale number)) ;formula from jimmys
  :initvals '('(-50 -60 -12 0) 0 127) 
  :indoc '("list" "lowscale" "highscale") 
  :icon 999
  :doc "converts dB to MIDI-velocity (0-127)" 
  
  (om::om-round
   (om::om-scale 
   (om::om+ 127 (om::om/ dB 0.599694 )) lowscale highscale))
  )

;********************************************************************************************
;x-append, weil die Version von OM noch nicht funktioniert

(om::defmethod! HT-PWGL-AS::x-append  (&rest liste)
  
  
  (apply 'append (mapcar #'(lambda (x)
                             (if (atom x)
                               (list x) x) )
                         liste))
  
  
  )

;(HT-PWGL-AS::x-append '(1 (2 3) 3) '(4 5) 4 '(8 9 ))
;********************************************************************************************

(om::defmethod! HT-PWGL-AS::save-or-not  ((final list)
                                  (filename string)
                                  )
  (let ((aux nil))
    #|
 (if (< 800 (om::list-max (dolist (n final (nreverse aux))
                               (push (length (format nil "~D" n)) aux))))
      "parameterlines becomes to long for Audiosculpt - reduce parameters"

      (HT-PWGL-AS::write-lists filename final)
      )
|#  
    
    (HT-PWGL-AS::write-lists (om::string+ HT-PWGL-AS::*om-as-parameter-folder* filename) final)
    
    )
  )

;(HT-PWGL-AS::save-or-not '((1 2 3) (4 5) (6 7 8 9)) "toto" "save")


;********************************************************************************************


(om::defmethod! HT-PWGL-AS::repeat  ((self t) 
                             (num integer)) 
  :numouts 1 
  :initvals '(nil 0)
  :indoc '("patch" "times")
  :icon 999
  :doc"this patch is creating a parameterfile for Audiosculpt formant-filter from a fundamental analysis"
  
  :doc "repeats n times the evaluation of <self> and collects the n results into a list. " 
  (let* (rep)
    (loop for i from 1 to num do
          (push self rep))
    (reverse rep)))
;(HT-PWGL-AS::repeat '(90 6) 5)

;********************************************************************************************
(om::defmethod! HT-PWGL-AS::groupe-beats ((liste list))    ;to translate leons midifile
  :initvals '(nil)
  :indoc '("liste des paires temps freqs")
  :icon 999 
  :doc""
  ; aux0 liste d'attente
  
  (let ((aux0 nil) (aux1 nil) (index 2))
    
    (dolist (n liste aux1)
      (if (not (=  (first n) 1))
        (progn ()
               (push (remove nil aux0) aux1)
               (setf aux0 nil)
               (push (list index (second n)) aux0)
               (setf index (+ index 1)))
        (progn ()
               (setf index 2)
               (push n aux0))))
    
    ;(om::mat-trans (list (om::remove-dup  (first (om::mat-trans liste)) 'equalp 1)
     ;                    (remove nil (reverse (push aux0 aux1)))))
    
    )
  )

;********************************************************************************************
(om::defmethod! HT-PWGL-AS::rec-read-from-string (string)
  "utilissimo!"
  (labels ((fun (x)
             (multiple-value-list (read-from-string x nil))))
    (if (null (read-from-string string nil))
      nil
      (cons (car (fun string))
            (rec-read-from-string (coerce
                                   (nthcdr
                                    (cadr (fun string))
                                    (coerce string 'list))
                                   'string))))))

(om::defmethod! HT-PWGL-AS::string-to-list (string)    ; by Mauro Lanza
  "utilissimo!"
  (labels ((fun (x)
             (multiple-value-list ( x nil))))
    (if (null (read-from-string string nil))
      nil
      (cons (car (fun string))
            (rec-read-from-string (coerce
                                   (nthcdr
                                    (cadr (fun string))
                                    (coerce string 'list))
                                   'string))))))

;********************************************************************************************
;********************************************************************************************
;;***********************************************************************

;; diese Funktionen müssen durch neuere ersetzt werden



(om::defmethod! HT-PWGL-AS::soundlength-sd2 ((soundname string))
  
  (print "function soundlength-sd2 must be replaced by snd-duration" )
     
  )


; (HT-PWGL-AS::soundlength-sd2 "G3-Daten02:sun.sd")

;;***********************************************************************

(om::defmethod! HT-PWGL-AS::numChannels-sd2 ((soundname string))
  
     (print "function soundlength-sd2 must be replaced by another function" )
     
  )


;;***********************************************************************

(om::defmethod! HT-PWGL-AS::refnum-of-open-file (f)
  (rref (uvref (cdr (ccl::column.fblock f)) 1) :cinfopbrec.iofrefnum))

; ****************************************************************

(om::defmethod! HT-PWGL-AS::read-ostype ((s t))
  (let ((a (read-byte s))
        (b (read-byte s))
        (c (read-byte s))
        (d (read-byte s)))
    (coerce (list (code-char a) (code-char b) (code-char c) (code-char d)) 'string)))

; ****************************************************************

(om::defmethod! HT-PWGL-AS::read-short ((s t))
  (let ((a (read-byte s))
        (b (read-byte s)))
    (logior (ash a 8) b)))

; ****************************************************************

(om::defmethod! HT-PWGL-AS::read-extended ((s t))
  (%stack-block ((x 8))
    (dotimes (i 8)
      (%put-byte x (read-byte s) i))
    (ccl::%get-x2float x)))

; ****************************************************************

(om::defmethod! HT-PWGL-AS::read-long ((s t))
  (let ((a (read-byte s))
        (b (read-byte s))
        (c (read-byte s))
        (d (read-byte s)))
    (logior (ash a 24) (ash b 16) (ash c 8) d)))

(defmethod stream-init ((s t))
  (file-position s 12))

; ****************************************************************

(om::defmethod! HT-PWGL-AS::look-for-chunck ((s t) ckname)
  (stream-init s)
  (loop while (and (not (stream-eofp s)) (not (string-equal ckname (HT-PWGL-AS::read-ostype s)))) do
        (let ((sizeck (HT-PWGL-AS::read-long s)))
          (loop for i from 1 to sizeck do
                (read-byte s))))
  (if (stream-eofp s)
    (error "no lo encontre"))
  (HT-PWGL-AS::read-long s))



|#