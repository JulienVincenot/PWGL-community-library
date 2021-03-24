(in-package :PWCSOUND)


;;****************************************
;;****************************************
;;*************ENVELOPE***********************
;;****************************************


(PWGLdef adsr-k (  (iatt "0.05") (idec ".5") (isus "1") (irel ".2") )
"Calculates the classical ADSR envelope using linear segments."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "adsr:k(" iatt "," idec ","  isus ","  irel ")" )) )
) 
(values tone1  ))) 


(PWGLdef adsr (  (iatt "0.05") (idec ".5") (isus "1") (irel ".2") )
"Calculates the classical ADSR envelope using linear segments."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "adsr:a(" iatt "," idec ","  isus ","  irel ")" )) )
) 
(values tone1  ))) 


(PWGLdef madsr-k (  (iatt "0.05") (idec ".5") (isus "1") (irel ".2") )
"Calculates the classical ADSR envelope using the linsegr mechanism."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "madsr:k(" iatt "," idec ","  isus ","  irel ")" )) )
) 
(values tone1  ))) 


(PWGLdef madsr (  (iatt "0.05") (idec ".5") (isus "1") (irel ".2") )
"Calculates the classical ADSR envelope using the linsegr mechanism."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "madsr:a(" iatt "," idec ","  isus ","  irel ")" )) )
) 
(values tone1  ))) 

(PWGLdef mxadsr (  (iatt "0.05") (idec ".5") (isus "1") (irel ".2") )
"Calculates the classical ADSR envelope using the expsegr mechanism."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "mxadsr:a(" iatt "," idec ","  isus ","  irel ")" )) )
) 
(values tone1  ))) 

(PWGLdef mxadsr-k (  (iatt "0.05") (idec ".5") (isus "1") (irel ".2") )
"Calculates the classical ADSR envelope using the expsegr mechanism."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "mxadsr:k(" iatt "," idec ","  isus ","  irel ")" )) )
) 
(values tone1  ))) 


(PWGLdef linseg-points-a (  (data "0") )
"linseg envelope"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.8 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "linseg:a(" data  ")" )) )
) 
(values tone1  )))


(PWGLdef linseg-points (  (data "0") )
"linseg envelope"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.8 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "linseg:k(" data  ")" )) )
) 
(values tone1  ))) 


(PWGLdef linseg3-a (  (point1 "0")  (point2 "1") (point3 "0") (dur "p3/2") )
"linseg envelope"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.6 :r 0.498039 :g 1 :b 0.831373 :groupings '( 4 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "linseg:a(" point1 ","  dur  ","  point2 "," dur "," point3 ")" )) )
) 
(values tone1  ))) 


(PWGLdef linseg3 (  (point1 "0")  (point2 "1") (point3 "0") (dur "p3/2") )
"linseg envelope"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.6 :r 0.498039 :g 1 :b 0.831373 :groupings '( 4 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "linseg:k(" point1 ","  dur  ","  point2 "," dur "," point3 ")" )) )
) 
(values tone1  ))) 


(PWGLdef linseg4 (  (point1 "1")  (point2 ".5") (point3 "1") (point4 "0") (dur "p3/3") )
"linseg envelope"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.7 :r 0.498039 :g 1 :b 0.831373 :groupings '( 5 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "linseg:k(" point1 ","  dur  ","  point2 "," dur "," point3  "," dur "," point4 ")" )) )
) 
(values tone1  ))) 



(PWGLdef linseg4-a (  (point1 "1")  (point2 ".5") (point3 "1") (point4 "0") (dur "p3/3") )
"linseg envelope"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.7 :r 0.498039 :g 1 :b 0.831373 :groupings '( 5 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "linseg:a(" point1 ","  dur  ","  point2 "," dur "," point3  "," dur "," point4 ")" )) )
) 
(values tone1  ))) 



(PWGLdef linseg5-a (  (point1 "0")  (point2 "1") (point3 ".2") (point4 ".8") (point5 "0") (dur "p3/4") )
"linseg envelope"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.8 :r 0.498039 :g 1 :b 0.831373 :groupings '( 6 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "linseg:a(" point1 ","  dur  ","  point2 "," dur "," point3  "," dur "," point4 "," dur "," point5 ")" )) )
) 
(values tone1  ))) 





(PWGLdef linseg5 (  (point1 "0")  (point2 "1") (point3 ".2") (point4 ".8") (point5 "0") (dur "p3/4") )
"linseg envelope"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.8 :r 0.498039 :g 1 :b 0.831373 :groupings '( 6 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "linseg:k(" point1 ","  dur  ","  point2 "," dur "," point3  "," dur "," point4 "," dur "," point5 ")" )) )
) 
(values tone1  ))) 


