
(IN-PACKAGE :CCL)

(DEFMETHOD NKI
  ((SELF CONTRABASS) (TYPE T) (EXPRESSION TREMOLO))
  #P"Strings/9 Double Basses/1 Long/F Cbs Trem.nki")

(DEFMETHOD NKI
  ((SELF CONTRABASS) (TYPE T) (EXPRESSION PIZZICATO))
  #P"Strings/9 Double Basses/2 Short/F CBS Pizz.nki")

(DEFMETHOD NKI
  ((SELF CONTRABASS) (TYPE T) (EXPRESSION SLUR))
  #P"Strings/9 Double Basses/1 Long/F Cbs Trem Leg.nki")
