(in-package :PW-O-Matic)


(PWGLdef Pfin ( (count ()) (pattern ())  )
"limit number of events embedded in a stream."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1  )) 
(let* 
( 
(ad1 (remove nil (pw::list "Pfin(" sum "," pattern "," tolerance ")"
 #\return  )) )
)
(values ad1 )))






(PWGLdef PdurStutter (  (event ()) )
"partition a value into n equal subdivisions."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "PdurStutter(" event  ")"
 #\return  )) )
)
(values ad1 )))






(PWGLdef Pconst ( (sum ()) (pattern ())  (tolerance "0.001") )
"constrain the sum of a value pattern."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 )) 
(let* 
( 
(ad1 (remove nil (pw::list "Pconst(" sum "," pattern "," tolerance ")"
 #\return  )) )
)
(values ad1 )))





(PWGLdef Pclutch ( (pattern ())  (connected "true") )
"sample and hold a pattern."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pclutch(" pattern "," connected ")"
 #\return  )) )
)
(values ad1 )))





(PWGLdef Pprob ( (distribution ()) (lo "0.01") (hi "1") (length "inf") (tableSize ()) )
"random values that follow a Poisson Distribution."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pprob(" distribution "," lo "," hi "," length "," tableSize ")"
 #\return  )) )
)
(values ad1 )))







(PWGLdef Ppoisson ( (mean "0")  (length "inf") )
"random values that follow a Poisson Distribution."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Ppoisson(" mean "," length ")"
 #\return  )) )
)
(values ad1 )))






(PWGLdef Pmeanrand( (lo "0.01") (hi "1") (length "inf") )
"no doc."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Pmeanrand(" lo "," hi "," length ")"
 #\return  )) )
)
(values ad1 )))





(PWGLdef Plprand( (lo "0.01") (hi "1") (length "inf") )
"random values that tend toward lo."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Plprand(" lo "," hi "," length ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Phprand ( (lo "0.01") (hi "1") (length "inf") )
"random values that tend toward hi."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Phprand(" lo "," hi "," length ")"
 #\return  )) )
)
(values ad1 )))





(PWGLdef Pgauss ( (mean "0") (dev "1") (length "inf") )
"random values that follow a Gaussian Distribution."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pgauss(" mean "," dev "," length ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Pcauchy ( (mean "0") (spread "1") (length "inf") )
"random values that follow a Cauchy Distribution."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pcauchy(" mean "," spread "," length ")"
 #\return  )) )
)
(values ad1 )))





(PWGLdef Ptpar (  (list ()) (repeats "1")  )
"embed event streams in parallel, with time offset."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Ptpar(" list "," repeats ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Pspawner (  (func ()) )
"dynamic control of multiple event streams from a Routine."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pspawner(" func  ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Pspawn (  (pattern ()) (spawnProtoEvent ())  )
"Spawns sub-patterns based on parameters in an event pattern."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pspawn(" pattern ","  spawnProtoEvent  ")"
 #\return  )) )
)
(values ad1 )))





(PWGLdef Pgpar (  (list ()) (repeats "1")  )
"embed event streams in parallel and put each in its own group."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pgpar(" list "," repeats ")"
 #\return  )) )
)
(values ad1 )))


(PWGLdef Ppar (  (list ()) (repeats "1")  )
"embed event streams in parallel."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Ppar(" list "," repeats ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Pwrap (  (pattern ()) (lo ()) (hi ())  )
"constrain the range of output values by wrapping."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pwrap(" pattern ","  lo "," hi  ")"
 #\return  )) )
)
(values ad1 )))






(PWGLdef Punop (  (operator ()) (a ())  )
"unary operator pattern."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Punop(" operator ","  a  ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Prorate (  (proportion ()) (pattern "1" ))
"divide stream proportionally."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Prorate(" proportion "," pattern ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Pnaryop (  (operator ()) (a ()) (arglist ())  )
"n-ary operator pattern."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pnaryop(" operator ","  a ","  arglist ")"
 #\return  )) )
)
(values ad1 )))





(PWGLdef Pmulpre (  (name ()) (value ()) (pattern ()) )
"multiply with value of a key in event stream."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pmulpre(" name "," value "," pattern ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Pmul (  (name ()) (value ()) (pattern ()) )
"multiply with value of a key in event stream."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pmul(" name "," value "," pattern ")"
 #\return  )) )
)
(values ad1 )))


(PWGLdef Pmulp (  (name ()) (value ()) (pattern ()) )
"multiply with value of a key in event stream."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pmulp(" name "," value "," pattern ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef PdegreeToKey (  (pattern ()) (scale ()) (stepsPerOctave "12") )
"Returns a series of notes derived from an index into a scale."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "PdegreeToKey(" pattern ","  scale "," stepsPerOctave ")"
 #\return  )) )
)
(values ad1 )))






