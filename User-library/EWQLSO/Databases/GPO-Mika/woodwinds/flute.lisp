
(IN-PACKAGE :CCL)


(DEFMETHOD NKI
  ((SELF FLUTE) (TYPE T) (EXPRESSION TREMOLO))
  #P"1. Woodwinds/1. Flutes/Flute Solo Flutter.nki")

(DEFMETHOD NKI
  ((SELF FLUTE) (TYPE T) (EXPRESSION EXPRESSION))
  (COND ((CL-PPCRE:SCAN "flutter*" (PRINT-SYMBOL EXPRESSION))
         #P"1. Woodwinds/1. Flutes/Flute Solo Flutter.nki")))