
(IN-PACKAGE :CCL)

(DEFMETHOD NKI
  ((SELF VIOLA-D-AMORE) (TYPE T) (EXPRESSION TRILLO))
  (CASE (AUXILIARY-SYMBOL EXPRESSION)
    (:SHARP #P"Strings/Solo Viola/3 Effects/F SVA Trill WT.nki")
    (T #P"Strings/Solo Viola/3 Effects/F SVA Trill HT.nki")))

(DEFMETHOD NKI
  ((SELF VIOLA-D-AMORE) (TYPE T) (EXPRESSION ACCENT))
  #P"Strings/Solo Viola/2 Short/F SVA Marc Hard.nki")

(DEFMETHOD NKI
  ((SELF VIOLA-D-AMORE) (TYPE T) (EXPRESSION PIZZICATO))
  #P"Strings/Solo Viola/2 Short/F SVA Pizz.nki")

(DEFMETHOD NKI
  ((SELF VIOLA-D-AMORE) (TYPE T) (EXPRESSION COL-LEGNO))
  #P"Strings/Solo Viola/2 Short/F SVA Col Legno.nki")

(DEFMETHOD NKI
  ((SELF VIOLA-D-AMORE) (TYPE T) (EXPRESSION SPICCATO))
  #P"Strings/Solo Viola/2 Short/F SVA Spic RR x2.nki")

(DEFMETHOD NKI
  ((SELF VIOLA-D-AMORE) (TYPE T) (EXPRESSION SLUR))
  #P"Strings/Solo Viola/1 Long/F SVA QLeg.nki")

(DEFMETHOD NKI
  ((SELF VIOLA-D-AMORE) (TYPE T) (EXPRESSION SLUR))
  #P"Strings/Solo Viola/1 Long/F SVA QLeg.nki")
