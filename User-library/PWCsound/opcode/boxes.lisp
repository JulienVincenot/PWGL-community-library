;;****************************************************************
;;****************************************************************
;;****************************************************************
;;************************PWCsound 1.0***************
;;************************Giorgio Zucco (2013)**************
;;****************************************************************
;;****************************************************************
;;****************************************************************
;;****************************************************************
;
;;;       PWCsound for PWGL

;;; Copyright (c) 2013, Giorgio Zucco.  All rights reserved.

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


(in-package :PWCSOUND)





;;;Tools for windows 



;; SCRIVI ORCHESTRA FILE
(PWGLDef make-csd-win ((data "csd") (filename (concatenate 'string '(#\") "c:/pwcs/test.csd" '(#\"))) ) 
"Csd"
(:class 'ccl::PWGL-values-box :outputs 1 :r 0.498039 :g 1 :b 0.831373 :w 0.6 :groupings '(1 1) )  
(list data  filename )

(with-open-file (stream filename
                        :direction :output
                        :if-does-not-exist :create
                        :if-exists :supersede)
(dolist (x (list (pw::flat  data  )))

(let ((*print-case* :downcase))

(format stream  "~{~A ~}~%" x )) data   )))




(PWGLDef synthesize-win ((data "csd") (filename (concatenate 'string '(#\") "c:/pwcs/test.csd" '(#\"))) (flag (concatenate 'string '(#\") "-odac" '(#\"))) ) 
"render csd"
(:class 'ccl::PWGL-values-box :outputs 1 :w 0.3 :r 0.498039 :g 1 :b 0.831373 :w 0.4 :groupings '(1 1 1) )  
(list data  filename )

(with-open-file (stream filename
                        :direction :output
                        :if-does-not-exist :create
                        :if-exists :supersede)
(dolist (x (list (pw::flat  data  )))

(let ((*print-case* :downcase))

(format stream  "~{~A ~}~%" x )) data   ))
(sys:call-system-showing-output (list "C:/Program Files/Csound6/bin/csound.exe"  flag  filename ) :wait t) )



;;*********************************************
;;Tools OSX




;; SCRIVI ORCHESTRA FILE
(PWGLDef make-csd ((data "csd") (filename (concatenate 'string '(#\") "/test.csd" '(#\"))) ) 
"Csd"
(:class 'ccl::PWGL-values-box :outputs 1 :r 0.498039 :g 1 :b 0.831373 :w 0.6 :groupings '(1 1) )  
(list data  filename )

(with-open-file (stream filename
                        :direction :output
                        :if-does-not-exist :create
                        :if-exists :supersede)
(dolist (x (list (pw::flat  data  )))

(let ((*print-case* :downcase))

(format stream  "~{~A ~}~%" x )) data   )))


 






(PWGLDef synthesize ((data "csd") (filename (concatenate 'string '(#\") "/test.csd" '(#\"))) (flag (concatenate 'string '(#\") "-odac" '(#\"))) ) 
"render csd"
(:class 'ccl::PWGL-values-box :outputs 1 :w 0.3 :r 0.498039 :g 1 :b 0.831373 :w 0.4 :groupings '(1 1 1) )  
(list data  filename )

(with-open-file (stream filename
                        :direction :output
                        :if-does-not-exist :create
                        :if-exists :supersede)
(dolist (x (list (pw::flat  data  )))

(let ((*print-case* :downcase))

(format stream  "~{~A ~}~%" x )) data   ))
(sys:call-system-showing-output (list "/usr/local/bin/csound"  flag  filename ) :wait t) )




(PWGLDef synthesize-dir ((data "csd") (compiler "dir") (filename (concatenate 'string '(#\") "/test.csd" '(#\"))) (flag (concatenate 'string '(#\") "-odac" '(#\"))) ) 
"synthesize object with user csound compiler directory"
(:class 'ccl::PWGL-values-box :outputs 1 :w 0.3 :r 0.498039 :g 1 :b 0.831373 :w 0.4 :groupings '(1 1 1 1) )  
(list data  filename )

(with-open-file (stream filename
                        :direction :output
                        :if-does-not-exist :create
                        :if-exists :supersede)
(dolist (x (list (pw::flat  data  )))

(let ((*print-case* :downcase))

(format stream  "~{~A ~}~%" x )) data   ))
(sys:call-system-showing-output (list compiler  flag  filename ) :wait t) )




;;instr
(PWGLdef instr (  (number "1") )
""
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(t2 (remove nil (pw::list  "instr" #\Space number  #\return )) )
)
(values t2  )))


(PWGLdef endin (  (endin "endin") )
"Sets the global seed value."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(t2 (remove nil (pw::list  endin  #\return )) )
)
(values t2  )))


;;GLOBAL FX

(PWGLdef cs-append (  (global-fx1 ())  (global-fx2 ()) (orchestra ()) )
"orchestra with master stereo global fx"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5 :r 0.498039 :g 1 :b 0.831373 :groupings '(1 1 1 )) 
(let* 
( 
(ad1 (remove nil (pw::list   global-fx1 #\return #\linefeed global-fx2 #\return #\linefeed orchestra #\return #\linefeed)) )
)
(values ad1 )))


;;init global fx

(PWGLdef  init ( (a () (ccl::mk-menu-subview :menu-list 
'(
"garev"
"gadelay"
"gafx1"
"gafx2"
"gafx3"
"gafx4"
"gafx5"
"gafx6"
"gafx7"
"gafx8"

 ) :value 1))) 
"global init fx"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(t1 (remove nil (pw::list a #\Space  "init" #\Space "0"  ))) 
)
(values t1 ))) 



(PWGLdef  vincr ( (a () (ccl::mk-menu-subview :menu-list 
'(
"garev"
"gadelay"
"gafx1"
"gafx2"
"gafx3"
"gafx4"
"gafx5"
"gafx6"
"gafx7"
"gafx8"
 ) :value 1))) 
"vincr"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(t1 (remove nil (pw::list  "vincr(" a "," "asig" ")" #\return #\linefeed ))) 
)
(values t1 ))) 




(PWGLdef  vincr-stereo ( (a () (ccl::mk-menu-subview :menu-list 
'(
"garev"
"gadelay"
"gafx1"
"gafx2"
"gafx3"
"gafx4"
"gafx5"
"gafx6"
"gafx7"
"gafx8"
 ) :value 1))) 
"vincr"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(t1 (remove nil (pw::list  "vincr(" a "," "asig1" ")" #\return #\linefeed "vincr(" a "," "asig2" ")" #\return #\linefeed ))) 
)
(values t1 ))) 


(PWGLdef  clear ( (a () (ccl::mk-menu-subview :menu-list 
'(
"garev"
"gadelay"
"gafx1"
"gafx2"
"gafx3"
"gafx4"
"gafx5"
"gafx6"
"gafx7"
"gafx8"
 ) :value 1))) 
"vincr"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(t1 (remove nil (pw::list  "clear(" a ")" #\return ))) 
)
(values t1 ))) 



;;OUT-FX
(PWGLdef mono-fx ( (instr "1" ) (in "connect") (fx () ) &optional (envelope () ) (trigger () ) )
"mono
output  : out asig"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.2 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 2  )) 
(let* 
( 
(mixx2 (remove nil (pw::list trigger #\return "instr" instr #\return  #\linefeed "asig" "=" in #\return  #\linefeed "out" "asig"
 envelope #\return #\linefeed fx   #\return #\linefeed "endin" #\return #\linefeed  ))) 
) 
(values mixx2  ))) 


(PWGLdef stereo-fx ( (instr "1" ) (in1 "in1")  (in2 "in2") (fx ()) &optional (envelope () ) (trigger () ) )
"mono
output  : outs asig,asig"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(1 1 1 1 )) 
(let* 
( 
(mixx2 (remove nil (pw::list trigger #\return "instr" instr #\return  #\linefeed "asig1" "=" in1 #\return #\linefeed "asig2" "=" in2 #\return #\linefeed "outs" 
"asig1"  envelope ","  "asig2"  envelope #\return #\linefeed fx   #\return #\linefeed  "endin" #\return #\linefeed  ))) 
) 
(values mixx2  ))) 

;;Make csd
(PWGLDef orc-sco ( (sr "44100" ) (ksmps "1") (channels "1") (orchestra "orchestra") (score "score") )
"Connect orchestra-score"
(:r 0.498039 :g 1 :b 0.831373 :groupings '(1 1 1 1 1 )) 
(list "<CsoundSynthesizer>" #\return "<CsOptions>" #\return "--env:RAWWAVE_PATH=/pwcs/rawwaves"  #\Space "--displays" #\return "</CsOptions>" #\return "<CsInstruments>" #\return "sr=" sr #\return   "ksmps=" ksmps #\return  "nchnls" "=" channels #\return "0dbfs=1" #\return #\linefeed "#include" (concatenate 'string '(#\") "pwcs" '(#\\) "pwcsound.inc" '(#\"))    #\return #\linefeed orchestra "</CsInstruments>" #\return "<CsScore>"  #\return #\return #\linefeed score #\return #\linefeed "</CsScore>" #\return "</CsoundSynthesizer>" #\return))


(PWGLDef orc-sco2 ( (sr "44100" ) (ksmps "1") (channels "1") (0dbfs "1") (orchestra "orchestra") (score "score") )
"Connect orchestra-score"
(:r 0.498039 :g 1 :b 0.831373 :groupings '(1 1 1 1 1 1 )) 
(list  "<CsoundSynthesizer>" #\return "<CsOptions>" #\return "--env:RAWWAVE_PATH=/pwcs/rawwaves"  #\Space "--displays" #\return "</CsOptions>" #\return "<CsInstruments>" #\return "sr=" sr #\return   "ksmps=" ksmps #\return  "nchnls" "=" channels #\return "0dbfs=" 0dbfs #\return #\linefeed "#include" (concatenate 'string '(#\") "pwcs" '(#\\) "pwcsound.inc" '(#\"))    #\return #\linefeed orchestra "</CsInstruments>" #\return "<CsScore>"  #\return #\return #\linefeed score #\return #\linefeed "</CsScore>" #\return "</CsoundSynthesizer>" #\return))




(PWGLDef orc-sco-disk ( (flag () ) (sr "44100" ) (ksmps "1") (channels "2") (orchestra "orchestra") (score "score") (recording ()) (rec-time "10") )
"Connect orchestra (stereo!),score, stereo disk recording input"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 1 1 1 1 1 1 1) ) 
(let* 
( 
(tone1 (remove nil (pw::list "<CsoundSynthesizer>" #\return "<CsOptions>" #\return "--env:RAWWAVE_PATH=/pwcs/rawwaves"  #\Space flag #\return "</CsOptions>" #\return "<CsInstruments>" #\return "sr=" sr #\return   "ksmps=" ksmps #\return  "nchnls" "=" channels #\return "0dbfs=1" #\return #\linefeed "#include" (concatenate 'string '(#\") "pwcs" '(#\\) "pwcsound.inc" '(#\"))  #\return  #\linefeed  orchestra  #\return  #\linefeed recording #\return "</CsInstruments>" #\return "<CsScore>" #\return #\linefeed 
score #\return #\linefeed 
"i9999" "0" rec-time #\return #\linefeed "</CsScore>" #\return "</CsoundSynthesizer>" #\return )) )
) 
(values tone1  ))) 



(PWGLDef orc-sco-disk2 ( (flag () ) (sr "44100" ) (ksmps "1") (odbfs "1") (channels "2") (orchestra "orchestra") (score "score") (recording ()) (rec-time "10") )
"Connect orchestra (stereo!),score, stereo disk recording input"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 1 1 1 1 1 1 1 1) ) 
(let* 
( 
(tone1 (remove nil (pw::list "<CsoundSynthesizer>" #\return "<CsOptions>" #\return "--env:RAWWAVE_PATH=/pwcs/rawwaves"  #\Space flag #\return "</CsOptions>" #\return "<CsInstruments>" #\return "sr=" sr #\return   "ksmps=" ksmps #\return  "nchnls" "=" channels #\return "0dbfs=" 0dbfs #\return #\linefeed "#include" (concatenate 'string '(#\") "pwcs" '(#\\) "pwcsound.inc" '(#\"))  #\return  #\linefeed  orchestra  #\return  #\linefeed recording #\return "</CsInstruments>" #\return "<CsScore>" #\return #\linefeed 
score #\return #\linefeed 
"i9999" "0" rec-time #\return #\linefeed "</CsScore>" #\return "</CsoundSynthesizer>" #\return )) )
) 
(values tone1  ))) 



(PWGLDef record-to-disk ( (filename () ) (iformat "1")  )
"fout opcode, stereo disk recording"
(:r 0.498039 :g 1 :b 0.831373 :groupings '(1 1 )) 
(list  "instr" #\Space "9999" #\return "a1,a2" #\Space "monitor" #\return 
 
"fout" #\Space (concatenate 'string '(#\") filename '(#\")) "," iformat ",a1,a2" #\return "endin" #\return #\linefeed 
))



;;audio input


(PWGLdef audio-input ( (in1 "input") )
"mono audio input"

(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "in("  ")" )) )
) 
(values tone1  ))) 




(PWGLdef p2-seq ( (N-event 1 ) (base 0  )   (step 1 ) )
"Returns a list of numbers starting from begin to end with increment step, 
add a uniform random function to the list of some depth according to a
value indicated."

(:class 'ccl::PWGL-values-box :outputs 2 :r 0.498039 :g 1 :b 0.831373 :w 0.3 :h 0.25  :groupings '(1 1 1) )

(let* 
( 
(a1 ( pw::loop for i from base to (length N-event) by (+ step 0) collect i))
(a2 ( pw::length N-event))
) 
 (values a1 a2   )))






;;***********************************

;; Sample level operators




(PWGLdef ntrpol (  (asig1 "0") (asig2 "0") (kpoint "0.5") )
"linear interpolation of two input signals"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "ntrpol:a(" asig1 ","  asig2  ","  kpoint ")" )) )
) 
(values tone1  ))) 




(PWGLdef diff-a (  (asig "0"))
"Modify a signal by differentiation"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "diff:a(" asig ")" )) )
) 
(values tone1  ))) 


(PWGLdef diff-k (  (asig "0"))
"Modify a signal by differentiation"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "diff:k(" asig ")" )) )
) 
(values tone1  ))) 



(PWGLdef downsamp ( (asig "0"))
"Modify a signal by down-sampling."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "downsamp(" asig ")" )) )
) 
(values tone1  )))



(PWGLdef fold ( (asig "0") (kincr "0"))
"Adds artificial foldover to an audio signal"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "fold(" asig ","  kincr ")" )) )
) 
(values tone1  )))



(PWGLdef integ-a ( (asig "0"))
"Modify a signal by integration."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "integ:a(" asig ")" )) )
) 
(values tone1  )))


(PWGLdef integ-k ( (asig "0"))
"Modify a signal by integration."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "integ:k(" asig ")" )) )
) 
(values tone1  )))


(PWGLdef interp ( (ksig "0") (iskip "0") (imode "0") )
"Converts a control signal to an audio signal using linear interpolation"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 1 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "interp(" ksig ","  iskip "," imode ")" )) )
) 
(values tone1  )))




