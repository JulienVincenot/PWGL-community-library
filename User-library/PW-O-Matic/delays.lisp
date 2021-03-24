(in-package :PW-O-Matic)




(PWGLdef AllpassC ( (in ())  (maxdelaytime "0.2") (delaytime "0.2")  (decaytime "1") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"All pass delay line with cubic interpolation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "AllpassC." (string-downcase a) "(" in "," maxdelaytime "," delaytime "," decaytime "," mul "," add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef AllpassL ( (in ())  (maxdelaytime "0.2") (delaytime "0.2")  (decaytime "1") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"All pass delay line with linear interpolation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "AllpassL." (string-downcase a) "(" in "," maxdelaytime "," delaytime "," decaytime "," mul "," add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef AllpassN ( (in ())  (maxdelaytime "0.2") (delaytime "0.2")  (decaytime "1") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"All pass delay line with no interpolation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "AllpassN." (string-downcase a) "(" in "," maxdelaytime "," delaytime "," decaytime "," mul "," add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef CombC ( (in ())  (maxdelaytime "0.2") (delaytime "0.2")  (decaytime "1") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Comb delay line with cubic interpolation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "CombC." (string-downcase a) "(" in "," maxdelaytime "," delaytime "," decaytime "," mul "," add ")"  #\return )) )
)
(values ad1 )))



(PWGLdef CombL ( (in ())  (maxdelaytime "0.2") (delaytime "0.2")  (decaytime "1") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Comb delay line with linear interpolation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "CombL." (string-downcase a) "(" in "," maxdelaytime "," delaytime "," decaytime "," mul "," add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef CombN ( (in ())  (maxdelaytime "0.2") (delaytime "0.2")  (decaytime "1") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Comb delay line with no interpolation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "CombN." (string-downcase a) "(" in "," maxdelaytime "," delaytime "," decaytime "," mul "," add ")"  #\return )) )
)
(values ad1 )))



(PWGLdef DelTapRd ( (buffer ())  (phase "0.2") (delaytime "0.2")  (interp "1") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Tap a delay line from a DelTapWr UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "DelTapRd." (string-downcase a) "(" buffer "," phase "," delaytime "," interp "," mul "," add ")"  #\return )) )
)
(values ad1 )))



(PWGLdef DelTapWr ( (buffer ())  (in ()) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Write to a buffer for a DelTapRd UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "DelTapRd." (string-downcase a) "(" buffer "," in  ")"  #\return )) )
)
(values ad1 )))





(PWGLdef Delay1 ( (in ()) (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Delays the input by 1 audio frame or control period."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Delay1." (string-downcase a) "(" in  "," mul "," add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef Delay2 ( (in ()) (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Delays the input by 2 samples."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Delay2." (string-downcase a) "(" in  "," mul "," add ")"  #\return )) )
)
(values ad1 )))





(PWGLdef DelayC ( (in ())  (maxdelaytime "0.2") (delaytime "0.2")  (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Simple delay line with cubic interpolation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "DelayC." (string-downcase a) "(" in "," maxdelaytime "," delaytime "," mul "," add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef DelayL ( (in ())  (maxdelaytime "0.2") (delaytime "0.2")  (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Simple delay line with linear interpolation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "DelayL." (string-downcase a) "(" in "," maxdelaytime "," delaytime "," mul "," add ")"  #\return )) )
)
(values ad1 )))




(PWGLdef DelayN ( (in ())  (maxdelaytime "0.2") (delaytime "0.2")  (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Simple delay line with no interpolation."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "DelayN." (string-downcase a) "(" in "," maxdelaytime "," delaytime "," mul "," add ")"  #\return )) )
)
(values ad1 )))



(PWGLdef TDelay ( (in ())  (dur "0.1")  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Delays a trigger by a given time. Any triggers which arrive in the time between an input trigger and its delayed output, are ignored."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "TDelay." (string-downcase a) "(" in "," dur ")"  #\return )) )
)
(values ad1 )))




