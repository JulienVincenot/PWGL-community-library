(in-package :MOTIFEXTRACTION)

;;; This file contains the class definition for a RP Tree node,
;;; each of which holds a RepeatingPattern object,
;;; a list of parents and children (also RPTreeNodes)

(defclass RPTreeNode (standard-object) ((data :initform (make-instance 'RepeatingPattern :pattern '() :positions '()) :accessor getData :initarg :data) 
					(parents :accessor getParents :initform ())
					(children :accessor getChildren :initform ()) ))


(defmethod hasChild ((this RPTreeNode) (testChildPattern RepeatingPattern))
  (with-slots (children) this
    (let ((found ())
	  (currChildren (getChildren this)))
      (loop until (or found (null currChildren)) do
	   (setq found (patternEqual testChildPattern (getData (car currChildren)) )
		 currChildren (cdr currChildren))
      )
      found
    )
  )
)

(defmethod hasSibling ((this RPTreeNode) (testSiblingPattern RepeatingPattern))
    (let ((found ())
	  (currParents (getParents this)))
      (loop until (or found (null currParents)) do
	   (setq found (hasChild (car currParents) testSiblingPattern)
		 currParents (cdr currParents))
      )
      found
    )
)

(defmethod hasParent ((this RPTreeNode) (testParentPattern RepeatingPattern))
    (let ((found ())
	  (currParents (getParents this)))
      (loop until (or found (null currParents)) do
	   (setq found (patternEqual testParentPattern (getData (car currParents)) )
		 currParents (cdr currParents))
      )
      found
    )
)



; adds a child to this nodes list of children
(defmethod addChild ((this RPTreeNode) (newChild RPTreeNode))
  (with-slots (children) this
    (if (and (null (find newChild children)) (not (eq newChild this)))
      (if (null children) 
	  (setf (getChildren this) (list newChild))
	  (setf (getChildren this) (nconc (getChildren this) (list newChild)))
      )
    )
  )
)

(defmethod addChildren ((this RPTreeNode) (newChildren sequence))
  (with-slots (children) this
    ;(if (not (null newChildren))
      (progn
      (if (null children)
	  (setf (getChildren this) (remove this newChildren :count 1))
	  (setf (getChildren this) (nconc (getChildren this) (remove this newChildren :count 1)))
      )
      (setf (getChildren this) (delete-duplicates (getChildren this)))
      )
    ;)
    ;(setf (getChildren this) (delete this children :count 1))
  )
)

(defmethod addParent ((this RPTreeNode) (newParent RPTreeNode))
  (with-slots (parents) this
    (if (and (null (find newParent parents)) (not (eq newParent this)))
      (if (null parents) 
	  (setf (getParents this) (list newParent))
	  (setf (getParents this) (nconc (getParents this) (list newParent)))
      )
    )
  )
)

(defmethod addParents ((this RPTreeNode) (newParents sequence))
  (with-slots (parents) this
    ;(if (not (null newParents))
      (progn 
      (if (null parents)
  	(setf (getParents this) (remove this newParents :count 1))
	(setf (getParents this) (nconc (getParents this) (remove this newParents :count 1)))
      )

      ;(print "New Parents:")
      ;(mapcar #'printNode newParents)
      ;(print "parent print complete")
      (setf (getParents this) (delete-duplicates (getParents this)))
      ;(setf (getParents this) (delete this parents :count 1))
      ;)
    )
  )
)

(defmethod removeChild ((this RPTreeNode) (child RPTreeNode))
  (with-slots (children) this
    (setf (getChildren this) (delete child (getChildren this) :count 1))
  )
) 

(defmethod removeParent ((this RPTreeNode) (parent RPTreeNode))
  (with-slots (parents) this
    (setf (getParents this) (delete parent (getParents this) :count 1)) 
  )
)

(defmethod removeNode ((this RPTreeNode))
  (with-slots (parents children) this
    ;(print "removing node:")
    ;(printNode this)
    (let ((currParents (getParents this))
	  (currChildren (getChildren this)))

      ; remove this child from all of it's parents,
      (loop while (not (null currParents)) do
	   (removeChild (car currParents) this) ; remove this node as a child
	   (addChildren (car currParents) (getChildren this)) ; add this nodes children to each parent of this
	   (setq currParents (cdr currParents))
      )

      ; add the new parents to each child, remove old parent (this)
      (loop while (not (null currChildren)) do
	   (removeParent (car currChildren) this)
	   (addParents (car currChildren) (getParents this))
	   (setq currChildren (cdr currChildren))
      )
	  
    )
  )
)

(defmethod insertNontrivial ((this RPTreeNode) 
			     (newParent RPTreeNode) 
			     (newChild1 RPTreeNode)
			     (newChild2 RPTreeNode))


    ; set the parents and children of this node
    (addParent this newParent)
    (addChild this newChild1)
    (addChild this newChild2)

    ; remove former children from parent
    (removeChild newParent newChild1)
    (removeChild newParent newChild2)
    
    ; remove former parent from children
    (removeParent newChild1 newParent)
    (removeParent newChild2 newParent)

    ; add this as the newParent's child
    (addChild newParent this)

    ; add this as newChild1 and newChild2's parent
    (addParent newChild1 this)
    (addParent newChild2 this)

    ; if the frequency of either child's pattern equals the frequency
    ; of this node, remove that child from the tree.

    ;(if (eql (getFreq (getData this)) (getFreq (getData newChild1)))
;	(removeNode newChild1)
;    )

    ;(if (eql (getFreq (getData this)) (getFreq (getData newChild2)))
;	(removeNode newChild2)
;    )
)



(defmethod toString ((this RPTreeNode))
  (with-slots (parents children) this
    (let ((tempChildren children) 
	  (tempParents parents) 
	  (outputString))
      (setq outputString
          (format nil "Node: ~S, Parents: " (if (null (getData this)) "()" (toString (getData this))) ) )


      (loop until (null tempParents) do
	   (setq outputString (concatenate 'string outputString
					   (format nil "~S   " 
						   (if (null (getData (car tempParents))) "()" (toString (getData (car tempParents))) ))))
	   (setq tempParents (cdr tempParents))
      )


      (setq outputString (concatenate 'string outputString ", Children: "))

      (loop until (null tempChildren) do
	   (setq outputString (concatenate 'string outputString
		 (format nil "~S   " (toString (getData (car tempChildren))))))

	   (setq tempChildren (cdr tempChildren))
      )
      outputString
    )
  )
)

(defmethod printNode ((this RPTreeNode))
  (print (toString this))
)

