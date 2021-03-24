(in-package :PWCSOUND)

;;*******************************
;;*******************************
;;*********SPAT************
;;*******************************
;;*******************************



(PWGLdef spat-space ( (instr "1")  (in "connect") (ifn "0") (ktime "1") (krevsend "1")  (kx ".5")  (ky ".5")   )
"space opcode, distributes an input signal among 4 channels using cartesian coordinates."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2  2  2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "instr"  #\Space instr #\return #\linefeed "aq1,aq2,aq3,aq4" #\Space  "space" #\Space in "," ifn "," ktime "," krevsend "," kx "," ky #\return #\linefeed
"outq" #\Space "aq1,aq2,aq3,aq4" #\return  "endin" #\return
)) )
)
(values ad1 ))) 




(PWGLdef spat-pan4 ( (instr "1")  (in "connect") (kx ".5")  (ky ".5") (ifn "gen09") (imode "1") (ioffset "1")  )
"pan opcode, distribute an audio signal amongst four channels with localization control."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2  2  2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "instr"  #\Space instr #\return #\linefeed "aq1,aq2,aq3,aq4" #\Space  "pan" #\Space in "," kx ","  ky "," ifn ","  imode  ","  ioffset #\return #\linefeed
"outq" #\Space "aq1,aq2,aq3,aq4" #\return  "endin" #\return
)) )
)
(values ad1 ))) 




(PWGLdef pan ( (in "connect") (pan ".5")  )
"autopan"
(:class 'ccl::PWGL-values-box :outputs 2  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list  in "*" pan )))
(tone2 (remove nil (pw::list  in "*" "(1-" pan ")" )))
) 
(values tone1 tone2 )))



;;pan2

(PWGLdef sqrt-pan ( (in "connect") (krate "1") )
"Curtis Roads method ,stereo pan"
(:class 'ccl::PWGL-values-box :outputs 2  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '(1 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list  in "*" "sqrt(oscili:k(1," krate ",gisine))"  )))
(tone2 (remove nil (pw::list  in "*" "sqrt(1-(oscili:k(1," krate  ",gisine)))"  )))
) 
(values tone1 tone2 )))




(PWGLdef jspline-pan ( (in "connect") (min-rate "0.1")  (max-rate "10") )
"random spline stereo pan"
(:class 'ccl::PWGL-values-box :outputs 2  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list  in "*" "(1-jspline:k(1,"  min-rate "," max-rate "))"  )))
(tone2 (remove nil (pw::list  in "*" "jspline:k(1,"  min-rate "," max-rate ")"  )))
) 
(values tone1 tone2 )))


(PWGLdef autopan ( (in "connect") (rate "2")  )
"autopan"
(:class 'ccl::PWGL-values-box :outputs 2  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list  in "*" "(1-lfo:k(1," rate  "))"  )))
(tone2 (remove nil (pw::list  in "*" "lfo:k(1,"  rate ")"  )))
) 
(values tone1 tone2 )))




