(in-package :PW-O-Matic)






(PWGLdef PlayBuf ( (numchannels "1" ) (bufnum "0") (rate "1") (trigger "1") (startpos "0") (loop "0") (doneaction "2") (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ar"
) :value 1)) 
)
"Plays back a sample resident in memory."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 2 2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "PlayBuf." (string-downcase a) "(" numchannels "," bufnum "," rate "," trigger ","  startpos "," loop "," doneaction  ")"  #\return )) )
)
(values ad1 ))) 





(PWGLdef BufRateScale ( (bufnum "0") (a () (ccl::mk-menu-subview :menu-list 
'(
"kr"
"ir"
) :value 1)) 
)
"Returns a ratio by which the playback of a soundfile is to be scaled."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "BufRateScale." (string-downcase a) "(" bufnum  ")"  #\return )) )
)
(values ad1 ))) 






(PWGLdef buffer-read( (name "b") (filename "/sound.aif"))
"soundfile buffer."
(:class 'ccl::PWGL-values-box :outputs 2  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 1) ) 
(let* 
( 
(ad1 (remove nil (pw::list name #\Space "=" #\Space "Buffer.read(s,"
(concatenate 'string '(#\") filename '(#\")) ");"  #\return #\linefeed )) )

(ad2 (remove nil (pw::list  name
)) )

) 
(values ad1  ad2 )))



(PWGLdef buffer-simple( (filename "/sound.aif"))
"soundfile buffer."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.4  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(1 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list "Buffer.read(s,"
(concatenate 'string '(#\") filename '(#\")) ");"  #\return #\linefeed )) )

) 
(values ad1 )))


