(in-package :PWCSOUND)


;; GEN menu
(PWGLdef menu-gen ( (a () (ccl::mk-menu-subview :menu-list 
'(
"gisine"
"gisquare"
"gitri"
"gisaw"
"gibell"
"gipt1" 
"gipt2" 
"gipt3" 
"gipt4" 
"gipt5"
"gipt6" 
"gipt7" 
"gipt8" 


) :value 1))) 
"Gen table menu"
 (:class 'ccl::PWGL-values-box :outputs 1 :r 0.498039 :g 1 :b 0.831373 :w 0.4  :groupings '(1  ) ) 
 (list    a ) )


(PWGLdef menu-grain ( (a () (ccl::mk-menu-subview :menu-list 
'(
"gihamming"
"gibartlett"
"giblackman"
"giBlackHarris"
"gigaussian" 
"girectangle" 
"gisync" 
 
) :value 1))) 
"grain envelope"
 (:class 'ccl::PWGL-values-box :outputs 1 :r 0.498039 :g 1 :b 0.831373 :w 0.5  :groupings '(1  ) ) 
 (list    a ) )


(PWGLdef gen01 ( (filename "beats.wav")  )
"This subroutine transfers data from a soundfile into a function table."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list '("ftgenonce(0,0,0,1,") (concatenate 'string '(#\") filename '(#\")) '(",0,0,1)") #\\ #\return )) )
)
(values ad1 )))






(PWGLdef gen10 ( (size "16384") (harm ()) )
"Generate composite waveforms made up of weighted sums of simple sinusoids."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "ftgenonce(" "0,0" "," size ",10," (list (setq newlist (format nil "~{~A~^, ~}"  harm ))) ")" #\\ #\return )) )
)
(values ad1 )))



(PWGLdef gen05 ( (size "513") (harm ()) )
"Constructs functions from segments of exponential curves."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "ftgenonce(" "0,0" "," size ",5," (list (setq newlist (format nil "~{~A~^, ~}"  harm ))) ")" #\\ #\return )) )
)
(values ad1 )))



(PWGLdef gen09 ( (size "8193") (harm ()) )
"Generate composite waveforms made up of weighted sums of simple sinusoids."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "ftgenonce(" "0,0" "," size ",9," (list (setq newlist (format nil "~{~A~^, ~}"  harm ))) ")" #\\ #\return )) )
)
(values ad1 )))




(PWGLdef gen07 ( (size "4097") (harm ()) )
"Constructs functions from segments of straight lines."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "ftgenonce(" "0,0" "," size ",7," (list (setq newlist (format nil "~{~A~^, ~}"  harm ))) ")" #\\ #\return )) )
)
(values ad1 )))


(PWGLdef gen02 ( (size "4") (values ()) )
"This subroutine transfers data from immediate pfields into a function table."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "ftgenonce(" "0,0" "," size ",2," (list (setq newlist (format nil "~{~A~^, ~}"  values ))) ")" #\\ #\return )) )
)
(values ad1 )))

(PWGLdef gen02-negative ( (size "4") (values ()) )
"This subroutine transfers data from immediate pfields into a function table."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "ftgenonce(" "0,0" "," size ",-2," (list (setq newlist (format nil "~{~A~^, ~}"  values ))) ")" #\\ #\return )) )
)
(values ad1 )))




