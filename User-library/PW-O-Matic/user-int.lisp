(in-package :PW-O-Matic)





(PWGLdef Mouse-scale ( (range ()) (step "1") (basenote "60") (scale () (ccl::mk-menu-subview :menu-list 
'(

"aeolian" 
"ahirbhairav"
"ajam"
"atharKurd"
"augmented"
"augmented2"
"bartok"
"bastanikar"
"bayati"
"bhairav"
"chinese"
"chromatic"
"chromatic24"
"diminished"
"diminished2"
"dorian"
"egyptian"
"enigmatic"
"farahfaza"
"gong"
"harmonicMajor"
"harmonicMinor"
"hexAeolian"
"hexDorian"
"hexMajor6"
"hexMajor7"
"hexPhrygian"
"hexSus"
"hijaz"
"hijazDesc"
"hindu"
"hirajoshi"
"hungarianMinor"
"husseini" 
"huzam" 
"indian" 
"ionian" 
"iraq" 
"iwato" 
"jiao" 
"jiharkah"
"karjighar"
"kijazKarKurd"
"kumoi"
"kurd"
"leadingWhole"
"locrian"
"locrianMajor"
"lydian"
"lydianMinor"
"mahur"
"major"
"majorPentatonic"
"marva"
"melodicMajor"
"melodicMinor"
"melodicMinorDesc"
"minor"
"minorPentatonic"
"mixolydian"
"murassah"
"mustar" 
"nahawand" 
"nahawandDesc" 
"nairuz" 
"nawaAthar" 
"neapolitanMajor"
"neapolitanMinor" 
"nikriz" 
"partch_o1" 
"partch_o2" 
"partch_o3" 
"partch_o4" 
"partch_o5" 
"partch_o6" 
"partch_u1" 
"partch_u2" 
"partch_u3" 
"partch_u4"
"partch_u5" 
"partch_u6" 
"pelog" 
"phrygian" 
"prometheus" 
"purvi" 
"rast"
"rastDesc"
"ritusen" 
"romanianMinor"
"saba" 
"scriabin" 
"shang" 
"shawqAfza" 
"sikah" 
"sikahDesc" 
"spanish"
"superLocrian" 
"suznak" 
"todi" 
"ushaqMashri" 
"whole"
"yakah" 
"yakahDesc" 
"yu" 
"zamzam" 
"zanjaran" 
"zhi" 

) :value 1)) 
)
"mouseX with menu-scales."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.5  :r 0.529412 :g 0.807843 :b 0.980392 :groupings '(2 2 ) ) 
(let* 
( 
(ad1 (remove nil (pw::list  "(DegreeToKey.kr(Scale."    (string-downcase scale)    ".as(LocalBuf),MouseX.kr("    (list (setq newlist (format nil "~{~A~^, ~}"  range )))     "), Scale."    (string-downcase scale)    ".stepsPerOctave,"    step    ","    basenote    ")).midicps" )) )
)
(values ad1 ))) 






(PWGLdef MouseButton ( (minval "0") (maxval "1") (lag "0.2" ) )
"Cursor tracking UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 1 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "MouseButton.kr(" minval "," maxval  "," lag  ")" #\return )) )
) 
(values tone1  ))) 





(PWGLdef MouseX ( (minval "0") (maxval "1") (warp "0" ) (lag "0.2" ) )
"Cursor tracking UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "MouseX.kr(" minval "," maxval ","  warp "," lag  ")" #\return )) )
) 
(values tone1  ))) 



(PWGLdef MouseY ( (minval "0") (maxval "1") (warp "0" ) (lag "0.2" ) )
"Cursor tracking UGen."
(:class 'ccl::PWGL-values-box :outputs 1  :w 0.3 :r 0.529412 :g 0.807843 :b 0.980392 :groupings '( 2 2 ) ) 
(let* 
( 
(tone1 (remove nil (pw::list "MouseY.kr(" minval "," maxval ","  warp "," lag  ")" #\return )) )
) 
(values tone1  ))) 
