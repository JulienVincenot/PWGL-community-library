
(IN-PACKAGE :CCL)

(DEFMETHOD NKI
  ((SELF PICCOLO) (TYPE T) (EXPRESSION STACCATO))
  #P"Woodwinds/Solo Piccolo Flute/2 Short/F Pfl Stac.nki")

(DEFMETHOD NKI
  ((SELF PICCOLO) (TYPE T) (EXPRESSION TRILLO))
  (CASE (AUXILIARY-SYMBOL EXPRESSION)
    (:SHARP
     #P"Woodwinds/Solo Piccolo Flute/3 Effects/F PFL Trill W.nki")
    (T #P"Woodwinds/Solo Piccolo Flute/3 Effects/F PFL Trill H.nki")))

(DEFMETHOD NKI
  ((SELF PICCOLO) (TYPE T) (EXPRESSION SLUR))
  #P"Woodwinds/Solo Piccolo Flute/1 Long/F PFL QLeg.nki")

(DEFMETHOD NKI
  ((SELF PICCOLO) (TYPE T) (EXPRESSION SLUR))
  #P"Woodwinds/Solo Piccolo Flute/1 Long/F PFL QLeg.nki")
