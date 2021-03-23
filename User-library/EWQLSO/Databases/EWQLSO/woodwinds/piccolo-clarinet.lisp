
(IN-PACKAGE :CCL)

(DEFMETHOD NKI
  ((SELF PICCOLO-CLARINET) (TYPE T) (EXPRESSION STACCATO))
  #P"Woodwinds/Solo Clarinet/2 Short/F 3Cl Stac.nki")

(DEFMETHOD NKI
  ((SELF PICCOLO-CLARINET) (TYPE T) (EXPRESSION TRILLO))
  (CASE (AUXILIARY-SYMBOL EXPRESSION)
    (:SHARP #P"Woodwinds/Solo Clarinet/3 Effects/F SCL Trill WT.nki")
    (T #P"Woodwinds/Solo Clarinet/3 Effects/F SCL Trill HT.nki")))

(DEFMETHOD NKI
  ((SELF PICCOLO-CLARINET) (TYPE T) (EXPRESSION ACCENT))
  #P"Woodwinds/Solo Clarinet/2 Short/F SCL Marc.nki")

(DEFMETHOD NKI
  ((SELF PICCOLO-CLARINET) (TYPE T) (EXPRESSION SLUR))
  #P"Woodwinds/Solo Clarinet/1 Long/F SCL QLeg.nki")

(DEFMETHOD NKI
  ((SELF PICCOLO-CLARINET) (TYPE T) (EXPRESSION SLUR))
  #P"Woodwinds/Solo Clarinet/1 Long/F SCL QLeg.nki")
