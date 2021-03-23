
(IN-PACKAGE :CCL)

(DEFMETHOD NKI
  ((SELF BASSOON) (TYPE T) (EXPRESSION STACCATO))
  #P"Woodwinds/Solo Bassoon/2 Short/F BSN Stac.nki")

(DEFMETHOD NKI
  ((SELF BASSOON) (TYPE T) (EXPRESSION TRILLO))
  (CASE (AUXILIARY-SYMBOL EXPRESSION)
    (:SHARP #P"Woodwinds/Solo Bassoon/3 Effects/F BSN Trill WT.nki")
    (T #P"Woodwinds/Solo Bassoon/3 Effects/F BSN Trill HT.nki")))

(DEFMETHOD NKI
  ((SELF BASSOON) (TYPE T) (EXPRESSION ACCENT))
  #P"Woodwinds/Solo Bassoon/2 Short/F BSN Marc.nki")

(DEFMETHOD NKI
  ((SELF BASSOON) (TYPE T) (EXPRESSION SLUR))
  #P"Woodwinds/Solo Bassoon/1 Long/F BSN QLeg.nki")

(DEFMETHOD NKI
  ((SELF BASSOON) (TYPE T) (EXPRESSION SLUR))
  #P"Woodwinds/Solo Bassoon/1 Long/F BSN QLeg.nki")
