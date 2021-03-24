(in-package :PWCSOUND)



;;OUT
(PWGLdef mono ( (instr "1" ) (in "connect")  &optional (envelope () ) (trigger () ) )
"mono
output  : out asig"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.2 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2  )) 
(let* 
( 
(mixx2 (remove nil (pw::list trigger #\return "instr" instr #\return  #\linefeed "asig" "=" in #\return  #\linefeed "out" "asig"
 envelope #\return #\linefeed "endin" #\return #\linefeed  ))) 
) 
(values mixx2  ))) 



(PWGLdef stereo ( (instr "1" ) (in1 "in1")  (in2 "in2") &optional (envelope () ) (trigger () ) )
"mono
output  : outs asig,asig"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.2 :r 0.498039 :g 1 :b 0.831373 :groupings '(1 1 1  )) 
(let* 
( 
(mixx2 (remove nil (pw::list trigger #\return "instr" instr #\return  #\linefeed "asig1" "=" in1 #\return #\linefeed "asig2" "=" in2 #\return #\linefeed "outs" 
"asig1"  envelope ","  "asig2"  envelope #\return #\linefeed "endin" #\return #\linefeed  ))) 
) 
(values mixx2  ))) 


(PWGLdef quad ( (instr "1" ) (in1 "in1")  (in2 "in2") (in3 "in3") (in4 "in4")  &optional (envelope () ) (trigger () ) )
"mono
output  : outq asig,asig,asig,asig"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.2 :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2  )) 
(let* 
( 
(mixx2 (remove nil (pw::list trigger #\return "instr" instr #\return  #\linefeed "asig1" "=" in1 #\return #\linefeed "asig2" "=" in2 #\return #\linefeed "asig3" "=" in3 #\return #\linefeed "asig4" "=" in4 #\return #\linefeed "outq" 
"asig1"  envelope ","  "asig2"  envelope ","  "asig3"  envelope ","  "asig4"  envelope #\return #\linefeed "endin" #\return #\linefeed  ))) 
) 
(values mixx2  ))) 


