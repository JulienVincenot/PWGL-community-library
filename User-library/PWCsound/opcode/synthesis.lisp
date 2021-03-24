(in-package :PWCSOUND)

;;****************************************
;;****************************************
;;*************OSCILLATORS***********************
;;****************************************
;;****************************************






(PWGLdef powershape ( (in1 "connect") (kshape "10") )
"Waveshapes a signal by raising it to a variable exponent."

(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "powershape(" in1  ","  kshape  ")" )) )
) 
(values tone1  ))) 




(PWGLdef distort ( (in1 "connect") (kdist "1")  (ifn () ) )
"Distort an audio signal via waveshaping and optional clipping."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "distort(" in1  ","  kdist "," ifn  ")" )) )
) 
(values tone1  ))) 



(PWGLdef distort1 ( (in1 "connect") (kpregain "2")  (kpostgain ".5" ) (kshape1 "0") (kshape2 "0")  )
"Modified hyperbolic tangent distortion."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "distort1(" in1  ","  kpregain ","  kpostgain ","  kshape1 ","  kshape2  ")" )) )
) 
(values tone1  ))) 



 
(PWGLdef hsboscil ((kamp ".4")  (ktone "1") (kbrite "0.3") (ibasfreq "200") (iwfn "gisine")  (ampdev () ) (freqdev () ) )
"An oscillator which takes tonality and brightness as arguments, relative to a base frequency."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 2 1  ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "hsboscil(" kamp ampdev  "," ktone  "," kbrite "," ibasfreq freqdev "," iwfn ",giblend"   ")" #\\ #\return )) )
)
(values ad1 )))




(PWGLdef dust ( (iamp ".6") (dens "1000") (ampdev () ) (densdev () ))
"Generates random impulses from 0 to 1."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "dust:a(" iamp ampdev "," dens densdev ")" #\\ #\return )) )
)
(values ad1 )))

(PWGLdef dust2 ( (iamp ".6") (dens "1000") (ampdev () ) (densdev () ))
"Generates random impulses from -1 to 1."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "dust2:a(" iamp ampdev "," dens densdev ")" #\\ #\return )) )
)
(values ad1 )))


(PWGLdef fractalnoise ( (iamp ".6") (kbeta "0") (ampdev () ) (betadev () ))
"A fractal noise generator implemented as a white noise filtered by a cascade of 15 first-order filters.kbeta = 0 to 2"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "fractalnoise(" iamp ampdev "," kbeta betadev ")" #\\ #\return )) )
)
(values ad1 )))





(PWGLdef noise ( (iamp ".6") (kbeta "0") (ampdev () ) (betadev () ))
"A white noise generator with an IIR lowpass filter.kbeta = -1 to 1"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "noise(" iamp ampdev "," kbeta betadev ")" #\\ #\return )) )
)
(values ad1 )))


(PWGLdef saw ( (iamp ".6") (ifreq "220") (ampdev () ) (freqdev () ))
"Vco saw"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "vcosaw(" iamp ampdev "," ifreq freqdev ")" #\\ #\return )) )
)
(values ad1 )))


(PWGLdef square ( (iamp ".6") (ifreq "220") (kpw ".5") (ampdev () ) (freqdev () ))
"Vco saw"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "vcosquare(" iamp ampdev "," ifreq freqdev "," kpw ")" #\\ #\return )) )
)
(values ad1 )))

;;Phasors


(PWGLdef phasor-a ( (xcps "1") (iphs "0")  (freqdev () ))
"Produce a normalized moving phase value."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "phasor:a(" xcps freqdev "," iphs ")" #\\ #\return )) )
)
(values ad1 )))


(PWGLdef phasor-k ( (xcps "1") (iphs "0")  (freqdev () ))
"Produce a normalized moving phase value."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "phasor:k(" xcps freqdev "," iphs ")" #\\ #\return )) )
)
(values ad1 )))



(PWGLdef table ( (andx "1") (ifn "0")  (ixmode "0" ) (ixoff "0" ) (iwrap "0" ) )
"Accesses table values by direct indexing."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "table(" andx "," ifn "," ixmode "," ixoff "," iwrap ")" #\\ #\return )) )
)
(values ad1 )))


(PWGLdef tablei ( (andx "1") (ifn "0")  (ixmode "0" ) (ixoff "0" ) (iwrap "0" ) )
"Accesses table values by direct indexing with linear interpolation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "tablei(" andx "," ifn "," ixmode "," ixoff "," iwrap ")" #\\ #\return )) )
)
(values ad1 )))



;;BASIC



