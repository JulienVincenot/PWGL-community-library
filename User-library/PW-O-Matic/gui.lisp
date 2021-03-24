(in-package :PW-O-Matic)






(PWGLdef FreqScope ( (width ())  )
"FreqScope"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "FreqScopeView(w," width  ").active_(true);" #\return #\linefeed)) )
)
(values ad1 )))




(PWGLdef Window ( (var "w") (name "synth") (rect ())  (color ()) )
"Gui windows"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  var "=Window(" (concatenate 'string '(#\") name '(#\")) "," "Rect(" (list (setq newlist (format nil "~{~A~^, ~}"  rect ))) "));"
var    ".view.background=Color(" (list (setq newlist (format nil "~{~A~^, ~}"  color )))   ");" #\return
var   ".view.decorator=FlowLayout("  var    ".view.bounds);" #\return var  ".alwaysOnTop_(true);" #\return
var  ".front;"  #\return #\linefeed)) )
)
(values ad1 )))



(PWGLdef Knob-vert ( (length ()) (name "synth") (control ()) (linear "linear") (init ()) (var2 ())   )
"Gui windows"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "EZKnob(w,"  length ","  (concatenate 'string '(#\") name '(#\"))  ",ControlSpec("  (list (setq newlist (format nil "~{~A~^, ~}"  control )))  ","     (concatenate 'string '(#\') linear '(#\')) "," (list (setq newlist (format nil "~{~A~^, ~}" init )))   "),{|ez|"  var2  ".set("   (concatenate 'string '(#\\) name )   ",ez.value)},layout:\\vert);" #\return #\linefeed )) )
)
(values ad1 )))



(PWGLdef slider-vert ( (length ()) (name "synth") (control ()) (linear "linear") (init ()) (var2 ())   )
"Gui windows"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "EZSlider(w,"  length ","  (concatenate 'string '(#\") name '(#\"))  ",ControlSpec("  (list (setq newlist (format nil "~{~A~^, ~}"  control )))  ","     (concatenate 'string '(#\') linear '(#\')) "," (list (setq newlist (format nil "~{~A~^, ~}" init )))   "),{|ez|"  var2  ".set("   (concatenate 'string '(#\\) name )   ",ez.value)},layout:\\vert);" #\return #\linefeed )) )
)
(values ad1 )))




(PWGLdef slider-horz ( (length ()) (name "synth") (control ()) (linear "linear") (init ()) (var2 ())   )
"Gui windows"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "EZSlider(w,"  length ","  (concatenate 'string '(#\") name '(#\"))  ",ControlSpec("  (list (setq newlist (format nil "~{~A~^, ~}"  control )))  ","     (concatenate 'string '(#\') linear '(#\')) "," (list (setq newlist (format nil "~{~A~^, ~}" init )))   "),{|ez|"  var2  ".set("   (concatenate 'string '(#\\) name )   ",ez.value)},layout:\\horz);" #\return #\linefeed )) )
)
(values ad1 )))


(PWGLdef Knob-horz ( (length ()) (name "synth") (control ()) (linear "linear") (init ()) (var2 ())   )
"Gui windows"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "EZKnob(w,"  length ","  (concatenate 'string '(#\") name '(#\"))  ",ControlSpec("  (list (setq newlist (format nil "~{~A~^, ~}"  control )))  ","     (concatenate 'string '(#\') linear '(#\')) "," (list (setq newlist (format nil "~{~A~^, ~}" init )))   "),{|ez|"  var2  ".set("   (concatenate 'string '(#\\) name )   ",ez.value)},layout:\\horz);" #\return #\linefeed )) )
)
(values ad1 )))



(PWGLdef slider ( (var "w") (length ()) (name "synth") (control ()) (var2 ())  (type "horz") )
"Gui windows"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "EZSlider(" var ","  length ","  (concatenate 'string '(#\") name '(#\"))  ",ControlSpec("  (list (setq newlist (format nil "~{~A~^, ~}"  control )))  ",'linear'),{|ez|"  var2  ".set("   (concatenate 'string '(#\\) name )   ",ez.value)},layout:"  (concatenate 'string '(#\\) type )  ");" #\return #\linefeed )) )
)
(values ad1 )))