(PWGLdef linseg6 (  (point1 ".2")  (point2 "1") (point3 ".2") (point4 ".8") (point5 ".4") (point6 "0") (dur "p3/5") )
"linseg envelope"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.9 :r 0.498039 :g 1 :b 0.831373 :groupings '( 7 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "linseg:k(" point1 ","  dur  ","  point2 "," dur "," point3  "," dur "," point4 "," dur "," point5 "," dur "," point6 ")" )) )
) 
(values tone1  ))) 


(PWGLdef linseg6-a (  (point1 ".2")  (point2 "1") (point3 ".2") (point4 ".8") (point5 ".4") (point6 "0") (dur "p3/5") )
"linseg envelope"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.9 :r 0.498039 :g 1 :b 0.831373 :groupings '( 7 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "linseg:a(" point1 ","  dur  ","  point2 "," dur "," point3  "," dur "," point4 "," dur "," point5 "," dur "," point6 ")" )) )
) 
(values tone1  ))) 



(PWGLdef line (  (point1 "0") (dur "p3") (point2 "1") )
"envelope"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "line:k(" point1 ","  dur  ","  point2 ")" )) )
) 
(values tone1  ))) 


(PWGLdef line-a (  (point1 "0") (dur "p3") (point2 "1") )
"envelope"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "line:a(" point1 ","  dur  ","  point2 ")" )) )
) 
(values tone1  )))




(PWGLdef linseg-pad ( (audio "linseg") )
"simple linseg envelope"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "linseg:k(" '("0,p3/2,1,p3/2,0)") ) ) )
) 
(values tone1  )))


(PWGLdef linseg-pad-a ( (audio "linseg") )
"simple linseg envelope"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "linseg:a(" '("0,p3/2,1,p3/2,0)") ) ) )
) 
(values tone1  )))


(PWGLdef expon-a (  (point1 "0") (dur "p3") (point2 "1") )
"Trace an exponential curve between specified points"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "expon:a(" point1 ","  dur  ","  point2 ")" )) )
) 
(values tone1  ))) 



(PWGLdef expon (  (point1 "0") (dur "p3") (point2 "1") )
"Trace an exponential curve between specified points"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "expon:k(" point1 ","  dur  ","  point2 ")" )) )
) 
(values tone1  ))) 



(PWGLdef jspline-a ( (kamp "8") (min "15") (max"10")   )
"A jitter-spline generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list  "jspline:a(" kamp "," min "," max ")"  )) )
)
(values t2  )))


(PWGLdef jspline ( (kamp "8") (min "15") (max"10")   )
"A jitter-spline generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list  "jspline:k(" kamp "," min "," max ")"  )) )
)
(values t2  )))


(PWGLdef rspline-a ( (rangemin "10") (rangemax "40") (cpsmin "1") (cpsmax"4")   )
"Generate random spline curves."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list  "rspline:a(" rangemin "," rangemax "," cpsmin "," cpsmax ")"  )) )
)
(values t2  )))


(PWGLdef rspline ( (rangemin "10") (rangemax "40") (cpsmin "1") (cpsmax"4")   )
"Generate random spline curves."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list  "rspline:k(" rangemin "," rangemax "," cpsmin "," cpsmax ")"  )) )
)
(values t2  )))


(PWGLdef  declick ( (global "connect")  )
"declick."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1   ) ) 
(let* 
( (tone1 (remove nil (pw::list "declick(" global ")" #\\ #\return )) )) 
(values tone1 ))) 


(PWGLdef env-poscil ( (iamp ".6") (ifn "p6"))
"poscil envelope for gen07"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "poscil(" iamp ",1/p3,"   ifn ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef scale ( (in1 "connect") (kmin "0") (kmax "1")  )
"Scales incoming value to user-definable range. Similar to scale object found in popular dataflow languages."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "scale(" in1  ","  kmax ","  kmin ")" )) )
) 
(values tone1  ))) 




(PWGLdef logcurve ( (kindex "0") (ksteepness "1")  )
"This opcode implements a formula for generating a normalised logarithmic curve in range 0 - 1. It is based on the Max / MSP work of Eric Singer (c) 1994."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 1 )) 
(let* 
( 
(tone1 (remove nil (pw::list "logcurve(" kindex","  ksteepness ")" )) )
) 
(values tone1  )))


(PWGLdef expseg-points-a (  (data "0") )
"Trace a series of exponential segments between specified points"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.8 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "expseg:a(" data  ")" )) )
) 
(values tone1  )))



(PWGLdef expseg-points (  (data "0") )
"Trace a series of exponential segments between specified points"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.8 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "expseg:k(" data  ")" )) )
) 
(values tone1  )))