(PWGLdef oscbnk ( (kcps "220")  (kamd "0")  (kfmd "p5*0.02")  (kpmd "0") (iovrlap "100")  (iseed "200")  (kl1minf "0.1")  (kl1maxf "0.2")
      (kl2minf "0")  (kl2maxf "0")  (ilfomode "144")  (keqminf "0")  (keqmaxf "6000")  (keqminl "0") (keqmaxl "0")
      (keqminq "1") (keqmaxq "1")  (ieqmode "2")  (kfn "gisaw")   (il1fn "gen07")  (il2fn "0")  (ieqffn "gen05")
      (ieqlfn "gen05") (ieqqfn "gen05") )
"oscbnk"
(:class 'ccl::PWGL-values-box :outputs 1  :w 1  :r 0.498039 :g 1 :b 0.831373 :groupings '(5 5 5 5 4 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "oscbnk(" kcps "," kamd  "," kfmd  "," kpmd "," iovrlap  "," iseed  "," kl1minf  "," kl1maxf  "," 
      kl2minf  "," kl2maxf  "," ilfomode  "," keqminf  "," keqmaxf  "," keqminl  "," keqmaxl  ","
      keqminq  "," keqmaxq  "," ieqmode  "," kfn "," il1fn "," il2fn  "," ieqffn  ","
      ieqlfn "," ieqqfn  ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef sine ( (iamp ".6") (ifreq "220") (ampdev () ) (freqdev () ))
"poscil, High precision oscillator"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "poscil(" iamp ampdev "," ifreq freqdev ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef osciln ( (iamp ".6") (ifreq "220") (ifn "0") (itimes "1") (ampdev () ) (freqdev () ))
"Accesses table values at a user-defined frequency."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "osciln(" iamp ampdev "," ifreq freqdev "," ifn "," itimes ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef poscil ( (iamp ".6") (ifreq "220") (ifn "p6") (ampdev () ) (freqdev () ))
"poscil, High precision oscillator"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "poscil(" iamp ampdev "," ifreq freqdev ","  ifn ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef oscils ( (iamp ".6") (ifreq "220") (ph "0") (iflg "1") (ampdev () ) (freqdev () ))
"Simple, fast sine oscillator, that uses only one multiply, and two add operations to generate one sample of output, and does not require a function table."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "oscils(" iamp ampdev "," ifreq freqdev "," ph "," iflg ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef poscil-ph ( (iamp ".6") (ifreq "220") (ifn "p6") (ph "0") (ampdev () ) (freqdev () ))
"poscil, High precision oscillator"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "poscil(" iamp ampdev "," ifreq freqdev ","  ifn  "," ph ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef poscil-k ( (iamp ".6") (ifreq "220") (ifn "p6") (ph ".5") (ampdev () ) (freqdev () ))
"poscil, High precision oscillator, krate signal"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "poscil:k(" iamp ampdev "," ifreq freqdev ","  ifn  "," ph ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef oscil ( (iamp ".6") (ifreq "220") (ifn "p6") (ampdev () ) (freqdev () ))
"oscil reads table ifn sequentially and repeatedly at a frequency xcps. The amplitude is scaled by xamp"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "oscil(" iamp ampdev "," ifreq freqdev ","  ifn ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef oscil3 ( (iamp ".6") (ifreq "220") (ifn "p6") (ampdev () ) (freqdev () ))
"A simple oscillator with cubic interpolation"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "oscil3(" iamp ampdev "," ifreq freqdev ","  ifn ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef oscili ( (iamp ".6") (ifreq "220") (ifn "p6") (ampdev () ) (freqdev () ))
"A simple oscillator with linear interpolation"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "oscili(" iamp ampdev "," ifreq freqdev ","  ifn ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef poscil3 ( (iamp ".6") (ifreq "220") (ifn "p6") (ampdev () ) (freqdev () ))
"High precision oscillator with cubic interpolation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "poscil3(" iamp ampdev "," ifreq freqdev ","  ifn ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef buzz ( (iamp ".6") (ifreq "220") (knh "1") (ifn "p6") (ampdev () ) (freqdev () ))
"Output is a set of harmonically related sine partials."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "buzz(" iamp ampdev "," ifreq freqdev "," knh "," ifn ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef gbuzz ( (iamp ".6") (ifreq "220") (knh "1") (klh "1")  (ampdev () ) (freqdev () ))
"Output is a set of harmonically related sine partials."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "gbuzz(" iamp ampdev "," ifreq freqdev "," knh "," klh "," '("0.5,gicosine")  ")" #\\ #\return )) )
)
(values ad1 )))


;;RAND noise
(PWGLdef rand ( (iamp ".6")  (ampdev () ) )
"rand, generates a controlled random number series.
Description : Output is a controlled random number series between -amp and +amp
output  : syntax (a1 rand iamp)"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "rand(" iamp ampdev ",rnd(1))" #\\ #\return )) )
)
(values ad1 ))) 




;;FM
(PWGLdef foscili ((iamp ".6") (ifreq "220") (kcar "1") (kmod "2") (kindx "1") (ifn "p6") (ampdev () ) (freqdev () ) )
"Basic frequency modulated oscillator with linear interpolation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "foscili(" iamp ampdev "," ifreq freqdev "," kcar "," kmod "," kindx "," ifn ")" #\\ #\return )) )
)
(values ad1 ))) 


;Phase Modulation
(PWGLdef phasemod ((iamp ".6")  (kcar "1") (kmod "220") (kindx "1") (kfback ".01")  (ampdev () ) (freqdev () ) )
"phase modulation synthesis"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 2 2  ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "phasemod(" iamp ampdev  "," kcar freqdev "," kmod "," kindx "," kfback  ")" #\\ #\return )) )
)
(values ad1 )))


(PWGLdef wterrain ((iamp ".6") (ifreq "220") (kxcenter "1") (kycenter "1") (kxradius "1") (kyradius "1") (itabx ()) (itaby ()) (ampdev () ) (freqdev () ) )
"A simple wave-terrain synthesis opcode"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "wterrain(" iamp ampdev "," ifreq freqdev "," kxcenter "," kycenter "," kxradius "," kyradius "," itabx "," itaby ")" #\\ #\return )) )
)
(values ad1 ))) 


