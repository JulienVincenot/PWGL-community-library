(in-package :PW-O-Matic)

;;************************PW-O-Matic 0.1*******************************
;;****************************************************************




(PWGLdef COsc ( (bufnum ())  (freq "440") (beats "0.5")  (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Chorusing wavetable lookup oscillator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "COsc." (string-downcase a) "(" bufnum "," freq "," beats ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 



;;Granular************************

(PWGLdef GrainFM ( (numchannels "1" ) (trigger "0") (dur "1") (carfreq "440") (modfreq "200") (index "1") (pan "0")  (envbufnum "-1") (maxgrains "512") (mul "1") (add "0" ) )
"Granular synthesis with frequency modulated sine tones."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.6 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 3 3 3 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "GrainFM.ar(" numchannels "," trigger ","  dur ","  carfreq ","  modfreq ","  index ","  pan "," envbufnum "," maxgrains "," mul "," add  ")" #\return )) )
) 
(values tone1  )))





(PWGLdef GrainBuf ( (numchannels "1" ) (trigger "0") (dur "1") (sndbuf ()) (rate "1") (pos "0") (interp "2") (pan "0")  (envbufnum "-1") (maxgrains "512") (mul "1") (add "0" ) )
"Granular synthesis with sound stored in a buffer."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.6 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 3 3 3 3) ) 
(let* 
( 
(tone1 (remove nil (pw::list "GrainBuf.ar(" numchannels "," trigger ","  dur ","  sndbuf ","  rate ","  pos ","  interp "," pan "," envbufnum "," maxgrains "," mul "," add  ")" #\return )) )
) 
(values tone1  )))






(PWGLdef GrainIn ( (numchannels "1" ) (trigger "0") (dur "1") (in ()) (pan "0") (envbufnum "-1") (maxgrains "512") (mul "1") (add "0" ) )
"Granulate an input signal."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.6 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "GrainIn.ar(" numchannels "," trigger ","  dur ","  in ","  pan "," envbufnum "," maxgrains "," mul "," add  ")" #\return )) )
) 
(values tone1  )))






(PWGLdef GrainSin ( (numchannels "1" ) (trigger "0") (dur "1")  (freq "440")  (pan "0") (envbufnum "-1") (maxgrains "512") (mul "1") (add "0" ) )
"Granular synthesis with sine tones."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.6 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "GrainSin.ar(" numchannels "," trigger ","  dur ","  freq ","  pan "," envbufnum "," maxgrains "," mul "," add  ")" #\return )) )
) 
(values tone1  )))





(PWGLdef TGrains ( (numchannels "1" ) (trigger "0") (bufnum "0")  (rate "1")  (centerPos "0") (dur "0.1")  (pan "0") (amp "0.1") (interp "4" ))
"Buffer granulator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.6 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "TGrains.ar(" numchannels "," trigger ","  bufnum ","  rate ","  centerPos "," dur "," pan "," amp "," interp  ")" #\return )) )
) 
(values tone1  )))




 

(PWGLdef Warp1 ((numchannels "1" )  (bufnum "0") (pointer "0")  (freqscale "1")  (windowSize "0.2") (envbufnum "-1")  (overlaps "8")  (windowRandRatio "0")   (interp "1" )  (mul "1") (add "0") )
"Warp a buffer with a time pointer."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.6 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 3 3 3 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "Warp1.ar("  numchannels ","   bufnum "," pointer "," freqscale "," windowSize  "," envbufnum ","  overlaps "," windowRandRatio "," interp  "," mul "," add  ")" #\return )) )
) 
(values tone1  )))






