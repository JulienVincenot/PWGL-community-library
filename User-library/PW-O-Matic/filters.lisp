(in-package :PW-O-Matic)





(PWGLdef MoogFF (  (in "0") (freq "100") (gain "2") (reset "0") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Moog VCF implementation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "MoogFF." (string-downcase a) "(" in "," freq "," gain "," reset "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 






(PWGLdef PitchShift ( (in "0") (windowSize "0.2") (pitchRatio "1") (pitchDispersion "0") (timeDispersion "0") (mul "1" ) (add "0" )   )
"Time domain pitch shifter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.6  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "PitchShift.ar(" in "," windowSize "," pitchRatio "," pitchDispersion "," timeDispersion "," mul "," add ")" #\return )) )
)
(values ad1 )))



 
(PWGLdef FreqShift ( (in "0") (freq "1200") (phase "1") (mul "1" ) (add "0" )   )
"Frequency Shifter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "FreqShift.ar(" in "," freq "," phase "," mul "," add ")" #\return )) )
)
(values ad1 )))




(PWGLdef Hasher (  (in "0") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Randomized value."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Hasher." (string-downcase a) "(" in "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef Hilbert ( (in "0") (mul "1" ) (add "0" )   )
"Frequency Shifter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Hilbert.ar(" in "," mul "," add ")" #\return )) )
)
(values ad1 )))




(PWGLdef HilbertFIR ( (in "0") (buffer "0" ) )
"Frequency Shifter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "HilbertFIR.ar(" in "," buffer ")" #\return )) )
)
(values ad1 )))





(PWGLdef MantissaMask (  (in "0") (bits "3") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Reduce precision."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "MantissaMask." (string-downcase a) "(" in "," bits "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef Median ( (length "3") (in "0") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Returns the median of the last length input points. This non-linear filter is good at reducing impulse noise from a signal."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Median." (string-downcase a) "(" length "," in  "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 



(PWGLdef Slew ( (in "0") (up "1") (dn "1") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Slew rate limiter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Slew." (string-downcase a) "(" in "," up  "," dn "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 


 
(PWGLdef Squiz ( (in "0") (pitchratio "2") (zcperchunk "1") (memlen "0.1") (mul "1" ) (add "0" )   )
"Wave squeezer, maybe a kind of pitch shifter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Squiz.ar(" in "," pitchratio "," zcperchunk "," memlen "," mul "," add ")" #\return )) )
)
(values ad1 )))




(PWGLdef BAllPass ( (in "0") (freq "1200") (rq "1") (mul "1" ) (add "0" )   )
"The B equalization suite is based on the Second Order Section SOS biquad UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "BAllPass.ar(" in "," freq "," rq "," mul "," add ")" #\return )) )
)
(values ad1 )))




(PWGLdef BBandPass ( (in "0") (freq "1200") (bw "1") (mul "1" ) (add "0" )   )
"The B equalization suite is based on the Second Order Section SOS biquad UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "BBandPass.ar(" in "," freq "," bw "," mul "," add ")" #\return )) )
)
(values ad1 )))




(PWGLdef BBandStop ( (in "0") (freq "1200") (bw "1") (mul "1" ) (add "0" )   )
"The B equalization suite is based on the Second Order Section SOS biquad UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "BBandStop.ar(" in "," freq "," bw "," mul "," add ")" #\return )) )
)
(values ad1 )))



(PWGLdef BHiPass ( (in "0") (freq "1200") (rq "1") (mul "1" ) (add "0" )   )
"The B equalization suite is based on the Second Order Section biquad UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "BHiPass.ar(" in "," freq "," rq "," mul "," add ")" #\return )) )
)
(values ad1 )))


(PWGLdef BHiPass4 ( (in "0") (freq "1200") (rq "1") (mul "1" ) (add "0" )   )
"The B equalization suite is based on the Second Order Section biquad UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "BHiPass4.ar(" in "," freq "," rq "," mul "," add ")" #\return )) )
)
(values ad1 )))



(PWGLdef BHiShelf ( (in "0") (freq "1200") (rs "1") (db "0") (mul "1" ) (add "0" )   )
"The B equalization suite is based on the Second Order Section biquad UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "BHiShelf.ar(" in "," freq "," rs "," db "," mul "," add ")" #\return )) )
)
(values ad1 )))


(PWGLdef BLowPass ( (in "0") (freq "1200") (rq "1")  (mul "1" ) (add "0" )   )
"The B equalization suite is based on the Second Order Section biquad UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "BLowPass.ar(" in "," freq "," rq "," mul "," add ")" #\return )) )
)
(values ad1 )))


(PWGLdef BLowPass4 ( (in "0") (freq "1200") (rq "1")  (mul "1" ) (add "0" )   )
"The B equalization suite is based on the Second Order Section biquad UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "BLowPass4.ar(" in "," freq "," rq "," mul "," add ")" #\return )) )
)
(values ad1 )))



(PWGLdef BLowShelf ( (in "0") (freq "1200") (rs "1") (db "0") (mul "1" ) (add "0" )   )
"The B equalization suite is based on the Second Order Section biquad UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "BLowShelf.ar(" in "," freq "," rs "," db "," mul "," add ")" #\return )) )
)
(values ad1 )))