;;IMPULSES
(PWGLdef mpulse ((iamp ".6") (itime ".5") (ampdev () ) (timedev () ))
"Generates a set of impulses of amplitude kamp separated by kintvl seconds (or samples if kintvl is negative)"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "mpulse(" iamp ampdev "," itime timedev ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef prepiano ((ifreq "60") (iNS "3")  (iD "10") (iK "1") (iT30 "3") (iB "0.002") (kbcl "2") (kbcr "2") (imass "1") (ifreq2 "5000") (iinit "-0.01") (ipos "0.09") (ivel "40") (isfreq "0") (isspread "0.1") )
"Audio output is a tone similar to a piano string, prepared with a number of rubbers and rattles. The method uses a physical model developed from solving the partial differential equation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 2 2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "prepiano:a(" ifreq "," iNS "," iD "," iK "," iT30 "," iB "," kbcl "," kbcr "," imass "," ifreq2 "," iinit "," ipos "," ivel "," isfreq "," isspread ",girattle,girubber" ")" #\\ #\return )) )
)
(values ad1 )))





;;PLUCK
(PWGLdef pluck ((iamp ".6") (ifreq "220") (icps "440") (ampdev () ) (freqdev () ))
"pluck, produces a naturally decaying plucked string or drum sound.
Audio output is a naturally decaying plucked string or drum sound based on the Karplus-Strong algorithms."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "pluck(" iamp ampdev "," ifreq freqdev "," icps "," "0" "," "1" ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef pluck2 ((iamp ".6") (ifreq "220") (icps "440") (ifn "0") (imeth "1") (iparm1 "0") (iparm2 "0") (ampdev () ) (freqdev () ))
"pluck,snare with opzional parameters.
Audio output is a naturally decaying plucked string or drum sound based on the Karplus-Strong algorithms."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "pluck(" iamp ampdev "," ifreq freqdev "," icps "," ifn "," imeth "," iparm1 "," iparm2 ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef repluck ((iplk "0.75") (iamp ".6") (ifreq "220") (krefl "0.95") (kpick "0.6") (axcite () ) (ampdev () ) (freqdev () ))
"repluck is an implementation of the physical model of the plucked string. A user can control the pluck point, the pickup point, the filter, and an additional audio signal, axcite. axcite is used to excite the 'string'. Based on the Karplus-Strong algorithm."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "repluck(" iplk "," iamp ampdev "," ifreq freqdev "," kpick "," krefl "," axcite ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef wgbow ( (iamp ".6") (ifreq "220") (kpres "3") (krat "0.23") (kvibf "6.12723" ) (kvamp ".01" )  (ifn "gisine" ) (ampdev () ) )
"Audio output is a tone similar to a bowed string, using a physical model developed from Perry Cook, but re-coded for Csound."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "wgbow("  iamp ampdev "," ifreq  "," kpres "," krat "," kvibf "," kvamp "," ifn ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef wgbowedbar ( (iamp ".6") (ifreq "220") (kpos "1") (kbowpres ".3") (kgain "0.995" )   (freqdev () ) (ampdev () ) )
"A physical model of a bowed bar, belonging to the Perry Cook family of waveguide instruments"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "wgbowedbar("  iamp ampdev "," ifreq freqdev "," kpos "," kbowpres "," kgain ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef wgclar ( (iamp ".6") (ifreq "220") (kstiff "-0.3") (iatt "0.1") (idetk "0.1") (kgain "0.2" )  (kvib "5.735" ) (kvamp "0.1")
 (ampdev () ) )
"Audio output is a tone similar to a clarinet, using a physical model developed from Perry Cook, but re-coded for Csound."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(3 3 3) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "wgclar("  iamp ampdev "," ifreq  "," kstiff "," iatt "," idetk "," kgain ","
 kvib "," kvamp ",gisine" ")" #\\ #\return )) )
)
(values ad1 ))) 





(PWGLdef wgflute ( (iamp ".6") (ifreq "220") (kjet "0.1") (iatt "0.1") (idetk "0.1") (kgain "0.2" )  (kvib "5.735" ) (kvamp "0.1")
 (ampdev () ) )
"Audio output is a tone similar to a flute, using a physical model developed from Perry Cook, but re-coded for Csound."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(3 3 3) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "wgflute("  iamp ampdev "," ifreq  "," kjet "," iatt "," idetk "," kgain ","
 kvib "," kvamp ",gisine" ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef wgpluck ( (iamp ".6") (ifreq "220") (kpick "0.5") (iplk "0") (idamp "10") (ifilt "1000" ) )
"A high fidelity simulation of a plucked string, using interpolating delay-lines."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(3 3) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "wgpluck(" ifreq "," iamp  "," kpick "," iplk "," idamp "," ifilt ",oscili(1,1,gisine)"
  ")" #\\ #\return )) )
)
(values ad1 ))) 





(PWGLdef wgpluck2 ( (kamp ".6") (ifreq "220") (kpick "0.75") (iplk "0.75") (krefl"0.5")  )
"wgpluck2 is an implementation of the physical model of the plucked string, with control over the pluck point, the pickup point and the filter. Based on the Karplus-Strong algorithm."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "wgpluck2(" iplk "," kamp "," ifreq "," kpick "," krefl ")" #\\ #\return )) )
)
(values ad1 )))


