
(IN-PACKAGE :CCL)

(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::TRUMPET)
   (TYPE T)
   (SYSTEM::EXPRESSION STACCATO))
  #P"23 Trumpet - C/nki/TrC-B_stac-1.nki")

(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::TRUMPET) (TYPE T) (SYSTEM::EXPRESSION SFZ))
  #P"23 Trumpet - C/nki/TrC-B_oV_sfz.nki")
