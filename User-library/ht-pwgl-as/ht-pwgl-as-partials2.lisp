;;;================================================================================================================
;;; SuperVP Sound Processing
;;; Hans Tutschku 2008

;;;code from repmus
;;;================================================================================================================

(in-package :ht-pwgl-as)
  

(defclass partial ()
  ((ponset :accessor ponset :initarg :ponset)
   (outset :accessor outset :initarg :outset)
   (frequency :accessor frequency :initarg :frequency)
   (amplitude :accessor amplitude :initarg :amplitude)
))

(defclass partial-set ()
  ((partials :accessor partials :initarg :partials)
   (inter-onsets :accessor inter-onsets :initarg :inter-onsets)
   (chord-delta :accessor chord-delta :initarg :chord-delta)
)) 

(defclass hans-chord ()
  ((LMidic :accessor LMidic :initarg :LMidic)
   (LDur :accessor LDur :initarg :LDur)
   (LVel :accessor LVel :initarg :LVel)
))

(defclass hans-chord-seq ()
  ((lmidic :accessor lmidic :initarg :lmidic)
   (lonset :accessor lonset :initarg :lonset)
))


(defmethod pduration ((partial partial))
  (- (outset partial) (ponset partial)))

(defmethod round-time ((partial partial))
  (setf (ponset partial)  (pw::g-round (* 100  (ponset partial))))
  (setf (outset partial) (max (ponset partial) (pw::g-round (* 100 (outset partial)))))
  partial)

(defmethod move-onset ((partial partial) onset)
  (setf (outset partial) (+ (outset partial) (- (ponset partial) onset))
        (ponset partial) onset)
  partial)

(defmethod set-inter-onset ((partial-set partial-set))
  (setf (inter-onsets partial-set)
        (loop for partial1 in (partials partial-set)
              for partial2 in (rest (partials partial-set))
              collect (- (ponset partial2) (ponset partial1))))
  partial-set)

(defmethod round-time ((partial-set partial-set))
  (loop
    for partial in (partials partial-set)
    with window-left = 0 and window-right = (chord-delta partial-set)
    if (< (ponset partial) window-right) do
    (move-onset partial window-left)
    else do (setf window-left (ponset partial)
                  window-right (+ window-left (chord-delta partial-set)))
    )
  partial-set)


(defun mk-partial-set (analyse delta vmin vmax fmin fmax)
  ;(setf analyse (first analyse))
  (let ((nbpartials nil))
    (setf analyse
          (mapcar #'(lambda (partial)
                      ;(pop partial)
                      (loop with nbpoints = (pop partial)
                            with first-date = (first partial)
                            with last-date 
                            for date in partial by #'cdddr
                            for freq in (cdr partial) by #'cdddr
                            for amp in (cddr partial) by #'cdddr
                            do (setf last-date date) 
                            sum freq into freq-sum
                            sum amp into amp-sum
                            finally (return (list first-date last-date 
                                                  (/ freq-sum nbpoints) 
                                                  (/ amp-sum nbpoints)))))
                  analyse))
    (setf analyse (mat-trans analyse)) 
    (setf (fourth analyse)
          (pw::g-round 
           (pw::g-scaling (mapcar #'(lambda (x) (* x (exp (* x 2))))
                                  (pw::g-scaling (fourth analyse) 0.0 1.0))
                          vmin vmax)))
;    (print analyse)
    (let
        ((partial-set
          (make-instance 'partial-set
                         :chord-delta delta
                         :partials
                         (apply  #'mapcar
                                 #'(lambda (onset outset freq amp)
                                     (round-time (make-instance 'partial :ponset  onset :outset  outset :frequency  freq
                                                                :amplitude  amp)))
                                 analyse))))
      (setf (partials partial-set)
            (loop for partial in (partials partial-set)
                  when (<= fmin (frequency partial) fmax)
                  collect partial))
      (round-time partial-set)
      (set-inter-onset partial-set)
      partial-set)))