;;fm
(PWGLdef fmb3 ((iamp ".6") (ifreq "220") (kc1 "5") (kc2 "5") (depth "0.1" ) (rate "6" ) (ampdev () ) )
"Uses FM synthesis to create a Hammond B3 organ sound.It comes from a family of FM sounds, all using 4 basic oscillators and various architectures, as used in the TX81Z synthesizer."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "fmb3(" iamp ampdev "," ifreq "," kc1 "," kc2 "," depth "," rate  ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef fmbell ((iamp ".6") (ifreq "220") (kc1 "5") (kc2 "5") (depth "0.005" ) (rate "6" ) (ampdev () ) )
"Uses FM synthesis to create a tublar bell sound. It comes from a family of FM sounds, all using 4 basic oscillators and various architectures, as used in the TX81Z synthesizer."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "fmbell(" iamp ampdev "," ifreq "," kc1 "," kc2 "," depth "," rate  ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef fmpercfl ((iamp ".6") (ifreq "220") (kc1 "5") (kc2 "5") (depth "0.01" ) (rate "6" ) (ampdev () ) )
"Uses FM synthesis to create a percussive flute sound. It comes from a family of FM sounds, all using 4 basic oscillators and various architectures, as used in the TX81Z synthesizer."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "fmpercfl(" iamp ampdev "," ifreq "," kc1 "," kc2 "," depth "," rate  ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef fmvoice ((iamp ".6") (ifreq "220") (kc1 "5") (kc2 "5") (depth "0.005" ) (rate "6" ) (ampdev () ) )
"FM Singing Voice Synthesis."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "fmvoice(" iamp ampdev "," ifreq "," kc1 "," kc2 "," depth "," rate  ")" #\\ #\return )) )
)
(values ad1 ))) 




;;GENDY
(PWGLdef gendy ((kamp ".6") (kampdist "1") (kdurdist "1") (kadpar "1") (kddpar "1" ) (kminfreq "60" ) (kmaxfreq "2000" ) (kampscl "0.5" ) (kdurscl "0.5" )  (ampdev () ) (freqdev () ))
"Implementation of the Generation Dynamique Stochastique, a dynamic stochastic approach to waveform synthesis conceived by Iannis Xenakis."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "gendy:a(" kamp ampdev "," kampdist "," kdurdist "," kadpar "," kddpar "," kminfreq freqdev "," kmaxfreq 
freqdev "," kampscl "," kdurscl ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef gendyc ((kamp ".6") (kampdist "1") (kdurdist "1") (kadpar "1") (kddpar "1" ) (kminfreq "60" ) (kmaxfreq "2000" ) (kampscl "0.5" ) (kdurscl "0.5" )  (ampdev () ) (freqdev () ))
"Implementation with cubic interpolation of the Génération Dynamique Stochastique (GENDYN), a dynamic stochastic approach to waveform synthesis conceived by Iannis Xenakis."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "gendyc:a(" kamp ampdev "," kampdist "," kdurdist "," kadpar "," kddpar "," kminfreq freqdev "," kmaxfreq 
freqdev "," kampscl "," kdurscl ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef gendyx ((kamp ".6") (kampdist "1") (kdurdist "1") (kadpar "1") (kddpar "1" ) (kminfreq "60" ) (kmaxfreq "2000" ) (kampscl "0.5" ) (kdurscl "0.5" )  (kcurveup "4" ) (kcurvedown "0.5" ) (ampdev () ) (freqdev () ))
"gendyx (gendy eXtended) is an implementation of the Génération Dynamique Stochastique (GENDYN), a dynamic stochastic approach to waveform synthesis conceived by Iannis Xenakis, using curves instead of segments."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2 2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "gendyc:a(" kamp ampdev "," kampdist "," kdurdist "," kadpar "," kddpar "," kminfreq freqdev "," kmaxfreq 
freqdev "," kampscl "," kdurscl "," kcurveup "," kcurvedown ")" #\\ #\return )) )
)
(values ad1 )))


;;granular
(PWGLdef diskgrain ((filename () ) (kamp ".5") (timescale ".1") (pitchscale "1") (grainsize ".04") (ifun () ) )
"diskgrain implements synchronous granular synthesis. The source sound for the grains is obtained by reading a soundfile containing the samples of the source waveform."
(:class 'ccl::PWGL-values-box :outputs 1 :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "diskgrain:a(" (concatenate 'string '(#\") filename '(#\")) "," kamp "," 
"2/" grainsize "," pitchscale "," grainsize "," "1/2*" timescale "," ifun ",2" ")" #\\ #\return )) )
) 
(values ad1   ))) 


;FOF2
(PWGLdef fof ((xamp ".6") (xfund "220") (xform "510")  (kband "30")  (itotdur "p3") (kgliss "1") (ampdev () ) (freqdev () ) )
"Audio output is a succession of sinusoid bursts initiated at frequency xfund with a spectral peak at xform. For xfund above 25 Hz these bursts produce a speech-like formant with spectral characteristics determined by the k-input parameters. For lower fundamentals this generator provides a special form of granular synthesis."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "fof2(" xamp ampdev "," xfund freqdev"," xform "," "0" "," kband ",0.01,0.03,0.01,100,gisine,gifof2" "," itotdur
",0" "," kgliss  ")" #\\ #\return )) )
)
(values ad1 )))




