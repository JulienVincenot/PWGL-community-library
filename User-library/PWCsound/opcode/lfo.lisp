(in-package :PWCSOUND)



;;****************************************
;;****************************************
;;*************LFO,VIBRATO****************
;;****************************************
;;****************************************

(PWGLdef  lfo-a (  (depth "2" )  (rate "2" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"0;sine"
"1;triangles"
"2;square(bipolar)"
"3;square(unipolar)"
"4;saw"
"5;saw(down" 
) :value 1))) 
"lfo"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 1 ) ) 
(let* 
( 
(t1 (remove nil (pw::list  "lfo:a(" depth "," rate "," a ")" ))) 
)
(values t1 ))) 



;;
(PWGLdef  lfo (  (depth "2" )  (rate "2" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"0;sine"
"1;triangles"
"2;square(bipolar)"
"3;square(unipolar)"
"4;saw"
"5;saw(down" 
) :value 1))) 
"lfo"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 1 ) ) 
(let* 
( 
(t1 (remove nil (pw::list  "lfo:k(" depth "," rate "," a ")" ))) 
)
(values t1 ))) 




(PWGLdef vibr (  (depth "2") (rate "2") (ifn () ) )
"Easier-to-use user-controllable vibrato"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 1 ) ) 
(let* 
( 
(t2 (remove nil (pw::list "vibr:k(" depth "," rate "," ifn ")" )) )
)
(values t2  ))) 


 
(PWGLdef vibrato ( (kAverageAmp ".5") (kAverageFreq "5")  (kRandAmountAmp "10") (kRandAmountFreq ".3") (kAmpMinRate "3") (kAmpMaxRate "5")  (kcpsMinRate "3") (kcpsMaxRate "5") (ifn () ) )
"Generates a natural-sounding user-controllable vibrato."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 2 2 2 1 ) ) 
(let* 
( 
(t2 (remove nil (pw::list "vibrato:k(" kAverageAmp "," kAverageFreq "," kRandAmountAmp "," kRandAmountFreq "," kAmpMinRate "," kAmpMaxRate "," kcpsMinRate "," kcpsMaxRate "," ifn  ")" )) )
)
(values t2  ))) 



