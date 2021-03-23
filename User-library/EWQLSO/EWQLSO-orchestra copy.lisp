(in-package :ccl)

;********************************************************************************
; PLAYER
;********************************************************************************

(defclass mpk-player (midi-play-device) ())

(add-play-device 'mpk-player "mpk-player")

(defmethod calc-dynamics-value-list ((output T) (ins T) note (exp (eql :crescendo)))
  (list (case (initial-dynamics (e note exp)) (:ppp 10)(:pp 30)(:p 50)(:mp 70) (:f 90)(:ff 110)(:fff 127) (T 60))
        (case (end-dynamics (e note exp)) (:ppp 10)(:pp 30)(:p 50)(:mp 70) (:f 90)(:ff 110)(:fff 127) (T 100))))

(defmethod calc-dynamics-value-list ((output T) (ins T) note (exp (eql :diminuendo)))
  (list (case (initial-dynamics (e note exp)) (:ppp 10)(:pp 30)(:p 50)(:mp 70) (:f 90)(:ff 110)(:fff 127) (T 100))
        (case (end-dynamics (e note exp)) (:ppp 10)(:pp 30)(:p 50)(:mp 70) (:f 90)(:ff 110)(:fff 127) (T 60))))

;;
;; problems here: the order of the expressions!!
;;

(defun sort-nkis-for-playback(instrument expressions)
  (when expressions
    (let ((nkis (iter (for expression in expressions)
                  (typecase expression
                    (muta-in ())
                    (T (when-let (nki (nki instrument t expression))
                         (collect nki)))))))
      (sort (remove-duplicates nkis :test #'eq)
            '>
            :key #'(lambda(x) (let ((namestring (pathname-directory x)))
                                (cond
                                 ((member "1 Long" namestring :test #'equalp) -1)
                                 (T 0))))))))

(defun most-significant-nki-for-playback(instrument expression)
  (car (print (sort-nkis-for-playback instrument expression))))

(defmethod prepare-Midi-play*((output mpk-player) score)
  "For mpk-player the setup method looks through the score and loads all the necessary samples"
  (with-message-dialog "Loading nki's"
    (dolist (part (parts score))
      (dolist (voice (voice-list part))
        (dolist (note (collect-enp-objects voice :note))
          (unless (rest-p note)
            (let ((default-instrument (read-key note :current-instrument))
                  current-instrument)
              (write-key note :mpk-chan (load-nki-instrument (nki default-instrument t t)))
              ;(format t "~%~%The default instrument is ~a :chan ~a~%" default-instrument (load-nki-instrument (nki default-instrument t t)))
              (let ((muta-in (expression? note :muta-in)))
                (when muta-in
                  (setq current-instrument (find-instrument (instrument muta-in)))
                  ;(format t "muta in ~a  :chan ~a~%" current-instrument (load-nki-instrument (nki current-instrument t t)))
                  (write-key note :mpk-chan (load-nki-instrument (nki current-instrument t t))))
                (let ((expressions (append (expressions (super-notation-object note)) (expressions note))))
                  (when-let (nki (most-significant-nki-for-playback (if muta-in current-instrument default-instrument) expressions))
                    (when-let (chan (load-nki-instrument nki))
                      ;(format t "expression instrument :chan ~a~%" chan)
                      (write-key note :mpk-chan chan))))) (terpri) (terpri))))))
    (redraw score)))

(defmethod calc-play-chan/midi* ((output mpk-player) (self note))
  (values (or (read-key self :mpk-chan) (chan self)) (midi self)))

(defmethod setup-Midi-play*((output mpk-player) score) ())

;********************************************************************************
; draw-note plug-in
;********************************************************************************

(defadvice ((METHOD DRAW-NOTE :AFTER (NOTE T T T T T))
            after-draw-note :after)
    (self kind x Staff-Position clef note-head &optional extra-symbols)
  (unless (rest-p self)
    (let ((chan (read-key self :mpk-chan)))
      (un-selectable
          (with-GL-color (if chan :blue :red)
            (txprint self (+ (x self) 1.1) (y self) 0.0 0.06 0.0 :times (format () "~a" (or chan "x")) t))))))

;(lw-tools::generic-function-method-dspecs #'draw-note)

;********************************************************************************

(DEFMETHOD NKI ((SELF INSTRUMENT) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Wood/F Steinway B.nki"))

(DEFMETHOD NKI ((SELF VIBRAPHONE) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Metals/F Vibes.nki"))

(DEFMETHOD NKI ((SELF OBOE) (TYPE T) (EXPRESSION T)) (values #P"Woodwinds/Solo Oboe/1 Long/F SOB Sus Vib.nki"))

(DEFMETHOD NKI ((SELF BASSOON) (TYPE T) (EXPRESSION T)) (values #P"Woodwinds/Solo Bassoon/1 Long/F BSN Sus Vib.nki"))

(DEFMETHOD NKI ((SELF HARP) (TYPE T) (EXPRESSION T)) (values #P"Strings/Harp/1 Long/F Harp Pluck long.nki"))

(DEFMETHOD NKI ((SELF XYLOPHONE) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Wood/F Xylophone.nki"))

(DEFMETHOD NKI ((SELF CASTANETS) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Wood/F Castanets.nki"))

(DEFMETHOD NKI ((SELF FRENCH-HORN) (TYPE T) (EXPRESSION T)) (values #P"Brass/Solo French Horn/1 Long/F SFH Sus.nki"))

(DEFMETHOD NKI ((SELF GLOCKENSPIEL) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Metals/F Glock.nki"))

(DEFMETHOD NKI ((SELF ALTO-FLUTE) (TYPE T) (EXPRESSION T)) (values #P"Woodwinds/Solo Alto Flute/1 Long/F AFL Sus Vib.nki"))

(DEFMETHOD NKI ((SELF TIMPANI) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Drums/F Timp Hits LR.nki"))

(DEFMETHOD NKI ((SELF SPLASH-CYMBAL) (TYPE T) (EXPRESSION T)) (values #P"Percussion/CymGong/F 20 Cymbal.nki"))

(DEFMETHOD NKI ((SELF FLUTE) (TYPE T) (EXPRESSION T)) (values #P"Woodwinds/Solo Flute/1 Long/F SFL Sus Vib.nki"))

(DEFMETHOD NKI ((SELF TUBA) (TYPE T) (EXPRESSION T)) (values #P"Brass/Solo Tuba/1 Long/F STU Sus.nki"))

(DEFMETHOD NKI ((SELF TAMBOURINE) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Wood/F Tambourine.nki"))

(DEFMETHOD NKI ((SELF BASS-CLARINET) (TYPE T) (EXPRESSION T)) (values #P"Woodwinds/Solo Bass Clarinet/1 Long/F BCL Sus.nki"))

(DEFMETHOD NKI ((SELF GUIRO) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Wood/F Guiro RR.nki"))

(DEFMETHOD NKI ((SELF WOOD-BLOCK) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Wood/F Woodblock symphony.nki"))

(DEFMETHOD NKI ((SELF PICCOLO) (TYPE T) (EXPRESSION T)) (values #P"Woodwinds/Solo Piccolo Flute/1 Long/S Pfl Sus Vib.nki"))

(DEFMETHOD NKI ((SELF SNARE-DRUM) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Drums/F 3 Snares.nki"))

(DEFMETHOD NKI ((SELF CROTALES) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Metals/F Crotales.nki"))

(DEFMETHOD NKI ((SELF BASS-DRUM) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Drums/F Bass Drum Concert.nki"))

(DEFMETHOD NKI ((SELF PIANO) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Wood/F Steinway B.nki"))

(DEFMETHOD NKI ((SELF TRUMPET) (TYPE T) (EXPRESSION T)) (values #P"Brass/Solo Trumpet 1/1 Long/F STP Sus.nki"))

(DEFMETHOD NKI ((SELF TAM-TAM) (TYPE T) (EXPRESSION T)) (values #P"Percussion/CymGong/F 37 Chinese Tam Tam.nki"))

(DEFMETHOD NKI ((SELF TUBULAR-BELLS) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Metals/F Orch chimes.nki"))

(DEFMETHOD NKI ((SELF CLARINET) (TYPE T) (EXPRESSION T)) (values #P"Woodwinds/Solo Clarinet/1 Long/F SCL Non Vib.nki"))

(DEFMETHOD NKI ((SELF TENOR-DRUM) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Drums/F Field Funeral Tenor.nki"))

(DEFMETHOD NKI ((SELF HARPSICHORD) (TYPE T) (EXPRESSION T)) (values #P"Strings/Harpsichord/1 Long/F Harpsichord.nki"))

(DEFMETHOD NKI ((SELF TOM-TOMS) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Drums/F 5 Concert Toms.nki"))

(DEFMETHOD NKI ((SELF TROMBONE) (TYPE T) (EXPRESSION T)) (values #P"Brass/Solo Trombone/1 Long/F STB Sus.nki"))

(DEFMETHOD NKI ((SELF CELESTA) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Metals/F Celesta.nki"))

(DEFMETHOD NKI ((SELF CONTRABASSOON) (TYPE T) (EXPRESSION T)) (values #P"Woodwinds/Solo Contrabasson/1 Long/F CTB Sus.nki"))

(DEFMETHOD NKI ((SELF ENGLISH-HORN) (TYPE T) (EXPRESSION T)) (values #P"Woodwinds/Solo English Horn 2/1 Long/F EH2 Sus.nki"))

(DEFMETHOD NKI ((SELF MARIMBA) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Wood/F Marimba.nki"))

(DEFMETHOD NKI ((SELF TRIANGLE) (TYPE T) (EXPRESSION T)) (values #P"Percussion/Metals/F Triangle.nki"))

(DEFMETHOD NKI ((SELF VIOLA-D-AMORE) (TYPE T) (EXPRESSION T)) (values #P"Strings/Solo Viola/1 Long/F SVA Sus Vib.nki"))



(DEFMETHOD NKI ((SELF VIOLONCELLO) (TYPE T) (EXPRESSION T)) 
  (values #P"Strings/Solo Cello/1 Long/F SVC Sus Vib Smooth.nki") 
  (values #P"Strings/10 Cellos/1 Long/F VCS Non Vib.nki"))

(DEFMETHOD NKI ((SELF VIOLA) (TYPE T) (EXPRESSION T)) 
  (values #P"Strings/Solo Viola/1 Long/F SVA Sus Vib.nki") 
  (values #P"Strings/10 Violas/1 Long/F VAS Sus.nki"))

(DEFMETHOD NKI ((SELF VIOLIN) (TYPE T) (EXPRESSION T))
 (values #P"Strings/Solo Violin/1 Long/F SVL Sus Vib Soft.nki")
 (values #P"Strings/18 Violins/1 Long/F 18V Non Vib.nki"))

(DEFMETHOD NKI ((SELF CONTRABASS) (TYPE T) (EXPRESSION T)) 
  (values #P"Strings/Solo Contrabass/1 Long/F SCB Sus Vib.nki")
  (values #P"Strings/9 Double Basses/1 Long/F CBS Big Sus.nki"))







;(DEFMETHOD NKI ((SELF VIOLONCELLO) (TYPE T) (EXPRESSION PIZZICATO)) (values #p"Strings/Solo Cello/2 Short/F SVC Pizz.nki"))
;(DEFMETHOD NKI ((SELF VIOLONCELLO) (TYPE T) (EXPRESSION COL-LEGNO)) (values #p"Strings/Solo Cello/2 Short/F SVC Col Legno.nki"))
;(DEFMETHOD NKI ((SELF VIOLIN) (TYPE T) (EXPRESSION PIZZICATO)) (values #p"Strings/Solo Violin/2 Short/F SVL Pizz.nki"))

#|
(DEFMETHOD NKI ((SELF FINGER-CYMBALS) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF POLICE-WHISTLE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF ALTO) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF GUITAR) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF CONGA) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF LUTE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF BASS) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF ELECTRIC-BASS) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF MANDOLIN) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF MARCHING-MACHINE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF BASS-FLUTE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF CONTRABASS-CLARINET) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF DRUMS) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF COWBELL) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF JEWS-HARP) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF BONGO-DRUMS) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF SYNTH-INSTRUMENT) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF TENOR) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF FLEX-A-TONE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF CLAVES) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF AGOGO-BELLS) (TYPE T) (EXPRESSION T)) ()
(DEFMETHOD NKI ((SELF ANTIQUE-CYMBALS) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF BOAT-WHISTLE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF BARITONE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF VIBRA-SLAP) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF VIOLA-DA-GAMBA) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF MARACAS) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF CONTRABASS-SAXOPHONE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF BIRD-WHISTLE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF TRAIN-WHISTLE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF CABASA) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF CORNET) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF RIDE-CYMBAL) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF SIREN) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF THUNDER-MACHINE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF BASS-SAXOPHONE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF TEMPLE-BLOCKS) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF BARITONE-SAXOPHONE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF MARK-TREE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF SLEIGH-BELLS) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF SOPRANO) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF TENOR-SAXOPHONE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF SIZZLE-CYMBAL) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF SLAPSTICK) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF ALTO-SAXOPHONE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF SUSPENDED-CYMBAL) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF HI-HAT) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF SANDPAPER-BLOCKS) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF SOPRANO-SAXOPHONE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF KICK-DRUM) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF GONG) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF MEZZO-SOPRANO) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF RATTLE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF FLUGELHORN) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF SOPRANINO-SAXOPHONE) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF PICCOLO-CLARINET) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF CRASH-CYMBALS) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF TIMBALES) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF RATCHET) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF SCRAPER) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF KEYBOARDS) (TYPE T) (EXPRESSION T)) ())
(DEFMETHOD NKI ((SELF ORGAN) (TYPE T) (EXPRESSION T)) ())
|#

#|
Brass/Solo Piccolo Trumpet/1 Long/F PTP Sus.nki

Strings/11 Violins/1 Long/F 11V Sus Vib.nki
Strings/10 Violas/1 Long/F VAS Sus.nki
Strings/10 Cellos/1 Long/F VCS Sus Vib.nki
Strings/9 Double Basses/1 Long/F Cbs Sus Vib.nki

Percussion/Wood/F Wind Machine.nki
Percussion/Wood/F Washboard RR.nki
Percussion/Wood/F Various Perc.nki
Percussion/Wood/F Tiny Puilli Sticks.nki

Percussion/Wood/F Tambourine 2.nki
Percussion/Wood/F Steinway B.nki
Percussion/Wood/F Puilli Sticks.nki
Percussion/Wood/F Slap Sticks.nki

Percussion/Wood/F All Sticks.nki
Percussion/Metals/F All Anvils.nki

Percussion/Metals/F Glock Mellow.nki
Percussion/Metals/F Triangle.nki
Percussion/Metals/F Triangle 2.nki
Percussion/Metals/F Bowed Crotales.nki
Percussion/Metals/F Artillery Shells.nki
Percussion/Metals/F Huge Anvils.nki
Percussion/Metals/F Hall Noise.nki
Percussion/Metals/F Waterphone.nki
Percussion/Metals/F Sleigh Bells RR.nki
Percussion/Metals/F Orch chimes.nki
Percussion/Metals/F Various Metals.nki
Percussion/Metals/F Anvil.nki
Percussion/Metals/F Anvil Low.nki

Percussion/Metals/F Celesta.nki
Percussion/Metals/F Steel Plates.nki
Percussion/Drums/F Snare Ens Small.nki
Percussion/Drums/S Bass Drum Wagner.nki
Percussion/Drums/F Timp Sft Mlt Hits LR.nki

Percussion/Drums/F Taiko Drums.nki
Percussion/Drums/F Timp Crec S.nki
Percussion/Drums/F Timp Roll DXF Mod.nki
Percussion/Drums/F 3 Snares DXF Rolls.nki
Percussion/Drums/F 5 Concert Toms.nki
Percussion/Drums/F Bass Drum Wagner.nki
Percussion/Drums/F Mahler Hammer.nki
Percussion/Drums/F Timp Crec L.nki
Percussion/Drums/F Field Funeral Tenor.nki
Percussion/Drums/F Snare Ens Large.nki

Percussion/Drums/F Timp Roll DXF Mod Hits.nki
Percussion/Drums/F Field Ens.nki

Percussion/Drums/F Roto Toms RR.nki
Percussion/CymGong/F 28 Gong.nki
Percussion/CymGong/F 60 Gong 2.nki
Percussion/CymGong/F 16 German cymbal.nki
Percussion/CymGong/F 12 Cymbal.nki
Percussion/CymGong/F 18 Cymbal.nki
Percussion/CymGong/F 18 Viennese Cymbal.nki
Percussion/CymGong/F 48 Gong.nki
Percussion/CymGong/F 18 Zildjan Roll DXF MOD.nki
Percussion/CymGong/F All Cymbals.nki
Percussion/CymGong/F 18 German Cymbal.nki
Percussion/CymGong/F All Gongs.nki
Percussion/CymGong/F 26 Zildjan Roll DXF MOD.nki
Percussion/CymGong/F 26 Zildjan Crash.nki
Percussion/CymGong/F 20 Cymbal.nki
Percussion/CymGong/F 22 Cymbal.nki
Percussion/CymGong/F 37 Chinese Tam Tam.nki
Percussion/CymGong/F 23 Gong.nki
Percussion/CymGong/F 12 Band Cymbal.nki
Percussion/CymGong/F 19 French Cymbal.nki
Percussion/CymGong/F 60 Gong.nki
Percussion/CymGong/F 21 French Cymbal.nki
Percussion/CymGong/F 20 French Cymbal.nki
|#