;;PARTIKKEL
(PWGLdef partikkel ((kamp ".6") (kwavfreq "220") (krate "10") (ksize "1") (krndmask "0") (iwave1 ()) 
(iwave2 ()) (iwave3 ()) (iwave4 ()) (ktransp1 "1") (ktransp2 "1") (ktransp3 "1") (ktransp4 "1") (ampdev () ) (freqdev () ) )
"partikkel was conceived after reading Curtis Roads' book-Microsound, and the goal was to create an opcode that was capable of all time-domain varieties of granular synthesis described in this book. The idea being that most of the techniques only differ in parameter values, and by having a single opcode that can do all varieties of granular synthesis makes it possible to interpolate between techniques. Granular synthesis is sometimes dubbed particle synthesis, and it was thought apt to name the opcode partikkel to distinguish it from other granular opcodes.
Some of the input parameters to partikkel is table numbers, pointing to tables where values for the -per grain- parameter changes are stored. partikkel can use single-cycle or complex (e.g. sampled sound) waveforms as source waveforms for grains. Each grain consists of a mix of 4 source waveforms. Individual tuning of the base frequency can be done for each of the 4 source waveforms. Frequency modulation inside each grain is enabled via an auxillary audio input (awavfm). Trainlet synthesis is available, and trainlets can be mixed with wavetable based grains. Up to 8 separate audio outputs can be used."

(:class 'ccl::PWGL-values-box :outputs 1  :w 0.6  :r 0.498039 :g 1 :b 0.831373 :groupings '(3 4 4 4 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "microsound(" kamp ampdev "," kwavfreq freqdev "," krate "," ksize "," krndmask
"," '("giattack,gidecay,gicosine") "," iwave1 "," iwave2 "," iwave3 "," iwave4 "," ktransp1 "," ktransp2 "," ktransp3 "," ktransp4                              ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef vosim ((kamp ".6")  (kFund "220")  (kForm "1000") (kDecay ".4") (kPulseCount "1") (kPulseFactor "1") (ifn ()) (ampdev ()) (freqdev ()) )
"This opcode produces a simple vocal simulation based on glottal pulses with formant characteristics. Output is a series of sound events, where each event is composed of a burst of squared sine pulses followed by silence. The VOSIM (VOcal SIMulation) synthesis method was developed by Kaegi and Tempelaars in the 1970."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "vosim(" kamp ampdev "," kFund freqdev "," kForm "," kDecay "," kPulseCount "," kPulseFactor "," ifn ")" #\\ #\return )) )
)
(values ad1 )))




(PWGLdef syncloop ((kamp ".5") (kfreq ".1") (kpitch ".8") (ksize "0.04") (krate "2") (kstart ".5") (kend ".9") (filename ()) (ifun2 ())  (iolaps "100") (ampdev ()) )
"syncloop is a variation on syncgrain, which implements synchronous granular synthesis. syncloop adds loop start and end points and an optional start position. Loop start and end control grain start positions, so the actual grains can go beyond the loop points (if the loop points are not at the extremes of the table), enabling seamless crossfading"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "syncloop(" kamp ampdev "," kfreq "," kpitch "," ksize "," krate "," kstart "," kend "," '("ftgenonce(0,0,0,1,") (concatenate 'string '(#\") filename '(#\")) '(",0,0,1)") ","  ifun2 ","  iolaps ")" #\\ #\return )) )
)
(values ad1 )))





(PWGLdef syncgrain ((kamp ".5") (kfreq ".1") (kpitch ".8") (ksize "0.04") (krate "2") (filename ()) (ifun2 ())  (iolaps "100") (ampdev ()) )
"syncgrain implements synchronous granular synthesis. The source sound for the grains is obtained by reading a function table containing the samples of the source waveform. For sampled-sound sources, GEN01 is used. syncgrain will accept deferred allocation tables."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 2 2 1  ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "syncgrain(" kamp ampdev "," kfreq "," kpitch "," ksize "," krate "," '("ftgenonce(0,0,0,1,") (concatenate 'string '(#\") filename '(#\")) '(",0,0,1)") ","  ifun2 ","  iolaps ")" #\\ #\return )) )
)
(values ad1 )))



(PWGLdef grain ((xamp ".5") (xpitch "220") (xdens "4") (kampoff ".1") (kpitchoff "880") (kgdur ".05") (igfn ())  (iwfn () ) (imgdur ".5") (ampdev ()) (freqdev ()) )
"Generates granular synthesis textures."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 2 2 2 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "grain(" xamp ampdev  "," xpitch freqdev  "," xdens "," kampoff ampdev "," kpitchoff freqdev  "," kgdur "," igfn ","  iwfn "," imgdur ")" #\\ #\return )) )
)
(values ad1 )))



(PWGLdef grain3 ((kcps "220")  (krand "10") (kgdur "0.3") (kdens "20") (kfn "gisine") (iwfn "gibartlett")  (imode "64") (freqdev () ) )
"Generate granular synthesis textures with more user control."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 2 2  ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "grain3(" kcps freqdev ",0.5," krand ",.05," kgdur "," kdens ",100," kfn "," iwfn ",0,-(randomi:k(0.02,0.5,5)),2,"
imode         ")" #\\ #\return )) )
)
(values ad1 )))





(PWGLdef bamboo ((iamp ".6") (itime "0.01") (ampdev () ) )
"bamboo is a semi-physical model of a bamboo sound. It is one of the PhISEM percussion opcodes. PhISEM (Physically Informed Stochastic Event Modeling) is an algorithmic approach for simulating collisions of multiple independent sound producing objects"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "bamboo(" iamp ampdev "," itime  ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef cabasa ((iamp ".6") (itime "0.01") (ampdev () ) )
"cabasa is a semi-physical model of a cabasa sound. It is one of the PhISEM percussion opcodes. PhISEM (Physically Informed Stochastic Event Modeling) is an algorithmic approach for simulating collisions of multiple independent sound producing objects"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "cabasa(" iamp ampdev "," itime  ")" #\\ #\return )) )
)
(values ad1 )))