(defun mk-partial-set2 (analyse delta vmin vmax fmin fmax)
  ;(setf analyse (first analyse))
  (let ((nbpartials nil))
    (setf analyse
          (mapcar #'(lambda (partial)
                      ;(pop partial)
                      (loop with nbpoints = (pop partial)
                            with first-date = (first partial)
                            with last-date 
                            for date in partial by #'cdddr
                            for freq in (cdr partial) by #'cdddr
                            for amp in (cddr partial) by #'cdddr
                            do (setf last-date date) 
                            sum freq into freq-sum
                            sum amp into amp-sum
                            finally (return (list first-date last-date 
                                                  (/ freq-sum nbpoints) 
                                                  (/ amp-sum nbpoints)))))
                  analyse))
    (setf analyse (mat-trans analyse))
    (setf (fourth analyse)
          (pw::g-round 
           (pw::g-scaling (mapcar #'(lambda (x) (* x (exp (* x 2))))
                                  (pw::g-scaling (fourth analyse) 0.0 1.0))
                          vmin vmax)))
    (print analyse)
    (let
        ((partial-set
          (make-instance 'partial-set
                         :chord-delta delta
                         :partials
                         (apply  #'mapcar
                                 #'(lambda (onset outset freq amp)
                                     (round-time (make-instance 'partial :ponset  (print onset) :outset  (print outset) :frequency  (print freq)
                                                                :amplitude  (print amp))))
                                 analyse))))
      (setf (partials partial-set)
            (loop for partial in (partials partial-set)
                  when (<= fmin (frequency partial) fmax)
                  collect partial))
      (round-time partial-set)
      (set-inter-onset partial-set)
 ;     (print (mapcar #'frequency (partials partial-set)))

 ;     (print (mapcar #'pduration (partials partial-set)))
 ;     (print (mapcar #'amplitude (partials partial-set)))


      partial-set)))

#|


(defun mk-partial-set (analyse delta vmin vmax fmin fmax)
  ;(setf analyse (first analyse))
  (let ((nbpartials nil))
    (setf analyse
          (mapcar #'(lambda (partial)
                      ;(pop partial)
                      (loop with nbpoints = (pop partial)
                            with first-date = (first partial)
                            with last-date 
                            for date in partial by #'cdddr
                            for freq in (cdr partial) by #'cdddr
                            for amp in (cddr partial) by #'cdddr
                            do (setf last-date date) 
                            sum freq into freq-sum
                            sum amp into amp-sum
                            finally (return (list first-date last-date 
                                                  (/ freq-sum nbpoints) 
                                                  (/ amp-sum nbpoints)))))
                  analyse))
    (setf analyse (mat-trans analyse)) 
    (setf (fourth analyse)
          (pw::g-round 
           (pw::g-scaling (mapcar #'(lambda (x) (* x (exp (* x 2))))
                                  (pw::g-scaling (fourth analyse) 0.0 1.0))
                          vmin vmax)))
    (let
        ((partial-set
          (make-instance 'partial-set
                         :chord-delta delta
                         :partials
                         (apply  #'mapcar
                                 #'(lambda (onset outset freq amp)
                                     (round-time (make-instance 'partial :ponset onset :outset outset :frequency freq
                                                                :amplitude amp)))
                                 analyse))))
      (setf (partials partial-set)
            (loop for partial in (partials partial-set)
                  when (<= fmin (frequency partial) fmax)
                  collect partial))
      (round-time partial-set)
      (set-inter-onset partial-set)
      partial-set)))
|#

#|
(defun mk-partial-set (analyse delta vmin vmax fmin fmax)
  (setf analyse (first analyse))
  (unless (string= (symbol-name (pop analyse)) "PARTIALS")
    (error "This is not a spectral analysis"))
  (let ((nbpartials (pop analyse)))
    (setf analyse
          (mapcar #'(lambda (partial)
                      (pop partial)
                      (loop with nbpoints = (pop partial)
                            with first-date = (first partial)
                            with last-date 
                            for date in partial by #'cdddr
                            for freq in (cdr partial) by #'cdddr
                            for amp in (cddr partial) by #'cdddr
                            do (setf last-date date) 
                            sum freq into freq-sum
                            sum amp into amp-sum
                            finally (return (list first-date last-date 
                                                  (/ freq-sum nbpoints) 
                                                  (/ amp-sum nbpoints)))))
                  analyse))
    (setf analyse (mat-trans analyse)) 
    (setf (fourth analyse)
          (om-round 
           (om-scale (mapcar #'(lambda (x) (* x (exp (* x 2))))
                             (om-scale (fourth analyse) 0.0 1.0))
                     vmin vmax)))
    (let
        ((partial-set
          (make-instance 'partial-set
                         :chord-delta delta
                         :partials
                         (apply  #'mapcar
                                 #'(lambda (onset outset freq amp)
                                     (round-time (make-instance 'partial :ponset onset :outset outset :frequency freq
                                                                :amplitude amp)))
                                 analyse))))
      (setf (partials partial-set)
            (loop for partial in (partials partial-set)
                  when (<= fmin (frequency partial) fmax)
                  collect partial))
      (round-time partial-set)
      (set-inter-onset partial-set)
      partial-set)))


