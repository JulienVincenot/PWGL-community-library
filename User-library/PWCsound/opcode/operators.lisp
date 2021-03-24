(in-package :PWCSOUND)


;;****************************************
;;****************************************
;;*************OPERATORS******************
;;****************************************
;;****************************************



(PWGLdef sub  ( (global "in") )
"subtraction"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(1  )) 
(let* 
( 
(mixx1 (remove nil (pw::list  "-" global )))
) 
(values mixx1  )))



(PWGLdef add  ( (global "in") )
"+ kenvelope (a1 rand p4+kenv)"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(1  )) 
(let* 
( 
(mixx1 (remove nil (pw::list  "+" global )))
) 
(values mixx1  )))


(PWGLdef div  ( (global "in") )
"division"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(1  )) 
(let* 
( 
(mixx1 (remove nil (pw::list  "/" global )))
) 
(values mixx1  )))


(PWGLdef multiply ( (global "in") )
"* kenvelope (a1 rand p4*kenv)"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(1  )) 
(let* 
( 
(mixx1 (remove nil (pw::list  "*" global )))
) 
(values mixx1  )))


(PWGLdef add-mult  ( (global1 "in") (global2 "in") )
"+ kenvelope (a1 rand p4+kenv)"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2  )) 
(let* 
( 
(mixx1 (remove nil (pw::list  "+" global1 "*" global2 )))
) 
(values mixx1  )))

;;(list (setq newlist (format nil "~{~A~^, ~}"  times )))




;;MIX2
(PWGLdef sum2 (  (in1 ())  (in2 ())   )
"mix 2 input, opcode sum"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "sum(" in1 "," in2 ")" #\\ #\return )) )
)
(values ad1 ))) 






(PWGLdef sum3 (  (in1 ())  (in2 ()) (in3 ())  )
"mix 3 input, opcode sum"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(1 1 1 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "sum(" in1 "," in2 "," in3 ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef sum4 (  (in1 ())  (in2 ()) (in3 ()) (in4 ())  )
"mix 4 input, opcode sum"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "sum(" in1 "," in2 "," in3  "," in4 ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef sum5 (  (in1 ())  (in2 ()) (in3 ()) (in4 ()) (in5 ()) )
"mix 5 input, opcode sum"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 1 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "sum(" in1 "," in2 "," in3  "," in4 "," in5 ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef sum6 (  (in1 ())  (in2 ()) (in3 ()) (in4 ()) (in5 ()) (in6 ())  )
"mix 6 input, opcode sum"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "sum(" in1 "," in2 "," in3  "," in4 "," in5 "," in6 ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef sum7 (  (in1 ())  (in2 ()) (in3 ()) (in4 ()) (in5 ()) (in6 ()) (in7 ())  )
"mix 7 input, opcode sum"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1)) 
(let* 
( 
(ad1 (remove nil (pw::list   "sum(" in1 "," in2 "," in3  "," in4 "," in5 "," in6 "," in7 ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef sum8 (  (in1 ())  (in2 ()) (in3 ()) (in4 ()) (in5 ()) (in6 ()) (in7 ())  (in8 ()) )
"mix 8 input, opcode sum"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 2)) 
(let* 
( 
(ad1 (remove nil (pw::list   "sum(" in1 "," in2 "," in3  "," in4 "," in5 "," in6 "," in7 "," in8 ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef sum16 (  (in1 ())  (in2 ()) (in3 ()) (in4 ()) (in5 ()) (in6 ()) (in7 ())  (in8 ()) (in9 ())  (in10 ()) (in11 ()) (in12 ()) (in13 ()) (in14 ()) (in15 ())  (in16 ()) )
"mix  16 input, opcode sum"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5 :r 0.498039 :g 1 :b 0.831373 :groupings '(4 4 4 4)) 
(let* 
( 
(ad1 (remove nil (pw::list   "sum(" in1 "," in2 "," in3  "," in4 "," in5 "," in6 "," in7 "," in8 "," in9 "," in10 "," in11  "," in12 "," in13 "," in14 "," in15 "," in16   ")" #\\ #\return )) )
)
(values ad1 ))) 











(PWGLdef addition (  (in1 ())  (in2 ())   )
"a+b"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "(" in1 "+" in2 ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef subtraction (  (in1 ())  (in2 ())   )
"a-b"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "(" in1 "-" in2 ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef multiplication (  (in1 ())  (in2 ())   )
"a*b"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "(" in1 "*" in2 ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef division (  (in1 ())  (in2 ())   )
"a/b"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "(" in1 "/" in2 ")" #\\ #\return )) )
)
(values ad1 ))) 


;;VECTORIAL
(PWGLdef vectorial ( (rate "1")  (in1 ())  (in2 ()) (in3 ()) (in4 ())  )
"mix 4 input, vectorial synthesis"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "vectron(" in1 "," in2 "," in3  "," in4 "," rate ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef vectorial-rt ( (in1 ())  (in2 ()) (in3 ()) (in4 ()) (kx "1") (ky "0") )
"mix 4 input for real time performance, vectorial synthesis"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "vectronrt(" in1 "," in2 "," in3  "," in4 "," kx "," ky ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef ring (  (in1 ())  (in2 ())   )
"ring modulator (a*b)"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "ring(" in1 "," in2 ")" #\\ #\return )) )
)
(values ad1 ))) 

(PWGLdef ring1 (  (in1 ())  (in2 ())   )
"supercollider ugen, ring modulator ((a*b) + a)"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "ring1(" in1 "," in2 ")" #\\ #\return )) )
)
(values ad1 ))) 

(PWGLdef ring2 (  (in1 ())  (in2 ())   )
"supercollider ugen, ring modulator  ((a*b) + a + b)"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "ring2(" in1 "," in2 ")" #\\ #\return )) )
)
(values ad1 ))) 

(PWGLdef ring3 (  (in1 ())  (in2 ())   )
"supercollider ugen, ring modulator  (a*a *b)"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "ring3(" in1 "," in2 ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef ring4 (  (in1 ())  (in2 ())   )
"supercollider ugen, ring modulator  ((a*a *b) - (a*b*b))"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "ring4(" in1 "," in2 ")" #\\ #\return )) )
)
(values ad1 ))) 


(PWGLdef sumsqr (  (in1 ())  (in2 ())   )
"supercollider ugen,(a*a) + (b*b)"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "sumsqr(" in1 "," in2 ")" #\\ #\return )) )
)
(values ad1 ))) 

(PWGLdef difsqr (  (in1 ())  (in2 ())   )
"supercollider ugen, (a*a) - (b*b)"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "difsqr(" in1 "," in2 ")" #\\ #\return )) )
)
(values ad1 )))


(PWGLdef sqrsum (  (in1 ())  (in2 ())   )
"supercollider ugen, (a + b)**2"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "sqrsum(" in1 "," in2 ")" #\\ #\return )) )
)
(values ad1 )))

(PWGLdef sqrdif (  (in1 ())  (in2 ())   )
"supercollider ugen, (a - b)**2"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "sqrdif(" in1 "," in2 ")" #\\ #\return )) )
)
(values ad1 )))


(PWGLdef absdif (  (in1 ())  (in2 ())   )
"supercollider ugen, abs(a - b)"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "absdif(" in1 "," in2 ")" #\\ #\return )) )
)
(values ad1 )))




