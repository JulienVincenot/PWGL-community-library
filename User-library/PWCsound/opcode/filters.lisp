(in-package :PWCSOUND)

;;****************************************
;;****************************************
;;*************FILTERS***********************
;;****************************************
;;****************************************

;;FILTRI


(PWGLdef  exciter ( (global "connect") (freq "3000" ) (kceil "20000") (kharmonics "10") (kblend "10") (freqdev () ) )
"Filtered distortion to add brilliance to a signal"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2 2 ) ) 
(let* 
( (tone1 (remove nil (pw::list "exciter(" global "," freq  freqdev  "," kceil "," kharmonics "," kblend ")" #\\ #\return )) )) 
(values tone1 )))




(PWGLdef  follow ( (global "connect") (idt "0.001" ) )
"Envelope follower unit generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "tone(" global "," idt ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  tone ( (global "connect") (freq "1000" ) (freqdev () ) )
"tone, a first-order recursive low-pass filter with variable frequency response
output : syntax (ares tone asig, kfreq)"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "tone(" global "," freq  freqdev ")" #\\ #\return )) )) 
(values tone1 ))) 

(PWGLdef  atone ( (global "connect") (freq "1000" ) (freqdev () ) )
"A hi-pass filter whose transfer functions are the complements of the tone opcode."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "atone(" global "," freq  freqdev ")" #\\ #\return )) )) 
(values tone1 ))) 

(PWGLdef  areson ( (global "connect") (freq "1000" ) (band "100" ) (freqdev () ) )
"A notch filter whose transfer functions are the complements of the reson opcode."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "areson(" global "," freq  freqdev "," band ")" #\\ #\return )) )) 
(values tone1 ))) 

(PWGLdef  lowpass2 ( (global "connect") (freq "1000" ) (reso "30" ) (freqdev () ) )
"Implementation of a resonant second-order lowpass filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "lowpass2(" global "," freq  freqdev "," reso ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  lowresx ( (global "connect") (freq "1000" ) (reso "30" ) (layer "4" ) (freqdev () ) )
"Simulates layers of serially connected resonant lowpass filters."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2 1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "lowresx(" global "," freq  freqdev "," reso "," layer ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  lpf18 ( (global "connect") (freq "1000" ) (reso "30" ) (kdist "10000" ) (freqdev () ) )
"Implementation of a 3 pole sweepable resonant lowpass filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2 1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "lpf18(" global "," freq  freqdev "," reso "," kdist ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef  lowres ( (global "connect") (freq "1000" ) (reso "30" ) (freqdev () ) )
"lowres is a resonant lowpass filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "lowres(" global "," freq  freqdev "," reso ")" #\\ #\return )) )) 
(values tone1 ))) 

(PWGLdef  moogvcf ( (global "connect") (freq "1000" ) (reso ".2" ) (freqdev () ) )
"A digital emulation of the Moog diode ladder filter configuration."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "moogvcf2(" global "," freq  freqdev "," reso ")" #\\ #\return )) )) 
(values tone1 ))) 

(PWGLdef  moogladder ( (global "connect") (freq "1000" ) (reso ".2" ) (freqdev () ) )
"Moogladder is an new digital implementation of the Moog ladder."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "moogladder(" global "," freq  freqdev "," reso ")" #\\ #\return )) )) 
(values tone1 ))) 

(PWGLdef  reson ( (global "connect") (freq "1000" ) (band "50" ) (freqdev () ) )
"A second-order resonant filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "reson(" global "," freq  freqdev "," band ")" #\\ #\return )) )) 
(values tone1 ))) 

(PWGLdef  resonx ( (global "connect") (freq "1000" ) (band "50" ) (freqdev () ) (layer "4" ) )
"Emulates a stack of filters using the reson opcode."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2 1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "resonx(" global "," freq  freqdev "," band "," layer ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  butterbp ( (global "connect") (freq "1000" ) (band "50" ) (freqdev () ) )
"Implementation of a second-order band-pass Butterworth filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "butterbp(" global "," freq  freqdev "," band ")" #\\ #\return )) )) 
(values tone1 ))) 

(PWGLdef  butterbr ( (global "connect") (freq "1000" ) (band "50" ) (freqdev () ) )
"Implementation of a second-order band-reject Butterworth filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "butterbr(" global "," freq  freqdev "," band ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  butterhp ( (global "connect") (freq "1000" ) (freqdev () ) )
"Implementation of second-order high-pass Butterworth filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "butterhp(" global "," freq  freqdev  ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  butterlp ( (global "connect") (freq "1000" ) (freqdev () ) )
"Implementation of second-order low-pass Butterworth filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "butterlp(" global "," freq  freqdev  ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  dcblock ( (global "connect") )
"Implements a DC blocking filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1  ) ) 
(let* 
( (tone1 (remove nil (pw::list "dcblock(" global ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  dcblock2 ( (global "connect") )
"Implements a DC blocking filter with improved DC attenuation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1  ) ) 
(let* 
( (tone1 (remove nil (pw::list "dcblock2(" global ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  fofilter ( (global "connect") (freq "1000" ) (kris "0.007" ) (kdec "0.04" ) (freqdev () ) )
"Fofilter generates a stream of overlapping sinewave grains, when fed with a pulse train."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "fofilter(" global "," freq  freqdev "," kris "," kdec ")" #\\ #\return )) )) 
(values tone1 ))) 