(PWGLdef crunch ((iamp ".6") (itime "0.01") (ampdev () ) )
"crunch is a semi-physical model of a crunch sound. It is one of the PhISEM percussion opcodes. PhISEM (Physically Informed Stochastic Event Modeling) is an algorithmic approach for simulating collisions of multiple independent sound producing objects"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "crunch(" iamp ampdev "," itime  ")" #\\ #\return )) )
)
(values ad1 )))


(PWGLdef dripwater ((iamp ".6") (itime "0.01") (ampdev () ) )
"dripwater is a semi-physical model of a dripwater sound. It is one of the PhISEM percussion opcodes. PhISEM (Physically Informed Stochastic Event Modeling) is an algorithmic approach for simulating collisions of multiple independent sound producing objects"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "dripwater(" iamp ampdev "," itime  ")" #\\ #\return )) )
)
(values ad1 )))


(PWGLdef guiro ((iamp ".6") (itime "0.01") (ampdev () ) )
"guiro is a semi-physical model of a guiro sound. It is one of the PhISEM percussion opcodes. PhISEM (Physically Informed Stochastic Event Modeling) is an algorithmic approach for simulating collisions of multiple independent sound producing objects"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "guiro(" iamp ampdev "," itime  ")" #\\ #\return )) )
)
(values ad1 )))


(PWGLdef sandpaper ((iamp ".6") (itime "0.01") (ampdev () ) )
"sandpaper is a semi-physical model of a sandpaper sound. It is one of the PhISEM percussion opcodes. PhISEM (Physically Informed Stochastic Event Modeling) is an algorithmic approach for simulating collisions of multiple independent sound producing objects"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "sandpaper(" iamp ampdev "," itime  ")" #\\ #\return )) )
)
(values ad1 )))


(PWGLdef sekere ((iamp ".6") (itime "0.01") (ampdev () ) )
"sekere is a semi-physical model of a sekere sound. It is one of the PhISEM percussion opcodes. PhISEM (Physically Informed Stochastic Event Modeling) is an algorithmic approach for simulating collisions of multiple independent sound producing objects"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "sekere(" iamp ampdev "," itime  ")" #\\ #\return )) )
)
(values ad1 )))



(PWGLdef shaker ((iamp ".6") (itime "0.01") (ampdev () ) )
"shaker is a semi-physical model of a shaker sound. It is one of the PhISEM percussion opcodes. PhISEM (Physically Informed Stochastic Event Modeling) is an algorithmic approach for simulating collisions of multiple independent sound producing objects"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "shaker(" iamp ampdev "," itime  ")" #\\ #\return )) )
)
(values ad1 )))



(PWGLdef stix ((iamp ".6") (itime "0.01") (ampdev () ) )
"stix is a semi-physical model of a stix sound. It is one of the PhISEM percussion opcodes. PhISEM (Physically Informed Stochastic Event Modeling) is an algorithmic approach for simulating collisions of multiple independent sound producing objects"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "stix(" iamp ampdev "," itime  ")" #\\ #\return )) )
)
(values ad1 )))



(PWGLdef sleighbells ((iamp ".6") (itime "0.01") (ampdev () ) )
"sleighbells is a semi-physical model of a sleighbells sound. It is one of the PhISEM percussion opcodes. PhISEM (Physically Informed Stochastic Event Modeling) is an algorithmic approach for simulating collisions of multiple independent sound producing objects"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "sleighbells(" iamp ampdev "," itime  ")" #\\ #\return )) )
)
(values ad1 )))


(PWGLdef tambourine ((iamp ".6") (itime "0.01") (ampdev () ) )
"tambourine is a semi-physical model of a tambourine sound. It is one of the PhISEM percussion opcodes. PhISEM (Physically Informed Stochastic Event Modeling) is an algorithmic approach for simulating collisions of multiple independent sound producing objects"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "tambourine(" iamp ampdev "," itime  ")" #\\ #\return )) )
)
(values ad1 )))






;;SCANNED

(PWGLdef simple-scan ( (iamp ".6") (ifreq "110") (irate ".5") (ampdev () ) (freqdev () ))
"Scanned synthesis"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "scanned(" iamp ampdev "," ifreq freqdev "," irate "," '("gitraj,giinit,givel,gimass,gispring,giforce,gidamp") ")" #\\ #\return )) )
)
(values ad1 )))



(PWGLdef scan-injection ( (iamp ".6") (ifreq "110") (irate ".5") (ain ()) (ampdev () ) (freqdev () ))
"Scanned synthesis"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "scanned2(" iamp ampdev "," ifreq freqdev "," irate "," '("gitraj,giinit,givel,gimass,gispring,giforce,gidamp,") ain ")" #\\ #\return )) )
)
(values ad1 )))


;;;***********************************************************************************
;;;*******************************STK************************************************

