(in-package :ASDF)

(defsystem :by-cycle

  :description "cycle generator and rhythm search"
  :long-description "Librairie essentiellement dédiée aux figures rythmiques, elle peut bien entendu s'appliquer à d'autres paramètres. Cette librairie se compose de deux sections avec ses propres utilitaires.
Une section génére des cycles à partir de liste d'entiers naturels. Ces entiers naturels peuvent bien évidemment se rapporter à n'importe quel objet ...
L'autre permet de rechercher à l'intérieur d'une séquence des éléments rythmiques donnés...
D'une manière générale, les algorithmes de cette librairie dont les entrées ne permettent pas de répondre aux conditions de fonctionnement de ceux-ci, réagiront de façon prédicative."
  :version "03-13"
  :author "Yann Bigot"
  :licence "from Hans Holbein's < Dance of death > woodcut < The New-Married Lady >"
  :maintainer "réalisée avec la participation active de Frédéric Voisin"

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
