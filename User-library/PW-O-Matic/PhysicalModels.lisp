(in-package :PW-O-Matic)




(PWGLdef Ball (  (in ()) (g "10") (damp "0" ) (friction "0.01" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Ball models the path of a bouncing object that is reflected by a vibrating surface."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Ball." (string-downcase a) "(" in "," g ","  damp "," friction ")"  #\return )) )
)
(values ad1 )))



(PWGLdef TBall (  (in ()) (g "10") (damp "0" ) (friction "0.01" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"models the impacts of a bouncing object that is reflected by a vibrating surface."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "TBall." (string-downcase a) "(" in "," g ","  damp "," friction ")"  #\return )) )
)
(values ad1 )))




(PWGLdef Spring (  (in ()) (spring "1") (damp "0" )  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"models the force of a resonating spring."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Spring." (string-downcase a) "(" in "," spring ","  damp  ")"  #\return )) )
)
(values ad1 )))






(PWGLdef Membrane-Circle ( (in () ) (tension "0.05") (loss "0.99") (mul "1") (add "0" ) )
"Waveguide mesh physical models of drum membranes."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "MembraneCircle.ar(" in ","  tension "," loss "," mul "," add  ")" #\return )) )
) 
(values tone1  )))



(PWGLdef Membrane-Hexagon ( (in () ) (tension "0.05") (loss "0.99") (mul "1") (add "0" ) )
"Waveguide mesh physical models of drum membranes."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "MembraneHexagon.ar(" in ","  tension "," loss "," mul "," add  ")" #\return )) )
) 
(values tone1  )))




(PWGLdef NTube ( (in () ) (lossarray "1") (karray ()) (dellengtharray ()) (mul "1") (add "0" ) )
"physical modeling simulation N tubes."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "NTube.ar(" in ","  lossarray "," karray "," dellengtharray "," mul "," add  ")" #\return )) )
) 
(values tone1  )))



(PWGLdef TwoTube ( (in () ) (k "0.01") (loss "1") (d1length "100" ) (d2length "100") (mul "1") (add "0" ) )
"two tube sections with scattering junction inbetween."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 2 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "TwoTube.ar(" in ","  k "," loss "," d1length "," d2length "," mul "," add  ")" #\return )) )
) 
(values tone1  )))



(PWGLdef OteyPiano ( (freq "440") (amp "0.5") (gate "1" ) (release "0.1"))
"Digital wave guide physical model of a piano wrapping the code provided by Clayton Otey."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "OteyPiano.ar(" freq ","  amp "," gate "," release  ")" #\return )) )
) 
(values tone1  )))






(PWGLdef MdaPiano ( (freq "440") (gate "1")  (vel "100") (decay "0.8") (release  "0.8") (hard  "0.8") (velhard  "0.8") (muffle  "0.8")  (velmuff  "0.8")  (velcurve  "0.8") (stereo  "0.2") (tune  "0.5") (random  "0.1")  (stretch  "0.1") (sustain "0") (mul "1") (add "0" ) )
"A piano synthesiser originally a VST plugin by Paul Kellett, ported to SC by Dan Stowell."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 1 4 4 4 4 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "MdaPiano.ar(" freq ","  gate "," vel "," decay "," release ","  hard  ","  velhard  "," muffle "," velmuff "," velcurve  "," stereo  ","  tune ","  random  ","  stretch  ","  sustain  "," mul  ","  add  ")" #\return )) )
) 
(values tone1  )))



(PWGLdef Pluck-sc ( (in ()) (trig "1") (maxdelaytime "0.2" ) (delaytime "0.2" )  (decaytime "1" )(coef "0.5")  (mul "1") (add "0" ))
"A Karplus-Strong UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "Pluck.ar(" in ","  trig "," maxdelaytime "," delaytime "," decaytime ","  coef  "," mul ","  add  ")" #\return )) )
) 
(values tone1  )))


