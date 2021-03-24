(in-package :PW-O-Matic)




(PWGLdef Convolution ( (in () ) (kernel ()) (fsize "512") (mul "1") (add "0") )
"Strict convolution of two continuously changing inputs."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Convolution.ar(" in ","  kernel ","  fsize ","  mul ","  add ")" #\return )) )
)
(values ad1 )))


