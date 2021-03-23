
(IN-PACKAGE :CCL)

(DEFMETHOD NKI
  ((SELF BASS-FLUTE) (TYPE T) (EXPRESSION STACCATO))
  #P"Woodwinds/Solo Flute/2 Short/F SFL Stac.nki")

(DEFMETHOD NKI
  ((SELF BASS-FLUTE) (TYPE T) (EXPRESSION TRILLO))
  (CASE (AUXILIARY-SYMBOL EXPRESSION)
    (:SHARP #P"Woodwinds/Solo Flute/3 Effects/F SFL Trill WT.nki")
    (T #P"Woodwinds/Solo Flute/3 Effects/F SFL Trill HT.nki")))


(DEFMETHOD NKI
  ((SELF BASS-FLUTE) (TYPE T) (EXPRESSION TREMOLO))
  #P"Woodwinds/Solo Flute/3 Effects/F SFL Flutter Mod.nki")

(DEFMETHOD NKI
  ((SELF BASS-FLUTE) (TYPE T) (EXPRESSION SLUR))
  #P"Woodwinds/Solo Flute/1 Long/F SFL QLeg.nki")

(DEFMETHOD NKI
  ((SELF BASS-FLUTE) (TYPE T) (EXPRESSION SLUR))
  #P"Woodwinds/Solo Flute/1 Long/F SFL Exp Legato.nki")

(DEFMETHOD NKI
  ((SELF BASS-FLUTE) (TYPE T) (EXPRESSION SLUR))
  #P"Woodwinds/Solo Flute/1 Long/F SFL QLeg.nki")

(DEFMETHOD NKI
  ((SELF BASS-FLUTE) (TYPE T) (EXPRESSION EXPRESSION))
  (COND ((CL-PPCRE:SCAN "flutter*" (PRINT-SYMBOL EXPRESSION))
         #P"Woodwinds/Solo Flute/3 Effects/F SFL Flutter Mod.nki")))