(PWGLdef samphold-a ( (asig "0") (agate "0"))
"Performs a sample-and-hold operation on its input."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "samphold:a(" asig ","  agate  ")" )) )
) 
(values tone1  )))


(PWGLdef samphold-k ( (ksig "0") (kgate "0"))
"Performs a sample-and-hold operation on its input."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "samphold:k(" ksig ","  kgate  ")" )) )
) 
(values tone1  )))


 

(PWGLdef upsamp ( (ksig "0"))
"Modify a signal by up-sampling."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "upsamp(" ksig ")" )) )
) 
(values tone1  )))

;;**************************************

;;*******************************
;;*******************************
;;*********SCORE GENERATOR************
;;*******************************
;;*******************************

;;Make score
(PWGLdef simple-score (  (instr "i1") (p2 "0" ) (p3 "2" ) )
"simple-score"
(:class 'ccl::PWGL-values-box :outputs 1  :r 0.498039 :g 1 :b 0.831373 :w 0.2 :groupings '(1 1 1  ) ) 
(loop for i in (list instr #\Space p2 #\Space p3  #\return) collect i ) )




;;Make score
(PWGLdef Multi-score ( (instr "1") (p2 "0" ) (p3 "2" ) (p4 ".5" ) (p5 "60" ) &optional (p6 () ) (p7 () ) (p8 () ) (p9 () ) (p10 () ) (p11 () ) (p12 () ) (p13 () ) (p14 () ) (p15 () ))
"multi-score"

(:class 'ccl::PWGL-values-box :outputs 1 :r 0.498039 :g 1 :b 0.831373 :w 0.3  :groupings '(1 1 1 1 1 ) ) 
(let* 
             ( 
(ad1 (remove nil (pw::list "i" instr #\Space p2 #\Space p3 #\Space p4 #\Space (pw::m->f  p5  ) #\Space p6 #\Space p7 #\Space 
p8 #\Space p9 #\Space p10 #\Space p11 #\Space p12 #\Space p13 #\Space p14 #\Space p15  #\return )) )

 ) 
 (values ad1   ))) 



(PWGLdef Multi-score2 ( (instr "1") (p2 "0" ) (p3 "2" ) (p4 ".5" ) (p5 "60" ) &optional (p6 () ) (p7 () ) (p8 () ) (p9 () ) (p10 () ) (p11 () ) (p12 () ) (p13 () ) (p14 () ) (p15 () ))
"p5 do not convert midi to frequency"

(:class 'ccl::PWGL-values-box :outputs 1 :r 0.498039 :g 1 :b 0.831373 :w 0.3  :groupings '(1 1 1 1 1 ) ) 
(let* 
             ( 
(ad1 (remove nil (pw::list "i" instr #\Space p2 #\Space p3 #\Space p4 #\Space p5   #\Space p6 #\Space p7 #\Space 
p8 #\Space p9 #\Space p10 #\Space p11 #\Space p12 #\Space p13 #\Space p14 #\Space p15  #\return )) )

 ) 
 (values ad1   ))) 




;;sketch
(PWGLdef sketch (  (global "connect")  (dur "2" ) (amp "0.5" ) (freq "60" ) (envelope () ) )
"sketch"
(:class 'ccl::PWGL-values-box :outputs 1 :r 0.498039 :g 1 :b 0.831373 :w 0.4  :groupings '(1 2 2  )) 
(let* 
( 
(mixx1 (remove nil (pw::list 
"<CsoundSynthesizer>" #\return "<CsOptions>" #\return "--env:RAWWAVE_PATH=/pwcs/rawwaves"  #\Space "--displays" #\return "</CsOptions>" #\return
 "<CsInstruments>" #\return "sr=44100" #\return  "kr=44100" #\return "ksmps=1" #\return  "nchnls" "=" "1" 
 #\return "0dbfs=1" 
#\return #\linefeed "#include"  (concatenate 'string '(#\") "pwcs" '(#\\) "pwcsound.inc" '(#\"))  
#\return #\linefeed 
 "instr" "1" #\return  
#\linefeed "asig" "=" global #\return  #\linefeed "out" "asig"
 envelope #\return #\linefeed "endin" #\return #\linefeed 

"</CsInstruments>" #\return "<CsScore>"   #\return #\linefeed 
 "i1" #\Space "0" #\Space dur #\Space  amp #\Space (pw::m->f  freq  )  #\Space #\return #\linefeed "</CsScore>" #\return "</CsoundSynthesizer>"
 ))) 
           
) 
(values mixx1  ))) 


;;*************

;;sketch
(PWGLdef sketch-midi (  (global "connect")  (dur "3600" )  (envelope () ) )
"midi performance synth"
(:class 'ccl::PWGL-values-box :outputs 1 :r 0.498039 :g 1 :b 0.831373 :w 0.4  :groupings '(1 2   )) 
(let* 
( 
(mixx1 (remove nil (pw::list 
"<CsoundSynthesizer>" #\return "<CsOptions>" #\return "--env:RAWWAVE_PATH=/pwcs/rawwaves"  #\Space "--displays" #\Space "-odac" #\Space "-+rtmidi=virtual" #\Space "-M0" #\return "</CsOptions>" #\return
 "<CsInstruments>" #\return "sr=44100" #\return  "kr=441" #\return "ksmps=100" #\return  "nchnls" "=" "1" 
 #\return "0dbfs=1" 
#\return #\linefeed "#include"  (concatenate 'string '(#\") "pwcs" '(#\\) "pwcsound.inc" '(#\"))  
#\return #\linefeed 
 "instr" "1" #\return  
#\linefeed "asig" "=" global #\return  #\linefeed "out" "asig"
 envelope #\return #\linefeed "endin" #\return #\linefeed 

"</CsInstruments>" #\return "<CsScore>"   #\return #\linefeed 
 "i1" #\Space "0" #\Space dur #\Space   #\return #\linefeed "</CsScore>" #\return "</CsoundSynthesizer>"
 ))) 
           
) 
(values mixx1  ))) 




;;sketch
(PWGLdef sketch-midi2 ( (flag ()) (sr "44100") (ksmps "100") (global "connect")  (dur "3600" )  (envelope () )  )

"real time midi performance, csound flags editor"

(:class 'ccl::PWGL-values-box :outputs 1 :r 0.498039 :g 1 :b 0.831373 :w 0.4  :groupings '(2 2 2 )) 
(let* 
( 
(mixx1 (remove nil (pw::list 
"<CsoundSynthesizer>" #\return "<CsOptions>" #\return flag #\return "</CsOptions>" #\return
 "<CsInstruments>" #\return "sr=" sr #\return  "ksmps=" ksmps #\return  "nchnls" "=" "1" 
 #\return "0dbfs=1" 
#\return #\linefeed "#include"  (concatenate 'string '(#\") "pwcs" '(#\\) "pwcsound.inc" '(#\"))  
#\return #\linefeed 
 "instr" "1" #\return  
#\linefeed "asig" "=" global #\return  #\linefeed "out" "asig"
 envelope #\return #\linefeed "endin" #\return #\linefeed 

"</CsInstruments>" #\return "<CsScore>"   #\return #\linefeed 
 "i1" #\Space "0" #\Space dur #\Space   #\return #\linefeed "</CsScore>" #\return "</CsoundSynthesizer>"
 ))) 
           
) 
(values mixx1  ))) 



;;midi to oscillator
(PWGLdef midisynth ((instr "midi") )

"real time midi performance, ampmidi and cpsmidi opcodes to oscillator"
 
(:class 'ccl::PWGL-values-box :outputs 2 :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "ampmidi(1)"


)) )
(ad2 (remove nil (pw::list  "cpsmidi()"
)) )

) 
(values ad1  ad2 )))



(PWGLdef ctrl7 ( (chan "1") (ctlno "1") (min "1") (max "10") )
"Allows a floating-point 7-bit MIDI signal scaled with a minimum and a maximum range."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.498039 :g 1 :b 0.831373 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list   "ctrl7:k(" chan "," ctlno "," min "," max ")" #\\ #\return )) )
)
(values ad1 ))) 





(PWGLdef  portk ( (global "connect") (ktime ".1" ) )
"Applies portamento to a step-valued control signal."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(2) ) 
(let* 
( (tone1 (remove nil (pw::list "portk(" global "," ktime ")" #\\ #\return )) )) 
(values tone1 ))) 






;;****************************************
;;*************SEQUENCER***********************
;;****************************************

;; Possibile bug con schedwhen!!!!!!

(PWGLdef schedkwhen( (ktrigger "1") (kmintim "0") (kmaxnum "1") (kinsnum "2") (kwhen "0")  (kdur ".5")  (p4 "1") (p5 "220") )
"Adds a new score event generated by a k-rate trigger."
(:class 'ccl::PWGL-values-box :outputs 2  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(2 2 2 2 ) ) 
(let* 
( (tone1 (remove nil (pw::list "schedkwhen(" ktrigger "," kmintim "," kmaxnum "," kinsnum "," kwhen "," kdur "," p4 ","  p5  ")" #\return )) ) 
(tone2 (remove nil (pw::list  kinsnum )) )
) 
(values tone1 tone2 )))


(PWGLdef metro( (value "1")  )
"Generate a metronomic signal to be used in any circumstance an isochronous trigger is needed."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373  :groupings '(1  ) ) 
(let* 
( (tone1 (remove nil (pw::list "metro(" value  ")"  )) )) 
(values tone1 )))








;;sequencer
(PWGLdef sequencer ((instr "1") (times "1" ) (p4 "0.5" ) (pitches "60" )  (insnum "2" ) )

"step-sequencer"
 
(:class 'ccl::PWGL-values-box :outputs 2 :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "instr" instr #\return
'("imap ftgenonce 0,0,1024,-2,") (list (setq newlist (format nil "~{~A~^, ~}"  times ))) #\return
'("inote ftgenonce 0,0 ,1024 ,-2 ,") (list (setq newlist (format nil "~{~A~^, ~}"  (pw::m->f  pitches  ) ))) #\return
'("ktrig	seqtime2 0, 1, 0, 1000, 2, imap") #\return
'("kfreq random 0,") (length pitches ) #\return
'("kpitch table kfreq,inote")  #\return
'("schedkwhen ktrig, 0, 0,") insnum  '(", 0, ktrig,") p4  '(", kpitch") #\return
"endin" #\return

)) )
(ad2 (remove nil (pw::list  insnum
)) )

) 
(values ad1  ad2 )))



;;sequencer
(PWGLdef chord ((instr "1") (times 1 ) (p4 "0.5" ) (pitches "60" )  (insnum "2" ) )

"4 voice chord sequencer"
 
(:class 'ccl::PWGL-values-box :outputs 2 :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "instr" instr #\return
'("imap ftgenonce 0,0,1024,-2,") (list (setq newlist (format nil "~{~A~^, ~}"  times ))) #\return
'("inote ftgenonce 0,0 ,1024 ,-2 ,") (list (setq newlist (format nil "~{~A~^, ~}"  (pw::m->f  pitches  ) ))) #\return
'("ktrig	seqtime2 0, 1, 0, 1000, 2, imap") #\return
'("kfreq1 random 0,") (length pitches ) #\return
'("kfreq2 random 0,") (length pitches ) #\return
'("kfreq3 random 0,") (length pitches ) #\return
'("kfreq4 random 0,") (length pitches ) #\return
'("kpitch1 table kfreq1,inote")  #\return
'("kpitch2 table kfreq2,inote")  #\return
'("kpitch3 table kfreq3,inote")  #\return
'("kpitch4 table kfreq4,inote")  #\return
'("schedkwhen ktrig, 0, 0,") insnum  '(", 0, ktrig,") p4 "*.4" '(", kpitch1") #\return
'("schedkwhen ktrig, 0, 0,") insnum  '(", 0, ktrig,") p4 "*.4" '(", kpitch2") #\return
'("schedkwhen ktrig, 0, 0,") insnum  '(", 0, ktrig,") p4 "*.4" '(", kpitch3") #\return
'("schedkwhen ktrig, 0, 0,") insnum  '(", 0, ktrig,") p4 "*.4" '(", kpitch4") #\return

"endin" #\return

)) )
(ad2 (remove nil (pw::list  insnum
)) )

) 
(values ad1  ad2 )))




 ;;Score-statement

(PWGLdef s-statement (  (s "s" ))
"Marks the end of a section."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "s" #\return )) )
) 
(values tone1  ))) 