(PWGLdef VarSaw (  (freq "440") (iphase "0") (width "0.5") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Sawtooth-triangle oscillator with variable duty."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "VarSaw." (string-downcase a) "(" freq "," iphase "," width ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef VOsc3 ( (bufpos ()) (freq1 "140") (freq2 "240") (freq3 "440") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A wavetable lookup oscillator which can be swept smoothly across wavetables."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "VOsc3." (string-downcase a) "(" bufpos "," freq1 "," freq2 ","  freq3 ","  mul "," add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef VOsc ( (bufpos ()) (freq "440") (phase "0") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A wavetable lookup oscillator which can be swept smoothly across wavetables."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "VOsc." (string-downcase a) "(" bufpos "," freq "," phase ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef SyncSaw (  (syncfreq "440") (sawfreq "440") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A sawtooth wave that is hard synched to a fundamental pitch."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "SyncSaw." (string-downcase a) "(" syncfreq "," sawfreq ","  mul "," add ")"  #\return )) )
)
(values ad1 )))






(PWGLdef SinOscFB (  (freq "440") (feedback "0") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"SinOscFB is a sine oscillator that has phase modulation feedback."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "SinOscFB." (string-downcase a) "(" freq "," feedback ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 






(PWGLdef Saw ( (freq "440" ) (mul "1") (add "0" ) )
"Band limited sawtooth wave generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 1) ) 
(let* 
( 
(tone1 (remove nil (pw::list "Pulse.ar(" freq ","  mul "," add  ")" #\return )) )
) 
(values tone1  )))





(PWGLdef Pulse ( (freq "440" ) (width "0.5") (mul "1") (add "0" ) )
"Band limited pulse wave generator with pulse width modulation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "Pulse.ar(" freq "," width ","  mul "," add  ")" #\return )) )
) 
(values tone1  ))) 




(PWGLdef PSinGrain ( (freq "440" ) (dur "0.2") (amp "1" ) )
"Very fast sine grain with a parabolic envelope."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 1 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "PSinGrain.ar(" freq "," dur ","  amp  ")" #\return )) )
) 
(values tone1  ))) 





(PWGLdef PMOsc (  (carfreq "440") (modfreq "20") (pmindex "0") (modphase "0") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Phase modulation sine oscillator pair."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "PMOsc." (string-downcase a) "(" carfreq "," modfreq "," pmindex "," modphase ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef OscN-wave ( (bufnum ()) (freq "440") (phase "0") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Non-interpolating wavetable lookup oscillator with frequency and phase modulation inputs."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "OscN." (string-downcase a) "(" bufnum "," freq "," phase ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef Osc-wave ( (bufnum ()) (freq "440") (phase "0") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Linear interpolating wavetable lookup oscillator with frequency and phase modulation inputs."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Osc." (string-downcase a) "(" bufnum "," freq "," phase ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 






(PWGLdef LFTri ( (freq "440") (phase "0") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A non-band-limited triangle oscillator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LFTri." (string-downcase a) "(" freq "," phase ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef LFSaw ( (freq "440") (phase "0") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A non-band-limited sawtooth oscillator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LFSaw." (string-downcase a) "(" freq "," phase ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef LFPulse ( (freq "440") (phase "0") (width "0.5") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A non-band-limited pulse oscillator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LFPulse." (string-downcase a) "(" freq "," phase "," width "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef LFPar ( (freq "440") (phase "0") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A sine-like shape made of two parabolas."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LFPar." (string-downcase a) "(" freq "," phase ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef LFGauss ( (dur "1") (width "0.1") (iphase "0" ) (loop "1" ) (doneAction "2") (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A non-band-limited gaussian function oscillator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LFGauss." (string-downcase a) "(" dur "," width "," iphase "," loop "," doneAction ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef LFCub ( (freq "440") (phase "0") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A sine like shape made of two cubic pieces."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LFCub." (string-downcase a) "(" freq "," phase ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 



(PWGLdef Klank ( (ArrayRef ()) (input ()) (freqscale "1") (freqoffset "0" ) (decayscale "1") )
"Klank is a bank of fixed frequency resonators which can be used to simulate the resonant modes of an object."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "Klank.ar(Ref.new(" ArrayRef ")," input "," freqscale ","  freqoffset "," decayscale ")" #\return )) )
) 
(values tone1  ))) 




(PWGLdef Klang ( (ArrayRef ()) (freqscale "1") (freqoffset "0" ) )
"Klang is a bank of fixed frequency sine oscillators"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "Klang.ar(Ref.new(" ArrayRef ")," freqscale ","  freqoffset  ")" #\return )) )
) 
(values tone1  ))) 




(PWGLdef Blip ( (freq "440") (numharm "200") (mul "1" ) (add "0" ) )
"Band Limited ImPulse generator,all harmonics have equal amplitude, this is the equivalent of buzz in MusicN languages."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "Blip.ar(" freq "," numharm ","  mul "," add  ")" #\return )) )
) 
(values tone1  ))) 



(PWGLdef FSinOsc ( (freq "440") (phase "0") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Very fast sine wave generator"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "FSinOsc." (string-downcase a) "(" freq "," phase ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef Formant ( (fund "440") (form "1760") (bwfreq "880") (mul "1" ) (add "0" ) )
"Generates a set of harmonics around a formant frequency at a given fundamental frequency."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "Formant.ar(" fund "," form "," bwfreq "," mul "," add  ")" #\return )) )
) 
(values tone1  ))) 




(PWGLdef Impulse ( (freq "440") (phase "0") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Outputs non-bandlimited single sample impulses."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Impulse." (string-downcase a) "(" freq "," phase ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 







(PWGLdef SinOsc ( (freq "440") (phase "0") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Interpolating sine wavetable oscillator"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "SinOsc." (string-downcase a) "(" freq "," phase ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef Vibrato ( (freq "440") (rate "6") (depth "0.02") (delay "0") (onset "0") (ratevar "0.04") (depthvar "0.1") (iphase "0") (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Vibrato is a slow frequency modulation. "
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(3 3 3) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Vibrato." (string-downcase a) "(" freq "," rate "," depth "," delay "," onset "," ratevar "," depthvar "," iphase ")"  #\return )) )
)
(values ad1 ))) 



 




(PWGLdef AY ( (tonea "1777") (toneb "1666") (tonec "1555") (noise "1") (control "7") (vola "15") (volb "15") (volc "15") (envfreq "4") (envstyle "1") (chiptype "0")  (mul "1")  (add "0") )
"Emulates the General Instrument AY-3-8910 (a.k.a. the Yamaha YM2149) 3-voice sound chip, as found in the ZX Spectrum 128, the Atari ST, and various other home computers during the 1980s."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 3 3 3 3 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "AY.ar(" tonea  "," toneb ","  tonec  ","  noise ","  control ","  vola ","  volb ","  volc "," envfreq "," envstyle "," chiptype "," mul ","  add  ")" #\return )) )
) 
(values tone1  ))) 






(PWGLdef KmeansToBPSet1 ((freq "440")  (numdatapoints "20") (maxnummeans "4") (nummeans "4") (tnewdata "1") (tnewmeans "1") (soft "0.1") (bufnum "1") (mul "1")  (add "0") )
"Uses succesive iterations of a k-means clustering algorithm on random data with random initial means to form break points in a 2-D space. These are then converted to wavetables in output synthesis based on the oscillator frequency."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "KmeansToBPSet1.ar(" freq "," numdatapoints "," maxnummeans "," nummeans "," tnewdata "," tnewmeans "," soft "," bufnum "," mul "," add  ")" #\return )) )
) 
(values tone1  ))) 



(PWGLdef SawDPW ( (freq "440") (phase "0") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A sawtooth oscillator using the Differentiated Parabolic Wave technique, which suppresses aliasing at a wide range of frequencies, yet is about 3 times as CPU-efficient as SuperCollider's Saw ugen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "SawDPW." (string-downcase a) "(" freq "," phase ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 



(PWGLdef PulseDPW ( (freq "440") (width "0.5") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"super-efficient square-wave oscillator with low aliasing"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "PulseDPW." (string-downcase a) "(" freq "," width ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 




;;//*********************Stochastic


(PWGLdef WhiteNoise ( (mul "1") (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Generates noise whose spectrum has equal power at all frequencies."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "WhiteNoise." (string-downcase a) "(" mul "," add ")"  #\return )) )
)
(values ad1 )))





(PWGLdef RandSeed ( (trig "0") (seed "56789" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ir"
) :value 1)) 
)
"Generates noise whose spectrum falls off in power by 3 dB per octave. This gives equal power over the span of each octave. This version gives 8 octaves of pink noise."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "RandSeed." (string-downcase a) "(" trig "," seed ")"  #\return )) )
)
(values ad1 )))







(PWGLdef RandID ( (id "1")  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ir"
) :value 1)) 
)
"Choose which random number generator to use for this synth. All synths that use the same generator reproduce the same sequence of numbers when the same seed is set again."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "RandID." (string-downcase a) "(" id ")"  #\return )) )
)
(values ad1 )))



(PWGLdef PinkNoise ( (mul "1") (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Generates noise whose spectrum falls off in power by 3 dB per octave. This gives equal power over the span of each octave. This version gives 8 octaves of pink noise."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "PinkNoise." (string-downcase a) "(" mul "," add ")"  #\return )) )
)
(values ad1 )))





(PWGLdef LFNoise2 ( (rate "5") (range "2000" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
(b () (ccl::mk-menu-subview :menu-list 
'(
"range"
"exprange"
) :value 1)))
"Generates quadratically interpolated random values at a rate given by the nearest integer division of the sample rate by the freq argument."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LFNoise2." (string-downcase a) "(" rate ")" "." b "(" range ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef LFDNoise3 ( (freq "440") (mul "1") (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Dynamic cubic noise."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LFDNoise3." (string-downcase a) "(" freq "," mul "," add ")"  #\return )) )
)
(values ad1 )))



(PWGLdef LFDNoise1 ( (freq "440") (mul "1") (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Dynamic ramp noise."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LFDNoise1." (string-downcase a) "(" freq "," mul "," add ")"  #\return )) )
)
(values ad1 )))



(PWGLdef LFDNoise0 ( (freq "440") (mul "1") (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Dynamic step noise."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LFDNoise0." (string-downcase a) "(" freq "," mul "," add ")"  #\return )) )
)
(values ad1 )))





(PWGLdef LFDClipNoise ( (freq "440") (mul "1") (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Generates noise which results from flipping random bits in a word. This type of noise has a high RMS level relative to its peak to peak level. The spectrum is emphasized towards lower frequencies."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LFDClipNoise." (string-downcase a) "(" freq "," mul "," add ")"  #\return )) )
)
(values ad1 )))


(PWGLdef LFClipNoise ( (freq "440") (mul "1") (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Generates noise which results from flipping random bits in a word. This type of noise has a high RMS level relative to its peak to peak level. The spectrum is emphasized towards lower frequencies."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LFClipNoise." (string-downcase a) "(" freq "," mul "," add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef GrayNoise ( (mul "1") (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Generates noise which results from flipping random bits in a word. This type of noise has a high RMS level relative to its peak to peak level. The spectrum is emphasized towards lower frequencies."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "GrayNoise." (string-downcase a) "(" mul "," add ")"  #\return )) )
)
(values ad1 )))








(PWGLdef BrownNoise ( (mul "1") (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Generates noise whose spectrum falls off in power by 6 dB per octave."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "BrownNoise." (string-downcase a) "(" mul "," add ")"  #\return )) )
)
(values ad1 )))



(PWGLdef ClipNoise ( (mul "1") (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Generates noise whose values are either -1 or 1. This produces the maximum energy for the least peak to peak amplitude."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "ClipNoise." (string-downcase a) "(" mul "," add ")"  #\return )) )
)
(values ad1 )))


(PWGLdef CoinGate ( (prob "1") (in "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"When CoinGate receives a trigger, it tosses a coin and either passes the trigger."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "CoinGate." (string-downcase a) "(" prob "," in ")"  #\return )) )
)
(values ad1 )))




(PWGLdef Crackle ( (chaosParam "1.5") (mul "1") (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A noise generator based on a chaotic function."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Crackle." (string-downcase a) "(" chaosParam "," mul "," add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef Dust-sc ( (density "0") (mul "1") (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Generates random impulses from 0 to +1."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Dust." (string-downcase a) "(" density "," mul "," add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef Dust2-sc ( (density "0") (mul "1") (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Generates random impulses from 0 to +1."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Dust2." (string-downcase a) "(" density "," mul "," add ")"  #\return )) )
)
(values ad1 )))





(PWGLdef Gendy1-sc ( (ampdist "1")   (durdist "1")  (adparam "1") (ddparam "1") (minfreq "440") (maxfreq "660") (ampscale "0.5") (durscale "0.5") (initCPs "12") (knum "1") (mul "1") (add "0" )
 (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"An implementation of the dynamic stochastic synthesis generator conceived by Iannis Xenakis and described in Formalized Music 1992"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(3 3 3 3 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Gendy1." (string-downcase a) "(" ampdist "," durdist ","  adparam "," ddparam "," minfreq "," maxfreq "," ampscale "," durscale "," initCPs "," knum  "," mul  ","  add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef GaussTrig-sc ( (freq "440") (dev "0.3") (mul "1") (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"impulses around a certain frequency"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "GaussTrig." (string-downcase a) "(" freq "," dev "," mul "," add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef LFNoise0 ( (rate "5") (range "2000" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
(b () (ccl::mk-menu-subview :menu-list 
'(
"range"
"exprange"
) :value 1)))
"Generates random values at a rate given by the nearest integer division of the sample rate by the freq argument"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LFNoise0." (string-downcase a) "(" rate ")" "." (string-downcase b) "(" range ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef LFNoise1 ( (rate "5") (range "2000" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
(b () (ccl::mk-menu-subview :menu-list 
'(
"range"
"exprange"
) :value 1)))
"Generates linearly interpolated random values at a rate given by the nearest integer division of the sample rate by the freq argument."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LFNoise1." (string-downcase a) "(" rate ")" "." (string-downcase b) "(" range ")"  #\return )) )
)
(values ad1 ))) 



;;********* CHAOTIC

(PWGLdef CuspL ( (freq "22050") (a "1") (b "1.9" ) (xi "0" ) (mul "1")  (add "0") )
"A linear-interpolating sound generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "CuspL.ar(" freq "," a "," b "," xi "," mul "," add  ")" #\return )) )
) 
(values tone1  ))) 



(PWGLdef CuspN ( (freq "22050") (a "1") (b "1.9" ) (xi "0" ) (mul "1")  (add "0") )
"A non-interpolating sound generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "CuspL.ar(" freq "," a "," b "," xi "," mul "," add  ")" #\return )) )
) 
(values tone1  ))) 



(PWGLdef FBSineC ( (freq "22050") (im "1") (fb "0.1") (a "1.1") (c "0.5") (xi "0.1") (yi "0.1") (mul "1")  (add "0") )
"A cubic-interpolating sound generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "FBSineC.ar(" freq "," im "," fb "," a "," c "," xi "," yi "," mul "," add  ")" #\return )) )
) 
(values tone1  ))) 


(PWGLdef FBSineL ( (freq "22050") (im "1") (fb "0.1") (a "1.1") (c "0.5") (xi "0.1") (yi "0.1") (mul "1")  (add "0") )
"A linear-interpolating sound generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "FBSineL.ar(" freq "," im "," fb "," a "," c "," xi "," yi "," mul "," add  ")" #\return )) )
) 
(values tone1  ))) 



(PWGLdef FBSineN ( (freq "22050") (im "1") (fb "0.1") (a "1.1") (c "0.5") (xi "0.1") (yi "0.1") (mul "1")  (add "0") )
"A non-interpolating sound generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "FBSineN.ar(" freq "," im "," fb "," a "," c "," xi "," yi "," mul "," add  ")" #\return )) )
) 
(values tone1  ))) 






