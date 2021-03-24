(in-package :PWCSOUND)


;;****************************************
;;****************************************
;;*************RANDOM***********************
;;****************************************
;;****************************************




(PWGLdef  jitter2  ( (ktotamp "10")  (kamp1 ".5") (kcps1 "10") (kamp2 ".5")  (kcps2 "2")  (kamp3 ".5") (kcps3 "3")   )
"Generates a segmented line with user-controllable random segments."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2 2 2 ) ) 
(let* 
( (tone1 (remove nil (pw::list "jitter2(" ktotamp "," kamp1 "," kcps1  "," kamp2  "," kcps2  ","  kamp3  "," kcps3 ")" #\\ #\return )) )) 
(values tone1 )))



(PWGLdef  weibull  ( (ksigma "1") (ktau "1")  )
"Weibull distribution random number generator (positive values only). This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "weibull:a(" ksigma "," ktau ")" #\\ #\return )) )) 
(values tone1 )))

(PWGLdef  weibull-k  ( (ksigma "1") (ktau "1")  )
"Weibull distribution random number generator (positive values only). This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "weibull:k(" ksigma "," ktau ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef  unirand  ( (krange "1")   )
"Uniform distribution random number generator (positive values only). This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "unirand:a(" krange ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef  unirand-k  ( (krange "1")   )
"Uniform distribution random number generator (positive values only). This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "unirand:k(" krange ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef  rnd31  ( (kscl "1")  (krpow "0") (iseed "10") )
"31-bit bipolar random opcodes with controllable distribution. These units are portable, i.e. using the same seed value will generate the same random sequence on all systems. The distribution of generated random numbers can be varied at k-rate."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 1 1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "rnd31:k(" kscl "," krpow "," iseed ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef  poisson  ( (klambda "1")   )
"Poisson distribution random number generator (positive values only). This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "poisson:a(" klambda ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef  poisson-k  ( (klambda "1")   )
"Poisson distribution random number generator (positive values only). This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "poisson:k(" klambda ")" #\\ #\return )) )) 
(values tone1 )))

(PWGLdef  pinkish  ( (xin "1") (imeth "1")  (inumbands "0")  (iseed "0") (iskip "1") )
"Generates approximate pink noise (-3dB/oct response) by one of two different methods."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2 2 ) ) 
(let* 
( (tone1 (remove nil (pw::list "pinkish:a(" xin "," imeth "," inumbands "," iseed "," iskip ")" #\\ #\return )) )) 
(values tone1 )))



(PWGLdef  gausstrig  ( (kamp "1") (kcps "2")  (kdev "1")  (imode "0")  )
"Generates random impulses around a certain frequency."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2 ) ) 
(let* 
( (tone1 (remove nil (pw::list "gausstrig:a(" kamp "," kcps "," kdev "," imode ")" #\\ #\return )) )) 
(values tone1 )))



(PWGLdef  gauss  ( (krange "1")   )
"Gaussian distribution random number generator. This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "gauss:a(" krange ")" #\\ #\return )) )) 
(values tone1 )))

(PWGLdef  gauss-k  ( (krange "1")   )
"Gaussian distribution random number generator. This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "gauss:k(" krange ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef  exprand  ( (klambda "1")   )
"Exponential distribution random number generator (positive values only). This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "exprand:a(" klambda ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef  exprand-k  ( (klambda "1")   )
"Exponential distribution random number generator (positive values only). This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "exprand:k(" klambda ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef cuserrnd ( (kmin "1")  (kmax "1" ) (ktable "1" )  )
"Continuous USER-defined-distribution RaNDom generator"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "cuserrnd:k(" kmin "," kmax "," ktable  ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef  cauchy ( (krange "1")   )
"Cauchy distribution random number generator. This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "cauchy:a(" krange ")" #\\ #\return )) )) 
(values tone1 )))

(PWGLdef  cauchy-k ( (krange "1")   )
"Cauchy distribution random number generator. This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "cauchy:k(" krange ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef bexprnd ( (krange "1")   )
"Exponential distribution random number generator. This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "bexprnd:a(" krange ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef betarand ( (krange "1")  (kalpha "1" ) (kbeta "1" )  )
"Beta distribution random number generator ,positive values only. This is an x-class noise generator"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "betarand:a(" krange "," kalpha "," kbeta  ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef bexprnd-k ( (krange "100")   )
"Exponential distribution random number generator. This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "bexprnd:k(" krange ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef betarand-k ( (krange "100")  (kalpha "1" ) (kbeta "1" )  )
"Beta distribution random number generator ,positive values only. This is an x-class noise generator"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "betarand:k(" krange "," kalpha "," kbeta  ")" #\\ #\return )) )) 
(values tone1 )))



(PWGLdef trandom ( (ktrig "1")  (kmin "1" ) (kmax "100" )  )
"Generates a controlled pseudo-random number series between min and max values at k-rate whenever the trigger parameter is different to 0"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 2  ) ) 
(let* 
( (tone1 (remove nil (pw::list "trandom(" ktrig "," kmin "," kmax  ")" #\\ #\return )) )) 
(values tone1 )))


(PWGLdef rnd ( (value "2")  )
"Returns a random number in a unipolar range at the rate given by the input argument."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1  ) ) 
(let* 
( (tone1 (remove nil (pw::list "rnd(" value  ")" #\\ #\return )) )) 
(values tone1 )))



(PWGLdef randomi ( (min "2") (max"200") (rate "1") (mode "0" ) )
"Generates a user-controlled random number series with interpolation between each new number."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list "randomi:k(" min "," max "," rate 
"," mode ")" )) )
)
(values  t2  ))) 


(PWGLdef randomi-a ( (min "2") (max"200") (rate "1") (mode "0" ) )
"Generates a user-controlled random number series with interpolation between each new number."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list "randomi:a(" min "," max "," rate 
"," mode ")" )) )
)
(values  t2  )))



(PWGLdef randomh ( (min "2") (max"200") (rate "1") (mode "0" ) )
"Generates random numbers with a user-defined limit and holds them for a period of time."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list "randomh:k(" min "," max "," rate
"," mode ")" )) )
)
(values  t2  )))


(PWGLdef randomh-a ( (min "2") (max"200") (rate "1") (mode "0" ) )
"Generates random numbers with a user-defined limit and holds them for a period of time."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list "randomh:a(" min "," max "," rate
"," mode ")" )) )
)
(values  t2  )))




