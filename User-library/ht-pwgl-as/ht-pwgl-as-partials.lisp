;;;================================================================================================================
;;; SuperVP Sound Processing
;;; Hans Tutschku 2008
;;;================================================================================================================

(in-package :ht-pwgl-as)
  
(in-menu partial-analysis)


;;;;------------------------------------------------------------------------#| |#
(define-box split-partials-into-sublists ((liste nil))
  "depending on the partial index, collects informations, which belong to the 
same partial into separate sub-lists

freq amp duration onsettime"
  :non-generic t
  (let
      ((result (make-array 5000)) (counter 0) (partial1 0) (partial2 0)
       (myfreq 0) (myamp 0) (aux0 nil) (deltatime nil))
    (setf liste (pw::sort-list (pw::flat-once liste) '< 'first))  
    (loop for i from 0 to (- (length liste) 1) do
                                                             ;read all frames sequentially
          (setf partial1 (first (nth i liste)))                 ; index of partial1 of actual frame
          (if (nth (+ 1 i) liste)
              (setf partial2 (first (nth (+ 1 i) liste))))           ;index of partial2 of next frame
          (if (= partial1 partial2)                       ; if both indicies of the two partials are equal
              (push (rest (nth i liste)) aux0 )         ;collect the frequency,amplitude, phase, onset-time (but not the index)
            (progn nil
              ;(print aux0)
              (setf counter (+ 1 counter))                   ; increment counter for array in result
              (setf (aref result counter) (pw::sort-list aux0 '< 'fourth))    ;write the current partial, sorted by onset times in the result-array
              (setf aux0 nil)                                ; clear aux0 for next iteration
              )))
    (setf counter (+ 1 counter))                   ; increment counter for array in result
    (setf (aref result counter) (pw::sort-list aux0 '< 'fourth))    ; write the current partial, sorted by onset times in the result-array
    	  
    (coerce (remove nil result) 'list)))                     ;convert array into list and remove nils

;;;;------------------------------------------------------------------------#| |#
(define-box split-partials-into-sublists2 ((liste nil))
  "depending on the partial index, collects informations, which belong to the 
same partial into separate sub-lists

onsettime  duration  freq amp"
  :non-generic t
  (let
      ((result (make-array 5000)) (counter 0) (partial1 0) (partial2 0)
       (myfreq 0) (myamp 0) (aux0 nil) (deltatime nil))
    (setf liste (pw::sort-list (pw::flat-once liste) '< 'first))  
    (loop for i from 0 to (- (length liste) 1) do
                                                             ;read all frames sequentially
          (setf partial1 (first (nth i liste)))                 ; index of partial1 of actual frame
          (if (nth (+ 1 i) liste)
              (setf partial2 (first (nth (+ 1 i) liste))))           ;index of partial2 of next frame
          (if (= partial1 partial2)                       ; if both indicies of the two partials are equal
              (push (reverse (rest (nth i liste))) aux0 )         ;collect the frequency,amplitude, phase, onset-time (but not the index)
            (progn nil
              ;(print aux0)
              (setf counter (+ 1 counter))                   ; increment counter for array in result
              (setf (aref result counter) (pw::sort-list aux0 '< 'fourth))    ;write the current partial, sorted by onset times in the result-array
              (setf aux0 nil)                                ; clear aux0 for next iteration
              )))
    (setf counter (+ 1 counter))                   ; increment counter for array in result
    (setf (aref result counter) (pw::sort-list aux0 '< 'fourth))    ; write the current partial, sorted by onset times in the result-array
    	  
    (coerce (remove nil result) 'list)))                     ;convert array into list and remove nils


;;;;------------------------------------------------------------------------#| |#

(define-box split-partials-into-sublists-om ((liste nil))
  "depending on the partial index, collects informations, which belong to the 
same partial into separate sub-lists
version for as-om
each partial (nb of points, onset, freq, amp)"
  :non-generic t
  (let
      ((result (make-array 5000)) (counter 0) (partial1 0) (partial2 0)
       (myfreq 0) (myamp 0) (aux0 nil) (aux1 nil) (deltatime nil))
    (setf liste (pw::sort-list (pw::flat-once liste) '< 'first))  
    (loop for i from 0 to (- (length liste) 1) do
                                                             ;read all frames sequentially
          (setf partial1 (first (nth i liste)))                 ; index of partial1 of actual frame
          (if (nth (+ 1 i) liste)
              (setf partial2 (first (nth (+ 1 i) liste))))           ;index of partial2 of next frame
          (if (= partial1 partial2)                       ; if both indicies of the two partials are equal
              (progn ()
                (push (rest (nth i liste)) aux0 )         ;collect the frequency,amplitude, phase, onset-time (but not the index)
                (setf aux0 (first aux0))
                ;(print aux0)
                (push (list (first aux0) (fourth aux0)  (second aux0)) aux1)
                (setf aux0 nil)
                ;(print aux1)
                )
            (progn nil
              ;(print aux1)
              (setf counter (+ 1 counter))                   ; increment counter for array in result
              ;(setf (aref result counter) (flat (list (length aux1) (pw::sort-list aux1 '< 'first))))    ;write the current partial, sorted by onset times in the result-array
(setf (aref result counter) (pw::sort-list aux1 '< 'second))
              (setf aux1 nil)                                ; clear aux0 for next iteration
              )))
    (setf counter (+ 1 counter))                   ; increment counter for array in result
    (setf (aref result counter) (pw::sort-list aux0 '< 'fourth))    ; write the current partial, sorted by onset times in the result-array
    	  
    (coerce (remove nil result) 'list)))                     ;convert array into list and remove nils


;;;;------------------------------------------------------------------------#| |#
(define-box calc-amps+durs ((liste nil))
  "calculates the minimum and maximum average amplitude for all partials
this box serves just to gather information into the PWGL interface"
  :non-generic t
  (let
      ((amplitudes nil) (aux0 nil) (aux1 nil) (durations nil) (ampmin nil) (ampmax nil) (ampaverage nil) (durmin nil) (durmax nil) (duraverage nil))
    (dolist (partial liste)
      (dolist (frame partial)
        (push (second frame) aux0) ;amplitudes
        (push (fourth frame) aux1)) ; onset-times
      (push (pw::g-average aux0 1) amplitudes) ; average amplitudes
      (push  (abs (- (first aux1) (pw::last-elem aux1))) durations) ; calculate duration for each partial
      (setf aux0 nil)
      (setf aux1 nil))
    (setf ampmin (pw::g-min amplitudes))
    (setf ampaverage (pw::g-average amplitudes 1))
    (setf ampmax (pw::g-max amplitudes))
    (setf durmin (pw::g-min durations))
    (setf duraverage (pw::g-average durations 1))
    (setf durmax (pw::g-max durations))
    (list ampmin ampaverage ampmax durmin duraverage durmax ))
  )

;;;;------------------------------------------------------------------------#| |#
(define-box show-amps+durs ((liste nil))
  "prints the values calculated by calc-amps+durs "
  :non-generic t
  (setf liste (ht-pwgl-as::calc-amps+durs liste))
  (print (list "ampmin" (first liste)))
  (print (list "ampaverage" (second liste)))
  (print (list "ampmax"  (third liste)))
  (print (list "durmin" (fourth liste)))
  (print (list "duraverage" (fifth liste)))
  (print (list "durmax"  (sixth liste)))
  nil)

;;;;------------------------------------------------------------------------#| |#

(define-box filter-partials ((liste nil) (filt-ampmin 60) (filt-ampmax 127) (filt-durmin 0.1) (filt-durmax 5) (approx 8))
  " filters partials which do not fall between min- and max-duration, as well as min- and max-amplitude
the amplitude-range is recalculated from 0 to 127

output = onset, duration, midinote, amp)"
  :non-generic t
  (let
      ((result nil)  (aux0 nil) (aux1 nil)  (aux2 nil) (aux3 nil)   (ampmin-all nil)  (ampmax-all nil)  (durmin-all nil)   (durmax-all nil)
       (amplitude nil)  (duration nil)
       (amps+durs (calc-amps+durs liste))   ; these are the min-, max- and average informations for the entire analysis
       )
    (setf ampmin-all (first amps+durs))       ; set individual variable names
    (setf ampmax-all (third amps+durs))
    (setf durmin-all (fourth amps+durs))
    (setf durmax-all (sixth amps+durs))

    (dolist (partial liste)
      (dolist (frame partial)
        (push (second frame) aux0) ;amplitudes
        (push (fourth frame) aux1)) ; onset-times
      (push  (first (pw::g-scaling             ;take first to make amplitude an atom, not a list
                     (pw::g-average aux0 1)                  ; average amplitudes of current 
                     60 127 ampmin-all ampmax-all)) aux2) ;partial and scale between 60 and 127
      (push  (abs (- (first aux1) (pw::last-elem aux1))) aux3) ; calculate duration for current partial
      (setf amplitude (first aux2))
      (setf duration (first aux3))

      (if (and (<= filt-ampmin amplitude) (>= filt-ampmax amplitude) (<= filt-durmin duration) (>= filt-durmax duration))
          (progn ()
            (setf aux4 (mat-trans partial))
            (setf midinote (pw::approx-midi (pw::f->m (pw::g-average (first aux4) 1)) approx)) ;average frequencies of partial
            (setf onset (first (fourth aux4)))          ; save onset-time
            (push (list onset duration midinote amplitude) result)))
      
      (setf aux0 nil)
      (setf aux1 nil)
      (setf aux2 nil)
      (setf aux3 nil)
      (setf aux4 nil)
      (setf duration nil)
      (setf amplitude nil))
    
    (pw::sort-list (reverse result) '< 'first))) ;sort by onset times

;output = freq amp onset duration


;;;;------------------------------------------------------------------------#| |#

(define-box make-one-voice ((liste nil) (midi (60 80)) (dur (0.1 1)) (vel (60 120)) (interval (-5 5)))
  "out of the ensemble of partials we collect one monodic voice
the pitches must be inside the range of midi
the durations inside the range of dur (in seconds)
the volocities inside the range of vel
the rising or falling intervals of adjacent notes inside interval"
  :non-generic t
;  :outputs 2
  (let
      ((result nil)  (notused nil) (liste2 liste) (aux0 nil) (aux2 nil) (aux3 nil) (counter 0))
 ;   (print (list "liste" liste))
    (pw::dowhile (not result)
      (setf aux0 (posn-match liste counter))        ; search for the first note, put all partials which do not fulfull the conditions into notused
                                                    ; as soon as a partial is found, it is copied into result and this dowhile stopps
                                                    ; then the endpunkt for this partial is calculated and the dolist starts
    ;  (print (list "result" result))
    ;  (print (list "aux0" aux0))
    ;  (print (list "counter" counter))
      (if (and (> (third aux0) (first midi)) (< (third aux0) (second midi))  ; pitch inside midiinterval
               (> (second aux0) (first dur)) (< (second aux0) (second dur))   ; durations between limits
               (> (fourth aux0) (first vel)) (< (fourth aux0) (second vel))   ; velocities between limits
               )
          (progn ()         
            (push aux0 result)
            (pop liste2))
        (progn () 
     ;     (print "++++++")  
          (pop liste2)
      ;    (print (list "liste2" liste2))        
          (push aux0 notused)
       ;   (print (list "notused" notused))
          (setf counter (pw::g+ counter 1))
          )) )
     
    (setf endpunkt (+ (first (first result)) (second (first result)))) ;note-off time of first note for this voice
 
    (dolist (zweiter (rest liste2))
     ; (print (list "third zweiter" (third zweiter) "res" (third (first result)) "first interval" (first interval)))
      (if (and (> (first zweiter) endpunkt) ;(> (+ (first zweiter) (second zweiter)) endpunkt) 
               (> (third zweiter) (first midi)) (< (third zweiter) (second midi)) ; pitch inside midiinterval
               (> (second zweiter) (first dur)) (< (second zweiter) (second dur))   ; durations between limits
               (> (fourth zweiter) (first vel)) (< (fourth zweiter) (second vel))   ; velocities between limits
               (> (- (third zweiter) (third (first result))) (first interval)) 
               (< (- (third zweiter) (third (first result))) (second interval))   ; interval to previous partial between limits
               )
          (progn ()  
     ;       (print "-------")
      ;      (print (list "first zweiter + second zweiter" (+ (first zweiter) (second zweiter)) "endpunkt" endpunkt))          
            (push zweiter result)
            (setf endpunkt (+ (first zweiter) (second zweiter)))
       ;     (print (list "neuend" endpunkt))
        ;    (print (list "result" result))
         ;   (print  (list "notused" notused))
            )
        (progn () 
         ; (print "++++++")          
         ; (print (list "first zweiter" (first zweiter) "second zweiter" (second zweiter) "endpunkt" endpunkt))          
          (push zweiter notused)
         ; (print (list "result" result))
         ; (print  (list "notused" notused))
          )) )
   ;(values (reverse result) (reverse notused))  ; this syntax is used when more than 1 output is defined
    (list (reverse result) (reverse notused)))
  )

;;;;------------------------------------------------------------------------#| |#
(define-box calculate-rests ((liste nil))
  "calculate durations for rests 
-next noteon minus last note-off"
  :non-generic t
  (let
      ((result nil) (aux0 nil))
    
    (loop for i from 0 to (- (length liste) 2) do           
          (setf onset (first (nth i liste)))                 
          (setf onset-next (first (nth (+ 1 i) liste)))           
          (setf dur (second (nth i liste)))                 
          (setf dur-next (second (nth (+ 1 i) liste))) 
          (setf rest-start (+ onset dur))
          (setf rest-dur (- onset-next rest-start))
         ; (print (list onset onset-next dur dur-next))
          (push (list (list onset dur (third (nth i liste)) (fourth (nth i liste))) (list rest-start (* rest-dur -1))) result)       
                    
          )
    (reverse result)))    
;;;;------------------------------------------------------------------------#| |#
(define-box shift-grace-onsets ((liste nil))
  "shift onset time for grace notes to next note"
  :non-generic t
  (let
      ((result nil) (onset nil))
    (setf liste (reverse liste))
    (setf onset (first (first liste)))
    (push (first liste) result)
    (dolist (partial liste)
      (if (= 0 (second partial))
          (push (list onset 0 (third partial)(fourth partial)) result)
        (progn ()
          (push partial result)
          (setf onset (first partial))
          )
        ))
    result) 
  )                   
                
;;;;------------------------------------------------------------------------#| |#

(define-box make-grace-notes-orig ((liste nil) (midi (60 80)) (grace-dur 0.3) (vel (60 80)) (interval (-5 5)) (max-gracenotes 4))
  ""
  :non-generic t
;  :outputs 2
  (let
      ((result nil)  (notused nil) (liste2 liste) (aux0 nil) (aux2 nil) (aux3 nil) (counter 0) (gracecounter 8) (laststart nil) (endpunkt nil))
 ;   (print (list "liste" liste))
    (pw::dowhile (not result)
      (setf aux0 (posn-match liste counter))        ; search for the first note
    ;  (print (list "result" result))
    ;  (print (list "aux0" aux0))
    ;  (print (list "counter" counter))
      (if (and (> (third aux0) (first midi)) (< (third aux0) (second midi))  ; pitch inside midiinterval
            ;   (> (second aux0) (first dur)) (< (second aux0) (second dur))   ; durations between limits
            ;   (> (fourth aux0) (first vel)) (< (fourth aux0) (second vel))   ; velocities between limits
               )
          (progn ()
       ;     (if (< (second aux0) min-partial-dur) ;if duration of partial shorter than min-partial-dur, then turn it into a grace note
       ;         (setf aux0 (list (first aux0) 0 (third aux0) (fourth aux0))))
            (push aux0 result)
            (pop liste2))
        (progn () 
     ;     (print "++++++")  
          (pop liste2)
      ;    (print (list "liste2" liste2))        
          (push aux0 notused)
       ;   (print (list "notused" notused))
          (setf counter (pw::g+ counter 1))
          )) )
     
    (setf laststart (first (first result))) ;start time of last note in result
    (setf endpunkt (+ (first (first result)) (second (first result)))) ;note-off time of first note for this voice
 


    (dolist (zweiter (rest liste2))
     ; (print (list "third zweiter" (third zweiter) "res" (third (first result)) "first interval" (first interval)))

      (if (<= gracecounter max-gracenotes)  ; as long as we don't have yet too many grace notes in a row
          (print (list "gracecounter" gracecounter))
        (if (and  
             (> (third zweiter) (first midi)) (< (third zweiter) (second midi)) ; pitch inside midiinterval
             (> (first zweiter) endpunkt) (> (+ (first zweiter) (second zweiter)) endpunkt) 
             (> (second zweiter) (first dur)) (< (second zweiter) (second dur))   ; durations between limits
             (> (fourth zweiter) (first vel)) (< (fourth zweiter) (second vel))   ; velocities between limits
             (> (- (third zweiter) (third (first result))) (first interval)) 
             (< (- (third zweiter) (third (first result))) (second interval))   ; interval to previous partial between limits
             )
            (progn ()  

     ;       (< (- (first zweiter) laststart) grace-dur)))   ; if next partial is clother
     ;       (print "-------")
      ;      (print (list "first zweiter + second zweiter" (+ (first zweiter) (second zweiter)) "endpunkt" endpunkt))          
              (push zweiter result)
              (setf endpunkt (+ (first zweiter) (second zweiter)))
       ;     (print (list "neuend" endpunkt))
        ;    (print (list "result" result))
         ;   (print  (list "notused" notused))
              )
          (progn () 
         ; (print "++++++")          
         ; (print (list "first zweiter" (first zweiter) "second zweiter" (second zweiter) "endpunkt" endpunkt))          
            (push zweiter notused)
         ; (print (list "result" result))
         ; (print  (list "notused" notused))
            ))))


   ;(values (reverse result) (reverse notused))  ; this syntax is used when more than 1 output is defined
    (list (reverse result) (reverse notused)))
  )

;;;;------------------------------------------------------------------------#| |#

(define-box make-grace-notes ((liste nil) 
                              (midi (60 80)) 
                              (dur (0.1 2)) 
                              (vel (60 127)) 
                              (interval (-5 5))
                              (grace-midi (70 90)) 
                              (grace-dur 0.3) 
                              (max-gracenotes 7)
                              (min-notes 3)
                              )
  ""
  :non-generic t
;  :outputs 2
  (let
      ((result nil)  (notused nil) (liste2 liste) (aux0 nil) (aux2 nil) (aux3 nil) (counter 0) 
       (gracecounter 0) (notecounter 0) (laststart nil) (endpunkt nil))
    (pw::dowhile (not result)
      (setf aux0 (posn-match liste counter))        ; search for the first note
      (if (and (> (third aux0) (first midi)) (< (third aux0) (second midi))  ; pitch inside midiinterval
            ;   (> (second aux0) (first dur)) (< (second aux0) (second dur))   ; durations between limits
               (> (fourth aux0) (first vel)) (< (fourth aux0) (second vel))   ; velocities between limits
               )
          (progn ()
            (push aux0 result)
            (pop liste2))
        (progn () 
          (pop liste2)
          (push aux0 notused)
          (setf counter (pw::g+ counter 1)))))
     
    (setf laststart (first (first result))) ;start time of last note in result
    (setf endpunkt (+ (first (first result)) (second (first result)))) ;note-off time of first note for this voice
    (setf notecounter (+ 1 notecounter))

    (dolist (zweiter (rest liste2))
     ; (print (list "third zweiter" (third zweiter) "res" (third (first result)) "first interval" (first interval)))
      (print "--------------------------------") 
      (print (list "laststart" laststart))
      (print (list "endpunkt" endpunkt))
      (print (list "zweiter" zweiter))
      (print (list "gracecounter" gracecounter))
      (print (list "notecounter" notecounter))
      (print (list "length result" (length result)))
      (print (list "result" result))

      (if (or (> gracecounter max-gracenotes)  ; if we have already too many grace notes in a row, pick a normal partial
              (< notecounter min-notes))
          (progn ()
            (if (and  
                 (> (third zweiter) (first midi)) (< (third zweiter) (second midi)) ; pitch inside midiinterval
                 (> (first zweiter) endpunkt) ; (> (+ (first zweiter) (second zweiter)) endpunkt) 
                 (> (second zweiter) (first dur)) (< (second zweiter) (second dur))   ; durations between limits
                 (> (fourth zweiter) (first vel)) (< (fourth zweiter) (second vel))   ; velocities between limits
                 (> (- (third zweiter) (third (first result))) (first interval)) 
                 (< (- (third zweiter) (third (first result))) (second interval))   ; interval to previous partial between limits
                 )
                (progn ()  
                  (print "normal upper ------------------------------------------------------------------")
     ;       (print "-------")
      ;      (print (list "first zweiter + second zweiter" (+ (first zweiter) (second zweiter)) "endpunkt" endpunkt))          
                  (push zweiter result)
                  (setf endpunkt (+ (first zweiter) (second zweiter)))
                  (setf laststart (first (first result))) ;start time of last note in result
                  (setf gracecounter 0)
                  (setf notecounter (+ 1 notecounter))
      ;     (print (list "neuend" endpunkt))
        ;    (print (list "result" result))
         ;   (print  (list "notused" notused))
                  )
              (progn () 
                (print "normal lower")
         ; (print "++++++")          
         ; (print (list "first zweiter" (first zweiter) "second zweiter" (second zweiter) "endpunkt" endpunkt))          
                (push zweiter notused)
         ; (print (list "result" result))
         ; (print  (list "notused" notused))
                ))
            )
        (progn ()  ; if we don't have yet too many grace notes
          (if (= gracecounter 0) ; first gracenote after a normal partial should start after the partial
              (progn ()
                (print "in gracecounter = 0")
                (if (and  ;(< (- (first zweiter) laststart) grace-dur)   ; if next partial is closer than grace-dur, make the last note in result a grace note
                     (> (third zweiter) (first midi)) (< (third zweiter) (second midi)) ; pitch inside midiinterval
                     (> (first zweiter) endpunkt) ;(> (+ (first zweiter) (second zweiter)) endpunkt) 
     ;  (> (second zweiter) (first dur)) (< (second zweiter) (second dur))   ; durations between limits
     ;  (> (fourth zweiter) (first vel)) (< (fourth zweiter) (second vel))   ; velocities between limits
     ;  (> (- (third zweiter) (third (first result))) (first interval)) 
     ;  (< (- (third zweiter) (third (first result))) (second interval))   ; interval to previous partial between limits
                     )
                    (progn ()
                      (push zweiter result)
                      (setf gracecounter (+ 1 gracecounter))
                      (setf endpunkt (+ (first zweiter) (second zweiter)))
                      (setf laststart (first (first result))) ;start time of last note in result
                      (if (> gracecounter max-gracenotes)
                          (setf notecounter 0))
                      )
                  (progn () ; else
                    (push zweiter notused)
                    )
                  )
                )
            (progn ()
              (print "drunter")
              (if (< (- (first zweiter) laststart) grace-dur)   ; if next partial is closer than grace-dur, make the last note in result a grace note
                  (progn ()
                    (if  (and (> (third zweiter) (first midi)) (< (third zweiter) (second midi)) ; pitch inside midiinterval
     ;  (> (first zweiter) endpunkt) (> (+ (first zweiter) (second zweiter)) endpunkt) 
     ;  (> (second zweiter) (first dur)) (< (second zweiter) (second dur))   ; durations between limits
     ;  (> (fourth zweiter) (first vel)) (< (fourth zweiter) (second vel))   ; velocities between limits
     ;  (> (- (third zweiter) (third (first result))) (first interval)) 
     ;  (< (- (third zweiter) (third (first result))) (second interval))   ; interval to previous partial between limits
                              )
                        (progn ()
                          (setf aux0 (first result))
                          (setf aux1 (list (first aux0) 0 (third aux0) (fourth aux0)))
                          (pop result)
                          (push aux1 result)
                          (push zweiter result)
                          (setf endpunkt (+ (first zweiter) (second zweiter)))
                          (setf laststart (first (first result))) ;start time of last note in result
                          (setf gracecounter (+ 1 gracecounter))

                          )
                      (progn () ; else
                        (push zweiter notused)
                        )
                      )
                    )
                (progn ()
                  (if  (and (> (third zweiter) (first midi)) (< (third zweiter) (second midi)) ; pitch inside midiinterval
     ;  (> (first zweiter) endpunkt) (> (+ (first zweiter) (second zweiter)) endpunkt) 
     ;  (> (second zweiter) (first dur)) (< (second zweiter) (second dur))   ; durations between limits
     ;  (> (fourth zweiter) (first vel)) (< (fourth zweiter) (second vel))   ; velocities between limits
     ;  (> (- (third zweiter) (third (first result))) (first interval)) 
     ;  (< (- (third zweiter) (third (first result))) (second interval))   ; interval to previous partial between limits
                            )
                      (progn () ; else
  ;                (push zweiter notused)
                        (push zweiter result) 
                        (setf endpunkt (+ (first zweiter) (second zweiter)))
                        (setf laststart (first (first result))) ;start time of last note in result
                        (setf notecounter (+ 1 notecounter))
                        (setf gracecounter 0)
                        )
                    (progn () ; else
                      (push zweiter notused)
                      )
                    )
                  ))
              )))))


   ;(values (reverse result) (reverse notused))  ; this syntax is used when more than 1 output is defined
    (list (reverse result) (reverse notused)))
  )







;;;;------------------------------------------------------------------------#| |#


(define-box make-grace-notes3 ((liste nil) 
                               (midi (60 80)) 
                               (dur (0.1 2)) 
                               (vel (60 127)) 
                               (interval (-5 5))
                               (grace-midi (70 90)) 
                               (grace-dur 0.3) 
                               (max-gracenotes 7)
                               (min-notes 3)
                               (printvar 1)
                              ; (approx 8)  (pw::approx-midi)
                               )
  ""
  :non-generic t
;  :outputs 2
  (let
      ((result nil)  (notused nil) (liste2 liste) (aux0 nil) (aux2 nil) (aux3 nil) (counter 0) 
       (gracecounter 0) (notecounter 0) (laststart nil) (endpunkt nil))
    (pw::dowhile (not result)
      (setf aux0 (posn-match liste counter))        ; search for the first note
      (if (and (>= (third aux0) (first midi)) (<= (third aux0) (second midi))  ; pitch inside midiinterval
               (>= (second aux0) (first dur)) (<= (second aux0) (second dur))   ; durations between limits
               (>= (fourth aux0) (first vel)) (<= (fourth aux0) (second vel))   ; velocities between limits
               )
          (progn ()
            (push aux0 result)
            (pop liste2))
        (progn () 
          (pop liste2)
          (push aux0 notused)
          (setf counter (pw::g+ counter 1)))))
     
    (setf laststart (first (first result))) ;start time of last note in result
    (setf endpunkt (+ (first (first result)) (second (first result)))) ;note-off time of first note for this voice
    (setf notecounter (+ 1 notecounter))

 
    (loop for i from 0 to (- (length liste2) 2) do          ;read through the list
                                                             
          (setf erster (nth i liste2))                 ; index of partial1 of actual frame
          (setf zweiter  (nth (+ 1 i) liste2))
          (if (= 1 printvar)
              (progn ()
                (print "--------------------------------") 
                (print (list "i" i))
                (print (list "laststart" laststart))
                (print (list "endpunkt" endpunkt))
                (print (list "erster" erster))
                (print (list "zweiter" zweiter))
                (print (list "gracecounter" gracecounter))
                (print (list "notecounter" notecounter))
                (print (list "length result" (length result)))
                (print (list "result" result))
                (print (list "midi" midi))
                (print (list "grace-midi" grace-midi))
                ))


          (if (<= notecounter min-notes)      ; if we don't have yet enough normal notes
              (progn ()
                (if (and  
                     (>= (third erster) (first midi)) (<= (third erster) (second midi)) ; pitch inside midiinterval
                     (> (first erster) endpunkt) ; (> (+ (first zweiter) (second zweiter)) endpunkt) 
                     (>= (second erster) (first dur)) (<= (second erster) (second dur))   ; durations between limits
                     (>= (fourth erster) (first vel)) (<= (fourth erster) (second vel))   ; velocities between limits
                     (>= (- (third erster) (third (first result))) (first interval)) 
                     (<= (- (third erster) (third (first result))) (second interval))   ; interval to previous partial between limits
                     )
                    (progn ()  
                      (if (= 1 printvar)
                          (print "(<= notecounter min-notes) ----------NNNNNNNNNNNNNNNNNNNNNNNNNNNNN")
                        )
                      (push erster result)
                      (setf endpunkt (+ (first erster) (second erster)))
                      (setf laststart (first (first result))) ;start time of last note in result
                      (setf gracecounter 0)
                      (setf notecounter (+ 1 notecounter))
                      )
                  (progn ()
                    (if (= 1 printvar)
                        (print "(<= notecounter min-notes) push ------------------------NOTUSED")
                      )
                    (push erster notused)
                    ))
                )
            (progn () ; if we have enough normal notes
              (if (= 1 printvar)
                  (print "hhhhhhhhhhhhhhhh enough notes")
                )
              (if (and (< (- (first zweiter) (first erster)) grace-dur)   ;if distance between next two notes is smaller than grace-dur
                       (> (first erster) endpunkt)                        ;and onset of erster is after endpunkt 
                       (< gracecounter max-gracenotes)
                       )
                  (if (and  
                       (>= (third erster) (first grace-midi)) (<= (third erster) (second grace-midi)) ; if pitch inside grace-midiinterval
                       )
                      (progn ()
                        (push (list (first erster) 0 (third erster) (fourth erster)) result) ; make gracenote from erster
                        (setf gracecounter (+ 1 gracecounter))
                        (if (>= gracecounter  max-gracenotes)
                            (setf notecounter 0))
                        )
                    (progn ()
                      (push erster notused)
                      )
                    )
                (progn ()  ;if distance between next two notes is NOT smaller than grace-dur
                           ; or if we have already enough grace notes, make normal note
                  (if (and  
                       (>= (third erster) (first midi)) (<= (third erster) (second midi)) ; pitch inside midiinterval
                       (> (first erster) endpunkt) ; (> (+ (first zweiter) (second zweiter)) endpunkt) 
                       (>= (second erster) (first dur)) (<= (second erster) (second dur))   ; durations between limits
                       (>= (fourth erster) (first vel)) (<= (fourth erster) (second vel))   ; velocities between limits
                       (>= (- (third erster) (third (first result))) (first interval)) 
                       (<= (- (third erster) (third (first result))) (second interval))   ; interval to previous partial between limits
                       )
                      (progn ()  
                        (if (= 1 printvar)
                            (print "enough notes but normal")
                          )
                        (push erster result)
                        (setf endpunkt (+ (first erster) (second erster)))
                        (setf laststart (first (first result))) ;start time of last note in result
                        (setf gracecounter 0)
                        (if (> notecounter min-notes)
                            (setf notecounter 0))
                        (setf notecounter (+ 1 notecounter))
                        )
                    (progn () 
                      (if (= 1 printvar)
                          (print "enough notes --------------------NOTUSED")
                        )
                      (push erster notused)
                      )))))))
   ;(values (reverse result) (reverse notused))  ; this syntax is used when more than 1 output is defined
    (list (reverse result) (reverse notused)))
  )


;;;;------------------------------------------------------------------------#| |#

#|


(defun ht-group-notes-recursion (notes actual-chord chords)
  (cond  ;cond nimmt die erste wahre Kondition in der folgenden Liste
   ((null notes) ; pruefen, ob unsere Notenliste leer ist - womit wir am Ende angelangt waeren
    (nreverse (cons actual-chord chords)))   ; letzer Akkord zum Ergebnis zufuegen und Ergebnisliste reverse  (cons fuegt element vor die Liste ein)
   ((null actual-chord) ; wenn der aktuelle Akkord leer ist, wird die aktuelle Note direkt in den neuen Akkord hereingenommen
    (ht-group-notes-recursion (rest notes)
                              (cons (first notes) actual-chord)
                              chords))
   ((= (first (first notes)) ; wenn neue onset time der neuen Note gleich ist
       (first (first actual-chord)))
    (ht-group-notes-recursion (rest notes) ;fuege aktuelle Note zum aktuellen Chord hinzu
                              (cons (first notes) actual-chord)
                              chords))
   (t ;dies ist wahr, wenn die neue Note nicht gleichzeitig mit dem bisher aufgebauten Akkord anfaengt
    (ht-group-notes-recursion notes  ; da die Note jetzt nicht gleich dem akkord ist und wir mit diesem Aufruf nur den Vergleich anstellen, wurde sie
                                      ;ja noch nicht verarbeitet, deshalb duerfen wir hier die Notenliste nicht verkuerzen
                              nil  ; actual chord wird geloescht, um beim naechsten Aufruf der Rekursion einen leeren aktuellen Akkord zu beginnen
                              (cons (nreverse actual-chord) chords)) ; der bisherige Akkord (von tief nach hoch sortier) wird zur Ergebnisliste hinzugefuegt
    )))
|#