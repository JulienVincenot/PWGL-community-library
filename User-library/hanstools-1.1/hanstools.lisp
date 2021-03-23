; little growing library with all kinds of functions - mainly related to special compositional tasks of mine
; there is very probably little general use
; Hans Tutschku - July 2007
(in-package :ht)

(define-menu hanstools :print-name "HansTools")
(define-menu test1 :in hanstools)
(define-menu test2 :in hanstools)
(in-menu hanstools)
(menu-separator)
(define-menu filter :in hanstools)
(menu-separator)
(define-menu random :in hanstools)

(in-menu test1)

(define-box groupe-notes (liste)
  ""
  :non-generic t
  (let ((aux0 nil) (aux1 nil) (mem -1))
    (dolist (n liste aux1)
      (if (not (= (first n) mem))
	  (progn nil (push (remove nil aux0) aux1) (setf aux0 nil)
		 (push (second n) aux0) (setf mem (first n)))
	  (progn nil (push (second n) aux0))))
    (mat-trans (list (remove-dup (first (mat-trans liste)) 'equalp 1)
		     (remove nil (reverse (push aux0 aux1)))))))

(in-menu test2)

(define-box write-fbreakpt ((donnees (1 2 3)) (myfilename "toto.par"))
  "Cette boite rassemble les tables et notes pour les imprimer dans un fichier <file.sco>"
  :non-generic t
  (let (fichier) (setf donnees (|OpenMusic|::flat-once donnees))
       (setq fichier
	     (choose-new-file-dialog :directory "Fbreakpt.par" :prompt "Save csound"))
       (when fichier
	 (with-open-file
	     (fd fichier :direction :output :if-exists :overwrite :if-does-not-exist
		 :create)
	   (dotimes (n (length donnees))
	     (dotimes (j (length (nth n donnees)))
	       (format fd "~D " (nth j (nth n donnees))))
	     (format fd "~%"))))))


(define-box write-ffifof ((donnees (1 2 3)) (myfilename "toto.par"))
  "Cette boite rassemble les tables et notes pour les imprimer dans un fichier <file.sco>"
  :non-generic t
  (let (fichier) (setf donnees (|OpenMusic|::flat-once donnees))
       (setq fichier
	     (choose-new-file-dialog :directory "Ffifof.par" :prompt "Save csound"))
       (when fichier
	 (with-open-file
	     (fd fichier :direction :output :if-exists :overwrite :if-does-not-exist
		 :create)
	   (dotimes (n (length donnees))
	     (dotimes (j (length (nth n donnees)))
	       (format fd "~D " (nth j (nth n donnees))))
	     (format fd "~%"))))))


(define-box bidul ((liste (1 2 3)) (lower 30) (upper 80) (intv 20) (erste 80))
  "bidul"
  :non-generic t
  (let ((ergebnis nil) (aux0 erste))
    (dolist (y liste (nreverse ergebnis))
      (if
       (and
	(and (and (< (fifth (first liste)) (first y)) (> (second y) lower))
	     (< (second y) upper))
	(< (abs (- aux0 (second y))) intv))
       (progn nil (push y ergebnis) (setf aux0 (second y)))))))


(define-box vorfilter ((liste (1 2 3)) (lower 6000) (upper 8000))
  "filtert erst den tonhöhenbereich"
  :non-generic t
  (let ((ergebnis nil))
    (dolist (y liste (nreverse ergebnis))
      (if (and (> (second y) lower) (< (second y) upper))
	  (progn nil (push y ergebnis))))))


(define-box pitchfilter ((liste (1 2 3)) (lower 30) (upper 80))
  "filtert den tonhöhenbereich"
  :non-generic t
  (let ((ergebnis nil))
    (dolist (y liste (nreverse ergebnis))
      (if (and (> (second y) lower) (< (second y) upper))
	  (progn nil (push y ergebnis))))))


(define-box formantanalyse ((liste (1 2 3)))
  "ermittelt aus analysefile die Anzahl der gefundenen Formanten für jedes analysefenster"
  :non-generic t
  (let ((ergebnis nil) (wert (first liste)) (myindex 0))
    (push (first liste) ergebnis)
    (loop :while wert
		      :do (setf myindex (+ (+ 2 (* 3 wert)) myindex))
		      (push (|OpenMusic|::posn-match liste myindex) ergebnis)
		      (setf wert (|OpenMusic|::posn-match liste myindex)))
    (remove nil (nreverse ergebnis))))


(define-box noformant ((liste (1 2 3)))
  "filtert analysen ohne gefundene formanten heraus"
  :non-generic t
  (let ((ergebnis nil))
    (dolist (y liste (nreverse ergebnis))
      (if (/= (first y) 0) (push (|OpenMusic|::om-round y 4) ergebnis)))))


(define-box analysetime ((liste (1 2 3)))
  "gibt zeiten der analysen"
  :non-generic t
  (let ((ergebnis nil))
    (dolist (y liste (nreverse ergebnis)) (push (second y) ergebnis))))


(define-box bwdevide ((liste (1 2 3)) (faktor 100))
  "teilt bandwith durch 100"
  :non-generic t
  (let ((ergebnis nil))
    (dolist (y liste (nreverse ergebnis))
      (push
       (list (first y) (second y)
	     (|OpenMusic|::om-round (|OpenMusic|::om/ (third y) faktor) 2))
       ergebnis))))


(define-box timeline ((liste (1 2 3)))
  "gibt alle Zeiten der Analysen aller partials von partialtracking"
  :non-generic t
  (let ((buffer nil))
    (dolist
	(y liste
	 (remove-duplicates
	  (first (mat-trans (|OpenMusic|::flat-once (nreverse buffer)))) :test '=))
      (push (|OpenMusic|::list-explode (rest (rest y)) (second y)) buffer))))


(define-box fo-grupp1 ((liste (1 2 3)))
  "gibt alle Analysen aller partials von partialtracking"
  :non-generic t
  (let ((buffer nil))
    (dolist (y liste (|OpenMusic|::flat-once (nreverse buffer)))
      (push (|OpenMusic|::list-explode (rest (rest y)) (second y)) buffer))))


(define-box fo-grupp2 ((liste (1 2 3)))
  "gruppiert die formanten einer analysezeit und hängt bandwith
             sowie die Werte 0 1 für das sdif-formant an"
  :non-generic t
  (let ((ergebnis nil) (buffer nil) (aux0 (first (first liste))))
    (dolist (y liste (nreverse ergebnis))
      (if (= (first y) aux0)
	  (push (|OpenMusic|::x-append (second y) (third y) 1 0 1) buffer)
	  (progn nil (push buffer ergebnis) (setf buffer nil)
		 (setf aux0 (first y))
		 (push (|OpenMusic|::x-append (second y) (third y) 1 0 1) buffer))))))


(define-box zeitintervall ((liste (1 2 3)) (dist 50) (dynmin 30) (dynmax 127)
                           (mindur 50) (startnote (6000 6500))
                           (maxinterval 700))
  "selektiert noten innerhalb einer bestimmten dynamik, deren abstand groesser als dist ist, die erste Note muß innerhalb eines bestimmten Intervalls sein"
  :non-generic t
  (let
      ((ergebnis nil) (startnotenindex nil) (aux0 0) (newlist nil) (lastpitch nil))
    (dolist (y liste startnotenindex)
      (if
       (and (> (fourth y) dynmin) (< (fourth y) dynmax)
	    (> (second y) (first startnote)) (< (second y) (second startnote)))
       (progn (setf aux0 (+ aux0 1)) (push aux0 startnotenindex))
       (setf aux0 (+ aux0 1))))
    (setf newlist
	  (|OpenMusic|::last-n liste
		      (- (length liste) (- (first (reverse startnotenindex)) 1))))
    (push (first newlist) ergebnis) (setf aux0 (first (first newlist)))
    (setf lastpitch (second (first newlist))) (setf newlist (rest newlist))
    (dolist (y newlist (nreverse ergebnis))
      (when (> mindur (third y)) (setf (nth 2 y) mindur))
      (if
       (and (> (- (first y) aux0) dist) (> (fourth y) dynmin) (< (fourth y) dynmax)
	    (> maxinterval (abs (- (second y) lastpitch))))
       (progn nil (push y ergebnis) (setf aux0 (first y))
	      (setf lastpitch (second y)))))))


(define-box zeitintervall2 ((liste nil) (dist 50))
  "gruppiert Einzelnoten zu akkorden, deren Onset-time innerhalb von dist fällt"
  :non-generic t
  (let
      ((ergebnis nil) (aux0 0) (lastonset 0) (delta 0) (tempmidic nil) (tempdur nil)
       (tempvel nil) (temponset nil))
    (dolist (y liste) (setf delta (- (second y) lastonset))
	    (setf lastonset (second y))
	    (if (> delta dist)
		(progn nil
		       (if (not (eq tempmidic 'nil))
			   (push
			    (list (|OpenMusic|::flat tempmidic) (first temponset) tempdur tempvel)
			    ergebnis))
		       (setf tempmidic nil) (setf tempdur nil) (setf tempvel nil)
		       (setf temponset nil) (push y ergebnis))
		(progn nil (push (first y) tempmidic) (push (third y) tempdur)
		       (push (fourth y) tempvel) (push lastonset temponset))))
    (remove nil (reverse ergebnis))))


(define-box mk-profile-rule ((ypoints (1 2 3)))
  "creates a heuristic rule for PMC that attempts to follow
the shape of the bpf as closely as possible. count
gives the number of pitches required in the result.
Funktion von Constraints übernommen, aber mit BPF-Sample ausgeführt.
Die beiden nreverse sind eigentlich überflüssig, aber nur die liste
ypoints zu geben, hat er nicht akzeptiert"
  :non-generic t
  (list
   (read-from-string
    (format nil
	    "(* ?1 (omcs::?if (- 1000 (abs (- ?1 (nth (1- omcs::len) '~D ))))))"
	    (nreverse (nreverse ypoints))))))


(define-box read-formant-analysis ((namein "G3:toto") (nameout "G3:toto1")
                                   (minamp -30) (stretchfactor 1.0))
  "wandelt eine formantanalyse von Audiosculpt in ein parameterfile für Formantfilter um. Dabei werden die Analyse mit 0 Formanten herausgeschmissen."
  :non-generic t
  (let
      ((number-of-formants nil) (analysetime nil) (aux0 nil) (teilergebnis nil)
       (|LäNGE| nil))
    (when namein
      (with-open-file (infile namein)
	(with-open-file
	    (outfile nameout :direction :output :if-does-not-exist :create :if-exists
		     :supersede)
	  (loop while (not (stream-eofp infile)) do
	       (setf analysetime
		     (|OpenMusic|::om-round (* (read infile) stretchfactor) 4))
	       (setf number-of-formants (read infile)) (setf teilergebnis nil)
	       (if (not (= number-of-formants 0))
		   (progn
		     (loop for i from 1 to number-of-formants do
			  (setf aux0
				(list (|OpenMusic|::om-round (read infile))
				      (|OpenMusic|::om-round (read infile) 2)
				      (|OpenMusic|::om-round (read infile) 1)))
			  (if (< minamp (second aux0)) (progn (push aux0 teilergebnis))))
		     (setf teilergebnis (reverse teilergebnis))
		     (setf |LäNGE| (length teilergebnis))
		     (if (not (= |LäNGE| 0))
			 (progn (format outfile "~%~D ~D " analysetime |LäNGE|)
				(loop for i from 0 to (- |LäNGE| 1) do
				     (format outfile "~D ~D ~D " (first (nth i teilergebnis))
					     (second (nth i teilergebnis))
					     (third (nth i teilergebnis))))))))))))))


(define-box check-formants ((namein "G3:toto"))
  "zeigt in einem parameterfile für formantfilterung die vorhandenen Anzahlen für Formanten"
  :non-generic t
  (let ((old-pos nil) (aux nil) (formantlist nil) (members nil))
    (when namein
      (with-open-file (infile namein)
	(loop while (not (stream-eofp infile)) do
	     (setf old-pos (file-position infile)) (read infile)
	     (setf aux (read infile)) (push aux formantlist)
	     (ccl::stream-position infile old-pos) (read-line infile)))
      (setf members
	    (sort (copy-list (remove-duplicates
						      formantlist
						      :test
						      'eq))
			      #'<))
      (mapcar
       #'(lambda (x)
	   (list x
		 (length
		  (|OpenMusic|::band-filter formantlist (list (list x x)) 'pass))))
       members))))


(define-box formant-script (nameout newnamelist formantnumberlist soundname)
  :non-generic t
  "schreibt das Audiosculptscript für beide Arten von Formantfilter für die gesamte Liste der Parameterfiles"
  (let ((scriptname (format nil "~A.script" nameout)))
    (with-open-file
	(outfile2 scriptname :direction :output :if-does-not-exist :create :if-exists
		  :supersede)
      (mapcar
       #'(lambda (x y)
	   (format outfile2
		   "svp -t -v -Z -A -S~A  -Ffifof ~A  -M4000 -N4096 ~A.ff.~D~%" soundname x
		   soundname y))
       newnamelist formantnumberlist)
      (mapcar
       #'(lambda (x y)
	   (format outfile2
		   "svp -t -v -Z -A -S~A  -Ffof ~A  -M4000 -N4096 ~A.f.~D~%" soundname x
		   soundname y))
       newnamelist formantnumberlist))))


(define-box formant-auswahl ((namein "G3:toto") (nameout "G3:toto1")
                             (soundname "noise.aiff"))
  "kreiert für jede formantanzahl ein parameterfile und das scriptfile für Audiosculpt fifof und fof"
  :non-generic t
  (let ((newnamelist nil) (formantnumberlist (check-formants namein)))
    (setf formantnumberlist
	  (remove nil
		  (mapcar #'(lambda (x) (if (and (< 2 (first x)) (< 1 (second x))) (first x)))
			  formantnumberlist)))
    (mapcar
     #'(lambda (x)
	 (let
	     ((oneline nil) (old-pos nil) (aux nil) (newname nil) (newname2 nil)
	      (firstline 0) (number-of-formants 0))
	   (when namein
	     (setf newname2 (format newname "~A.~D" (pathname-name nameout) x))
	     (setf newname (format newname "~A.~D" nameout x))
	     (push newname2 newnamelist)
	     (with-open-file (infile namein)
	       (with-open-file
		   (outfile newname :direction :output :if-does-not-exist :create
			    :if-exists :supersede)
		 (loop while (not (stream-eofp infile)) do
		      (setf old-pos (file-position infile)) (read infile)
		      (setf aux (read infile)) (ccl::stream-position infile old-pos)
		      (setf oneline (read-line infile))
		      (if (= x aux)
			  (progn
			    (if (= firstline 0)
				(progn (ccl::stream-position infile old-pos) (read infile)
				       (setf number-of-formants (read infile))
				       (setf oneline
					     (|OpenMusic|::x-append 0.0 number-of-formants
							 (loop for i from 1 to (* 3 number-of-formants) collect
							      (read infile))))
				       (setf firstline (+ firstline 1))
				       (format outfile "~{~D ~}" oneline))
				(format outfile "~%~A " oneline))))))))))
     formantnumberlist)
    (formant-script nameout (reverse newnamelist) formantnumberlist soundname)))


(define-box onestep-init (list)
  :non-generic t
  "gibt bei jeder Berechnung den nächsten member einer Liste"
  (setf stepindex -1)
  (setf stepindex2 -1))


(define-box onestep (list)
  :non-generic t
  "gibt bei jeder Berechnung den nächsten member einer Liste"
  (if (< stepindex (- (length list) 1)) (setf stepindex (+ 1 stepindex)))
  (print stepindex)
  (|OpenMusic|::posn-match list stepindex))


(define-box onestep2 (list)
  :non-generic t
  "gibt bei jeder Berechnung den nächsten member einer Liste"
  (if (< stepindex2 (- (length list) 1)) (setf stepindex2 (+ 1 stepindex2)))
  (print stepindex2)
  (|OpenMusic|::posn-match list stepindex2))


(define-box onset-mapping ((rtm-onset (1 2 3)) (partials-onset (1 3 5)))
  "die erste Liste ist der rtm-rhythmus, die zweite Liste sind die onsetzeiten der Parial-Analyse und die Tonhöhen.
nun soll für jeden berechneten rhythmus die onsetzeit gefunden werden, die gerade SPIELT. Deren Tonhöhen werden
mit den RTM-Zeiten kombiniert"
  :non-generic t
  (let ((aux0 nil) (aux1 nil) (mem -1))
    (dolist (n rtm-onset aux1)
      (progn nil
	     (dolist (m partials-onset aux0)
	       (if (<= (first m) n) (push (second m) aux0)))
	     (push (first aux0) aux1) (setf aux0 nil)))
    (reverse aux1)))


(define-box partial-grouping ((partials
                               ((1.0 781.523 0.021 114.227 0.075)
                                (1.0 794.822 0.005 -1.911 0.134)
                                (2.0 586.937 0.072 192.248 0.075))))
  "kombiniert die frame-daten der partials und bringt alle frames eines partials in eine liste"
  :non-generic t
  (let ((aux0 nil) (aux1 nil) (aux2 nil) (aux3 nil) (mem 1.0))
    (dolist (n partials aux1)
      (if (= (first n) mem) (push (|OpenMusic|::rotate (rest n) 2) aux0)
	  (progn nil (setf mem (first n)) (setf aux2 (first aux0))
		 (setf aux3 (first (last aux0)))
		 (push (|OpenMusic|::x-append "points" 2 aux3 aux2) aux1) (setf aux0 nil)
		 (setf aux3 nil) (setf aux2 nil)
		 (push (|OpenMusic|::rotate (rest n) 2) aux0))))
    (reverse aux1)))



(in-menu filter)

(define-box filter-cello ((noten (4000 6000 8000)))
  "Spiegelt Noten, die ausserhalb des Instrumentenbereiches sind wieder hinein"
  :non-generic t
  (|Profile|::double-reflect noten (list 3599 8401) 2 1))



(define-box filter-crotales ((noten (4000 6000 8000)))
  "Spiegelt Noten (nicht klingend sondern geschrieben), die ausserhalb des Instrumentenbereiches sind wieder hinein"
  :non-generic t
  (|Profile|::double-reflect noten (list 5999 8401) 2 1))


(define-box FILTER-FL\öTE ((noten (4000 6000 8000)))
  "Spiegelt Noten, die ausserhalb des Instrumentenbereiches sind wieder hinein"
  :non-generic t
  (|Profile|::double-reflect noten (list 5999 9601) 2 1))


(define-box filter-oboe ((noten (5800 6000 9100)))
  "Spiegelt Noten, die ausserhalb des Instrumentenbereiches sind wieder hinein"
  :non-generic t
  (|Profile|::double-reflect noten (list 5799 9101) 2 1))


(define-box filter-klarinette ((noten (4000 6000 8000)))
  "Spiegelt Noten (nicht klingend sondern geschrieben), die ausserhalb des Instrumentenbereiches sind wieder hinein"
  :non-generic t
  (|Profile|::double-reflect noten (list 5199 9601) 2 1))


(define-box filter-piano-low ((noten (4000 6000 8000)))
  "Spiegelt Noten, die ausserhalb des Instrumentenbereiches sind wieder hinein"
  :non-generic t
  (|Profile|::double-reflect noten (list 0 5999) 2 1))


(define-box filter-piano-high ((noten (4000 6000 8000)))
  "Spiegelt Noten, die ausserhalb des Instrumentenbereiches sind wieder hinein"
  :non-generic t
  (|Profile|::double-reflect noten (list 5999 10801) 2 1))


(define-box filter-piccolo ((noten (4000 6000 8000)))
  "Spiegelt Noten (nicht klingend sondern geschrieben), die ausserhalb des Instrumentenbereiches sind wieder hinein"
  :non-generic t
  (|Profile|::double-reflect noten (list 6199 9601) 2 1))


(define-box filter-sopran ((noten (4000 6000 8000)))
  "Spiegelt Noten, die ausserhalb des Instrumentenbereiches sind wieder hinein"
  :non-generic t
  (|Profile|::double-reflect noten (list 5699 8101) 2 1))


(define-box filter-vibraphone ((noten (4000 6000 8000)))
  "Spiegelt Noten, die ausserhalb des Instrumentenbereiches sind wieder hinein"
  :non-generic t
  (|Profile|::double-reflect noten (list 5299 8901) 2 1))


(in-menu random)



(defun pw-random-value (num)
  (if (< num 0)
    (- (random (- num)))
    (random num)))

(define-box pw-random ((low -3.0) (high 4.0)) 
"random number between <low> and <high>"
:non-generic t
  (if (zerop (- low high))
    (+ low high (- high))
    (let ((low-min (min low high)))
      (if (or (floatp  low) (floatp high))
        (+ (pw-random-value (- (max low high) low-min)) low-min)
        (+ (pw-random-value (- (1+ (max low high)) low-min)) low-min)))))

(defun mulalea (n percent)
  (* n (+ 1  (pw-random  (- percent) (float percent)) )))


(define-box perturbation ((self 100) (percent 0.01))
"applies to <self> a random deviation bounded by the <percent> parameter, a value in [0 1]. Both argument can be trees."
:non-generic t
  (mulalea self percent))


(defmethod perturbation ((self number) (num list)) 
  (mapcar #'(lambda (input)
                 (perturbation self input)) num))

(defmethod perturbation ((self list) (num number))   
  (mapcar #'(lambda (input)
              (perturbation  input num)) self))

(defmethod perturbation ((self list) (num list))
  (mapcar #'(lambda (input1 input2)
              (perturbation input1 input2)) self num))



(install-menu hanstools)