(PWGLdef repeat (  (ival "2" ))
"repeat event score ."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "r" ival #\return )) )
) 
(values tone1  )))









(PWGLdef tempo (  (tempo "100" ))
"This statement sets the tempo and specifies the accelerations and decelerations for the current section. This is done by converting beats into seconds."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.498039 :g 1 :b 0.831373 :groupings '( 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "t" #\Space "0" #\Space tempo #\return )) )
) 
(values tone1  )))







(PWGLdef scrap-x ( (in "2dx") (a "0") (b "1") (c "2") )
"c"
(:class 'ccl::PWGL-values-box :outputs 2  :w 0.5 :r 0.498039 :g 1 :b 0.831373 :groupings '( 4 ) ) 
(let* 
( 
(tone1   (nth a (pw::g-round (pw::flat in) 2) ))
(tone2  (- (nth b (pw::g-round (pw::flat in) 2)) (nth c (pw::g-round (pw::flat in) 2))) )
) 
(values tone1 tone2 )))


;;instr
(PWGLdef instr-empty ( (number "1") (in "connect"))
"empty"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4 :r 0.498039 :g 1 :b 0.831373 :groupings '( 2 ) ) 
(let* 
( 
(t2 (remove nil (pw::list  "instr" #\Space number  #\return #\linefeed in #\return #\linefeed "endin" #\return #\linefeed )) )
)
(values t2  )))




;;Make score schedule
(PWGLdef schedule ( (instr "1") (p2 "0" ) (p3 "2" ) (p4 ".5" ) (p5 "60" ))
"schedule"
(:class 'ccl::PWGL-values-box :outputs 1 :r 0.498039 :g 1 :b 0.831373 :w 0.3  :groupings '(1 1 1 1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "schedule" #\Space instr "," p2 "," p3 "," p4 "," (pw::m->f p5)  #\return )) )
) 
(values ad1 ))) 


;;Make score schedule
(PWGLdef schedule-p6 ( (instr "1") (p2 "0" ) (p3 "2" ) (p4 ".5" ) (p5 "60" ) (p6 "1") )
"schedule"
(:class 'ccl::PWGL-values-box :outputs 1 :r 0.498039 :g 1 :b 0.831373 :w 0.3  :groupings '(1 1 1 1 1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "schedule" #\Space instr "," p2 "," p3 "," p4 "," (pw::m->f  p5 ) "," p6 #\return )) )
) 
(values ad1 ))) 


;;Make score schedule
(PWGLdef schedule-p7 ( (instr "1") (p2 "0" ) (p3 "2" ) (p4 ".5" ) (p5 "60" ) (p6 "1") (p7 "1"))
"schedule"
(:class 'ccl::PWGL-values-box :outputs 1 :r 0.498039 :g 1 :b 0.831373 :w 0.3  :groupings '(1 1 1 1 1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "schedule" #\Space instr "," p2 "," p3 "," p4 "," (pw::m->f  p5 ) "," p6 "," p7 #\return )) )
) 
(values ad1 )))


;;Make score schedule
(PWGLdef schedule-p8 ( (instr "1") (p2 "0" ) (p3 "2" ) (p4 ".5" ) (p5 "60" ) (p6 "1") (p7 "1") (p8 "1"))
"schedule"
(:class 'ccl::PWGL-values-box :outputs 1 :r 0.498039 :g 1 :b 0.831373 :w 0.3  :groupings '(1 1 1 1 1 1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "schedule" #\Space instr "," p2 "," p3 "," p4 "," (pw::m->f  p5 ) "," p6 "," p7 "," p8 #\return )) )
) 
(values ad1 )))





;;user defined opcode
(PWGLdef udo-design ( (name "oscillator") (outtypes "a") (intypes  "k") (xin "kfreq" ) (code "a1") (xout "aout" ) )
"user defined opcode"
(:class 'ccl::PWGL-values-box :outputs 1 :r 0.498039 :g 1 :b 0.831373 :w 0.3  :groupings '(1 1 1 1 1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "opcode" #\Space  name "," outtypes "," intypes #\return 
xin #\Space "xin" #\return code #\return "xout"  #\Space xout #\return "endop" #\return 
#\linefeed )) )
) 
(values ad1 ))) 


