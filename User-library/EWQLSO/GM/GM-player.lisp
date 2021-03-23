(in-package :ccl)

;;;(defclass GM-player (QT-play-device) ())
(defclass GM-player (play-device::midi-play-device) ()) ;;; to test a soft soundfont synth via IAC ???!!

(defvar *GM-setup* (make-array 128))

(defun reset-GM-setup()
  "Clears the instrument cache"
  (iter (for i below 64)
    (setf (aref *GM-setup* i) ())))

;; (reset-GM-setup)

(add-playback-device 'GM-player "GM-player")

(defmethod change-GM-instrument((intrument number) &optional (channels :all))
  (let ((all-channels (case channels
                        (:all (loop for x from 1 repeat 128 collect x))
                        (T (list! channels)))))
    (loop for c in all-channels
          do
          (if *useQTmidi?*
              (setQTinstrument c (1+ intrument))
            (send-midi-cc-event *current-midi-device* (list :controller #xC0 :chan (1- c) :bus (midi-play-bus (1- c)) :data intrument))))))

(defmethod change-GM-instrument((intrument string) &optional (channels :all))
  (when-let (i (position intrument *GM-instrument-list* :test #'(lambda (a b) (string= (string-downcase a) (string-downcase b)))))
    (change-GM-instrument i channels)))

(defmethod load-GM-instrument(gm-patch)
  (or (position gm-patch *GM-setup* :test #'equalp)
      (let ((next-vacant-slot (or (getf gm-patch :channel) (position NIL *GM-setup*))))
        (if next-vacant-slot
            (progn
              (format () "Loading ~a" gm-patch) 
              (setf (elt *GM-setup* next-vacant-slot) gm-patch)
              (when-let (instrument (getf gm-patch :patch))
                (change-GM-instrument instrument next-vacant-slot))
              next-vacant-slot)
          (error "The current configuration exceeds the 128 slots available.")))))

(defmethod play-device::prepare-playback*((output GM-player) score)
  "For GM-player the setup method looks through the score and loads all the necessary samples"
  (with-message-dialog "Loading GM's"
    (dolist (part (parts score))
      (dolist (voice (voice-list part))
        (dolist (note (collect-enp-objects voice :note))
          (unless (rest-p note)
            (let ((default-instrument (read-key note :current-instrument))
                  current-instrument)
              (write-key note :mpk-chan (load-GM-instrument (gm-patch default-instrument t)))
              ;(format t "~%~%The default instrument is ~a :chan ~a~%" default-instrument (load-nki-instrument (nki default-instrument t t)))
              (let ((muta-in (expression? note :muta-in)))
                (when muta-in
                  (setq current-instrument (find-instrument (instrument muta-in)))
                  ;(format t "muta in ~a  :chan ~a~%" current-instrument (load-nki-instrument (nki current-instrument t t)))
                  (write-key note :mpk-chan (load-GM-instrument (gm-patch current-instrument t))))
                (let ((expressions (find-all-if #'gm-expression-p (append (expressions (super-notation-object note)) (expressions note)))))
                  (dolist (expression expressions)
                    (when-let (gm-patch (gm-patch (if muta-in current-instrument default-instrument) expression))
                      (when-let (chan (load-GM-instrument gm-patch))
                      ;(format t "expression instrument :chan ~a~%" chan)
                        (write-key note :mpk-chan chan)))))))))))
    (redraw score)))

(defmethod gm-expression-p ((self t))
  ())

(defmethod gm-expression-p ((self tremolo))
  self)

(defmethod gm-expression-p ((self pizzicato))
  self)

;;;

(defmethod play-device::calc-playback-chan/midi* ((output GM-player) (self note))
  (values (or (read-key self :mpk-chan) (chan self)) (or (read-key self :mpk-midi) (midi self))))

(defmethod play-device::setup-playback*((output GM-player) score) ())

;;;

(defun GM-player-browser-items()
  (loop for x across *GM-setup*
        for i from 1
        collect (list i (if x (getf x :patch) "-"))))

(capi::define-interface GM-player-browser()
  ()
  (:panes
   (navigator-pane capi:multi-column-list-panel
                   :items (GM-player-browser-items)
                   :visible-min-width 400
                   :visible-min-height 500
                   :columns '((:title "Chan" :visible-min-width 32) (:title "Default Sample")))
   (reset-button capi::push-button :text "Reset" :callback #'(lambda(item interface)
                                                               (reset-GM-setup)
                                                               (with-slots (navigator-pane) interface
                                                                 (setf (capi:collection-items navigator-pane) (GM-player-browser-items))))))
  (:default-initargs
   :title "GM player"
   :activate-callback #'(lambda(interface status) (with-slots (navigator-pane) interface
                                                    (setf (capi:collection-items navigator-pane) (GM-player-browser-items))))))

;(capi:find-interface 'GM-player-browser)

;;;

;;; (defmethod setup-Midi-play*((output GM-player) score) ())

;;;

(defmethod gm-patch((self CONGA) (expression t))
  ;("Mute Hi Conga" 62) ("Open Hi Conga" 63) ("Low Conga" 64) 
  '(:channel 10 :pitch 62))

(defmethod gm-patch((self TIMPANI) (expression t))
  ;"Timpani" 
  '(:patch "Timpani"))

(defmethod gm-patch((self HARP) (expression t))
  ;"Harpsichord"  
  '(:patch "Orchestral_Harp"))

(defmethod gm-patch((self ALTO) (expression t))
  ;"Alto Sax" 
  '(:patch "Choir_Aahs"))

(defmethod gm-patch((self BIRD-WHISTLE) (expression t))
  ;"Whistle" 
  '(:patch "Whistle"))

(defmethod gm-patch((self FRENCH-HORN) (expression t))
  ;"French Horn" 
  '(:patch "French_Horn"))

(defmethod gm-patch((self RATCHET) (expression t))
  ;
  '(:channel 10 :pitch 0))

(defmethod gm-patch((self TENOR-SAXOPHONE) (expression t))
  ;"Tenor Sax" 
  '(:patch "Tenor_Sax"))

(defmethod gm-patch((self GLOCKENSPIEL) (expression t))
  ;"Glockenspiel" 
  '(:patch "Glockenspiel"))

(defmethod gm-patch((self CRASH-CYMBALS) (expression t))
  ;
  '(:channel 10 :pitch 49))

(defmethod gm-patch((self TUBULAR-BELLS) (expression t))
  ;"Tubular Bells" 
  '(:patch "Tubular_Bells"))

(defmethod gm-patch((self SIZZLE-CYMBAL) (expression t))
  ;
  '(:channel 10 :pitch 57))

(defmethod gm-patch((self RIDE-CYMBAL) (expression t))
  ;("Ride Cymbal 2" 59) ("Ride Cymbal 1" 51) 
  '(:channel 10 :pitch 59))

(defmethod gm-patch((self THUNDER-MACHINE) (expression t))
  ;
  '(:channel 10 :pitch 0))

(defmethod gm-patch((self XYLOPHONE) (expression t))
  ;"Xylophone" 
  '(:patch "Xylophone"))

(defmethod gm-patch((self BARITONE-SAXOPHONE) (expression t))
  ;"Baritone Sax" 
  '(:patch "Baritone_Sax"))

(defmethod gm-patch((self MANDOLIN) (expression t))
  ;
  '(::patch "Acoustic_Guitar_steel"))

(defmethod gm-patch((self CABASA) (expression t))
  ;("Cabasa" 69) 
  '(:channel 10 :pitch 69))

(defmethod gm-patch((self BASS-DRUM) (expression t))
  ;("Acoustic Bass Drum" 35) ("Bass Drum 1" 36) 
  '(:channel 10 :pitch 35))


(defmethod gm-patch((self CASTANETS) (expression t))
  ;
  '(:channel 10 :pitch 0))

(defmethod gm-patch((self POLICE-WHISTLE) (expression t))
  ;"Whistle" 
  '(:patch "Whistle"))

(defmethod gm-patch((self VIBRAPHONE) (expression t))
  ;"Vibraphone" 
  '(:patch "Vibraphone"))

(defmethod gm-patch((self SIREN) (expression t))
  ;
  '(:channel 10 :pitch 0))

(defmethod gm-patch((self GUITAR) (expression t))
  ;"Acoustic Guitar nylon" "Acoustic Guitar steel" "Electric Guitar jazz" "Electric Guitar clean" "Electric Guitar muted" "Overdriven Guitar" "Distortion Guitar" "Guitar harmonics" "Guitar Fret Noise" 
  '(:patch "Acoustic_Guitar_nylon"))

(defmethod gm-patch((self MARACAS) (expression t))
  ;("Maracas" 70) 
  '(:channel 10 :pitch 70))

(defmethod gm-patch((self BASS-SAXOPHONE) (expression t))
  ;
  '(:patch "Baritone_Sax"))

(defmethod gm-patch((self TENOR) (expression t))
  ;"Tenor Sax" 
  '(:patch "Choir_Aahs"))

(defmethod gm-patch((self MARIMBA) (expression t))
  ;"Marimba" 
  '(:patch "Marimba"))

(defmethod gm-patch((self TEMPLE-BLOCKS) (expression t))
  ;
  '(:patch "Woodblock"))

(defmethod gm-patch((self TRUMPET-IN-EB) (expression t))
  ;"Trumpet" "Muted Trumpet" 
  '(:patch "Trumpet"))

(defmethod gm-patch((self ANTIQUE-CYMBALS) (expression t))
  ;
  '(:patch "Tubular_Bells"))

(defmethod gm-patch((self FLUGELHORN) (expression t))
  ;
  '(:patch "Trumpet"))

(defmethod gm-patch((self CONTRABASS-SAXOPHONE) (expression t))
  ;"Contrabass" 
  '(:patch "Baritone_Sax"))

(defmethod gm-patch((self SNARE-DRUM) (expression t))
  ;
  '(:channel 10 :pitch 38))

(defmethod gm-patch((self HI-HAT) (expression t))
  ;("Pedal Hi-Hat" 44) ("Open Hi-Hat" 46) 
  '(:channel 10 :pitch 44))

(defmethod gm-patch((self CLARINET-IN-EB) (expression t))
  ;"Clarinet" 
  '(:patch "Clarinet"))

(defmethod gm-patch((self BASS-CLARINET-IN-A) (expression t))
  ;"Clarinet" 
  '(:patch "Clarinet"))

(defmethod gm-patch((self TOM-TOMS) (expression t))
  ;
  '(:patch "Melodic_Tom"))

(defmethod gm-patch((self MARCHING-MACHINE) (expression t))
  ;
  '(:channel 10 :pitch 0))

(defmethod gm-patch((self GUIRO) (expression t))
  ;("Short Guiro" 73) ("Long Guiro" 74) 
  '(:channel 10 :pitch 73))

(defmethod gm-patch((self TAMBOURINE) (expression t))
  ;("Tambourine" 54) 
  '(:channel 10 :pitch 54))

(defmethod gm-patch((self MEZZO-SOPRANO) (expression t))
  ;
  '(:patch "Choir_Aahs"))

(defmethod gm-patch((self LUTE) (expression t))
  ;
  '(:patch "Acoustic_Guitar_nylon"))

(defmethod gm-patch((self BONGO-DRUMS) (expression t))
  ;
  '(:channel 10 :pitch 61))

(defmethod gm-patch((self VIOLONCELLO) (expression t))
  ;
  '(:patch "Cello"))

(defmethod gm-patch((self VIOLONCELLO) (expression tremolo))
  ;"Violin" 
  '(:patch "Tremolo_Strings"))

(defmethod gm-patch((self VIOLONCELLO) (expression pizzicato))
  ;"Violin" 
  '(:patch "Pizzicato_Strings"))

(defmethod gm-patch((self CELESTA) (expression t))
  ;"Celesta" 
  '(:patch "Celesta"))

(defmethod gm-patch((self CLAVES) (expression t))
  ;("Claves" 75) 
  '(:channel 10 :pitch 75))

(defmethod gm-patch((self SPLASH-CYMBAL) (expression t))
  ;("Splash Cymbal" 55) 
  '(:channel 10 :pitch 55))

(defmethod gm-patch((self KICK-DRUM) (expression t))
  ;
  '(:channel 10 :pitch 36))

(defmethod gm-patch((self TRUMPET-IN-BB) (expression t))
  ;"Trumpet" "Muted Trumpet" 
  '(:patch "Trumpet"))

(defmethod gm-patch((self CROTALES) (expression t))
  ;
  '(:patch "Tubular_Bells"))

(defmethod gm-patch((self PICCOLO) (expression t))
  ;"Piccolo" 
  '(:patch "Piccolo"))

(defmethod gm-patch((self KEYBOARDS) (expression t))
  ;
  '(:patch "Electric_Piano_1"))

(defmethod gm-patch((self BASS-CLARINET) (expression t))
  ;"Clarinet" 
  '(:patch "Clarinet"))

(defmethod gm-patch((self TENOR-DRUM) (expression t))
  ;
  '(:channel 10 :pitch 47))

(defmethod gm-patch((self PICCOLO-CLARINET) (expression t))
  ;"Clarinet" "Piccolo" 
  '(:patch "Clarinet"))

(defmethod gm-patch((self COWBELL) (expression t))
  ;("Cowbell" 56) 
  '(:channel 10 :pitch 56))

(defmethod gm-patch((self JEWS-HARP) (expression t))
  ;
  '(:channel 10 :pitch 0))

(defmethod gm-patch((self SLEIGH-BELLS) (expression t))
  ;
  '(:channel 10 :pitch 0))

(defmethod gm-patch((self FLUTE) (expression t))
  ;"Flute" "Pan Flute" 
  '(:patch "Flute"))

(defmethod gm-patch((self AGOGO-BELLS) (expression t))
  ;"Agogo" 
  '(:patch "Agogo"))

(defmethod gm-patch((self PIANO) (expression t))
  ;"Acoustic Grand Piano" "Bright Acoustic Piano" "Electric Grand Piano" "Honky tonk Piano" "Electric Piano 1" "Electric Piano 2" 
  '(:patch "Acoustic_Grand_Piano"))

(defmethod gm-patch((self TIMBALES) (expression t))
  ;
  '(:channel 10 :pitch 65))

(defmethod gm-patch((self CLARINET-IN-A) (expression t))
  ;"Clarinet" 
  '(:patch "Clarinet"))

(defmethod gm-patch((self ALTO-FLUTE) (expression t))
  ;"Flute" 
  '(:patch "Flute"))

(defmethod gm-patch((self CORNET) (expression t))
  ;
  '(:patch "Trumpet"))

(defmethod gm-patch((self TRUMPET) (expression t))
  ;"Trumpet" "Muted Trumpet" 
  '(:patch "Trumpet"))

(defmethod gm-patch((self VIOLA-D-AMORE) (expression t))
  ;"Viola" 
  '(:patch "Viola"))

(defmethod gm-patch((self VIOLA-D-AMORE) (expression tremolo))
  ;"Violin" 
  '(:patch "Tremolo_Strings"))

(defmethod gm-patch((self VIOLA-D-AMORE) (expression pizzicato))
  ;"Violin" 
  '(:patch "Pizzicato_Strings"))


(defmethod gm-patch((self ELECTRIC-BASS) (expression t))
  ;"Electric Bass finger" "Electric Bass pick" 
  '(:patch "Electric_Bass_finger"))

(defmethod gm-patch((self BASS) (expression t))
  ;"Acoustic Bass" "Electric Bass finger" "Electric Bass pick" "Fretless Bass" "Slap Bass 1" "Slap Bass 2" "Synth Bass 1" "Synth Bass 2" "Bassoon" 
  '(:patch "Choir_Aahs"))

(defmethod gm-patch((self TAM-TAM) (expression t))
  ;
  '(:channel 10 :pitch 52))

(defmethod gm-patch((self CONTRABASS-CLARINET) (expression t))
  ;"Contrabass" "Clarinet" 
  '(:patch "Clarinet"))

(defmethod gm-patch((self FLEX-A-TONE) (expression t))
  ;
  '(:channel 10 :pitch 0))

(defmethod gm-patch((self BASS-FLUTE) (expression t))
  ;"Flute" 
  '(:patch "Flute"))

(defmethod gm-patch((self SLAPSTICK) (expression t))
  ;
  '(:channel 10 :pitch 0))

(defmethod gm-patch((self WOOD-BLOCK) (expression t))
  ;("Hi Wood Block" 76) ("Low Wood Block" 77) 
  '(:channel 10 :pitch 76))

(defmethod gm-patch((self BASS-TROMBONE) (expression t))
  ;"Trombone" 
  '(:patch "Trombone"))

(defmethod gm-patch((self HARPSICHORD) (expression t))
  ;"Harpsichord" 
  '(:patch "Harpsichord"))

(defmethod gm-patch((self TRIANGLE) (expression t))
  ;("Mute Triangle" 80) ("Open Triangle" 81) 
  '(:channel 10 :pitch 81))

(defmethod gm-patch((self SCRAPER) (expression t))
  ;
  '(:channel 10 :pitch 0))

(defmethod gm-patch((self SOPRANO) (expression t))
  ;"Soprano Sax" 
  '(:patch "Choir_Aahs"))

(defmethod gm-patch((self BASSOON) (expression t))
  ;"Bassoon" 
  '(:patch "Bassoon"))

(defmethod gm-patch((self OBOE) (expression t))
  ;"Oboe" 
  '(:patch "Oboe"))

(defmethod gm-patch((self CLARINET) (expression t))
  ;"Clarinet" 
  '(:patch "Clarinet"))

(defmethod gm-patch((self SUSPENDED-CYMBAL) (expression t))
  ;
  '(:channel 10 :pitch 55))

(defmethod gm-patch((self VIOLA-DA-GAMBA) (expression t))
  ;"Viola" 
  '(:patch "Viola"))

(defmethod gm-patch((self VIOLA-DA-GAMBA) (expression tremolo))
  ;"Violin" 
  '(:patch "Tremolo_Strings"))

(defmethod gm-patch((self VIOLA-DA-GAMBA) (expression pizzicato))
  ;"Violin" 
  '(:patch "Pizzicato_Strings"))

(defmethod gm-patch((self DRUMS) (expression t))
  ;"Steel Drums" 
  '(:patch 16386 :channel 10 :pitch 60))

#|
1 Dry Set
9 Room Set
19 Power Set
25 Electronic Set
33 Jazz Set
41 Brush Set
|#

(defmethod gm-patch((self FRENCH-HORN-IN-EB) (expression t))
  ;"French Horn" 
  '(:patch "French_Horn"))

(defmethod gm-patch((self VIOLIN) (expression t))
  ;"Violin" 
  '(:patch "Violin"))

(defmethod gm-patch((self VIOLIN) (expression tremolo))
  ;"Violin" 
  '(:patch "Tremolo_Strings"))

(defmethod gm-patch((self VIOLIN) (expression pizzicato))
  ;"Violin" 
  '(:patch "Pizzicato_Strings"))

(defmethod gm-patch((self CONTRABASSOON) (expression t))
  ;"Contrabass" 
  '(:patch "Bassoon"))

(defmethod gm-patch((self OBOE-DAMORE) (expression t))
  ;"Oboe" 
  '(:patch "Oboe"))

(defmethod gm-patch((self FINGER-CYMBALS) (expression t))
  ;
  '(:channel 10 :pitch 55))

(defmethod gm-patch((self TROMBONE) (expression t))
  ;"Trombone" 
  '(:patch "Trombone"))

(defmethod gm-patch((self SANDPAPER-BLOCKS) (expression t))
  ;
  '(:channel 10 :pitch 69))

(defmethod gm-patch((self VIBRA-SLAP) (expression t))
  ;
  '(:channel 10 :pitch 58))

(defmethod gm-patch((self BARITONE) (expression t))
  ;"Baritone Sax" 
  '(:patch "Choir_Aahs"))

(defmethod gm-patch((self VIOLA) (expression t))
  ;"Viola" 
  '(:patch "Viola"))

(defmethod gm-patch((self VIOLA) (expression tremolo))
  ;"Violin" 
  '(:patch "Tremolo_Strings"))

(defmethod gm-patch((self VIOLA) (expression pizzicato))
  ;"Violin" 
  '(:patch "Pizzicato_Strings"))

(defmethod gm-patch((self ORGAN) (expression t))
  ;"Drawbar Organ" "Percussive Organ" "Rock Organ" "Church Organ" "Reed Organ" 
  '(:patch "Church_Organ"))

(defmethod gm-patch((self SOPRANINO-SAXOPHONE) (expression t))
  ;
  '(:patch "Soprano_Sax"))

(defmethod gm-patch((self ENGLISH-HORN) (expression t))
  ;"English Horn" 
  '(:patch "English_Horn"))

(defmethod gm-patch((self MARK-TREE) (expression t))
  ;
  '(:channel 10 :pitch 0))

(defmethod gm-patch((self FRENCH-HORN-IN-BB) (expression t))
  ;"French Horn" 
  '(:patch "French_Horn"))

(defmethod gm-patch((self SOPRANO-SAXOPHONE) (expression t))
  ;"Soprano Sax" 
  '(:patch "Soprano_Sax"))

(defmethod gm-patch((self BOAT-WHISTLE) (expression t))
  ;"Whistle" 
  '(:patch "Whistle"))

(defmethod gm-patch((self RATTLE) (expression t))
  ;
  '(:channel 10 :pitch 0))

(defmethod gm-patch((self CONTRABASS) (expression t))
  ;"Contrabass" 
  '(:patch "Contrabass"))

(defmethod gm-patch((self CONTRABASS) (expression tremolo))
  ;"Violin" 
  '(:patch "Tremolo_Strings"))

(defmethod gm-patch((self CONTRABASS) (expression pizzicato))
  ;"Violin" 
  '(:patch "Pizzicato_Strings"))

(defmethod gm-patch((self TUBA) (expression t))
  ;"Tuba" 
  '(:patch "Tuba"))

(defmethod gm-patch((self GONG) (expression t))
  ;
  '(:channel 10 :pitch 0))

(defmethod gm-patch((self TRAIN-WHISTLE) (expression t))
  ;"Whistle" 
  '(:patch "Whistle"))

(defmethod gm-patch((self ALTO-SAXOPHONE) (expression t))
  ;"Alto Sax" 
  '(:patch "Alto_Sax"))

(defmethod gm-patch((self t) (expression t))
  '(:patch 1))