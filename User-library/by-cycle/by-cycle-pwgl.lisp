;; PWGL specific
;; to have special (french like) accentuation in tutorials, thank's to Mika

(in-package :dbl)
(defmethod parse-DBL-doc((pathname pathname) &key master-db-document document-source backend capi-args
 panes-only-p)
 (declare (ignore document-source))
 (if (equalp (pathname-type pathname) "DBD")
     (let ((*db-directory* pathname))
       (with-open-stream (stream (open pathname :direction :input
                                       :element-type 'ccl::simple-char 
                                       :external-format :utf-8))
         (parse-DBL-doc-stream stream :master-db-document
                               master-db-document :document-source
                               pathname :backend backend 
                               :capi-args capi-args
                               :panes-only-p panes-only-p)))
   (error "Not a DBD file")))

;;;================================================================
;;; menu

(in-package :BY-CYCLE)

(defclass  by-box  (ccl::PWGL-box) ())
(defmethod ccl::special-info-string ((self by-box)) "by")
(ccl::write-key 'by-box  :code-compile t)

(define-menu by-cycle :print-name "by-cycle")
(in-menu by-cycle)

;;=================================================================

(define-menu CYCLE :in by-cycle)
(in-menu cycle)

(define-box kaprekar-l ((list-k (6 1 7 4)) (n 10) (option-k :no))
 "Application de l'algorithme de Kaprekar à une liste d'entier naturel de base n. Le résultat présente le chemin menant au cycle (s'il existe) et le cycle lui-même. 

L'option-k yes/no permet une correction de la liste en fonction de la base donnée.

Exemple: la liste (3 7 2) en base 3 ...

avec l'option-k inactive (:no), l'évaluation sera nil car 3 et 7 ne peuvent exister en base 3 (constituant une condition insatisfaite), par contre avec l'option-k active (:yes), la correction de la liste (3 7 2) sera la liste (1 2 1 2) en base 3, compatible avec kaprekar-l."
 :menu (option-k (:yes ":yes") (:no ":no"))
 :non-generic t
 :class by-box
 (by-cycle::kaprekar-l2 list-k n option-k))

(define-box cycle-x ((crible (7 11 12 8 2 14)) (field-x nil) (i nil) (j nil) (option-x :no))
 "Réalise la matrice de coordonnée i j (lorsque celle-ci est réalisable) dans laquelle un crible donné va par décalage horizontal et vertical constituer les deux cycles du résultat lors de l'évaluation.

L'option-x permet de trouver une solution (optimum avec :yes) par excès (quant field-x est nil) ou par défaut, remplissant la condition matricielle impliquant que le plus grand commun diviseur de i et de j soit égal à un, ou plus simplement que le nombre d'arguments désirés (c'est à dire le produit i j) ne doit pas être un nombre premier.

Lorsque :in-field-x est sélectionné, la solution est optimisée dans le champs borné par la valeur maximum du crible plus un et la valeur de field-x. Cette optimisation consiste à ne retenir que la plus petite valeur de | i - j | non nulle (et par excès).

Lorsque que i et j sont attribuées numériquement, l'option-x est alors inopérant."
 :menu (option-x (:yes ":yes") (:no ":no") (:in-field-x ":in-field-x"))
 :non-generic t
 :class by-box
 (by-cycle::cycle-x1 crible field-x i j option-x))

(define-box cycle-com ((lst (1)))
 "Le principe du commentaire cyclique est de commenter une liste numérique en dénombrant les éléments de cette liste du plus petit au plus grand, et de commenter le commentaire jusqu'à ce que le résultat soit son propre commentaire."
 :non-generic t
 :class by-box
 (by-cycle::commentaire-cyclique1 lst))

(define-box perm-cycl ((lst nil))
 "La permutation cyclique permet de répertorier les cycles d'une liste selon le positionnement de ses éléments."
 :non-generic t
 :class by-box
 (by-cycle::cfp1 lst))

(define-box perm-sym ((lst nil) (code-lst nil))
 "Les permutations symétriques consistent a numéroter (code-lst) des durées chromatiques choisies (lst) [ ou autre référence symbolique ] et de les relire toujours dans le même ordre de lecture."
 :non-generic t
 :class by-box
 (by-cycle::perm-sym1 lst code-lst))

(define-box perm-circ-base ((lst (6 1 7 4)) (opt :no) (n-lst 10) (n-circ 2))
 "Simple permutation circulaire dont il est possible de lire et de permuter d'une base à une autre.

opt permet la conversion d'une liste en n'importe quelle base.
Voir la documentation (option-k) de kaprekar-l pour plus de précisions."
 :menu (opt (:yes ":yes") (:no ":no"))
 :non-generic t
 :class by-box
 (by-cycle::p-c-b lst opt n-lst n-circ))

(menu-separator :in cycle)

(define-box 10->n ((x nil) (n 10))
 "Permet de convertir un nombre entier en une liste en base n. 

Par exemple 234 en base 10 est égal à (2 3 4) et ce même nombre en base 5 est égale à (1 4 1 4), etc..."
 :non-generic t
 :class by-box
 (by-cycle::10->n-a x n))

(define-box n->10 ((lst nil) (n 10))
 "Permet de convertir une liste d'entiers naturels de base n en un nombre en base 10. 

Fait le chemin inverse de la fonction 10->n."
 :non-generic t
 :class by-box
 (by-cycle::n->10-a lst n))

(menu-separator :in cycle)

(define-box mk-integer-lst ((lst nil))
 "Permet de construire une liste d'entier naturel (0 inclus) à partir de n'importe quelle liste."
 :non-generic t
 :class by-box
 (by-cycle::mk-integer-by lst))

(define-box fill-lst ((lst) &optional (n nil))
 "Il s'agit de compléter une liste de listes en insérant en début de chaque liste un 0, de façon que toutes les listes présentent le même nombre d'éléments."
 :non-generic t
 :class by-box
 (by-cycle::fill-list lst n))

(define-menu SEARCH :in by-cycle)
(in-menu search)

(define-box search-rnr ((seq nil) &optional (threshold 0) (length-rnr-list nil))
 "Comme son nom l'indique, cet algorithme permet de rechercher tout Rythme-Non-Retrogradable dans une séquence donné.
En option, la possibilité d'établir un seuil (threshold) de tolérance de ressemblance en pourcentage, 
et la possibilité de filtrer le type de RNR recherché en fonction de sa composition interne (en terme de nombre d'élément), sous forme de liste d'entier naturel dans length-rnr-list.

Pour l'indexation, voir motif-find dans la librairie fv-morphologie (rubrique Differentiation)."
 :non-generic t
 :class by-box 
 (by-cycle::search-rnr2 seq threshold length-rnr-list))

(define-box search-pattern ((pattern nil) (seq nil) &optional (threshold 0))
 "Cet algorithme permet de trouver un rythme donné (sous forme de pattern) à l'intérieur d'une séquence, en tenant compte d'un éventuel monnayage dans la même proportion de durée.
En option, un seuil (threshold) de tolérance de ressemblance peut être appliqué sous forme d'un pourcentage explicite.

Pour l'indexation, voir motif-find dans la librairie fv-morphologie (rubrique Differentiation)."
 :non-generic t
 :class by-box
 (by-cycle::search-pattern-in-lst pattern seq threshold))

(menu-separator :in search)

(define-box streamline-V ((seq nil))
 "Ne retiens que les <peaks> et les <valleys> d'une séquence de type '((x1 y1) (x2 y2) ... (xn yn))."
 :non-generic t
 :class by-box
 (by-cycle::stream-V seq))

(define-box streamline-seq ((seq nil) (threshold 0))
 "Simplifie une séquence de type '((x1 y1) (x2 y2) ... (xn yn)) par la moyenne pondérée suivant un seuil donné (threshold)."
 :non-generic t
 :class by-box
 (by-cycle::streamline seq threshold))

(define-box streamline-wind ((seq nil) (wind 1))
 "Simplifie une séquence de type '((x1 y1) (x2 y2) ... (xn yn)) par la moyenne pondérée de la fenêtre donnée en nombre d'éléments (wind) avec un pas de 1."
 :non-generic t
 :class by-box
 (by-cycle::streamline-w seq wind))

(menu-separator :in search)

(define-box peaks-from-seq ((seq nil))
 "Ne retiens que les <peaks> d'une séquence, laquelle se présente sous la forme: '((x1 y1) (x2 y2) ... (xn yn))."
 :non-generic t
 :class by-box
 (by-cycle::peaks seq))

(define-box valleys-from-seq ((seq nil))
 "Ne retiens que les <valleys> d'une séquence, laquelle se présente sous la forme: '((x1 y1) (x2 y2) ... (xn yn))."
 :non-generic t
 :class by-box
 (by-cycle::valleys seq))

(menu-separator :in search)

(define-box ratio-from-scope ((input nil) (scope nil) (option-rat :no))
 "Converti un nombre réel (ou une liste de nombres réels) en un nombre rationnel (ou une liste de nombres rationnels) suivant une liste de dénominateur(s) donné(s) dans le scope.
[-> implique un arrondi en fonction du scope]

Avec l'option-rat active (:yes), la discrétisation de la liste est respectée.
Attention: la séquence ne doit pas avoir d'élément égal à zéro."
 :menu (option-rat (:yes ":yes") (:no ":no"))
 :non-generic t
 :class by-box
 (by-cycle::rat-fr-sc input scope option-rat))


;;==================================================================
;;; installing menu

(install-menu by-cycle)