(PWGLdef Shakers ( (iamp ".6") (ifreq "220") (kenerg "80") (kdecay "100") (kshake "2") (knum "2") (kres "100")  (kinstr "3"))
"STKShakers is an instrument that simulates environmental sounds or collisions of multiple independent sound producing objects."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKShakers(" ifreq "," iamp ",2," kenerg ",4," kdecay ",128," kshake ",11," knum ",1," kres ",1071," kinstr  ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef Saxofony ( (iamp ".6") (ifreq "220") (kstiff "80") (kapert "100") (kblow "0") (knoise "10") (klfo "2") (klfodepth "2") (kbreath "100"))
"STKSaxofony is a faux conical bore reed instrument"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "STKSaxofony(" ifreq "," iamp ",2," kstiff ",26," kapert ",11," kblow ",4," knoise ",29," klfo ",1," klfodepth ",128," kbreath ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef Rhodey ( (iamp ".6") (ifreq "220") (kmod "80") (kcross "100") (klfo "8") (klfodepth "8") (kadsr "100"))
"This opcode implements an instrument based on two simple FM Pairs summed together, also referred to as algorithm 5 of the Yamaha TX81Z"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKRhodey(" ifreq "," iamp ",2," kmod ",4," kcross ",11," klfo ",1," klfodepth ",128," kadsr ")" #\\ #\return )) )
)
(values ad1 )))




(PWGLdef Resonate ( (iamp ".6") (ifreq "220") (kfreq "80") (kpole "100") (knotch "80") (kzero "80") (kenv "100"))
"STKResonate is a noise driven formant filter. This instrument contains a noise source, which excites a biquad resonance filter, with volume controlled by an ADSR."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKResonate(" ifreq "," iamp ",2," kfreq ",4," kpole ",11," knotch ",1," kzero ",128," kenv ")" #\\ #\return )) )
)
(values ad1 ))) 





(PWGLdef PercFlut ( (iamp ".6") (ifreq "220") (kmod "80") (kcross "100") (klfo "2") (klfodepth "2") (kadsr "100"))
"STKPercFlut is a percussive flute FM synthesis instrument, also referred to as algorithm 6 of the TX81Z."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKPercFlut(" ifreq "," iamp ",2," kmod ",4," kcross ",11," klfo ",1," klfodepth ",128," kadsr ")" #\\ #\return )) )
)
(values ad1 ))) 





(PWGLdef Moog ( (iamp ".6") (ifreq "220") (kq "80") (krate "10") (klfo "2") (klfodepth "2") (kvol "100"))
"STKMoog produces moog-like swept filter sounds, using one attack wave, one looped wave, and an ADSR envelope and adds two sweepable formant filters"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKMoog(" ifreq "," iamp ",2," kq ",4," krate ",11," klfo ",1," klfodepth ",128," kvol ")" #\\ #\return )) )
)
(values ad1 )))