(PWGLdef GbmanL ( (freq "22050") (xi "0.1") (yi "0.1") (mul "1")  (add "0") )
"A linear-interpolating sound generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "GbmanL.ar(" freq "," xi "," yi "," mul "," add  ")" #\return )) )
) 
(values tone1  )))



(PWGLdef GbmanN ( (freq "22050") (xi "0.1") (yi "0.1") (mul "1")  (add "0") )
"A non-interpolating sound generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "GbmanN.ar(" freq "," xi "," yi "," mul "," add  ")" #\return )) )
) 
(values tone1  )))



(PWGLdef rand-range ( (min "100") (max "1000") )
"random number list"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list  "Rand(" min "," max ")" #\return )) )
) 
(values tone1  ))) 



(PWGLdef HenonC ( (freq "22050") (a "1.4") (b "0.3") (x0 "0.1") (x1 "0.1") (mul "1")  (add "0") )
"Henon map chaotic generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "HenonC.ar(" freq "," a "," b "," x0 "," x1 "," mul "," add  ")" #\return )) )
) 
(values tone1  )))




(PWGLdef HenonL ( (freq "22050") (a "1.4") (b "0.3") (x0 "0.1") (x1 "0.1") (mul "1")  (add "0") )
"Henon map chaotic generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "HenonL.ar(" freq "," a "," b "," x0 "," x1 "," mul "," add  ")" #\return )) )
) 
(values tone1  )))



