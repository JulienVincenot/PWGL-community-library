
(IN-PACKAGE :CCL)

(DEFMETHOD NKI
  ((SELF VIOLIN) (TYPE T) (EXPRESSION TREMOLO))
  #P"Strings/18 Violins/1 Long/F 18V Trem LeG.nki")

(DEFMETHOD NKI
  ((SELF VIOLIN) (TYPE T) (EXPRESSION ACCENT))
  #P"Strings/18 Violins/2 Short/F 18V Marc Long.nki")

(DEFMETHOD NKI
  ((SELF VIOLIN) (TYPE T) (EXPRESSION PIZZICATO))
  #P"Strings/18 Violins/2 Short/F 18V Pizz.nki")

(DEFMETHOD NKI
  ((SELF VIOLIN) (TYPE T) (EXPRESSION SPICCATO))
  #P"Strings/18 Violins/2 Short/F 18V Spiccato RR.nki")

(DEFMETHOD NKI
  ((SELF VIOLIN) (TYPE T) (EXPRESSION SLUR))
  #P"Strings/18 Violins/1 Long/F 18V QLeg.nki")

(DEFMETHOD NKI
  ((SELF VIOLIN) (TYPE T) (EXPRESSION SLUR))
  #P"Strings/18 Violins/1 Long/F 18V Butter Legato.nki")

(DEFMETHOD NKI
  ((SELF VIOLIN) (TYPE T) (EXPRESSION SLUR))
  #P"Strings/18 Violins/1 Long/F 18V QLeg.nki")
