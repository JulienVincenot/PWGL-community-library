(in-package :PW-O-Matic)

;;****************************************************************
;;****************************************************************
;;****************************************************************
;;************************PW-O-Matic***************
;;************************Giorgio Zucco (2015)**************
;;****************************************************************
;;****************************************************************
;;****************************************************************
;;****************************************************************

;;;       Supercollider for PWGL

;;; Copyright (c) 2015, Giorgio Zucco.  All rights reserved.

;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions
;;; are met:

;;;   * Redistributions of source code must retain the above copyright
;;;     notice, this list of conditions and the following disclaimer.

;;;   * Redistributions in binary form must reproduce the above
;;;     copyright notice, this list of conditions and the following
;;;     disclaimer in the documentation and/or other materials
;;;     provided with the distribution.

;;; THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED
;;; OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;;; WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
;;; DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;;; DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
;;; GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;;; WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;;; NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;;; SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.








(PWGLdef var-arg ( (arg ()) (a () (ccl::mk-menu-subview :menu-list 
'(
"var"
"arg"
) :value 1)) 
  )
"var"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  a arg  ";" #\return #\linefeed
)) )
)
(values ad1 )))






(PWGLdef pwcollider-gui ( (in ()) )
"input"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "(" #\return #\linefeed  


"~boot={s.makeGui.window.alwaysOnTop_(true);" #\return 
"s.boot;};" #\return 
"~scope={s.scope(numChannels:2);};" #\return 
"~meter={s.meter;};" #\return 
"~analyzer={FreqScope.new;};" #\return 
"~recording={SndRecGUI.new(s);};" #\return
"~help={Help.gui;};" #\return
"~stop={CmdPeriod.run;};" #\return
"~quit={0.exit;};" #\return
"~run={" #\return #\linefeed

in

#\return

"};" #\return #\linefeed

"w=Window.new("   (concatenate 'string '(#\") "PW-O-Matic-0.9" '(#\"))  ",Rect(400,200,820,60),resizable:false);"

#\return

"a=Button(w,Rect(10,20,80,30)).states_([["    (concatenate 'string '(#\") "Boot-server" '(#\")) ",Color.black,Color.new255(193, 205, 205)]]).action_(~boot);" #\return
"b=Button(w,Rect(100,20,80,30)).states_([[" (concatenate 'string '(#\") "Play" '(#\")) ",Color.black, Color.new255(193, 205, 205)]]).action_(~run);" #\return
"c=Button(w,Rect(190,20,80,30)).states_([[" (concatenate 'string '(#\") "Stop" '(#\")) ",Color.black, Color.new255(193, 205, 205)]]).action_(~stop);" #\return
"d=Button(w,Rect(280,20,80,30)).states_([[" (concatenate 'string '(#\") "Meter" '(#\")) ",Color.black, Color.new255(193, 205, 205)]]).action_(~meter);" #\return
"e=Button(w,Rect(370,20,80,30)).states_([[" (concatenate 'string '(#\") "Analyzer" '(#\")) ",Color.black, Color.new255(193, 205, 205)]]).action_(~analyzer);" #\return
"f=Button(w,Rect(460,20,80,30)).states_([[" (concatenate 'string '(#\") "Scope" '(#\")) ",Color.black, Color.new255(193, 205, 205)]]).action_(~scope);" #\return
"g=Button(w,Rect(550,20,80,30)).states_([[" (concatenate 'string '(#\") "Recording" '(#\")) ",Color.black, Color.new255(193, 205, 205)]]).action_(~recording);" #\return
"h=Button(w,Rect(640,20,80,30)).states_([[" (concatenate 'string '(#\") "Help" '(#\")) ",Color.black, Color.new255(193, 205, 205)],]).action_(~help);" #\return  
"i=Button(w,Rect(730,20,80,30)).states_([[" (concatenate 'string '(#\") "Quit" '(#\")) ",Color.black, Color.new255(193, 205, 205)],]).action_(~quit);" #\return #\linefeed


"w.background_(Color.white).front;" #\return
"w.alwaysOnTop_(true);" #\return
"w.front;" #\return


")"  )) )
)
(values ad1 )))








(PWGLdef list-sc ( (a ()) (b ())  &optional (c ()) (d ()) (e ()) (f ()) (g ()) (h ()) (i ()) (l ()) (m ()) )
"sum"
(:class 'ccl::PWGL-values-box :outputs 1 :r 0.529412 :g 0.807843 :b 0.980392 :w 0.3  :groupings '(1 1) ) 
(let* 
( 
(ad1 (list (setq newlist (format nil "~{~A~^, ~}"  (remove nil (list a b c d e f g h i l m)) )))  )
) 
(values ad1   ))) 





(PWGLdef recording ( (in ())  )
"recording Gui"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  in #\return  #\linefeed "SndRecGUI.new(s);"   #\return  #\linefeed)) )
)
(values ad1 )))





(PWGLDef make-scd ((data "scd") (filename (concatenate 'string '(#\") "/test.scd" '(#\"))) ) 
"Csd"
(:class 'ccl::PWGL-values-box :outputs 1 :r 0.529412 :g 0.807843 :b 0.980392 :w 0.4 :groupings '(1 1) )  
(list data  filename )

(with-open-file (stream filename
                        :direction :output
                        :if-does-not-exist :create
                        :if-exists :supersede)
(dolist (x (list (pw::flat  data  )))

(let ((*print-case* :downcase))

(format stream  "~{~A ~}~%" x )) data   )))



;;maths




(PWGLdef sum-3 ( (a ()) (b ()) ( c ()) )
"a+b+c"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Sum3(" a  "," b "," c  ")" #\return   )) )
)
(values ad1 )))


(PWGLdef sum-4 ( (a ()) (b ()) ( c ()) (d ()) )
"a+b+c+d"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Sum4(" a  "," b "," c "," d ")"  #\return  )) )
)
(values ad1 )))




(PWGLdef stereo ( (in-a ()) (in-b ()) )
"a+b"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "[" in-a  "," in-b "]"  #\return  )) )
)
(values ad1 )))





(PWGLdef a+b ( (in-a ()) (in-b ()) )
"a+b"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  in-a "+" in-b  #\return  )) )
)
(values ad1 )))



(PWGLdef a*b ( (in-a ()) (in-b ()) )
"a*b"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  in-a "*" in-b   #\return )) )
)
(values ad1 )))




(PWGLdef scd-empty ( (in ()) )
"input"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "{" #\return  in  "}"   #\return )) )
)
(values ad1 )))





(PWGLdef play ( (in ()) )
"xx"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  in ".play;" #\return  #\linefeed)) )
)
(values ad1 )))


(PWGLdef play-trace ( (in ()) )
"xx"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  in ".trace.play;" #\return  #\linefeed)) )
)
(values ad1 )))



(PWGLdef array ( (data ()) )
"array"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "[" (list (setq newlist (format nil "~{~A~^, ~}"  data ))) "]" #\return )) )
)
(values ad1 )))





