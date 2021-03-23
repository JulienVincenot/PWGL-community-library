
(IN-PACKAGE :CCL)

(DEFMETHOD NKI
  ((SELF OBOE-DAMORE) (TYPE T) (EXPRESSION STACCATO))
  #P"Woodwinds/Solo Oboe/2 Short/F SOB Stac.nki")

(DEFMETHOD NKI
  ((SELF OBOE-DAMORE) (TYPE T) (EXPRESSION TRILLO))
  (CASE (AUXILIARY-SYMBOL EXPRESSION)
    (:SHARP #P"Woodwinds/Solo Oboe/3 Effects/F SOB Trill W.nki")
    (T #P"Woodwinds/Solo Oboe/3 Effects/F SOB Trill H.nki")))

(DEFMETHOD NKI
  ((SELF OBOE-DAMORE) (TYPE T) (EXPRESSION SFZ))
  #P"Woodwinds/Solo Oboe/1 Long/F SOB Sfz.nki")

(DEFMETHOD NKI
  ((SELF OBOE-DAMORE) (TYPE T) (EXPRESSION SLUR))
  #P"Woodwinds/Solo Oboe/1 Long/F SOB QLeg.nki")

(DEFMETHOD NKI
  ((SELF OBOE-DAMORE) (TYPE T) (EXPRESSION SLUR))
  #P"Woodwinds/Solo Oboe/1 Long/F SOB QLeg.nki")
