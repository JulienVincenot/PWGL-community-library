(in-package :PWCSOUND)


;;balance
(PWGLdef balance (  (in1 ())  (in2 ())   )
"balance"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list   "balance(" in1 "," in2 ")" #\\ #\return )) )
)
(values ad1 ))) 




;;compress
(PWGLdef compress (  (connect ())  (avoice ()) (kthresh  "0") (kloknee "40") (khiknee  "60") (kratio  "3") (katt  "0.1")  (krel ".5") (ilook "02"))
"Compress, limit, expand, duck or gate an audio signal."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2 2 2  )) 
(let* 
( 
(ad1 (remove nil (pw::list  "compress(" connect "," avoice "," kthresh "," kloknee "," khiknee "," kratio "," katt "," krel "," ilook ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef gain (  (connect ())  (krms ()) )
"Adjusts the amplitude audio signal according to a root-mean-square value."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '(1 1)) 
(let* 
( 
(ad1 (remove nil (pw::list  "gain(" connect "," krms ")" #\\ #\return )) )
)
(values ad1 ))) 




(PWGLdef  gainslider ( (global "connect") (irange "80" )   )

"An implementation of a logarithmic gain curve which is similar to the gainslider object from Cycling 74 MaxMSP."

(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 1 ) ) 
(let* 
( (tone1 (remove nil (pw::list global "*" "gainslider(" irange ")" #\\ #\return )) )) 
(values tone1 ))) 



(PWGLdef  clip ( (global "connect") (imeth "0" ) (ilimit ".5" )  )
"Clips an a-rate signal to a predefined limit, in a soft manner, using one of three methods."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1 1 1 ) ) 
(let* 
( (tone1 (remove nil (pw::list "clip(" global "," imeth "," ilimit ")" #\\ #\return )) )) 
(values tone1 ))) 



