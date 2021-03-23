
(IN-PACKAGE :CCL)

(DEFMETHOD NKI
  ((SELF ENGLISH-HORN) (TYPE T) (EXPRESSION STACCATO))
  #P"Woodwinds/Solo English Horn 2/2 Short/F EH2 Stac.nki")

(DEFMETHOD NKI
  ((SELF ENGLISH-HORN) (TYPE T) (EXPRESSION TRILLO))
  (CASE (AUXILIARY-SYMBOL EXPRESSION)
    (:SHARP
     #P"Woodwinds/Solo English Horn 2/3 Effects/F EH2 Trill WT.nki")
    (T #P"Woodwinds/Solo English Horn 2/3 Effects/F EH2 Trill HT.nki")))

(DEFMETHOD NKI
  ((SELF ENGLISH-HORN) (TYPE T) (EXPRESSION SLUR))
  #P"Woodwinds/Solo English Horn 2/1 Long/F EH2 QLeg.nki")

(DEFMETHOD NKI
  ((SELF ENGLISH-HORN) (TYPE T) (EXPRESSION SLUR))
  #P"Woodwinds/Solo English Horn 2/1 Long/F EH2 QLeg.nki")
