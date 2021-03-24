(in-package :PW-O-Matic)


(PWGLdef sig-to-chnls ( (a ()) (b ())  &optional (c ()) (d ()) (e ()) (f ()) (g ()) (h ()) (i ()) (l ()) (m ()) (n ())  (o ()) (p ()) )
"route signal to n-channels"
(:class 'ccl::PWGL-values-box :outputs 1 :r 0.529412 :g 0.807843 :b 0.980392 :w 0.3  :groupings '(1 1) ) 
(let* 
( 
(ad1 (list "[" (setq newlist (format nil "~{~A~^, ~}"  (remove nil (list (pw::flat a) (pw::flat b) (pw::flat c) (pw::flat d) (pw::flat e) (pw::flat f) (pw::flat g) (pw::flat h) (pw::flat i) (pw::flat l) (pw::flat m) (pw::flat n) (pw::flat o) (pw::flat p) ))  )) "]" )  )
) 
(values ad1   ))) 





(PWGLdef Mix ( (in ()) (a () (ccl::mk-menu-subview :menu-list 
'(
"new"
"fill"
) :value 1)) 
)
"Sum an array of channels."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Mix." (string-downcase a) "(" in ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef pan2-sc ( (in ()) (pos "0") (level "1") (a () (ccl::mk-menu-subview :menu-list 
'(
"ar"
"kr"
) :value 1)) 
)
"Two channel equal power panner"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Pan2." (string-downcase a) "(" in "," pos "," level ")"  #\return )) )
)
(values ad1 ))) 







(PWGLdef Balance2 ( (left ()) (right ()) (pos "0") (level "1") (a () (ccl::mk-menu-subview :menu-list 
'(
"ar"
"kr"
) :value 1)) 
)
"Equal power panning balances two channels; by panning, you are favouring one or other channel in the mix, and the other loses power."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Balance2." (string-downcase a) "(" left "," right ","  pos "," level ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef LinPan2 ( (in ())  (pos "0") (level "1") (a () (ccl::mk-menu-subview :menu-list 
'(
"ar"
"kr"
) :value 1)) 
)
"Two channel linear pan."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LinPan2." (string-downcase a) "(" in ","  pos "," level ")"  #\return )) )
)
(values ad1 ))) 






(PWGLdef Pan4 ( (in ())  (xpos "0") (ypos "0") (level "1") (a () (ccl::mk-menu-subview :menu-list 
'(
"ar"
"kr"
) :value 1)) 
)
"Four channel equal power pan."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Pan4." (string-downcase a) "(" in ","  xpos "," ypos "," level ")"  #\return )) )
)
(values ad1 ))) 




 

(PWGLdef PanAz ( (numChans ())  (in ())  (pos "0")  (level "1")  (width "2")  (orientation "0.5") (a () (ccl::mk-menu-subview :menu-list 
'(
"ar"
"kr"
) :value 1)) 
)
"Multichannel equal power panner."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "PanAz." (string-downcase a) "(" numChans  ","  in "," pos "," level "," width ","  orientation ")"  #\return )) )
)
(values ad1 ))) 






(PWGLdef Rotate2 ( (x ())  (y ()) (pos "1") (a () (ccl::mk-menu-subview :menu-list 
'(
"ar"
"kr"
) :value 1)) 
)
"Rotate a sound field."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Rotate2." (string-downcase a) "(" x "," y "," pos  ")"  #\return )) )
)
(values ad1 ))) 






(PWGLdef Splay ( (inArray ()) (spread "1") (level "1") (center "0") (levelComp "true")
 (a () (ccl::mk-menu-subview :menu-list 
'(
"ar"
"kr"
) :value 1)) 
)
"Splay spreads an array of channels across the stereo field."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Splay." (string-downcase a) "(" inArray "," spread "," level "," center "," levelComp  ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef SplayAz ( (numChans "4")  (inArray ())  (spread "1") (level "1")  (width "2")  (center "0") (orientation "0.5") (levelComp "true") )
"Spreads an array of channels across a ring of channels."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "SplayAz.ar(" numChans ","  inArray "," spread ","  level "," width "," center "," orientation "," levelComp  ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef LinSelectX ( (which ()) (array ()) (wrap "1") (a () (ccl::mk-menu-subview :menu-list 
'(
"ar"
"kr"
) :value 1)) 
)
"Mix one output from many sources."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LinSelectX." (string-downcase a) "(" which "," array "," wrap ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef LinXFade2 ( (inA ())  (inB "0")  (pan "0")  (level "1") (a () (ccl::mk-menu-subview :menu-list 
'(
"ar"
"kr"
) :value 1)) 
)
"Two channel linear crossfade."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "LinXFade2." (string-downcase a) "(" inA "," inB "," pan "," level ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef Select ( (which ()) (array ())  (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"The output is selected from an array of inputs."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Select." (string-downcase a) "(" which "," array  ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef SelectX ( (which ()) (array ()) (wrap "1") (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Mix one output from many sources."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "SelectX." (string-downcase a) "(" which "," array "," wrap ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef SelectXFocus ( (which ()) (array ()) (focus "1") (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Mix one output from many sources."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "SelectXFocus." (string-downcase a) "(" which "," array "," focus ")"  #\return )) )
)
(values ad1 ))) 




(PWGLdef XFade2 ( (inA ())  (inB "0")  (pan "0")  (level "1") (a () (ccl::mk-menu-subview :menu-list 
'(
"ar"
"kr"
) :value 1)) 
)
"Two channel equal power crossfader."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "XFade2." (string-downcase a) "(" inA "," inB "," pan "," level ")"  #\return )) )
)
(values ad1 ))) 


