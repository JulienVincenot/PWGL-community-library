(in-package :FDSDB_XXth_CT)

;; define a user menu
(ccl::add-PWGL-user-menu 
 '(:menu-component
   ("FDSDB_XXth_CT"

   ("Dodecaphony"
   ("Schoenberg" (Retrograde Inverse Retrograde-Inverse Canonical-Forms Chromatic-Transpositions Ordered-Transpositions 12Tone-Matrix-PCS 12Tone-Matrix-MIDIS 12Tone-Matrix-NOTENAME Random-Series))
   ("Berg" (All-Interval-Series))
   ("Webern" (6+6_H+TH 6+6_H+RH 6+6_H+IH 6+6_H+RIH H+TH H+RH H+IH H+RIH 4+4+4_O+O+O 4+4+4_O+R+R 4+4+4_O+I+I 4+4+4_O+RI+RI 4+4+4_O+R+RI 4+4+4_O+RI+R 4+4+4_O+I+R 4+4+4_O+R+I 4+4+4_O+I+RI 4+4+4_O+RI+I Te+TTe+TTe Te+TRTe+TRTe Te+TRTe+TTe Te+TTe+TRTe))
   ("Babbitt" (Babbitt-bichord-ints Babbitt-Rule1 Babbitt-Rule2 Babbitt-Rule3))
)
   ("Serial/Post-serial Music"
   ("Babbitt" (Time-points))
   ("Boulez" (O-Matrix-Pitches O-Matrix-Pitches-Mod I-Matrix-Pitches I-Matrix-Pitches-Mod O-Matrix-Durs O-Matrix-Durs-Mod I-Matrix-Durs I-Matrix-Durs-Mod O-Matrix-Amps O-Matrix-Amps-Mod I-Matrix-Amps I-Matrix-Amps-Mod Generic-mapping Generic-mapping-Mod Demultiplied-Rhythms Demultiplied-Rhythms2 Chord-Multiplication PDA Melody-expansion Derive))
   ("Carter" (Symmetric-Chords))
   ("Ligeti" (LuxAeterna))
    ("Maderna" (Latin-Squares-3X3 Latin-Squares-4X4 Latin-Squares-5X5 Latin-Squares-6X6 Latin-Squares-7X7 Latin-Squares-8X8 Latin-Squares-9X9 Latin-Squares-10X10 Latin-Squares-11X11 Latin-Squares-12X12 Latin-Squares-3X3-list Latin-Squares-4X4-list Latin-Squares-5X5-list Latin-Squares-6X6-list Latin-Squares-7X7-list Latin-Squares-8X8-list Latin-Squares-9X9-list Latin-Squares-10X10-list Latin-Squares-11X11-list Latin-Squares-12X12-list))
   ("Manzoni" (Chord-Expansion))
   ("Messiaen" (Turangalila-mult Turangalila-div LTM-1 LTM-2 NRR-User-defined NRR-User-Poly NRR-Random-Monodic NRR-Random-Polyphonic))
   ("Xenakis" (Sieves Sieves-durs Sieves-pchs Poisson-Matrix Poisson-list))
)
   ("PCST" (PC-T-Invariants PC-T-Invariants-stat PC-IT-Invariants PC-IT-Invariants-stat P-T-Invariants P-T-Invariants-stat P-IT-Invariants P-IT-Invariants-stat Intersections-Tchord2-chord1 Intersections-ITchord2-chord1 pc2dur-size pc2dur-factor p2dur-size p2dur-factor Imbrication))

   ("Rhythm" (Mensural_Canons Mensural_Canons_random Phasing-size Phasing-factor RTM-frgm_no_pauses RTM-frgm_with_pauses Rhythmic-windowing Rhythmic-inversion Mono2Poly Num2RTMs-size Num2RTMs-factor Prime-size Prime-size-del Prime-factor Prime-factor-del Fibo-size Fibo-size-del Fibo-factor Fibo-factor-del Mosaic-Canons Mosaic-Canons+Matrix))

   ("Pitch" (Axis-inversion BPF-Axis-Inversion Mask))
   ("Utilities" (score+chords chords2score in-permut in-repetition in-sorting))
)
))