(PWGLdef random-i (  (min "100") (max"1000")   )
"Generates is a controlled pseudo-random number series between min and max values."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list  "random:i(" min "," max ")" )) )
)
(values t2  )))


(PWGLdef random-k (  (min "100") (max"1000")   )
"Generates is a controlled pseudo-random number series between min and max values."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list  "random:k(" min "," max ")" )) )
)
(values t2  )))



(PWGLdef random-a (  (min "100") (max"1000")   )
"Generates is a controlled pseudo-random number series between min and max values."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list  "random:a(" min "," max ")" )) )
)
(values t2  )))


;;JITTER

(PWGLdef jitter ( (kamp "8") (min "15") (max"10")   )
"Generates a segmented line whose segments are randomly generated."

(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list  "jitter:k(" kamp "," min "," max ")"  )) )
)
(values t2  )))


;;TRIRAND
(PWGLdef trirand (  (range "100") )
"Triangular distribution random number generator. This is an x-class noise generator."

(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(t2 (remove nil (pw::list "trirand:k(" range ")" )) )
)
(values t2  )))


;;RANDI
(PWGLdef randi ( (depth "2") (rate "2") )
"randy, generates a controlled random number series with interpolation between each new number.
syntax (a1 rand xamp, xcps)"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list  "randi:k(" depth "," rate ")" )) )
)
(values t2  )))


(PWGLdef randi-a ( (depth "2") (rate "2") )
"randy, generates a controlled random number series with interpolation between each new number.
syntax (a1 rand xamp, xcps)"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list  "randi:a(" depth "," rate ")" )) )
)
(values t2  )))



(PWGLdef randh-a ( (depth "100") (rate "10") )
"Generates random numbers and holds them for a period of time."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list "randh:a(" depth "," rate ")" )) )
)
(values  t2  )))


;;RANDH
(PWGLdef randh ( (depth "100") (rate "10") )
"Generates random numbers and holds them for a period of time."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list "randh:k(" depth "," rate ")" )) )
)
(values  t2  )))


;;pcauchy
(PWGLdef pcauchy ( (range "1000") )
"Cauchy distribution random number generator (positive values only). This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(t2 (remove nil (pw::list "pcauchy:k(" range ")" )) )
)
(values  t2  )))


;;LINRAND
(PWGLdef linrand (  (range "1000")    )
"Linear distribution random number generator (positive values only). This is an x-class noise generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(t2 (remove nil (pw::list  "linrand:k(" range ")"  )) )
)
(values t2  )))


;;seed
(PWGLdef seed (  (range "1000") )
"Sets the global seed value."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(t2 (remove nil (pw::list  "seed" #\Space range   )) )
)
(values t2  )))




