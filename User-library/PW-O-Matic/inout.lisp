(in-package :PW-O-Matic)





(PWGLdef Out ( (in "0" ) (bus "0")  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Write a signal to a bus."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Out." (string-downcase a) "(" bus "," in  ")"  #\return )) )
)
(values ad1 ))) 







(PWGLdef In-sc (  (bus "0") (Channels "1" ) (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Read a signal from a bus."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "In." (string-downcase a) "(" bus "," Channels  ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef DiskIn ( (channels "1") (bufnum ()) (loop "0") )
"Continously play a longer soundfile from disk. This requires a buffer to be preloaded with one buffer size of sound."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "DiskIn.ar(" channels "," bufnum "," loop ")" #\return )) )
)
(values ad1 )))



(PWGLdef InFeedback ( (bus "0") (channels "1") )
"Read signal from a bus with a current or one cycle old timestamp."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "InFeedback.ar(" bus "," channels ")" #\return )) )
)
(values ad1 )))


