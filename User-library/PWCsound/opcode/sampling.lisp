(in-package :PWCSOUND)


;;****************************************
;;*************SAMPLING***********************
;;****************************************

(PWGLdef sndloop ( (ain () ) (kpitch "1") (ktrig "1") (idur "2") (ifad "0.05") )
"This opcode records input audio and plays it back in a loop with duration, pitch and crossfade time."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "tapeloop(" ain "," kpitch "," ktrig "," idur "," ifad ")" #\\ #\return )) )
)
(values ad1 ))) 



(PWGLdef soundin ((filename () )  )
"simple sampler"
 (:class 'ccl::PWGL-values-box :outputs 1 :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "soundin:a(" (concatenate 'string '(#\") filename '(#\"))
")" #\\ #\return )) )
) 
(values ad1   ))) 


;;diskin2
(PWGLdef diskin2-noloop ((filename () ) (kpitch "1") (pitchdev ()) )
"Reads audio data from a file, and can alter its pitch using one of several available interpolation types, as well as convert the sample rate to match the orchestra sr setting."
 (:class 'ccl::PWGL-values-box :outputs 1 :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "diskin2:a(" (concatenate 'string '(#\") filename '(#\")) "," kpitch pitchdev '(",0,0,0,32")
")" #\\ #\return )) )
) 
(values ad1   )))


;;diskin2-hd
(PWGLdef diskin2-hd ((filename () ) (kpitch "1") (pitchdev ()) )
"diskin2 high quality for best precision in transpositions"
 (:class 'ccl::PWGL-values-box :outputs 1 :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "diskin2:a(" (concatenate 'string '(#\") filename '(#\")) "," kpitch pitchdev '(",0,1,8,512,262144,0")
")" #\\ #\return )) )
) 
(values ad1   ))) 

;;diskin2
(PWGLdef diskin2 ((filename () ) (kpitch "1") (pitchdev ()) )
"Reads audio data from a file, and can alter its pitch using one of several available interpolation types, as well as convert the sample rate to match the orchestra sr setting."
 (:class 'ccl::PWGL-values-box :outputs 1 :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "diskin2:a(" (concatenate 'string '(#\") filename '(#\")) "," kpitch pitchdev '(",0,1,0,32")
")" #\\ #\return )) )
) 
(values ad1   )))



(PWGLdef loscil3 ((kamp ".6") (kpitch "1") (filename () ) (basenote "261.626") (loop "0") (ampdev ()) (pitchdev ()) )
"Read sampled sound from a table using cubic interpolation."
 (:class 'ccl::PWGL-values-box :outputs 1 :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "loscil3:a(" kamp ampdev "," kpitch pitchdev  "," '("ftgenonce(0,0,0,1,") (concatenate 'string '(#\") filename '(#\")) '(",0,0,1)") "," basenote "," loop ")" #\\ #\return )) )
) 
(values ad1   ))) 



(PWGLdef flooper ((kamp ".6") (kpitch "1") (istart "0") (idur "1") (ifad "0.05") (filename () )  (ampdev ()) (pitchdev ()) )
"This opcode reads audio from a function table and plays it back in a loop with user-defined start time, duration and crossfade time. It also allows the pitch of the loop to be controlled, including reversed playback. It accepts non-power-of-two tables, such as deferred-allocation GEN01 tables"
 (:class 'ccl::PWGL-values-box :outputs 1 :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "flooper(" kamp ampdev "," kpitch pitchdev "," istart "," idur "," ifad "," '("ftgenonce(0,0,0,1,") (concatenate 'string '(#\") filename '(#\")) '(",0,0,1)")
")" #\\ #\return )) )
) 
(values ad1   ))) 


(PWGLdef flooper2 ((kamp ".6") (kpitch "1") (kstart "0") (kend "1") (kfad "0.05") (filename () )  (ampdev ()) (pitchdev ()) )
"This opcode implements a crossfading looper with variable loop parameters and three looping modes, optionally using a table for its crossfade shape. It accepts non-power-of-two tables for its source sounds, such as deferred-allocation GEN01 tables"
 (:class 'ccl::PWGL-values-box :outputs 1 :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "flooper2(" kamp ampdev "," kpitch pitchdev "," kstart "," kend "," kfad "," '("ftgenonce(0,0,0,1,") (concatenate 'string '(#\") filename '(#\")) '(",0,0,1)")
")" #\\ #\return )) )
) 
(values ad1   ))) 



(PWGLdef bbcutm ((asource ()) (ibps "4") (isubdiv "8") (ibarlength "4") (iphrasebars "1") (inumrepeats "2" )  )
"The BreakBeat Cutter automatically generates cut-ups of a source audio stream in the style of drum and bass/jungle breakbeat manipulations. There are two versions, for mono (bbcutm) or stereo (bbcuts) sources. Whilst originally based on breakbeat cutting, the opcode can be applied to any type of source audio"
 (:class 'ccl::PWGL-values-box :outputs 1 :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "bbcutm("  asource "," ibps "," isubdiv "," ibarlength "," iphrasebars "," inumrepeats ")" #\\ #\return )) )
) 
(values ad1   ))) 


