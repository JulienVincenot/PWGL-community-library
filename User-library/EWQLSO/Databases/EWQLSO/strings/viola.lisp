
(IN-PACKAGE :CCL)

(DEFMETHOD NKI
  ((SELF VIOLA) (TYPE T) (EXPRESSION STACCATO))
  #P"Strings/10 Violas/2 Short/F VAS Stac RR x4.nki")

(DEFMETHOD NKI
  ((SELF VIOLA) (TYPE T) (EXPRESSION TRILLO))
  (CASE (AUXILIARY-SYMBOL EXPRESSION)
    (:SHARP #P"Strings/10 Violas/3 Effects/F VAS Trill WT.nki")
    (T #P"Strings/10 Violas/3 Effects/F VAS Trill HT.nki")))

(DEFMETHOD NKI
  ((SELF VIOLA) (TYPE T) (EXPRESSION TREMOLO))
  #P"Strings/10 Violas/3 Effects/F VAS Trem.nki")

(DEFMETHOD NKI
  ((SELF VIOLA) (TYPE T) (EXPRESSION ACCENT))
  #P"Strings/10 Violas/2 Short/F VAS Marc Long.nki")

(DEFMETHOD NKI
  ((SELF VIOLA) (TYPE T) (EXPRESSION PIZZICATO))
  #P"Strings/10 Violas/2 Short/F VAS Pizz.nki")

(DEFMETHOD NKI
  ((SELF VIOLA) (TYPE T) (EXPRESSION COL-LEGNO))
  #P"Strings/10 Violas/2 Short/F VAS Col Legno.nki")

(DEFMETHOD NKI
  ((SELF VIOLA) (TYPE T) (EXPRESSION SLUR))
  #P"Strings/10 Violas/1 Long/F VAS QLeg.nki")

(DEFMETHOD NKI
  ((SELF VIOLA) (TYPE T) (EXPRESSION SLUR))
  #P"Strings/10 Violas/1 Long/F VAS QLeg.nki")
