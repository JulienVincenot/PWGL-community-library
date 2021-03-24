(in-package :PW-O-Matic)





(PWGLdef FreeVerb ( (in ()) (mix "0.5") (room "0.9" ) (damp "0.5" ) (mul "1") (add "0") )
"Coded from experiments with faust"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2 2) ) 
(let* 
( 
(tone1 (remove nil (pw::list "FreeVerb.ar(" in "," mix "," room "," damp "," mul "," add  ")" #\return )) )
) 
(values tone1  ))) 



(PWGLdef FreeVerb2 ( (in ()) (in2 ()) (mix "0.5") (room "0.9" ) (damp "0.5" ) (mul "1") (add "0") )
"Coded from experiments with faust"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2 2 1) ) 
(let* 
( 
(tone1 (remove nil (pw::list "FreeVerb2.ar(" in "," in2 "," mix "," room "," damp "," mul "," add  ")" #\return )) )
) 
(values tone1  ))) 






(PWGLdef GVerb ( (in ()) (room "10") (revtime "3") (damp "0.5") (inputbw "0.5") (spread "15")  (drylevel "1") (earlyref "0.7") (taillevel "0.5") (maxroom "300")  (mul "1") (add "0") )
"A two channel reverb UGen based on the GVerb LADSPA effect by Juhana Sadeharju"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 3 3 3 3) ) 
(let* 
( 
(tone1 (remove nil (pw::list "GVerb.ar("  in "," room "," revtime "," damp "," inputbw "," spread "," drylevel "," earlyref "," taillevel "," maxroom "," mul "," add ")" #\return )) )
) 
(values tone1  ))) 