(PWGLdef BPeakEQ ( (in "0") (freq "1200") (rq "1") (db "0") (mul "1" ) (add "0" )   )
"The B equalization suite is based on the Second Order Section biquad UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "BPeakEQ.ar(" in "," freq "," rq "," db "," mul "," add ")" #\return )) )
)
(values ad1 )))





;;LINEAR


(PWGLdef APF (  (in "0") (freq "1200") (radius "1")  (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"APF."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "APF." (string-downcase a) "(" in "," freq "," radius  "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 



(PWGLdef BPF (  (in "0") (freq "440") (rq "1")  (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"2nd order Butterworth bandpass filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "BPF." (string-downcase a) "(" in "," freq "," rq  "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 



(PWGLdef BPZ2 (  (in "0") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Two zero fixed midpass."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "BPZ2." (string-downcase a) "(" in "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 



(PWGLdef BRF (  (in "0") (freq "440") (rq "1")  (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"2nd order Butterworth band reject filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "BRF." (string-downcase a) "(" in "," freq "," rq  "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 



(PWGLdef Formlet (  (in "0") (freq "440") (attack "1") (decay "1") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"2nd order Butterworth band reject filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Formlet." (string-downcase a) "(" in "," freq "," attack "," decay  "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 



(PWGLdef DynKlank (  (ArrayRef ()) (input ()) (freqscale "1") (freqoffset "0" ) (decayscale "1")  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Bank of resonators."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "DynKlank." (string-downcase a) "(Ref.new(" ArrayRef ")," input "," freqscale ","  freqoffset "," decayscale ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef HPF ((in ()) (freq "440") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"2nd order Butterworth highpass filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "HPF." (string-downcase a) "(" in "," freq ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 



(PWGLdef HPZ1 (  (in "0") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Two point difference filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "HPZ1." (string-downcase a) "(" in "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef HPZ2 (  (in "0") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Two zero fixed midcut."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "HPZ2." (string-downcase a) "(" in "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 



(PWGLdef Integrator (  (in "0") (coef "1") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A leaky integrator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Integrator." (string-downcase a) "(" in "," coef "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef LPF ((in ()) (freq "440") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"2nd order Butterworth lowpass filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LPF." (string-downcase a) "(" in "," freq ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 



(PWGLdef LPZ1 (  (in "0") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Two point average filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LPZ1." (string-downcase a) "(" in "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef LPZ2 (  (in "0") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Two zero fixed lowpass."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LPZ2." (string-downcase a) "(" in "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef Lag ((in ()) (lagtime "0.1") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Exponential lag."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Lag." (string-downcase a) "(" in "," lagtime ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef Lag2 ((in ()) (lagtime "0.1") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Exponential lag."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Lag2." (string-downcase a) "(" in "," lagtime ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef Lag3 ((in ()) (lagtime "0.1") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Exponential lag."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Lag3." (string-downcase a) "(" in "," lagtime ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef LeakDC (  (in "0") (coef "0.995") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"remove dc."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LeakDC." (string-downcase a) "(" in "," coef "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 



(PWGLdef MidEQ (  (in "0") (freq "440") (rq "1") (db "0") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Parametric filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "MidEQ." (string-downcase a) "(" in "," freq "," rq  "," db "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef OnePole (  (in "0") (coef "0.5") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"One pole filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "OnePole." (string-downcase a) "(" in "," coef "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef OneZero (  (in "0") (coef "0.5") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"One zero filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "OneZero." (string-downcase a) "(" in "," coef "," mul "," add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef RHPF (  (in "0") (freq "440") (rq "1")  (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A resonant high pass filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "RHPF." (string-downcase a) "(" in "," freq "," rq  "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef RLPF (  (in "0") (freq "440") (rq "1")  (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A resonant low pass filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "RLPF." (string-downcase a) "(" in "," freq "," rq  "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef Ramp ((in ()) (lagtime "0.1") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Break a continuous signal into line segments."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Ramp." (string-downcase a) "(" in "," lagtime ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef Resonz (  (in "0") (freq "440") (bwr "1")  (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A resonant filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Resonz." (string-downcase a) "(" in "," freq "," bwr  "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 






(PWGLdef Ringz (  (in "0") (freq "440") (decay "1")  (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A ringing filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Ringz." (string-downcase a) "(" in "," freq "," decay  "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef SOS (  (in "0") (a0 "0") (a1 "0")  (a2 "0" ) (b1 "0")  (b2 "0" ) (mul "1") (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"A ringing filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "SOS." (string-downcase a) "(" in "," a0 ","  a1 ","  a2 "," b1 "," b2  "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef Slope (  (in "0") (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Slope of signal."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Slope." (string-downcase a) "(" in "," mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef TwoPole (  (in "0") (freq "440") (radius "0.8")  (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Two pole filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "TwoPole." (string-downcase a) "(" in "," freq "," radius  "," mul "," add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef TwoZero (  (in "0") (freq "440") (radius "0.8")  (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Two zero filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "TwoZero." (string-downcase a) "(" in "," freq "," radius  "," mul "," add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef VarLag (  (in "0") (time "0.1") (curvature "0") (warp "5" ) (start "0" )  (mul "1" ) (add "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Variable shaped lag."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "VarLag." (string-downcase a) "(" in "," time "," curvature  "," warp ","  start "," mul "," add ")"  #\return )) )
)
(values ad1 )))