(PWGLdef Pbinop (  (operator ()) (a ()) (b ()) (adverb ()) )
"binary operator pattern."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pbinop(" operator ","  a ","  b "," adverb ")"
 #\return  )) )
)
(values ad1 )))





(PWGLdef Pavaroh (  (pattern ()) (aroh ()) (avaroh ()) (stepsPerOctave "12") )
"applying ascending and descending scales to event stream."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pavaroh(" pattern ","  aroh ","  avaroh ","   stepsPerOctave ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Paddpre (  (name ()) (value ()) (pattern ()) )
"add each value of a pattern to value of a key in event stream."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Paddpre(" name "," value "," pattern ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Paddp (  (name ()) (value ()) (pattern ()) )
"add each value of a pattern to value of a key in event stream."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Paddp(" name "," value "," pattern ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Padd (  (name ()) (value ()) (pattern ()) )
"add to value of a key in event stream."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Padd(" name "," value "," pattern ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef ListPattern (  (list ()) (repeats "1")  )
"abstract class that holds a list."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "ListPattern(" list "," repeats ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Pwhile (  (func ()) (pattern ())  )
"While a condition holds, repeatedly embed stream."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pwhile(" func "," pattern ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Pseed (  (randSeed ()) (pattern ()) )
"set the random seed in subpattern."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pseed(" randSeed "," pattern  ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Pprotect (  (pattern ())  (func ()) )
"evaluate a function when an error occured in the thread."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pprotect(" pattern "," func ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Pif (  (condition ()) (iftrue ()) (iffalse()) (default()) )
"Pattern-based conditional expression."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pif(" condition "," iftrue ","  iffalse "," default ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Prout ( (func "0") )
"Use the function like a routine."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Prout(" func ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Plazy (  (func ()) )
"instantiate new patterns from a function."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Plazy(" func ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef PlazyEnvir (  (func ()) )
"instantiate new patterns from a function."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "PlazyEnvir(" func ")"
 #\return  )) )
)
(values ad1 )))


(PWGLdef PlazyEnvirN (  (func ()) )
"instantiate new patterns from a function."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "PlazyEnvirN(" func ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Pchain (  (series ()) )
"pass values from stream to stream."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pchain(" series ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Pbindf (  (series ()) )
"bind several value patterns to one existing event stream by binding keys to valueskeys to values."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pbindf(" series ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Penvir (  (envir ()) (pattern ()) (independent "true") )
"bind several value patterns to one existing event stream by binding keys to valueskeys to values."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Penvir(" envir "," pattern "," independent ")"
 #\return  )) )
)
(values ad1 )))






(PWGLdef Pfset (  (func ()) (pattern ()) (cleanupFunc ()) )
"Good for setting default values or loading server objects."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pfset(" func "," pattern "," cleanupFunc ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Pkey (  (key ())  )
"Pkey simplifies backward access to values in an event being processed by Pbind or another event pattern."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pkey(" key ")"
 #\return  )) )
)
(values ad1 )))






(PWGLdef Plambda (  (pattern ())  (scope ()) )
"create a scope for enclosed streams."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Plambda(" pattern "," scope ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Pevent (  (pattern ())  (event ()) )
"..."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pevent(" pattern "," event ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Pmono ( (in ()) (synthname "synth")   )
"monophonic event stream."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pmono(" #\return #\linefeed  (concatenate 'string '(#\\) synthname  ) "," #\return #\linefeed
in #\Space ")" #\return #\linefeed )) )
)
(values ad1 )))


(PWGLdef PmonoArtic ( (in ()) (synthname "synth")   )
"partly monophonic event stream."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "PmonoArtic(" #\return #\linefeed  (concatenate 'string '(#\\) synthname  ) "," #\return #\linefeed
in #\Space ")" #\return #\linefeed )) )
)
(values ad1 )))



(PWGLdef Pcollect (  (func ()) (pattern ())  )
"Apply a function to a pattern."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pcollect(" func "," pattern ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Pdrop (  (count ()) (pattern ())  )
"no doc."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pdrop(" count "," pattern ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Ppatmod ( (pattern ()) (func ()) (repeats ()) )
"modify a given pattern before passing it into the stream."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Ppatmod(" pattern "," func  ","  repeats ")"
 #\return  )) )
)
(values ad1 )))


(PWGLdef Preject (  (func ()) (pattern ())  )
"Reject values from a pattern."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Preject(" func "," pattern ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Pselect (  (func ()) (pattern ())  )
"Select values from a pattern."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pselect(" func "," pattern ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Pset (  (name ()) (value () )  (pattern ())  )
"event pattern that sets values of one key."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pset(" name "," value "," pattern ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Psetp (  (name ()) (value () )  (pattern ())  )
"event pattern that sets values of one key."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Psetp(" name "," value "," pattern ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Psetpre (  (name ()) (value () )  (pattern ())  )
"event pattern that sets values of one key."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Psetpre(" name "," value "," pattern ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef build-pattern ( (a ()) (b ())  &optional (c ()) (d ()) (e ()) (f ()) (g ()) (h ()) (i ()) (l ()) (m ()) (n ())  (o ()) (p ()) )
"sum"
(:class 'ccl::PWGL-values-box :outputs 1 :r 0.529412 :g 0.807843 :b 0.980392 :w 0.3  :groupings '(1 1) ) 
(let* 
( 
(ad1 (list (setq newlist (format nil "~{~A~^, ~}"  (remove nil (list (pw::flat a) (pw::flat b) (pw::flat c) (pw::flat d) (pw::flat e) (pw::flat f) (pw::flat g) (pw::flat h) (pw::flat i) (pw::flat l) (pw::flat m) (pw::flat n) (pw::flat o) (pw::flat p) )) )))  )
) 
(values ad1   ))) 






(PWGLdef simple-pattern (  (synthname "synth") (midinote ()) (dur ())  )
"pattern"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "//pattern" #\return "Pbind(" #\return #\linefeed 
 "\\instrument"  "," (concatenate 'string '(#\\) synthname  ) "," #\return #\linefeed  "\\midinote," midinote "," #\return #\linefeed
"\\dur," dur  #\Space ")" #\return #\linefeed )) )
)
(values ad1 )))



(PWGLdef pattern2 (  (synthname "synth") (midinote ()) (dur ()) (legato "0.5") (tempo "1") )
"pattern"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "//pattern" #\return "Pbind(" #\return #\linefeed 
 "\\instrument"  "," (concatenate 'string '(#\\) synthname  ) "," #\return #\linefeed  "\\midinote," midinote "," #\return #\linefeed
"\\dur," dur  "," #\return #\linefeed
"\\legato," legato  "," #\return #\linefeed  
"\\tempo," tempo  ")" #\return #\linefeed
)) )
)
(values ad1 )))



(PWGLdef pattern3 (  (synthname "synth") (midinote ()) (attack "0.01") (dur ()) (legato "0.5") (tempo "1") )
"pattern"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "//pattern" #\return "Pbind(" #\return #\linefeed 
 "\\instrument"  "," (concatenate 'string '(#\\) synthname  ) "," #\return #\linefeed  "\\midinote," midinote "," #\return #\linefeed
"\\attack," attack  "," #\return #\linefeed
"\\dur," dur  "," #\return #\linefeed
"\\legato," legato  "," #\return #\linefeed  
"\\tempo," tempo  ")" #\return #\linefeed
)) )
)
(values ad1 )))




(PWGLdef pattern4 (  (synthname "synth") (name1 ()) (seq1 ()) (name2 ()) (seq2 ()) (name3 ()) (seq3 ()) (name4 ()) (seq4 ()) )
"pattern"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "//pattern" #\return "Pbind(" #\return #\linefeed 
 "\\instrument"  "," (concatenate 'string '(#\\) synthname  ) "," #\return #\linefeed  
(concatenate 'string '(#\\) name1  ) "," seq1 "," #\return #\linefeed
(concatenate 'string '(#\\) name2  ) "," seq2 "," #\return #\linefeed
(concatenate 'string '(#\\) name3  ) "," seq3 "," #\return #\linefeed
(concatenate 'string '(#\\) name4  ) "," seq4  ")" #\return #\linefeed
)) )
)
(values ad1 )))



(PWGLdef pattern5 (  (synthname "synth") (name1 ()) (seq1 ()) (name2 ()) (seq2 ()) (name3 ()) (seq3 ()) (name4 ()) (seq4 ()) 
(name5 ()) (seq5 ()) )
"pattern"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "//pattern" #\return "Pbind(" #\return #\linefeed 
 "\\instrument"  "," (concatenate 'string '(#\\) synthname  ) "," #\return #\linefeed  
(concatenate 'string '(#\\) name1  ) "," seq1 "," #\return #\linefeed
(concatenate 'string '(#\\) name2  ) "," seq2 "," #\return #\linefeed
(concatenate 'string '(#\\) name3  ) "," seq3 "," #\return #\linefeed
(concatenate 'string '(#\\) name4  ) "," seq4 "," #\return #\linefeed
(concatenate 'string '(#\\) name5  ) "," seq5  ")" #\return #\linefeed
)) )
)
(values ad1 )))


(PWGLdef pattern6 (  (synthname "synth") (name1 ()) (seq1 ()) (name2 ()) (seq2 ()) (name3 ()) (seq3 ()) (name4 ()) (seq4 ()) 
(name5 ()) (seq5 ()) (name6 ()) (seq6 ())  )
"pattern"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "//pattern" #\return "Pbind(" #\return #\linefeed 
 "\\instrument"  "," (concatenate 'string '(#\\) synthname  ) "," #\return #\linefeed  
(concatenate 'string '(#\\) name1  ) "," seq1 "," #\return #\linefeed
(concatenate 'string '(#\\) name2  ) "," seq2 "," #\return #\linefeed
(concatenate 'string '(#\\) name3  ) "," seq3 "," #\return #\linefeed
(concatenate 'string '(#\\) name4  ) "," seq4 "," #\return #\linefeed
(concatenate 'string '(#\\) name5  ) "," seq5 "," #\return #\linefeed
(concatenate 'string '(#\\) name6  ) "," seq6  ")" #\return #\linefeed
)) )
)
(values ad1 )))



(PWGLdef pattern7 (  (synthname "synth") (name1 ()) (seq1 ()) (name2 ()) (seq2 ()) (name3 ()) (seq3 ()) (name4 ()) (seq4 ()) 
(name5 ()) (seq5 ()) (name6 ()) (seq6 ()) (name7 ()) (seq7 ()) )
"pattern"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 2 2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "//pattern" #\return "Pbind(" #\return #\linefeed 
 "\\instrument"  "," (concatenate 'string '(#\\) synthname  ) "," #\return #\linefeed  
(concatenate 'string '(#\\) name1  ) "," seq1 "," #\return #\linefeed
(concatenate 'string '(#\\) name2  ) "," seq2 "," #\return #\linefeed
(concatenate 'string '(#\\) name3  ) "," seq3 "," #\return #\linefeed
(concatenate 'string '(#\\) name4  ) "," seq4 "," #\return #\linefeed
(concatenate 'string '(#\\) name5  ) "," seq5 "," #\return #\linefeed
(concatenate 'string '(#\\) name6  ) "," seq6 "," #\return #\linefeed
(concatenate 'string '(#\\) name7  ) "," seq7  ")" #\return #\linefeed
)) )
)
(values ad1 )))



(PWGLdef pattern8 (  (synthname "synth") (name1 ()) (seq1 ()) (name2 ()) (seq2 ()) (name3 ()) (seq3 ()) (name4 ()) (seq4 ()) 
(name5 ()) (seq5 ()) (name6 ()) (seq6 ()) (name7 ()) (seq7 ()) (name8 ()) (seq8 ()))
"pattern"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2 2 2 2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "//pattern" #\return "Pbind(" #\return #\linefeed 
 "\\instrument"  "," (concatenate 'string '(#\\) synthname  ) "," #\return #\linefeed  
(concatenate 'string '(#\\) name1  ) "," seq1 "," #\return #\linefeed
(concatenate 'string '(#\\) name2  ) "," seq2 "," #\return #\linefeed
(concatenate 'string '(#\\) name3  ) "," seq3 "," #\return #\linefeed
(concatenate 'string '(#\\) name4  ) "," seq4 "," #\return #\linefeed
(concatenate 'string '(#\\) name5  ) "," seq5 "," #\return #\linefeed
(concatenate 'string '(#\\) name6  ) "," seq6 "," #\return #\linefeed
(concatenate 'string '(#\\) name7 )  "," seq7 "," #\return #\linefeed
(concatenate 'string '(#\\) name8  ) "," seq8  ")" #\return #\linefeed
)) )
)
(values ad1 )))



(PWGLdef Pbind ( (in ())  (synthname "synth")   )
"The arguments to Pbind are an alternating sequence of keys and patterns. A pattern can also be bount to an array of keys."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pbind(" #\return #\linefeed 
(concatenate 'string '(#\\) "instrument" ) "," (concatenate 'string '(#\\) synthname  ) "," #\return #\linefeed
in #\Space ")" #\return #\linefeed )) )
)
(values ad1 )))





(PWGLdef Pseq (  (array ()) (repeats "inf") )
"Cycles over a list of values."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pseq(" array "," repeats ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Pshuf ( (array ()) (repeats "inf") )
"scramble the list into random order."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Pshuf(" array "," repeats ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Prand ( (array ()) (repeats "inf") )
"choose from the list's values randomly."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Prand(" array "," repeats ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Pxrand ( (array ()) (repeats "inf") )
"choose randomly but never return the same list item twice in a row."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Pxrand(" array "," repeats ")"
 #\return  )) )
)
(values ad1 )))





(PWGLdef Pexprand ( (lo "0.01") (hi "1") (repeats "inf") )
"random values that follow a Exponential Distribution."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "Pexprand(" lo "," hi "," repeats ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Pwhite (  (lo "0.01") (hi "1") (repeats "inf") )
"random values with uniform distribution."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pwhite(" lo "," hi "," repeats ")"
 #\return  )) )
)
(values ad1 )))





(PWGLdef Ppatlace (  (data () )  (repeats "inf") )
"interlace streams."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Ppatlace([" data "],"  repeats ")"
 #\return  )) )
)
(values ad1 )))







(PWGLdef Pseries (  (start "0.01") (step "1") (repeats "inf") )
"artithmetic series pattern."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pseries(" start "," step "," repeats ")"
 #\return  )) )
)
(values ad1 )))






(PWGLdef scale-root (  (scale "0.01") (root "1") )
"artithmetic series pattern."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 )) 
(let* 
( 
(ad1 (remove nil (pw::list "\\scale," "#[" (list (setq newlist (format nil "~{~A~^, ~}"  scale ))) "]," #\return  "\\root," root  #\return )) )
)
(values ad1 )))




(PWGLdef play-tclock ( (in ()) (tempo "128/60") )
"play-tempoclock"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list in ".play(TempoClock(" tempo "));"
 #\return #\linefeed )) )
)
(values ad1 )))


 



(PWGLdef play-quant ( (in ()) (delay "1") )
"play-tempoclock"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list in ".play(quant:" delay ");"
 #\return #\linefeed )) )
)
(values ad1 )))



(PWGLdef Pwrand (  (listx ()) (weights "1") (repeats "inf") )
"Choose randomly according to weighted probabilities"
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pwrand(" listx "," weights "," repeats ")"
 #\return  )) )
)
(values ad1 )))


(PWGLdef Pgeom (  (start ()) (grow "1") (length "inf") )
"Geometric series."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pgeom(" start "," grow "," length ")"
 #\return  )) )
)
(values ad1 )))


(PWGLdef Pbrown ( (lo "0") (hi "1") (steps "0.125") (length "inf") )
"Returns a stream that behaves like a brownian motion."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pbrown(" lo "," hi "," steps "," length ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Pfunc ( (next "0") (reset "0") )
"Get the stream values from a user-supplied function."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pfunc(" next "," reset ")"
 #\return  )) )
)
(values ad1 )))


(PWGLdef Pfuncn ( (func "0") (repeats "0") )
"Get values from the function, but stop after repeats items."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pfuncn(" func "," repeats ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Proutine ( (func "0")  )
"Use the function like a routine."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Proutine(" func ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Pser (  (array ()) (repeats "inf") (offset "0") )
"Cycles over a list of values."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pser(" array "," repeats ","  offset ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Pslide (  (array ()) (repeats "inf") (len "0") (step "1") (start "0") (wrapAtEnd "true") )
"Play overlapping segments from the list."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pslide(" array "," repeats ","  len "," step "," start ","  wrapAtEnd ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Pwalk (  (array ()) (step "1") (direction "1") (startpos "0") )
"Random walk over the list."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2  ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pwalk(" array "," step ","  direction "," startpos  ")"
 #\return  )) )
)
(values ad1 )))




(PWGLdef Place (  (array ()) (repeats "inf") (offset "0") )
"Interlace any arrays found in the main list."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1 1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Place(" array "," repeats ","  offset ")"
 #\return  )) )
)
(values ad1 )))


(PWGLdef Ptuple (  (array ()) (repeats "inf")  )
"Collect the list items into an array as the return value."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1  ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Ptuple(" array "," repeats ")"
 #\return  )) )
)
(values ad1 )))


(PWGLdef Pgbrown ( (lo "0") (hi "1") (steps "0.125") (length "inf") )
"Returns a stream that behaves like a brownian motion."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pgbrown(" lo "," hi "," steps "," length ")"
 #\return  )) )
)
(values ad1 )))



(PWGLdef Pbeta ( (lo "0") (hi "1") (prob1 "1") (prob2 "1") (length "inf") )
"Returns a stream that behaves like a brownian motion."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Pbeta(" lo "," hi "," prob1 "," prob2 "," length ")"
 #\return  )) )
)
(values ad1 )))



