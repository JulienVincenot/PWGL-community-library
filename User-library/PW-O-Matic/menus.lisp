(in-package :PW-O-Matic)


;; define a user menu
(ccl::add-PWGL-user-menu 
 '(:menu-component
   ("PW-O-Matic"
 ("Tools"  ( pwcollider-gui sclang  a+b a*b array Array-methods make-scd  play play-trace scd-empty SynthDef Synth-name Synth-name-arg  do-loop var-arg list-sc stereo sum-3 sum-4)) 

 
 ("Operators"  (Unary Binary )) 

 ("Gui"  ( Window slider slider-horz slider-vert Knob-horz Knob-vert FreqScope)) 


("Buffer"  (buffer-read buffer-simple BufRateScale PlayBuf ))

("Convolution"  (Convolution))


("Delays"  (AllpassC  AllpassL  AllpassN CombC CombL  CombN DelTapRd DelTapWr Delay1 Delay2 DelayC DelayL DelayN TDelay ))


("Generators"  
( "Chaotic" ( CuspL CuspN FBSineC FBSineL FBSineN GbmanL GbmanN rand-range HenonC HenonL HenonN LatoocarfianC LatoocarfianL LatoocarfianN LinCongC  LinCongL LinCongN))
( "Deterministic" ( Blip COsc SinOsc FSinOsc Formant Impulse Klang Klank LFCub LFGauss LFPar LFPulse LFSaw LFTri Osc-wave OscN-wave PMOsc PSinGrain Pulse Saw SinOscFB SyncSaw VOsc VOsc3 VarSaw Vibrato AY KmeansToBPSet1 PulseDPW SawDPW ))
( "Granular" (GrainBuf GrainFM GrainIn GrainSin TGrains Warp1))
( "PhysicalModels" (Ball TBall Spring Membrane-Circle Membrane-Hexagon NTube TwoTube OteyPiano MdaPiano Pluck-sc))

( "Stochastic" ( BrownNoise ClipNoise CoinGate Crackle Dust-sc Dust2-sc GaussTrig-sc Gendy1-sc GrayNoise LFClipNoise LFDClipNoise LFDNoise0 LFDNoise1 LFDNoise3  LFNoise0  LFNoise1 LFNoise2 PinkNoise RandID RandSeed WhiteNoise) )
) 


("InOut"  (Out In-sc DiskIn InFeedback))

("Envelope"  (Decay Decay2 EnvGen Env-linen Env-triangle Env-sine Env-perc Env-adsr Line Linen Xline))

("Filters"  
( "BEQSuite" (BAllPass BBandPass BBandStop BHiPass BHiPass4 BHiShelf BLowPass  BLowPass4  BLowShelf  BPeakEQ))
("Linear" (APF  BPF  BPZ2  BRF  Formlet  DynKlank HPF HPZ1  HPZ2 
Integrator  LPF  LPZ1 LPZ2  Lag  Lag2  Lag3  LeakDC  MidEQ  OnePole  OneZero  RHPF  RLPF  Ramp  Resonz   Ringz  SOS  Slope
TwoPole  TwoZero  VarLag MoogFF
))
("NonLinear" (PitchShift FreqShift  Hasher  Hilbert  HilbertFIR  MantissaMask  Median Slew Squiz))
) 


("Multichannel"  
( "Panners" (sig-to-chnls Balance2 LinPan2 Pan4 PanAz Rotate2 Splay SplayAz Mix pan2-sc))
( "Select" (LinSelectX LinXFade2 Select SelectX  SelectXFocus XFade2))

)



("Random"  (TChoose))
("Reverbs"  (FreeVerb FreeVerb2 GVerb))
("Triggers"  (Stepper ))
("Interaction"  (Mouse-scale MouseX MouseY MouseButton ))

("Patterns"  
( "Structures" (play-tclock play-quant scale-root build-pattern simple-pattern pattern2 pattern3  pattern4 pattern5 pattern6 pattern7 pattern8))
( "Composition" (Pbindf Pchain))
( "Data-sharing" (Penvir Pfset Pkey Plambda))
( "Event" ( Pbind Pevent Pmono PmonoArtic ))
( "Filter" ( Pcollect Pdrop Ppatmod Preject Pselect Pset Psetp Psetpre))
( "Function" ( Pfunc Pfuncn Plazy PlazyEnvir PlazyEnvirN Prout Proutine))
( "Language-control" (Pif Pprotect Pseed Pwhile))
( "List" (ListPattern Pgeom Place Ppatlace Prand Pseq Pser Pseries Pshuf  Pslide Pwalk   Ptuple Pwrand Pxrand))
( "Math" (Padd Paddp Paddpre Pavaroh Pbinop PdegreeToKey Pmul Pmulp Pmulpre Pnaryop Prorate Punop Pwrap ))
( "Parallel" (Pgpar Ppar Pspawn Pspawner Ptpar))
( "Random" (  Pbeta Pbrown Pcauchy Pgauss Phprand Plprand Pmeanrand Ppoisson Pprob  Pgbrown  Pexprand   Pwhite))
( "Repetition" ( Pclutch Pconst PdurStutter Pfin  ))


)

)))