(PWGLdef SynthDef ((synthname "sine" ) (in "0") )
"SynthDef"
 (:class 'ccl::PWGL-values-box :outputs 1 :w 0.4 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "SynthDef(" (concatenate 'string '(#\\) synthname )
 "," in  #\return  ").add;" #\return  #\linefeed )) )
) 
(values ad1   ))) 



(PWGLdef Synth-name ((synthname "sine" ) )
"Synth"
 (:class 'ccl::PWGL-values-box :outputs 1 :w 0.4 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list #\return "Synth(" (concatenate 'string '(#\\) synthname  )
 ");"  #\linefeed #\return )) )
) 
(values ad1   ))) 



(PWGLdef Synth-name-arg ((synthname "sine" ) (in ()) )
"Synth"
 (:class 'ccl::PWGL-values-box :outputs 1 :w 0.5 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list #\return "Synth(" (concatenate 'string '(#\\) synthname  ) "," in
 ");"  #\linefeed #\return )) )
) 
(values ad1   ))) 


	
	

(PWGLdef do-loop ( (in ()) (iter "2")  (wait "0.1") )
"do-loop"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "{"  iter ".do({" in wait ".wait;})}.fork;"  #\return #\linefeed )) )
)
(values ad1 )))






(PWGLDef sclang ((data "scd") (filename (concatenate 'string '(#\") "/test.scd" '(#\"))) ) 
"render csd"
(:class 'ccl::PWGL-values-box :outputs 1 :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :w 0.4 :groupings '(1 1 ) )  
(list data  filename )

(with-open-file (stream filename
                        :direction :output
                        :if-does-not-exist :create
                        :if-exists :supersede)
(dolist (x (list (pw::flat  data  )))

(let ((*print-case* :downcase))

(format stream  "~{~A ~}~%" x )) data   ))
(sys:call-system-showing-output (list "/Applications/SuperCollider/SuperCollider.app/Contents/Resources/sclang"  filename ) :wait t) )









(PWGLdef Array-methods ( (in () )  (a () (ccl::mk-menu-subview :menu-list 
'(
"fill"
"fill2D"
"fillND"
"newFrom"
"newClear"
"with"
"series"
"geom"
"iota"

) :value 1)) 
)
"Array."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.6  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Array." a "(" in  ")"  #\return )) )
)
(values ad1 ))) 

