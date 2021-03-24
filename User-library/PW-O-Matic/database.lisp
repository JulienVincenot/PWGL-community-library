(in-package :PW-O-Matic)





(PWGLdef samples-library ( (a () (ccl::mk-menu-subview :menu-list 
'(


"/pwcs/samples/pippo.aif"
"/pwcs/samples/lupo.aif"
"/pwcs/samples/cat.aif"
"/pwcs/samples/man.aif"


) :value 1)) 
)
"samples."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  a )) )
)
(values ad1 ))) 



