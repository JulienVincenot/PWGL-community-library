(in-package :PW-O-Matic)





(PWGLdef Stepper ( (trig "0" ) (reset "0") (min "0") (max "7") (step "1") (resetval "-1")(a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Each trigger increments a counter which is output as a signal. The counter wraps between min and max."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Stepper." (string-downcase a) "(" trig "," reset "," min "," max "," step "," resetval  ")"  #\return )) )
)
(values ad1 ))) 