|#


(defun partials->chords (partial-set approx npoly)
  (and (partials partial-set)
       (let ((partial-list (list (list (first (partials partial-set)))))
             (chord-list) (result nil)) 
         (loop for partial in (rest (partials partial-set))
               for inter-onset in (inter-onsets partial-set)
               if (zerop inter-onset) do
               (push partial (first partial-list))
               else do (push (list partial) partial-list))
         (setf partial-list (reverse partial-list))
         (setf chord-list
               (mapcar #'(lambda (partials)
                           (setf partials (reduce-partials partials approx npoly))
                           
                           ;  (make-instance 'chord
                           ;      :LMidic (pw::f->m (mapcar #'frequency partials))
                           ;      :LDur (pw::g* 10 (mapcar #'pduration partials))
                           ;      :LVel (mapcar #'amplitude partials)))

                           (print(list
                            (pw::approx-midi (pw::f->m (mapcar #'frequency partials)) approx)
                            (pw::g* 10 (mapcar #'pduration partials))
                            (mapcar #'amplitude partials)))
                           )


                       partial-list)
               
               )
         (push (list chord-list (pw::g* 10 (mapcar #'(lambda ( partials) (ponset (first partials)))  partial-list))) result)

 ;        (make-instance 'chord-seq
 ;          :lmidic chord-list
 ;          :lonset  (om* 10 (mapcar #'(lambda ( partials) (ponset (first partials)))  partial-list))) 
         
        (print (nreverse result))
         )))

(defun partials->chords3 (partial-set approx npoly)
  (and (partials partial-set)
       (let ((partial-list (list (list (first (partials partial-set)))))
             (chord-list) (result nil)) 
         (loop for partial in (rest (partials partial-set))
               for inter-onset in (inter-onsets partial-set)
               if (zerop inter-onset) do
               (push partial (first partial-list))
               else do (push (list partial) partial-list))
         (setf partial-list (reverse partial-list))
         (print (setf chord-list
               (mapcar #'(lambda (partials)
                           (setf partials (reduce-partials partials approx npoly))
                           
                           (push (list (pw::f->m (mapcar #'frequency partials))
                                       (pw::g* 10 (mapcar #'pduration partials))
                                       (mapcar #'amplitude partials)) result)
                       partial-list))))
        
; (make-instance 'hans-chord-seq
;                        :lmidic chord-list
;                        :lonset  (pw::g* 10 (mapcar #'(lambda ( partials) (ponset (first partials)))  partial-list))) 


         )))


(defun partials->chords2 (partial-set approx npoly)
  (and (partials partial-set)
       (let ((partial-list (list (list (first (partials partial-set)))))
             (chord-list) (result nil)) 
         (loop for partial in (rest (partials partial-set))
               for inter-onset in (inter-onsets partial-set)
               if (zerop inter-onset) do
               (push partial (first partial-list))
               else do (push (list partial) partial-list))
         (setf partial-list (reverse partial-list))
         (mapcar #'(lambda (partials)
                     (setf partials (reduce-partials partials approx npoly))
                           
                           ;  (make-instance 'chord
                           ;      :LMidic (pw::f->m (mapcar #'frequency partials))
                           ;      :LDur (pw::g* 10 (mapcar #'pduration partials))
                           ;      :LVel (mapcar #'amplitude partials)))

                     (push (list
                            (print (pw::approx-midi (pw::f->m (mapcar #'frequency partials)) approx))
                            (pw::g* 10 (mapcar #'pduration partials))
                            (mapcar #'amplitude partials)) result)
                     )


                 partial-list)
         (print (nreverse result))
; (make-instance 'hans-chord-seq
;                        :lmidic chord-list
;                        :lonset  (pw::g* 10 (mapcar #'(lambda ( partials) (ponset (first partials)))  partial-list))) 


         )))


#|


;--------------------------------------         
  (defun partials->chords (partial-set approx npoly)
    (and (partials partial-set)
         (let ((partial-list (list (list (first (partials partial-set)))))
               (chord-list) )          
           (loop for partial in (rest (partials partial-set))
                 for inter-onset in (inter-onsets partial-set)
                 if (zerop inter-onset) do
                 (push partial (first partial-list))
                 else do (push (list partial) partial-list))
           (setf partial-list (reverse partial-list))
           (setf chord-list
                 (mapcar #'(lambda (partials)
                             (setf partials (reduce-partials partials approx npoly))
                             (make-instance 'chord
                                            :LMidic (f->mc (mapcar #'frequency partials))
                                            :LDur (om* 10 (mapcar #'pduration partials))
                                            :LVel (mapcar #'amplitude partials)))
                         partial-list))
           (make-instance 'chord-seq
                          :lmidic chord-list
                          :lonset  (om* 10 (mapcar #'(lambda ( partials) (ponset (first partials)))  partial-list))) )))
 |#

(defun reduce-partials (partials approx npoly)
  (let ((pbuf ()) (partials (sort partials #'(lambda (p1 p2) (< (frequency p1) (frequency p2))))))
    (loop for partial in partials
          if (and pbuf 
                  (= (pw::approx-midi (pw::f->m (frequency partial)) approx)
                     (pw::approx-midi (pw::f->m (frequency (first pbuf))) approx))) do
          (setf (amplitude (first pbuf)) (max (amplitude (first pbuf)) (amplitude partial))
                (outset (first pbuf)) (max (outset (first pbuf)) (outset partial)))
          else do (push  partial pbuf))
    (pw::firstn  npoly (sort pbuf '> :key #'amplitude) )))
    
        
                    
(defmethod AS->OM ((analyse list)
                   (vmin integer)
                   (vmax integer)
                   (delta integer)
                   (mmin integer )
                   (mmax integer )
                   (approx integer)
                   (npoly integer ))
  :initvals '( () 40 100 5 4000 8600 8 1)
  :indoc '("Analyse" "vel min" "vel max" "delta" "midic min" "midic max" "approx" "poly. density")
  :icon 250
  :doc  "
Converts partials-analysis data, obtained from AudioSculpt by the 'Export Partials' command,
in a suitable format for displaying and manipulating in OM

parameters : 

analyse : connect here the output of a text module containing the partial analysis.
vmin,vmax : integers, amplitudes will be scaled as Midi Velocities between  vmin and vmax
delta: integer, events whose onset-time fall within a window of <delta> 1/1000sec will be gathered into chords
mmin,mmax: midic values that define the allowed pitch range for the output.
approx: 1,2,4, or 8. Micro-tonal approximation.
npoly: tries and reduce the polyphony to <npoly> notes at the same time by taking the louder partials first.

output : 

a list of chords to be connected to a chordseq module.
"
(partials->chords (mk-partial-set analyse (pw::g-round delta 10) vmin vmax (pw::m->f mmin) (pw::m->f mmax)) approx npoly)
)

(defmethod AS->OM2 ((analyse list)
                   (vmin integer)
                   (vmax integer)
                   (delta integer)
                   (mmin integer )
                   (mmax integer )
                   (approx integer)
                   (npoly integer ))
  :initvals '( () 40 100 5 4000 8600 8 1)
  :indoc '("Analyse" "vel min" "vel max" "delta" "midic min" "midic max" "approx" "poly. density")
  :icon 250
  :doc  "
Converts partials-analysis data, obtained from AudioSculpt by the 'Export Partials' command,
in a suitable format for displaying and manipulating in OM

parameters : 

analyse : connect here the output of a text module containing the partial analysis.
vmin,vmax : integers, amplitudes will be scaled as Midi Velocities between  vmin and vmax
delta: integer, events whose onset-time fall within a window of <delta> 1/1000sec will be gathered into chords
mmin,mmax: midic values that define the allowed pitch range for the output.
approx: 1,2,4, or 8. Micro-tonal approximation.
npoly: tries and reduce the polyphony to <npoly> notes at the same time by taking the louder partials first.

output : 

a list of chords to be connected to a chordseq module.
"
(partials->chords2 (mk-partial-set2 analyse (pw::g-round delta 10) vmin vmax (pw::m->f mmin) (pw::m->f mmax)) approx npoly)
)


;;
;;            Librairie RepMus
;;            SDIF partial tracking --> OM chord-seq
;;            Jean Bresson  © IRCAM 2005
           

;(in-package :om)

#|


;;;=============================================
;;; AUDIOSCULPT SDIF 
;;;=============================================


(defmethod! get-chordseq-data ((self sdiffile))
   :doc "Return a list of chords data (pitch onset offset velocity) from an sdif file (using 1MRK frames)"
   :icon 639
   (let ((chords nil) 
         (mrk-partials (make-hash-table)) (trc-partials (make-hash-table))
          mlist bmat emat pmat time
          (ptrfile (dynamic-open self)))
     (sdif::SdifFReadGeneralHeader ptrfile)
     (sdif::SdifFReadAllASCIIChunks ptrfile)
     (loop for item in (framesdesc self) do
             (when (equal "1MRK" (car item))
                 (setf time (nth 1 item))
                 (sdif-set-pos ptrfile (nth 3 item))
                 (setf mlist (nth 4 item))
                 (loop for mat in mlist do
                         (cond ((equal "1BEG" (car mat)) (setf bmat mat))
                                  ((equal "1END" (car mat)) (setf emat mat))
                                  ((equal "1TRC" (car mat)) (setf pmat mat))
                                  (t nil)))
                 (when bmat 
                     ;;; a begin matrix :
                     ;;; ajoute (onset (note1 note2 ...)) dans tmplist 
                     ;;; avec des valeurs de amp (0) freq (0) et dur (1000) arbitraires pour l'instant
                     (sdif-read-headers ptrfile (nth 3 item) (fifth bmat))
                     (loop for i = 0 then (+ i 1) while (< i (second bmat)) do
                             (sdif::SdifFReadOneRow ptrfile)
                             (sethash mrk-partials (floor (sdif::SdifFCurrOneRowCol ptrfile 1)) (list 0 time time 0))
                     ))
                 (when pmat 
                     ;;; a parameter matrix :
                     ;;; cherche les notes dans tmplist et set pitch et velocity
                     (sdif-read-headers ptrfile (nth 3 item) (fifth pmat))
                     (loop for i = 0 then (+ i 1) while (< i (second pmat)) do
                             (sdif::SdifFReadOneRow ptrfile)
                             (let* ((ind (floor (sdif::SdifFCurrOneRowCol  ptrfile 1))) 
                                    (freq (sdif::SdifFCurrOneRowCol ptrfile 2))
                                    (amp (sdif::SdifFCurrOneRowCol ptrfile 3)) 
                                    (par (gethash ind mrk-partials)))
                               (when par
                                 (setf (car par) freq)
                                 (setf (fourth par) amp))
                               ))
                     )
                 (when emat 
                     ;;; a end matrix :
                     ;;; find the notes, set duration and put int the final notes list 
                     (sdif-read-headers ptrfile (nth 3 item) (fifth emat))
                     (loop for i = 0 then (+ i 1) while (< i (second emat)) do
                             (sdif::SdifFReadOneRow ptrfile)
                             (let* ((ind (floor (sdif::SdifFCurrOneRowCol ptrfile 1)))
                                   (par (gethash ind mrk-partials)))
                               (when par
                                 (setf (third par) time))
                               )))
                 (setf bmat nil)
                 (setf emat nil)
                 (setf pmat nil)
                 )

             
             (when (or (equal "1TRC" (car item)) (equal "1HRM" (car item)))
               (setf time (nth 1 item))
               (sdif-set-pos ptrfile (nth 3 item))
               (setf mlist (nth 4 item))
               (loop for m in mlist do
                     (when (or (equal "1TRC" (car m)) (equal "1HRM" (car m)))
                       (sdif-read-headers ptrfile (nth 3 item) (fifth m))
                       (loop for i = 0 then (+ i 1) while (< i (second m)) do
                             (sdif::SdifFReadOneRow ptrfile)
                             (let* ((ind (floor (sdif::SdifFCurrOneRowCol ptrfile 1)))
                                    (freq (sdif::SdifFCurrOneRowCol ptrfile 2))
                                    (amp (sdif::SdifFCurrOneRowCol ptrfile 3))
                                    (par (gethash ind trc-partials)))
                               (if par
                                 (progn 
                                   (setf (car par) (push freq (car par)))
                                   (setf (fourth par) (push amp (fourth par)))
                                   (setf (third par) time)
                                   )
                                 (sethash trc-partials ind (list (list freq) time time (list amp))))
                               )
                             ))
                     )
               )


             )
     
        (maphash #'(lambda (key val)
                  (push val chords)) 
              mrk-partials)

     (maphash #'(lambda (key val)
                  (push (list (om-mean (car val)) 
                              (second val) (third val) 
                              (om-mean (fourth val)))  
                        chords)) 
              trc-partials)
     
     (dynamic-close self ptrfile)
     (sort chords '< :key 'cadr)
     
     ))



;;; !!!!!!   A REFAIRE   !!!!!!!
(defmethod! get-chordseq-data ((self sdifstream))
   :doc "Return a list of chords data (pitch onset offset velocity) from an sdif file (using 1MRK frames)"
   :icon 639
   (let ((chords nil) (tmplist nil) 
          mlist bmat emat pmat time)
     (loop for item in (Lframes self) do
             (when (equal "1MRK" (signature item))
                 (setf time (Ftime item))
                 (loop for mat in (LMatrix item) do
                         (cond ((equal "1BEG" (signature mat)) (setf bmat mat))
                                  ((equal "1END" (signature mat)) (setf emat mat))
                                  ((equal "1TRC" (signature mat)) (setf pmat mat))
                                  (t nil)))
                 (when bmat 
                     ;;; a begin matrix :
                     ;;; ajoute (onset (note1 note2 ...)) dans tmplist 
                     ;;; avec des valeurs de amp (0) freq (0) et outset (time) arbitraires pour l'instant
                     (loop for i = 0 then (+ i 1) while (< i (numcols bmat)) do
                             (push (list (floor (get-array-i-j bmat 0 i)) 0 time time 0) tmplist)
                             )
                     )
                 (when pmat 
                     ;;; a parameter matrix :
                     ;;; cherche les notes dans tmplist et set pitch et velocity
                     (loop for i = 0 then (+ i 1) while (< i (numcols pmat)) do
                             (let ((found nil) ind freq amp)
                               (setf ind (floor (get-array-i-j pmat 0 i)))
                               (setf freq (get-array-i-j pmat 1 i))
                               (setf amp (get-array-i-j pmat 2 i))
                               (loop for note in tmplist while (not found) do
                                       (when (equal ind (car note))
                                           (setf found t)
                                           (setf (second note) freq)
                                           (setf (fifth note) amp)))
                               ))
                     )
                 (when emat 
                     ;;; a end matrix :
                     ;;; find the notes, set duration and put int the final notes list 
                     (loop for i = 0 then (+ i 1) while (< i (numcols emat)) do
                             (let ((found nil) ind)
                               (setf ind (floor (get-array-i-j emat 0 i)))
                               (loop for note in tmplist while (not found) do
                                       (when (equal ind (car note))
                                           (setf found t)
                                           (setf (fourth note) time)
                                           (push (cdr note) chords)
                                           (setf tmplist (remove note tmplist))
                                           ))
                               )))
             (setf bmat nil)
             (setf emat nil)
             (setf pmat nil)
             ))
     (sort chords '< :key 'cadr)
     ))



(defun mk-partial-set-from-sdif (sdiffile delta vmin vmax fmin fmax)
   (setf analyse (get-chordseq-data sdiffile))
   (let ((nbpartials (length analyse)))
     (setf analyse (mat-trans analyse))
     (setf (fourth analyse) (om-round (om-scale (fourth analyse) vmin vmax)))
     (setf analyse (list (second analyse) (third analyse) (first analyse) (fourth analyse)))
     (let ((partial-set
             (make-instance 'partial-set
                 :chord-delta delta
                 :partials
                 (apply  #'mapcar
                           #'(lambda (onset outset freq amp)
                               (round-time (make-instance 'partial :ponset onset :outset outset :frequency freq
                                                      :amplitude amp)))
                           analyse))))
       (setf (partials partial-set)
         (loop for partial in (partials partial-set)
               when (<= fmin (frequency partial) fmax)
               collect partial))
      (round-time partial-set)
      (set-inter-onset partial-set)
       partial-set)))

(defmethod! AS->OM ((analyse sdiffile)
                    (vmin integer)
                    (vmax integer)
                    (delta integer)
                    (mmin integer)
                    (mmax integer)
                    (approx integer)
                    (npoly integer ))
  (partials->chords (mk-partial-set-from-sdif analyse  (round delta 10) 
                                    vmin vmax (mc->f mmin) (mc->f mmax)) approx npoly))


(defmethod! AS->OM ((analyse sdifstream)
                    (vmin integer)
                    (vmax integer)
                    (delta integer)
                    (mmin integer)
                    (mmax integer)
                    (approx integer)
                    (npoly integer ))
  (partials->chords (mk-partial-set-from-sdif analyse (round delta 10) 
                                    vmin vmax (mc->f mmin) (mc->f mmax)) approx npoly))


;;;==============================
;;; PARTIALS -> OMSDIF (compatibilite SDIFEdit)
;;;==============================

(defun moyene-list (list)
  (let* ((timel (car list))
        (st (car timel))
        (args (cdr list)))
    (setf timel (cons st (loop for item in timel collect (- item st))))
    (cons timel
          (loop for item in args 
                collect (let ((newitem (/ (apply '+ item) (length item))))
                          (cons newitem (om- item newitem )))))))

(defun write-the-frame (fileptr point)
  (let* ((col-num 3)
         (only-data (moyene-list (list-modulo (cddr point) col-num))))
    (save-sdif-partials only-data fileptr (third point))))

(defun calc-pad (n)
  (if (zerop (mod n 8)) n
      (* 8 (+ (floor n 8) 1))))

(defun save-sdif-partials (points ptr starttime)
   (without-interrupts  
    (let* ((datatype 4)
           (numcols 3)
           (mat-points (mat-trans points))
           (numlines (length mat-points))
           (framesize (+ 32 (calc-pad (* numcols datatype  numlines))))
           (values (om-make-pointer (* numcols datatype  numlines))))     ;;;(#_newptr (* numcols datatype  numlines))))
      (sdif::SdifFSetCurrFrameHeader ptr (sdif-string-to-signature "EASF") framesize 1  0 (coerce starttime 'double-float))
      (sdif::SdifFWriteFrameHeader ptr)
      (loop for i from 0 to (- numlines 1)
            for sdifrow in mat-points do
            (loop for j from 0 to (- numcols 1)
                  for val in sdifrow do
                    (om-write-ptr values (+ (* j datatype) (* i numcols datatype)) :single-float (coerce val 'single-float))))   
      (sdif::SdifFWriteMatrix ptr (sdif-string-to-signature "EASM") datatype numlines  numcols values))))

(defun write-partial-headers (ptrfile)
   (let (str sstr)
     (sdif::SdifFWriteGeneralHeader ptrfile)
     (write-1nvt-table ptrfile
                               (list "Author" )
                               (list (format nil "OM ~D" *om-version*)))
     (setf str (format nil "{1MTD EASM   {Onset, Frequency, Amplitude} 1FTD EASF {EASM  PartialsSet;}}"))
     (setf sstr (sdif::SdifStringNew)) 
     (Sdif-String-Append sstr str)
     (sdif::SdifStringGetC sstr)
     (sdif::SdifFGetAllTypefromSdifString ptrfile sstr)
     (sdif::SdifFWriteAllASCIIChunks  ptrfile)
     ))

(defmethod! as-cs2sdifedit ((analyse list))
  :icon 639
   :doc "audiosculpt partials to sdifedit partials."
   (let* ((new-path (om-CHOOSE-new-FILE-DIALOG)))
     (when new-path
         (let ((sfile (sdif-open-file (om-path2cmdpath new-path) :eWriteFile)))
           (write-partial-headers sfile)
           (setf analyse (first analyse))
           (unless (string= (symbol-name (pop analyse)) "PARTIALS")
              (error "This is not a spectral analysis"))
           (loop for cur-point in (cdr analyse) do
                   (write-the-frame sfile cur-point))
           (sdif-close-file sfile)))
           new-path))


(defmethod! as-cs2sdifedit ((sdiffile sdiffile))
  :icon 639
  :doc "audiosculpt partials to sdifedit partials."
   (let ((new-path (om-CHOOSE-new-FILE-DIALOG)))
     (when new-path
         (let ((sfile (sdif-open-file (om-path2cmdpath new-path) :eWriteFile))
                        (analyse (get-chordseq-data sdiffile)))
           (write-partial-headers sfile)
           (loop for cur-point in analyse do
                   (write-the-frame sfile (list 'points 2 
                                                           (second cur-point) (first cur-point) (fourth cur-point)
                                                           (third cur-point) (first cur-point) (fourth cur-point))))
           (sdif-close-file sfile)))
     new-path))

(defmethod! as-cs2sdifedit ((sdiffile sdifstream))
  :icon 639
  :doc "audiosculpt partials to sdifedit partials."
   (let ((new-path (om-CHOOSE-new-FILE-DIALOG)))
     (when new-path
         (let ((sfile (sdif-open-file (om-path2cmdpath new-path) :eWriteFile))
                        (analyse (get-chordseq-data sdiffile)))
           (write-partial-headers sfile)
           (loop for cur-point in analyse do
                   (write-the-frame sfile (list 'points 2 
                                                           (second cur-point) (first cur-point) (fourth cur-point)
                                                           (third cur-point) (first cur-point) (fourth cur-point))))
           (sdif-close-file sfile)))
     new-path))


;;;===================================================
;;;
;;; ON SE SERT PLUS DE TOUT ÁA
;;;
;;;===================================================
;;;(defclass! EASM (SDIF-MTC)
;;;   ((Onset :initform 0 :initarg :Onset :type number :accessor Onset)
;;;    (Frequency :initform 440.0 :initarg :Frequency :type number :accessor Frequency)
;;;    (Amplitude :initform 0.8 :initarg :Amplitude :type number :accessor Amplitude)
;;;    )
;;;   (:icon 640)
;;;   (:documentation "Onset, Frequency, Amplitude."))
;;;===================================================
;;;
;;; ÁA C'ETAIT POUR PASSER DE PARTIAL ASCII A OM-SDIF
;;;====================================================
;;;
;;;(defmethod* as-cs2sdif ((filename t))
;;;  :icon 639
;;;  :doc "audiosculpt partials to sdif."
;;;  (let* ((new-path (om-CHOOSE-new-FILE-DIALOG))
;;;        (sfile (sdif-open-file (om-path2cmdpath new-path) :eWriteFile)) str sstr)
;;;    (sdif::SdifFWriteGeneralHeader sfile)
;;;    (write-1nvt-table sfile
;;;                       (list "Author" )
;;;                       (list (format nil "OM ~D" *om-version*)))
;;;    (setf str (format nil "{1MTD EASM   {Onset, Frequency, Amplitude} 1FTD EASF {EASM  PartialsSet;}}"))
;;;    (setf sstr (sdif::SdifStringNew)) 
;;;    (Sdif-String-Append sstr str)
;;;    (sdif::SdifStringGetC sstr)
;;;    (sdif::SdifFGetAllTypefromSdifString sfile sstr)
;;;    (sdif::SdifFWriteAllASCIIChunks  sfile)
;;;    (with-open-file (in filename)
;;;      (let ((info (read-line in)) np  )
;;;        (setf info (string+ info ")"))
;;;        (setf np (second (read-from-string info)))
;;;        (loop for i from 1 to np do
;;;              (let ((cur-point (read in)))
;;;                (write-the-frame sfile cur-point)))
;;;        (close-sdif-file sfile)))
;;;    new-path))
;;;
;;;
;;; ÁA C'EST POUR PASSER DE OM-SDIF A PARTIAL-ASCII
;;;==================================================
;;;(defmethod* om-sdif2partials ((self sdiffile))
;;;  :icon 639
;;;  (let ((frame-num (numFrames self))
;;;        rep)
;;;    (setf rep
;;;          (loop for i from 0 to (- frame-num 1) 
;;;                when (equal :EASF (FrameInfo self i)) collect (read-partial-as self i)))
;;;    (list (cons 'PARTIALS (cons frame-num rep)))))
;;;
;;;(defun read-partial-as (file fnum)
;;;  (let* ((mat-info (multiple-value-list (MatrixInfo file fnum 0)))
;;;         (numrows (second mat-info)))
;;;    (cons-partial-as (loop for i from 0 to (- numrows 1) collect (GetRow file fnum 0 i)))))
;;;
;;;(defun cons-partial-as (list)
;;;  (cons 'POINTS (cons (- (length list) 1)
;;;                      (loop for item in (cdr list)
;;;                            append (om+ (car list) item)))))

|#