(in-package :PWCSOUND)  

;; define a user menu
(ccl::add-PWGL-user-menu 
 '(:menu-component
   ("PWCsound"
 ("Tools"  (synthesize synthesize-dir instr endin orc-sco orc-sco2 orc-sco-disk orc-sco-disk2 record-to-disk sketch  multi-score multi-score2 simple-score audio-input p2-seq make-csd  instr-empty scrap-x udo-design ))  

 ("Tools-windows"  ( synthesize-win make-csd-win ))

  
     ("Synthesis" ("Basic" (sine oscil oscils osciln oscil3 oscili poscil poscil3 poscil-ph poscil-k oscbnk))
                  ("Dynamic-Spectrum-Oscillators" ( buzz gbuzz saw square hsboscil ))
                  ("Noise" ( rand fractalnoise noise betarand bexprnd cauchy exprand gauss pinkish poisson unirand weibull))
                  ("Fm" ( foscili fmb3 fmbell fmpercfl fmvoice phasemod))
("Phasors" ( phasor-a phasor-k table tablei))
                  ("Impulses" ( mpulse dust dust2 gausstrig))
("Granular" ( grain grain3 diskgrain fof partikkel syncgrain syncloop vosim))
("Wave-terrain" ( wterrain))
("Waveshaping" ( distort distort1 powershape))
("Scanned" ( simple-scan scan-injection))
                  ("Models" ( gendy gendyc gendyx bamboo cabasa crunch dripwater guiro sandpaper sekere shaker sleighbells stix tambourine))
                  ("Modeling" ( pluck pluck2 repluck wgclar wgflute wgpluck wgpluck2 wgbow wgbowedbar prepiano))
 ("STK" ( BandedWg BeeThree BlowBotl BlowHole Bowed Brass Clarinet Flute FMVoices HevyMetl Mandolin ModalBar Moog PercFlut 
Resonate Rhodey Saxofony Shakers Simple StifKarp TubeBell VoicForm Whistle Wurley Sitar Plucked Drummer )))

("Sampling"  ( soundin loscil3 diskin2 diskin2-noloop diskin2-hd flooper flooper2  bbcutm sndloop))
("Outputs"  (mono stereo quad ))
("Spatialization"  (pan autopan jspline-pan sqrt-pan spat-pan4 spat-space ))            
("Filters" ("Standard" (tone atone butterbp butterbr butterhp butterlp ))
                 ("Lowpass-resonant" (areson lowpass2 lowres lowresx lpf18 moogvcf moogladder reson resonx ))
("Specialized" (dcblock dcblock2 fofilter )))


("Spectral" ("tools" (analysis  resynthesis ))
             ("Processing" ( timestretch pvswarp pvsfreeze pvscale pvsmix pvsmooth pvsfilter pvsblur pvsmorph pvsarp pvsvoc )))

("Resonators"  ( streson wguide1 wguide2 mode membrane chime_tube2  jegogan_bars aluminum_bar redwood 
dahina_tabla  vibraphone1  wine_glass spinel_sphere   small_handbell tibetan_bowl pot_lit))

     ("Lfo"  ( lfo lfo-a vibr vibrato))


     ("Random numbers"  ( seed betarand-k bexprnd-k cauchy-k cuserrnd exprand-k gauss-k poisson-k rnd rnd31 random-i random-a random-k randomi randomi-a randomh randomh-a linrand pcauchy randi randi-a randh randh-a trirand unirand-k weibull-k jitter jitter2 trandom))



     ("Envelopes"  ( adsr adsr-k madsr madsr-k mxadsr mxadsr-k expon expon-a jspline jspline-a rspline rspline-a line line-a linseg-points-a linseg-points linseg3 linseg3-a linseg4 linseg4-a linseg5 linseg5-a linseg6 linseg6-a linseg-pad linseg-pad-a declick env-poscil follow scale logcurve expseg-points-a expseg-points))
     
     ("Amplitude Modifiers"  (balance compress clip gain gainslider))
     ("Operators"  (addition subtraction multiplication division add sub div multiply add-mult sum2 sum3 sum4  sum5 sum6 sum7 sum8 sum16 ring ring1 ring2 ring3 ring4 sumsqr difsqr sqrsum sqrdif absdif vectorial ))

("Delay"  ( delay delay1 fbkdelay vintage-echo vdelay vdelay3 ))

("Reverberation"  ( alpass comb reverb freeverb reverbsc platerev ))

("Sample level operators"  (diff-a diff-k downsamp fold integ-a integ-k interp samphold-a samphold-k ntrpol upsamp))

("Global FX"  ( cs-append init vincr vincr-stereo clear mono-fx stereo-fx))

("Midi"  ( sketch-midi sketch-midi2  midisynth ctrl7 portk vectorial-rt))

     ("Effects"  (flanger phaser1 phaser2 freq-shift metalizer bitcrush doppler exciter))
    ("Trigger"  ( metro schedkwhen sequencer chord schedule  schedule-p6  schedule-p7  schedule-p8))
("GEN"  ( gen10 gen09 gen07 gen05 gen02 gen02-negative gen01 menu-gen menu-grain  ))
    
 ("Score-Statements"  ( s-statement tempo repeat))

    
     )))







                  