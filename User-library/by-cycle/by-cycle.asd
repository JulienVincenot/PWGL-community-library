(in-package :ASDF)

(defsystem :by-cycle

  :description "cycle generator and rhythm search"
  :long-description "Librairie essentiellement d�di�e aux figures rythmiques, elle peut bien entendu s'appliquer � d'autres param�tres. Cette librairie se compose de deux sections avec ses propres utilitaires.
Une section g�n�re des cycles � partir de liste d'entiers naturels. Ces entiers naturels peuvent bien �videmment se rapporter � n'importe quel objet ...
L'autre permet de rechercher � l'int�rieur d'une s�quence des �l�ments rythmiques donn�s...
D'une mani�re g�n�rale, les algorithmes de cette librairie dont les entr�es ne permettent pas de r�pondre aux conditions de fonctionnement de ceux-ci, r�agiront de fa�on pr�dicative."
  :version "03-13"
  :author "Yann Bigot"
  :licence "from Hans Holbein's < Dance of death > woodcut < The New-Married Lady >"
  :maintainer "r�alis�e avec la participation active de Fr�d�ric Voisin"

  ;; :serial t means that each component is only compiled, when the
  ;; predecessors are already loaded
  :serial t
  :components
  (
   (:FILE "package")
   (:FILE "by-cycle")
   (:FILE "by-cycle-pwgl")
    )
  :depends-on (:ompw)
 )
