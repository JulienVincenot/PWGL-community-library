(in-package :PW-O-Matic)




(PWGLdef Env-adsr ( (attack "0.01" ) (decay "0.3") (sustain "0.5") (release "1" ) (level "1" )
 (curve "\sin" ) (bias "0") )
"Standard Shape Envelope Creation Methods"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Env.adsr(" attack "," decay "," sustain "," release "," level ","  curve "," bias ")"  #\return )) )
)
(values ad1 )))




(PWGLdef Env-perc ( (attack "0.01" )  (release "1" ) (level "1" )
 (curve "\sin" ))
"Standard Shape Envelope Creation Methods"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Env.perc(" attack ","  release "," level ","  curve  ")"  #\return )) )
)
(values ad1 )))




(PWGLdef Env-sine ( (dur "1" )  (level "0.1" )
 (curve "\sin" ))
"Standard Shape Envelope Creation Methods"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Env.sine(" dur "," level  ")"  #\return )) )
)
(values ad1 )))




(PWGLdef Env-triangle ( (dur "1" )  (level "0.1" )
 (curve "\sin" ))
"Standard Shape Envelope Creation Methods"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Env.triangle(" dur "," level  ")"  #\return )) )
)
(values ad1 )))




(PWGLdef Env-linen ( (attack "0.01" ) (sustain "1") (release "1" ) (level "1" )
 (curve "\sin" ))
"Standard Shape Envelope Creation Methods"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Env.linen(" attack "," sustain "," release "," level ","  curve  ")"  #\return )) )
)
(values ad1 )))





(PWGLdef EnvGen ( (envelope () ) (gate "1") (levelscale "1" ) (levelbias "0" )
(timescale "1") (doneaction "2") (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Plays back break point envelopes. The envelopes are instances of the Env class."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "EnvGen." (string-downcase a) "(" envelope "," gate "," levelscale "," levelbias "," timescale "," doneaction ")"  #\return )) )
)
(values ad1 )))





(PWGLdef Decay ( (in "0" ) (decayTime "1") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"This is essentially the same as Integrator except that instead of supplying the coefficient directly,it is calculated from a 60 dB decay time."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Decay." (string-downcase a) "(" in "," decayTime ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef Decay2 ( (in "0") (attackTime "0.01") (decayTime "1") (mul "1" ) (add "0" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Decay has a very sharp attack and can produce clicks. Decay2 rounds off the attack by subtracting one Decay from another"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Decay2." (string-downcase a) "(" in "," attackTime "," decayTime ","  mul "," add ")"  #\return )) )
)
(values ad1 ))) 






(PWGLdef Line ( (start "0") (end "1") (dur "1") (mul "1" ) (add "0" ) (doneAction "2") (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Generates a line from the start value to the end value."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Line." (string-downcase a) "(" start "," end "," dur ","  mul "," add  "," doneAction ")"  #\return )) )
)
(values ad1 ))) 



(PWGLdef XLine ( (start "0") (end "1") (dur "1") (mul "1" ) (add "0" ) (doneAction "2") (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Generates an exponential curve from the start value to the end value. Both the start and end values must be non-zero and have the same sign"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "XLine." (string-downcase a) "(" start "," end "," dur ","  mul "," add  "," doneAction ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef Linen ( (gate "1") (attack "0.01") (sus "1" ) (rel "1" ) (doneAction "2") )
"Simple linear envelope generator."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2 1) ) 
(let* 
( 
(tone1 (remove nil (pw::list "Linen.kr(" gate "," attack ","  sus "," rel "," doneAction ")" #\return )) )
) 
(values tone1  )))



