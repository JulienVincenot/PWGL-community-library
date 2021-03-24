(in-package :PWCSOUND)



;;****************************************
;;****************************************
;;*************EFFECTS***********************
;;****************************************
;;****************************************


(PWGLdef  phaser1 ( (global "connect") (kfreq "1000" ) (kord "1" ) (kfeedback ".5") (iskip "0"))
"An implementation of iord number of first-order allpass filters in series."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2 1)) 
(let* 
( (tone1 (remove nil (pw::list "phaser1(" global "," kfreq "," kord "," kfeedback "," iskip ")" #\\ #\return )) )) 
(values tone1 )))



(PWGLdef  phaser2 ( (global "connect") (kfreq "1000" ) (kq "1")  (kord "2" ) (kmode "2") (ksep ".33") (kfeedback ".5") )
"An implementation of iord number of second-order allpass filters in series."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2 2 1)) 
(let* 
( (tone1 (remove nil (pw::list "phaser2(" global "," kfreq "," kq "," kord "," kmode "," ksep "," kfeedback ")" #\\ #\return )) )) 
(values tone1 )))





(PWGLdef  flanger ( (global "connect") (adel ".5" ) (kfeedback ".5" ) (imaxd "1") )
"A user controlled flanger."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "flanger(" global "," adel "," kfeedback "," imaxd ")" #\\ #\return )) )) 
(values tone1 )))




(PWGLdef  freq-shift ( (global "connect") (freq "1000" ) (freqdev () ) )
"frequency shifting, or single sideband amplitude modulation. Frequency shifting is similar to ring modulation, except the upper and lower sidebands are separated into individual outputs"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "freqshift(" global "," freq  freqdev "," "gisine" ")" #\\ #\return )) )) 
(values tone1 )))

 

(PWGLdef  fbkdelay ( (global "connect") (kdelay ".5" ) (ifback ".5" ) )
"simple feedback delay"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "fbkdelay(" global "," kdelay "," ifback ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef  delay1 ( (global "connect")  )
"Delays an input signal by one sample"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1   ) ) 
(let* 
( (tone1 (remove nil (pw::list "delay1(" global ")" #\\ #\return )) )) 
(values tone1 ))) 



(PWGLdef  delay ( (global "connect")  (del ".5" ) (dry-wet ".2" ) )
"simple delay"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "simpledelay(" global "," del "," dry-wet ")" #\\ #\return )) )) 
(values tone1 )))





(PWGLdef  vintage-echo ( (global "connect") (ilevel ".5" ) (del ".5" ) (kfilt "1000" ) )
"simple delay with feedback"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "vintagecho(" global "," ilevel "," del "," kfilt ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef  vdelay ( (global "connect")  (adel "1" ) (imaxdel "100" )  )
"An interpolating variable time delay."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 1  ) ) 
(let* 
( (tone1 (remove nil (pw::list "vdelay(" global "," adel "," imaxdel  ")" #\\ #\return )) )) 
(values tone1 )))

(PWGLdef  vdelay3 ( (global "connect")  (adel "1" ) (imaxdel "100" )  )
"A variable time delay with cubic interpolation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 1  ) ) 
(let* 
( (tone1 (remove nil (pw::list "vdelay3(" global "," adel "," imaxdel  ")" #\\ #\return )) )) 
(values tone1 )))





(PWGLdef  doppler ( (global "connect")  (kposition "120") (kmicposition "4") (isoundspeed "340")  (ifiltercutoff "6") )
"A fast and robust method for approximating sound propagation, achieving convincing Doppler shifts without having to solve equations."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2 2 ) ) 
(let* 
( (tone1 (remove nil (pw::list "doppler(" global "," kposition "," kmicposition "," isoundspeed "," ifiltercutoff ")" #\\ #\return )) )) 
(values tone1 )))







(PWGLdef  metalizer ( (global "connect")  (depth "2" ) (rate "4" )  )
"A comb filters bank"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "metalizer(" global "," depth "," rate  ")" #\\ #\return )) )) 
(values tone1 )))

 





(PWGLdef bitcrush ( (global "connect")  (bit "8" ) (srate "12000" )  )
"bit reduction"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "decimator(" global "," bit "," srate  ")" #\\ #\return )) )) 
(values tone1 )))




;;REVERBERATION



(PWGLdef platerev ( (in1 "connect") (kbndry "1") (iaspect "0.73") (istiff "1") (idecay "5") (iloss "0.001") )
"Models the reverberation of a rectangular metal plate with settable physical characteristics when excited by audio signal(s)."

(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "platerev:a(" "gipl1,gipl2" "," kbndry "," iaspect "," istiff "," idecay "," iloss "," in1 ")" )) )
) 
(values tone1  ))) 


(PWGLdef reverb ( (in1 "connect") (krvt ".8") )
"Reverberates an input signal with a natural room frequency response."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "reverb(" in1 ","  krvt ")" )) )
) 
(values tone1  ))) 



(PWGLdef freeverb ( (in1 "connect") (in2 "connect") (kroomsize "0.9") (kdamp "0.35") (kdrywet ".5") )
"freeverb is a stereo reverb unit based on Jezar's public domain C++ sources, composed of eight parallel comb filters on both channels, followed by four allpass units in series. The filters on the right channel are slightly detuned compared to the left channel in order to create a stereo effect."

(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 1) ) 
(let* 
( 
(tone1 (remove nil (pw::list "freeverbx(" in1 "," in2 ","  kroomsize ","  kdamp  "," kdrywet ")" )) )
) 
(values tone1  ))) 




(PWGLdef reverbsc ( (in1 "connect") (in2 "connect") (kfback "0.85") (kcut "12000") (kdrywet ".5") )
"8 delay line stereo FDN reverb, with feedback matrix based upon physical modeling scattering junction of 8 lossless waveguides of equal characteristic impedance. Based on Csound orchestra version by Sean Costello."

(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 1) ) 
(let* 
( 
(tone1 (remove nil (pw::list "revsc(" in1 "," in2 ","  kfback ","  kcut  "," kdrywet ")" )) )
) 
(values tone1  ))) 





(PWGLdef alpass ( (in1 "connect") (krvt "3.5") (ilpt "0.1")  )
"Reverberates an input signal with a flat frequency response."

(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "alpass(" in1  ","  krvt ","  ilpt ")" )) )
) 
(values tone1  ))) 



(PWGLdef comb ( (in1 "connect") (krvt "3.5") (ilpt "0.1")  )
"Reverberates an input signal with a colored frequency response."

(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "comb(" in1  ","  krvt ","  ilpt ")" )) )
) 
(values tone1  ))) 





