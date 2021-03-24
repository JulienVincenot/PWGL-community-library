(in-package :PWCSOUND)


;;****************************************
;;*************SPECTRAL***********************
;;****************************************
	


(PWGLdef  timestretch ( (ktime "1" ) (kamp "1" ) (kpitch "1" ) (filename () ) )"temposcal opcode,Phase-locked vocoder processing with onset detection/processing."(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '( 2 2 ) ) (let* ( (tone1 (remove nil (pw::list "temposcal:a(" ktime "," kamp "," kpitch ","'("ftgenonce(0, 0, 0, 1,") (concatenate 'string '(#\") filename '(#\")) '(", 0, 0, 1)") ",0" ")" #\\ #\return )) )) (values tone1 )))



(PWGLdef  analysis ( (global "ain") (fftsize "16384" ) (winshape "1" )  )
"pvsanal - generate an fsig from a mono audio source ain, using phase vocoder overlap-add analysis."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 1 1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "pvsanal(" global "," fftsize  "," fftsize '("/4") "," fftsize  "," winshape ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  resynthesis ( (global "connect")  )
"Resynthesise phase vocoder data (f-signal) using a FFT overlap-add."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "pvsynth(" global  ")" #\\ #\return )) )) 
(values tone1 ))) 

;;fsig pvsfreeze fsigin, kfreeza, kfreezf


(PWGLdef  pvsfreeze ( (global "connect") (kfreeza ".5" ) (kfreezf "1" )  )
"pvsfreeze — Freeze the amplitude and frequency time functions of a pv stream according to a control-rate trigger."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 1 1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "pvsfreeze(" global "," kfreeza "," kfreezf ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  pvswarp ( (global "connect") (kscal "1" ) (kshift "0" )  )
"Warp the spectral envelope of a PVS signal by means of shifting and scaling."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 1 1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "pvswarp(" global "," kscal "," kshift ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  pvscale ( (global "connect") (kscal "2" )   )
"Scale the frequency components of a pv stream, resulting in pitch shift. Output amplitudes can be optionally modified in order to attempt formant preservation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 ) ) 
(let* 
( (tone1 (remove nil (pw::list "pvscale(" global "," kscal  ")" #\\ #\return )) )) 
(values tone1 ))) 

(PWGLdef  pvsmix ( (ain1 "in1") (ain2 "in2" )   )
"Mix 'seamlessly' two pv signals. This opcode combines the most prominent components of two pvoc streams into a single mixed stream."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 ) ) 
(let* 
( (tone1 (remove nil (pw::list "pvsmix(" ain1 "," ain2  ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  pvsmooth ( (global "connect") (kacf ".01" ) (kfcf ".01" )  )
"Smooth the amplitude and frequency time functions of a pv stream using parallel 1st order lowpass IIR filters with time-varying cutoff frequency."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 1 1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "pvsmooth(" global "," kacf "," kfcf ")" #\\ #\return )) )) 
(values tone1 ))) 



(PWGLdef  pvsfilter ( (ain1 "in1") (ain2 "in2" )  (kdepth "0.5" ))
"Multiply amplitudes of a pvoc stream by those of a second pvoc stream, with dynamic scaling."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 1 1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "pvsfilter(" ain1 "," ain2 "," kdepth ")" #\\ #\return )) )) 
(values tone1 ))) 

(PWGLdef  pvsblur ( (global "connect") (ktime ".5" ) (idel ".9" )  )
"Average the amp-freq time functions of each analysis channel for a specified time (truncated to number of frames). As a side-effect the input pvoc stream will be delayed by that amount."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 1 1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "pvsblur(" global "," ktime "," idel ")" #\\ #\return )) )) 
(values tone1 ))) 




(PWGLdef  pvsmorph ( (ain1 "in1") (ain2 "in2" )  (kampint "0.5" ) (kfrqint "0.5" ) )
"Performs morphing (or interpolation) between two source fsigs."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 1 1 1) ) 
(let* 
( (tone1 (remove nil (pw::list "pvsmorph(" ain1 "," ain2 "," kampint "," kfrqint ")" #\\ #\return )) )) 
(values tone1 ))) 



(PWGLdef  pvsarp ( (ain "in")   (kbin "0.1" ) (kdepth "0.9" ) (kgain "2" ) )
"This opcode arpeggiates spectral components, by amplifying one bin and attenuating all the others around it. Used with an LFO it will provide a spectral arpeggiator similar to Trevor Wishart's CDP program specarp."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2 ) ) 
(let* 
( (tone1 (remove nil (pw::list "pvsarp(" ain "," kbin "," kdepth "," kgain ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef  pvsvoc ( (ain1 "in1")  (ain2 "in2") (kdepth "1" ) (kgain "1" ) )
"This opcode provides support for cross-synthesis of amplitudes and frequencies. It takes the amplitudes of one input fsig and combines with frequencies from another. It is a spectral version of the well-known channel vocoder"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2 ) ) 
(let* 
( (tone1 (remove nil (pw::list "pvsvoc(" ain1 "," ain2 "," kdepth "," kgain ")" #\\ #\return )) )) 
(values tone1 ))) 


