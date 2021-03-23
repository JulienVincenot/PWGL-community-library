
(IN-PACKAGE :CCL)

(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::CONTRABASS)
   (TYPE T)
   (SYSTEM::EXPRESSION STACCATO))
  #P"43 Solo strings/Solo bass/nki/KB-B_stac.nki")

(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::CONTRABASS)
   (TYPE T)
   (SYSTEM::EXPRESSION TRILLO))
  #P"43 Solo strings/Solo bass/nki/KB_tr_GS.nki")

(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::CONTRABASS)
   (TYPE T)
   (SYSTEM::EXPRESSION TREMOLO))
  #P"43 Solo strings/Solo bass/nki/KB_trem_0sus.nki")

(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::CONTRABASS)
   (TYPE T)
   (SYSTEM::EXPRESSION PIZZICATO))
  #P"43 Solo strings/Solo bass/nki/KB-B_pz-.nki")

(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::CONTRABASS)
   (TYPE T)
   (SYSTEM::EXPRESSION COL-LEGNO))
  #P"43 Solo strings/Solo bass/nki/KB_legno-1.nki")

(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::CONTRABASS)
   (TYPE T)
   (SYSTEM::EXPRESSION BARTOK-PIZZICATO))
  #P"43 Solo strings/Solo bass/nki/KB_pzbtk-1.nki")