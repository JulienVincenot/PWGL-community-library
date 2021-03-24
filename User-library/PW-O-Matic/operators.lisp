(in-package :PW-O-Matic)





(PWGLdef Unary ((in ()) (mul "1") (a () (ccl::mk-menu-subview :menu-list 
'(
"neg"
"reciprocal"
"abs"
"floor"
"ceil"
"frac"
"sign"
"squared"
"cubed"
"sqrt"
"exp"
"midicps"
"cpsmidi"
"midiratio"
"ratiomidi"
"dbamp"
"ampdb"
"octcps"
"cpsoct"
"log"
"log2"
"log10"
"sin"
"cos"
"tan"
"asin"
"acos"
"atan"
"sinh"
"cosh"
"tanh"
"distort"
"softclip"
"isPositive"
"isNegative"
"isStrictlyPositive"

) :value 1)) 
)
"Unary Operators."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.6  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  in "." (string-downcase a) "*" mul #\return )) )
)
(values ad1 ))) 






(PWGLdef Binary ((a ()) (b ()) (op () (ccl::mk-menu-subview :menu-list 
'(

"+"
"-"
"*"
"/"
"%"
"**"
"pow"
"<"
"<="
">"
">="
"=="
"!="
"<!"
"min"
"max"
"round"
"trunc"
"hypot"
"hypotApx"
"atan2"
"ring1"
"ring2"
"ring3"
"ring4"
"sumsqr"
"difsqr"
"sqrsum"
"sqrdif"
"absdif"
"thresh"
"amclip"
"scaleneg"
"clip2"
"wrap2"
"fold2"
"excess"

) :value 1)) 
)
"Binary Operators."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.6  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list (string-downcase op)  "(" a "," b  ")"  #\return )) )
)
(values ad1 ))) 


