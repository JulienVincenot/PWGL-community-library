(in-package :PWCSOUND)



;;****************************************
;;****************************************
;;*************RESONATORS****************
;;****************************************
;;****************************************

(PWGLdef  streson ( (global "connect") (kfr "440" ) (ifdbgain "0.9" ) ( freqdev () ) )
"An audio signal is modified by a string resonator with variable fundamental frequency."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "streson(" global "," kfr  freqdev "," ifdbgain ")" #\\ #\return )) )) 
(values tone1 ))) 

(PWGLdef  wguide1 ( (global "connect") (kfr "440" ) (kcutoff "1000" ) (kfeedback ".8" ) ( freqdev () ))
"A simple waveguide model consisting of one delay-line and one first-order lowpass filter."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "wguide1(" global "," kfr  freqdev "," kcutoff freqdev "," kfeedback ")" #\\ #\return )) )) 
(values tone1 ))) 



(PWGLdef  wguide2 ( (global "connect") (kfr1 "220" ) (kfr2 "440" ) (kcutoff1 "10000" ) (kcutoff2 "5000" ) (kfeedback1 ".2" ) (kfeedback2 ".2" ) ( freqdev () ) )
"A model of beaten plate consisting of two parallel delay-lines and two first-order lowpass filters."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2 2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "wguide2(" global "," kfr1  freqdev "," kfr2  freqdev "," kcutoff1 freqdev "," kcutoff2 freqdev  "," kfeedback1 "," kfeedback2 ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  mode ( (global "connect") (kfr "440" ) (kq "1000" )  ( freqdev () ))
"Filters the incoming signal with the specified resonance frequency and quality factor. It can also be seen as a signal generator for high quality factor, with an impulse for the excitation. You can combine several modes to built complex instruments such as bells or guitar tables"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '( 2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "mode(" global "," kfr  freqdev "," kq  ")" #\\ #\return )) )) 
(values tone1 ))) 



(PWGLdef  membrane ( (global "connect") (kfr "440" ) (kq "1000" )  ( freqdev () ))
"Membrane"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '( 2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "membrane(" global "," kfr  freqdev "," kq  ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  chime_tube2 ( (global "connect") (kfr "440" ) (kq "1000" )  ( freqdev () ))
"chime_tube2"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '( 2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "chime_tube2(" global "," kfr  freqdev "," kq  ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  jegogan_bars ( (global "connect") (kfr "240" ) (kq "100" )  ( freqdev () ))
"jegogan_bars"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '( 2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "jegogan_bars(" global "," kfr  freqdev "," kq  ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  aluminum_bar ( (global "connect") (kfr "240" ) (kq "100" )  ( freqdev () ))
"aluminum_bar"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '( 2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "aluminum_bar(" global "," kfr  freqdev "," kq  ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  redwood ( (global "connect") (kfr "240" ) (kq "100" )  ( freqdev () ))
"redwood"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '( 2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "redwood(" global "," kfr  freqdev "," kq  ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  dahina_tabla ( (global "connect") (kfr "240" ) (kq "100" )  ( freqdev () ))
"dahina_tabla"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '( 2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "dahina_tabla(" global "," kfr  freqdev "," kq  ")" #\\ #\return )) )) 
(values tone1 )))

(PWGLdef  vibraphone1 ( (global "connect") (kfr "240" ) (kq "100" )  ( freqdev () ))
"vibraphone1"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '( 2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "vibraphone1(" global "," kfr  freqdev "," kq  ")" #\\ #\return )) )) 
(values tone1 )))

(PWGLdef  wine_glass ( (global "connect") (kfr "240" ) (kq "100" )  ( freqdev () ))
"wine_glass"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '( 2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "wine_glass(" global "," kfr  freqdev "," kq  ")" #\\ #\return )) )) 
(values tone1 )))
  

(PWGLdef  spinel_sphere ( (global "connect") (kfr "240" ) (kq "100" )  ( freqdev () ))
"spinel_sphere"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '( 2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "spinel_sphere(" global "," kfr  freqdev "," kq  ")" #\\ #\return )) )) 
(values tone1 )))

(PWGLdef  small_handbell ( (global "connect") (kfr "240" ) (kq "100" )  ( freqdev () ))
"small_handbell"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '( 2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "small_handbell(" global "," kfr  freqdev "," kq  ")" #\\ #\return )) )) 
(values tone1 )))

(PWGLdef  tibetan_bowl ( (global "connect") (kfr "240" ) (kq "100" )  ( freqdev () ))
"tibetan_bowl"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '( 2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "tibetan_bowl(" global "," kfr  freqdev "," kq  ")" #\\ #\return )) )) 
(values tone1 )))

(PWGLdef  pot_lit ( (global "connect") (kfr "240" ) (kq "100" )  ( freqdev () ))
"pot_lit"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '( 2 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "pot_lit(" global "," kfr  freqdev "," kq  ")" #\\ #\return )) )) 
(values tone1 )))



