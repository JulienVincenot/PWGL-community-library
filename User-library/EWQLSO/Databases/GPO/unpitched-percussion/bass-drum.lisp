
(IN-PACKAGE :CCL)

(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::BASS-DRUM)
   (TYPE T)
   (SYSTEM::EXPRESSION TRILLO))
  #P"8. Section Strings/1. Violins 1/Vlns 1 Trills H.nki")

(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::BASS-DRUM)
   (TYPE T)
   (SYSTEM::EXPRESSION TREMOLO))
  #P"8. Section Strings/1. Violins 1/Vlns 1 Tremolo.nki")


(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::BASS-DRUM)
   (TYPE T)
   (SYSTEM::EXPRESSION TREMOLO))
  #P"1. Woodwinds/1. Flutes/Flute Solo Flutter.nki")

(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::BASS-DRUM)
   (TYPE T)
   (SYSTEM::EXPRESSION PIZZICATO))
  #P"7. Solo Strings/2. Viola/Viola Pizz Solo.nki")

(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::BASS-DRUM)
   (TYPE T)
   (SYSTEM::EXPRESSION HARMONICS))
  #P"4. Harps/Harp Harmonics 1.nki")

(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::BASS-DRUM)
   (TYPE T)
   (SYSTEM::EXPRESSION CON-SORDINO))
  #P"8. Section Strings/1. Violins 1/Vlns 1 Lush Mutes.nki")

(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::BASS-DRUM)
   (TYPE T)
   (SYSTEM::EXPRESSION SYSTEM::EXPRESSION))
  (COND ((CL-PPCRE:SCAN "flutter*"
                        (SYSTEM::PRINT-SYMBOL SYSTEM::EXPRESSION))
         #P"1. Woodwinds/1. Flutes/Flute Solo Flutter.nki")))