(PWGLdef ModalBar ( (iamp ".6") (ifreq "220") (khard "80") (kpos "100") (klfo "2") (klfodepth "2") (kmix "100") (kvol "120") (kinstr "3"))
"This opcode is a resonant bar instrument.It has a number of different struck bar instruments"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKModalBar(" ifreq "," iamp ",2," khard ",4," kpos ",11," klfo ",1," klfodepth ",8," kmix ",128," kvol ",16," kinstr  ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef Mandolin ( (iamp ".6") (ifreq "220") (kbody "80") (kpos "100") (ksus "80") (kdetune "80") (kmic "100"))
"STKMandolin produces mamdolin-like sounds, using commuted synthesis techniques to model a mandolin instrument."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKMandolin(" ifreq "," iamp ",2," kbody ",4," kpos ",11," ksus ",1," kdetune ",128," kmic ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef HevyMetl ( (iamp ".6") (ifreq "220") (kmod "80") (kcross "100") (klfo "2") (klfodepth "2") (kadsr "100"))
"STKHevyMetl produces metal sounds. It has 3 carriers and a common modulator, also referred to as algorithm 6 of the TX81Z."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKHevyMetl(" ifreq "," iamp ",2," kmod ",4," kcross ",11," klfo ",1," klfodepth ",128," kadsr ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef FMVoices ( (iamp ".6") (ifreq "220") (kvowel "80") (kspec "100") (klfo "2") (klfodepth "2") (kadsr "100"))
"STKFMVoices is a singing FM synthesis instrument. It has 3 carriers and a common modulator, also referred to as algorithm 6 of the TX81Z."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKFMVoices(" ifreq "," iamp ",2," kvowel ",4," kspec ",11," klfo ",1," klfodepth ",128," kadsr ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef Flute ( (iamp ".6") (ifreq "220") (kjet "80") (knoise "100") (klfo "2") (klfodepth "2") (kbreath "100"))
"STKFlute uses a simple flute physical model. The jet model uses a polynomial, a la Cook."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKFlute(" ifreq "," iamp ",2," kjet ",4," knoise ",11," klfo ",1," klfodepth ",128," kbreath ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef Clarinet ( (iamp ".6") (ifreq "220") (kstiff "80") (knoise "10") (klfo "2") (klfodepth "2") (kbreath "100"))
"STKClarinet uses a simple clarinet physical model."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKClarinet(" ifreq "," iamp ",2," kstiff ",4," knoise ",11," klfo ",1," klfodepth ",128," kbreath ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef Brass ( (iamp ".6") (ifreq "220") (klip "80") (kslide "100") (klfo "2") (klfodepth "2") (kvol "100"))
"STKBrass uses a simple brass instrument waveguide model, a la Cook."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKBrass(" ifreq "," iamp ",2," klip ",4," kslide ",11," klfo ",1," klfodepth ",128," kvol ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef Bowed ( (iamp ".6") (ifreq "220") (kpress "80") (kpos "100") (klfo "2") (klfodepth "2") (kvol "100"))
"STKBowed is a bowed string instrument, using a waveguide model."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKBowed(" ifreq "," iamp ",2," kpress ",4," kpos ",11," klfo ",1," klfodepth ",128," kvol ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef BlowHole ( (iamp ".6") (ifreq "220") (kreed "80") (knoise "10") (khole "80") (kreg "20") (kbreath "100"))
"This opcode is based on the clarinet model, with the addition of a two-port register hole and a three-port dynamic tonehole implementation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKBlowHole(" ifreq "," iamp ",2," kreed ",4," knoise ",11," khole ",1," kreg ",128," kbreath ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef BlowBotl ( (iamp ".6") (ifreq "220") (knoise "80") (klfo "2")  (klfodepth "2") (kvol "100"))
"This opcode implements a helmholtz resonator (biquad filter) with a polynomial jet excitation (a la Cook)."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKBlowBotl(" ifreq "," iamp ",4," knoise ",11,"  klfo ",1," klfodepth ",128," kvol ")" #\\ #\return )) )
)
(values ad1 )))



(PWGLdef BeeThree ( (iamp ".6") (ifreq "220") (kop4 "80") (kop3 "100") (klfo "2") (klfodepth "2") (kadsr "100"))
"STK Hammond-oid organ-like FM synthesis instrument."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKBeeThree(" ifreq "," iamp ",2," kop4 ",4," kop3 ",11," klfo ",1," klfodepth ",128," kadsr ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef BandedWg ( (iamp ".6") (ifreq "220") (kpress "80") (kmot "100") (klfo "2") (klfodepth "2") (kvel "100") (kstrk "120") (kinstr "3"))
"This opcode uses banded waveguide techniques to model a variety of sounds, including bowed bars, glasses, and bowls."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKBandedWG(" ifreq "," iamp ",2," kpress ",4," kmot ",11," klfo ",1," klfodepth ",128," kvel ",64," kstrk ",16," kinstr  ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef Sitar ( (iamp ".6") (ifreq "220"))
"STKSitar uses a plucked string physical model based on the Karplus-Strong algorithm."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKSitar(" ifreq "," iamp ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef Plucked ( (iamp ".6") (ifreq "220"))
"STKPlucked uses a plucked string physical model based on the Karplus-Strong algorithm."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKPlucked(" ifreq "," iamp ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef Drummer ( (iamp ".6") (ifreq "220"))
"STKDrummer is a drum sampling synthesizer using raw waves and one-pole filters, The drum rawwave files are sampled at 22050 Hz, but will be appropriately interpolated for other sample rates."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKDrummer(" ifreq "," iamp ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef Simple ( (iamp ".6") (ifreq "220") (kpos "80") (kcross "100") (kenv "80") (kgain "100"))
"STKSimple is a wavetable/noise instrument. It combines a looped wave, a noise source, a biquad resonance filter, a one-pole filter, and an ADSR envelope to create some interesting sounds."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKSimple(" ifreq "," iamp ",2," kpos ",4," kcross ",11," kenv ",128," kgain  ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef StifKarp ( (iamp ".6") (ifreq "220") (kpos "8") (ksus "10") (kstretch "8"))
"STKStifKarp is a plucked stiff string instrument. It a simple plucked string algorithm with enhancements,including string stiffness and pluck position controls. The stiffness is modeled with allpass filters."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKStifKarp(" ifreq "," iamp ",4," kpos ",11," ksus ",1," kstretch ")" #\\ #\return )) )
)
(values ad1 )))




(PWGLdef TubeBell ( (iamp ".6") (ifreq "220") (kmod "80") (kcross "100") (klfo "2") (klfodepth "2") (kadsr "100"))
"STKTubeBell is a tubular bell (orchestral chime) FM synthesis instrument. It uses two simple FM Pairs summed together, also referred to as algorithm 5 of the TX81Z."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1)) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKTubeBell(" ifreq "," iamp ",2," kmod ",4," kcross ",11," klfo ",1," klfodepth ",128," kadsr ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef VoicForm ( (iamp ".6") (ifreq "220") (kmix "80") (ksel "100") (klfo "2") (klfodepth "2") (kloud "100"))
"STKVoicForm is a four formant synthesis instrument."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1)) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKVoicForm(" ifreq "," iamp ",2," kmix ",4," ksel ",11," klfo ",1," klfodepth ",128," kloud ")" #\\ #\return )) )
)
(values ad1 ))) 





(PWGLdef Whistle ( (iamp ".6") (ifreq "220") (kmod "80") (knoise "100") (kfipfreq "80") (kfipgain "80") (kvol "100"))
"STKWhistle produces (police) whistle sounds. It uses a hybrid physical/spectral model of a police whistle (a la Cook)."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1)) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKWhistle(" ifreq "," iamp ",2," kmod ",4," knoise ",11," kfipfreq ",1," kfipgain ",128," kvol ")" #\\ #\return )) )
)
(values ad1 ))) 





(PWGLdef Wurley ( (iamp ".6") (ifreq "220") (kmod "80") (kcross "100") (klfo "2") (klfodepth "2") (kadsr "100"))
"STKWurley simulates a Wurlitzer electric piano FM synthesis instrument. It uses two simple FM Pairs summed together, also referred to as algorithm 5 of the TX81Z."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1)) 
(let* 
( 
(ad1 (remove nil (pw::list   "STKWurley(" ifreq "," iamp ",2," kmod ",4," kcross ",11," klfo ",1," klfodepth ",128," kadsr ")" #\\ #\return )) )
)
(values ad1 ))) 