(PWGLdef HenonN ( (freq "22050") (a "1.4") (b "0.3") (x0 "0.1") (x1 "0.1") (mul "1")  (add "0") )
"Henon map chaotic generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "HenonN.ar(" freq "," a "," b "," x0 "," x1 "," mul "," add  ")" #\return )) )
) 
(values tone1  )))




(PWGLdef LatoocarfianC( (freq "22050") (a "1") (b "3") (c "0.4") (d "0.3") (xi "0.1") (yi "0.1") (mul "1")  (add "0") )
"Latoocarfian chaotic generator"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "LatoocarfianC.ar(" freq "," a "," b "," c "," d "," xi "," yi "," mul "," add  ")" #\return )) )
) 
(values tone1  )))


(PWGLdef LatoocarfianL( (freq "22050") (a "1") (b "3") (c "0.4") (d "0.3") (xi "0.1") (yi "0.1") (mul "1")  (add "0") )
"Latoocarfian chaotic generator"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "LatoocarfianL.ar(" freq "," a "," b "," c "," d "," xi "," yi "," mul "," add  ")" #\return )) )
) 
(values tone1  )))


(PWGLdef LatoocarfianN( (freq "22050") (a "1") (b "3") (c "0.4") (d "0.3") (xi "0.1") (yi "0.1") (mul "1")  (add "0") )
"Latoocarfian chaotic generator"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "LatoocarfianN.ar(" freq "," a "," b "," c "," d "," xi "," yi "," mul "," add  ")" #\return )) )
) 
(values tone1  )))



(PWGLdef LinCongC( (freq "22050") (a "1") (c "3") (m "0.4") (xi "0.1") (mul "1")  (add "0") )
"Linear congruential chaotic generator"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "LinCongC.ar(" freq "," a "," c "," m "," xi "," mul "," add  ")" #\return )) )
) 
(values tone1  )))



(PWGLdef LinCongL( (freq "22050") (a "1") (c "3") (m "0.4") (xi "0.1") (mul "1")  (add "0") )
"Linear congruential chaotic generator"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "LinCongL.ar(" freq "," a "," c "," m "," xi "," mul "," add  ")" #\return )) )
) 
(values tone1  )))


(PWGLdef LinCongN( (freq "22050") (a "1") (c "3") (m "0.4") (xi "0.1") (mul "1")  (add "0") )
"Linear congruential chaotic generator"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "LinCongN.ar(" freq "," a "," c "," m "," xi "," mul "," add  ")" #\return )) )
) 
(values tone1  )))
