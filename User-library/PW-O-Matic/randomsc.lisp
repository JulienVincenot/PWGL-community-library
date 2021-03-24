(in-package :PW-O-Matic)





(PWGLdef TChoose ((trig "440") (array "0.5") (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"An output is selected randomly on recieving a trigger from an array of inputs."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "TChoose." (string-downcase a) "(" trig "," "[" array "]" ")"  #\return )) )
)
(values ad1 )))