
(IN-PACKAGE :CCL)


(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::PICCOLO)
   (TYPE T)
   (SYSTEM::EXPRESSION TREMOLO))
  #P"1. Woodwinds/1. Flutes/Flute Solo Flutter.nki")

(DEFMETHOD SYSTEM::NKI
  ((SYSTEM::SELF SYSTEM::PICCOLO)
   (TYPE T)
   (SYSTEM::EXPRESSION SYSTEM::EXPRESSION))
  (COND ((CL-PPCRE:SCAN "flutter*"
                        (SYSTEM::PRINT-SYMBOL SYSTEM::EXPRESSION))
         #P"1. Woodwinds/1. Flutes/Flute Solo Flutter.nki")))