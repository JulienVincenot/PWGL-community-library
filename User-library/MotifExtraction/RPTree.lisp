(in-package :MOTIFEXTRACTION)

;;; This file contains the class definition for an RP-Tree.
;;; An RP-Tree is a tree data structure for efficiently
;;; organizing Repeating patterns, removing trivial patterns,
;;; and finding all non-trivial patterns.

(defclass RPTree (standard-object) ((root :reader getRoot  
					  :initform (make-instance 'RPTreeNode) )
				    )
)

(defvar *visitedNodes* ()) ; global variable for traversing the tree


(defun addToVisitedNodes (newNode)
     (if (null *visitedNodes*)
        (setf *visitedNodes* (list newNode))
        (nconc *visitedNodes* (list newNode))
     )
)

(defun clearVisitedNodes ()
  (setf *visitedNodes* ())
)

;; ---------------------
;; createNodes (inputList)
;; ---------------------
;; PARAMETERS:
;; patternList - the list of RepeatingPattern objects from which to create a list of RPTreeNode objects
;;
;; DESCRIPTION:
;; Returns a list of RPTreeNode object with nil children and parents from the
;; given a list of RepeatingPattern objects
(defun createNodes (patternList)
  (let ((nodes ()))

    (if (not (null patternList))
	(progn
	  (setq nodes (list (make-instance 'RPTreeNode :data (car patternList) ))
		patternList (cdr patternList))
	  (loop while (not (null patternList)) do
	       (nconc nodes (list (make-instance 'RPTreeNode :data (car patternList) ) ))
	       (setq patternList (cdr patternList))
	  )
	)
    )
    nodes ; return the list of nodes
  )
)

; checks if the input number is a power of 2
(defun isAPowerOf2 (x)
  (and (integerp x) (> x 0) (eql (boole boole-and x (- x 1)) 0))
)

;; ---------------------
;; connect (parent child)
;; ---------------------
;; PARAMETERS:
;; parent - the parent RPTreeNode
;; child - the child RPTreeNode
;;
;; DESCRIPTION:
;; Creates the necessary links between a given parent a child RPTreeNode.
(defun connect (parent child) 
  (addParent child parent)
  (addChild parent child)
)


;; ---------------------
;; tieNilParentsToRoot ((this RPTree) (nodes)))
;; ---------------------
;; PARAMETERS:
;; this RPTree - self-reference
;; nodes sequence - the list of nodes to tie to the root (if their parents are nil)
;;
;; DESCRIPTION:
;; Given a list of RPTreeNode objects, this method ties any of these RPTreeNodes
;; with nil parents to the root (makes the root their parent)
(defmethod tieNilParentsToRoot ((this RPTree) (nodes sequence))
  (with-slots (root) this
    (loop while (not (null nodes)) do
      (if (null (getParents (car nodes))) 
	  (connect root (car nodes)) 
      )
      (setq nodes (cdr nodes))
    )
  )
)


;; ---------------------
;; build_RP_Tree ((this RPTree) (RP2KPatterns sequence) (RPL RPList))
;; ---------------------
;; PARAMETERS:
;; this RPTree - self-reference to this object
;; RP2KPatterns sequence - A list of RPLists containing RP[2^k], RP[2^k-1], ... RP[2], RP[1]
;; RPL RPList - RP[L], the set of longest RepeatingPatterns.
;;
;; DESCRIPTION:
;; Builds an RPTree object given the RepeatingPattern objects in the input list.
(defmethod build_RP_Tree ((this RPTree) (RP2KPatterns sequence) (RPL RPList) (minFreq integer)) 
  (with-slots (root) this
    (let ((currNodes ()) ; used to store unlinked nodes
	  (currNodesCopy1 ()) ; copy of the currNodes list for traversal, substring checking
          (currNodesCopy2 ()) ; copy of the currNodes list for traversal, substring checking
          (currNodesSubString ())
	  (currRPNode) ; holds an RPTreeNode
	  (currRPSubStringNode) ; holds an RPTreeNode which contains potenital substring of another RP
	  )

      (setf (getFreq (getData (getRoot this))) (- minFreq 1)) ; set the root's frequency

      ; create nodes for RPL
      (setq currNodes (createNodes (getPatterns RPL))
	    currNodesCopy1 currNodes
	    currNodesCopy2 currNodes)

      ; Check if any pattern in RPL is a subpattern of another in RPL
      (loop while (not (null currNodesCopy1)) do
	   (setq currRPNode (car currNodesCopy1))
	   (loop while (not (null currNodesCopy2)) do
		(setq currRPSubStringNode (car currNodesCopy2))

		(if (and (< (length (getPattern (getData currRPSubStringNode))) 
			    (length (getPattern (getData currRPNode)))  ) 
			 (not (null (search (getPattern (getData currRPSubStringNode)) (getPattern (getData currRPNode)) :test #'equal) )))
		    ; currRPSubString is a subsequence of currRP,
		    ; so make currSubString a child of currString
		    ; unless their frequencies are equal, then delete the substring
		    (if (eql (getFreq (getData currRPNode)) (getFreq (getData currRPSubStringNode)))
		        (setq currNodes (delete currRPSubStringNode currNodes :count 1)
			      currNodesCopy1 (delete currRPSubStringNode currNodesCopy1 :count 1))
			; else

			(connect currRPNode currRPSubStringNode)
		    )
		)
		(setq currNodesCopy2 (cdr currNodesCopy2))
	   )
	   (setq currNodesCopy2 currNodes
	         currNodesCopy1 (cdr currNodesCopy1))
      )
      

      ; set any nodes with nil parents to children of the root node:
      (tieNilParentsToRoot this currNodes)


      ; create nodes for RP2K
      (setq currNodesSubString (createNodes (getPatterns (car RP2KPatterns)))
	    currNodesCopy1 currNodesSubString)

      ; Check if any pattern in RP2K is a subpattern of one in RPL
      (loop while (not (null currNodes)) do
	   (setq currRPNode (car currNodes))
	   (loop while (not (null currNodesCopy1)) do
		(setq currRPSubStringNode (car currNodesCopy1))
		(if (not (null 
			  (search (getPattern (getData currRPSubStringNode)) (getPattern (getData currRPNode)) :test #'equal) )) 
		    ; currRPSubString is a subsequence of currRP,
		    ; so make currSubString a child of currString
		    (connect currRPNode currRPSubStringNode)
		)
		(setq currNodesCopy1 (cdr currNodesCopy1))
	   )
	   (setq currNodesCopy1 currNodesSubString
	         currNodes (cdr currNodes))
      )

      ; set any nodes with nil parents to children of the root node:
      (tieNilParentsToRoot this currNodesSubString)
     
      (setq currNodes currNodesSubString)
            ;currNodesSubString (createNodes (getPatterns (cadr RP2KPatterns)))
	    ;currNodesCopy1 (copy-list currNodesSubString))

      (loop while (> (length RP2KPatterns) 1) do
	     (setq currNodesSubString (createNodes (getPatterns (cadr RP2KPatterns)))
		   currNodesCopy1 currNodesSubString)
	     ; Check if any pattern in RP2K is a subpattern of one in RPL
	     (loop while (not (null currNodes)) do
		  (setq currRPNode (car currNodes))
		  (loop while (not (null currNodesCopy1)) do
		       (setq currRPSubStringNode (car currNodesCopy1))
		       (if (not (null 
				 (search (getPattern (getData currRPSubStringNode)) (getPattern (getData currRPNode)) :test #'equal) )) 
			   ; currRPSubString is a subsequence of currRP,
			   ; so make currSubString a child of currString
			   (connect currRPNode currRPSubStringNode)
		       )
		       (setq currNodesCopy1 (cdr currNodesCopy1))
		  )
		  (setq currNodesCopy1 currNodesSubString
		        currNodes (cdr currNodes))
	     )

	     ; set any nodes with nil parents to children of the root node:
	     (tieNilParentsToRoot this currNodesSubString)
	     (setq RP2KPatterns (cdr RP2KPatterns))

             (setq currNodes currNodesSubString)
		   ;currNodesSubString (createNodes (getPatterns (cadr RP2KPatterns)))
		   ;currNodesCopy1 (copy-list currNodesSubString))
      )

    )
  )
)


(defmethod refine_RP_tree ((this RPTree))
  (with-slots (root) this
    (clearVisitedNodes)
    (refine_RP_tree_stub this root (getChildren root))
  )
)

;; ---------------------
;; refine_RP_tree_stub ((this RPTree) (currNode RPTreeNode) (children sequence))
;; ---------------------
;; PARAMETERS:
;; this RPTree - self-reference
;; currNode RPTreeNode - should be passed the root initially
;; children sequence - used in the recursion
;;
;; DESCRIPTION:
;; Refines an RPTree that was created using the build_RP_tree method. Any trivial
;; patterns are removed by this method.
(defmethod refine_RP_tree_stub ((this RPTree) (currNode RPTreeNode) (children sequence))
  (with-slots (root) this
    (let ((currParents ())
	  (currParent ())
	  )

      (loop while (not (null children)) do
         (refine_RP_tree_stub this (car children) (getChildren (car children)))
         (setq children (cdr children))
      )

      ;(traverseAndPrint this)
      ;(print " ")
      ;(clearVisitedNodesTraverse)


      (if (null (find currNode *visitedNodes*))
        (progn
	  
	  ;(print "visiting node:")
	  ;(printNode currNode)
	  
	  (setq currParents (getParents currNode))

	  ; check if this node's frequency equals that of any of it's parents
	  ; if it does, stop checking and remove the node
	  (loop while (not (null currParents)) do
	       (setq currParent (car currParents))
	       (if (eql (getFreq (getData currParent)) (getFreq (getData currNode)) )
		   (setq currParents nil)
		   ; else
		   (setq currParents (cdr currParents))
	       )
	  )
	  (if (and (not (null currParent))
		  (eql (getFreq (getData currParent)) (getFreq (getData currNode))))
		  ; if here, the freqency of this node is equal to that of one of it's parents
		  ; so remove the node, it is trivial
	          ;(progn 
		  (removeNode currNode) 
		  ;(print "deleted")
		  ;(print " ") 
		  ; (print "parent of removed node:") (printNode currParent) )
	  )
	  (addToVisitedNodes currNode)
        )
      )
    )
  )
)


(defmethod generate_nontrivial_RP ((this RPTree))
  (with-slots (root) this
    (clearVisitedNodes)
    (generate_nontrivial_RP_stub this root (getChildren root))
    ;(traverseAndPrint this)
  )
)

;; ---------------------
;; refine_RP_tree_stub ((this RPTree) (currNode RPTreeNode) (children sequence))
;; ---------------------
;; PARAMETERS:
;; this RPTree - self-reference
;; currNode RPTreeNode - should be passed the root initially
;; children sequence - used in the recursion
;;
;; DESCRIPTION:
;; Refines an RPTree that was created using the build_RP_tree method. Any trivial
;; patterns are removed by this method.
(defmethod generate_nontrivial_RP_stub ((this RPTree) (currNode RPTreeNode) (children sequence))
  (with-slots (root) this
    (let ((currParents ())
	  (siblings ())
	  (currParent ())
	  (currSiblings1 ())
	  (currSiblings2 ())
	  (currSibling1 ())
	  (currSibling2 ())
	  (newRP ())
	  (newNode ())
	  (m 0)
	  (terminateLength 0)
	  (currFreq)
	  (currSiblingJoinNodes ()) ; holds list of new nodes created from a certain sibling
	  (falsePositiveNode) ; for a rare special case
	  )

      (loop while (not (null children)) do
         (generate_nontrivial_RP_stub this (car children) (getChildren (car children)))
         (setq children (cdr children))
      )

      ;(traverseAndPrint this)
      ;(print " ")
      ;(clearVisitedNodesTraverse)


      (setq currParents (getParents currNode))

      (loop while (not (null currParents)) do

	(setq currParent (car currParents)
	      siblings (getChildren currParent)
	      currSiblings1 siblings
	      currSiblings2 siblings)
	      ;currFreq (getFreq (getData currParent)))

        (if (null (find currParent *visitedNodes*))
          (progn

	    ; String join all siblings of the same length
	    (loop while (not (null currSiblings1)) do
	        (setq currSibling1 (car currSiblings1)
		      currSiblingJoinNodes ())
		(loop while (not (null currSiblings2)) do

		     (setq currSibling2 (car currSiblings2)
		           currParent (car currParents)
		           currFreq (getFreq (getData currParent)))

		     ; check if these two siblings are of the same length
		     (if (and (eql (getPatternLength (getData currSibling1)) (getPatternLength (getData currSibling2)))
			      (isAPowerOf2 (getPatternLength (getData currSibling1) ) ) )
			 ; if they are, string join them
			 (progn
			   (setq m 1
			         terminateLength (getPatternLength (getData currSibling1)) 
				 doneLoop ())
			   (loop while (and (< m terminateLength) (not doneLoop)) do
				(setq newRP (stringJoin (getData currSibling1) (getData currSibling2) m))
				(if (> (getFreq newRP) currFreq )
				    ; we've found a new non-trivial node
				    ; add it to the tree with parent currParent,
				    ; and two children (currSibling1 and currSibling2)
				    ; if the frequency of currSibling1 or currSibling2
				    ; is the same as the new node, remove said node.
				    (if (and (null (hasParent currSibling1 newRP)) (null (hasParent currSibling2 newRP)))
				      (progn

					(setq falsePositiveNode (find-if #'(lambda (x) (search (getPattern (getData x)) (getPattern newRP) :test #'equal)) currSiblingJoinNodes ))

					; see if a shorter node exists
					(if falsePositiveNode
					    (if (eql (getFreq (getData falsePositiveNode)) (getFreq newRP))
					        (removeNode falsePositiveNode)
					    )					    
					)

					
					(if (or falsePositiveNode (not (find-if #'(lambda (x) (search (getPattern newRP) (getPattern (getData x)) :test #'equal)) currSiblingJoinNodes )))
					(progn
					(setq currFreq (getFreq newRP))
					;(if (eql (car (getPositions newRP)) 639)
					    ;(progn
					      ;(print "Sibling1")
					      ;(printNode currSibling1)
					      ;(print "Sibling2")
					      ;(printNode currSibling2)
					      ;(print "NewNode")
					      ;(printPattern newRP)
					    ;)
					;)

				        (setq newNode (make-instance 'RPTreeNode :data newRP))
				        (insertNontrivial newNode currParent currSibling1 currSibling2)

					; append the new node to the list currSiblingJoinNodes
					(if (null currSiblingJoinNodes)
					  (setf currSiblingJoinNodes (list newNode))
					  (setf currSiblingJoinNodes (nconc currSiblingJoinNodes (list newNode)))
					)

					(addToVisitedNodes currParent)
					(setq currParent newNode) ; make the new node the currParent					
				        (if (eql (getFreq newRP) (getFreq (getData currSibling1)))
					  (progn
					    (setq doneLoop t)
					    (removeNode currSibling1)
					    ;(delete currSibling1 siblings :count 1)
					    ;(delete currSibling1 currSiblings2 :count 1)
					  )
				        )

				        (if (eql (getFreq newRP) (getFreq (getData currSibling2)))
					  (progn
					    (setq doneLoop t)
					    (removeNode currSibling2)
					    ;(delete currSibling2 siblings :count 1)
					    ;(delete currSibling2 currSiblings1 :count 1)
					  )
				        )
					)
					)
				      )
				    )
				)
				(setq m (1+ m))
			   )
                         )
		     )
		     (setq currSiblings2 (cdr currSiblings2))
		 )
		 (setq currSiblings1 (cdr currSiblings1)
		       currSiblings2 siblings)
	    )

	    (if (and (not (null currParent))
		  (eql (getFreq (getData currParent)) (getFreq (getData currNode))))
		  ; if here, the freqency of this node is equal to that of one of it's parents
		  ; so remove the node, it is trivial
	          ; (progn 
		  (removeNode currNode) 
		  ;(print "deleted")
		  ;(print " ") 
		  ; (print "parent of removed node:") (printNode currParent) )
	    )

	    (addToVisitedNodes currParent)	    
          ) 
        )
        (setq currParents (cdr currParents))
      )
    )
  )
)

(defmethod getRootsChildren ((this RPTree))
  (mapcar #'getData (getChildren (getRoot this)))
)


(defvar *patternList* ())

(defun addToPatternList (newPattern)
     (if (null *patternList*)
        (setf *patternList* (list newPattern))
        (nconc *patternList* (list newPattern))
     )
)

(defun clearPatternList ()
  (setf *patternList* ())
)


(defmethod makeRPList ((this RPTree))
  (with-slots (root) this
      (clearVisitedNodes)
      (clearPatternList)
      (addToVisitedNodes root) ; don't add the null root to the list
      (makeRPListStub this root (getChildren root))
      ;(delete root *patternList*)
      *patternList*
  )
)

; postorder traversal
(defmethod makeRPListStub ((this RPTree) (currNode RPTreeNode) (children sequence) )
  (with-slots (root) this

      (loop while (not (null children)) do
          (makeRPListStub this (car children) (getChildren (car children))) 
	  (setq children (cdr children))
      )

      (if (null (find currNode *visitedNodes*))
	  (progn 
	    (addToPatternList (getData currNode))
	    (addToVisitedNodes currNode)
  	  )
      )
    

  )
)



(defvar *visitedNodesTraverse* ())
(defun addToVisitedNodesTraverse (newNode)
     (if (null *visitedNodesTraverse*)
        (setf *visitedNodesTraverse* (list newNode))
        (nconc *visitedNodesTraverse* (list newNode))
     )
)

(defun clearVisitedNodesTraverse ()
  (setf *visitedNodesTraverse* ())
)

(defmethod traverseAndPrint ((this RPTree))
  (with-slots (root) this
      (clearVisitedNodesTraverse)
      (traverseAndPrintStub this root (getChildren root))
  )
)



;; pass the root as currNode
(defmethod traverseAndPrintStub ((this RPTree) (currNode RPTreeNode) (children sequence) )
  (with-slots (root) this

      (loop while (not (null children)) do
          (traverseAndPrintStub this (car children) (getChildren (car children))) 
	  (setq children (cdr children))
      )
    
      (if (null (find currNode *visitedNodesTraverse*))
	  (progn 
	    (printNode currNode)
	    (addToVisitedNodesTraverse currNode)
  	  )
      )
  )
)


(defun testBuildTree (string)
  (let ((RP1 ())
	(RP2K ())
        (RP2KList ())
	(RPL ())
	(tree ()))
 
    (setq RP1 (find_RP1 string)
	  RP2K RP1)
    (loop while (not (isEmpty RP2K)) do
	 (printList RP2K)
	 (setq  RP2KList (append (list RP2K) RP2KList)
                RP2K (find_RP2K (car RP2KList)))
	 
    )

    (setq RPL (find_longest_RP (car RP2KList)))
    (printList RPL)

    (setq tree (make-instance 'RPTree))
    (build_RP_Tree tree RP2KList RPL 2)
    (traverseAndPrint tree)
  )
)

(defun testRefineTree (string)
  (let ((RP1 ())
	(RP2K ())
        (RP2KList ())
	(RPL ())
	(tree ()))
 
    (setq RP1 (find_RP1 string)
	  RP2K RP1)
    (loop while (not (isEmpty RP2K)) do
	 (printList RP2K)
	 (setq  RP2KList (append (list RP2K) RP2KList)
                RP2K (find_RP2K (car RP2KList)))
	 
    )

    (setq RPL (find_longest_RP (car RP2KList)))
    (printList RPL)

    (setq tree (make-instance 'RPTree))
    (build_RP_Tree tree RP2KList RPL 2)
    (print "Built RP Tree:")
    (traverseAndPrint tree)
    (print " ")
    (print "Refined RP Tree:")
    (refine_RP_Tree tree)
    (traverseAndPrint tree)
  )
)

(defun testGenerateNonTrivial (string)
  (let ((RP1 ())
	(RP2K ())
        (RP2KList ())
	(RPL ())
	(tree ()))
 
    (setq RP1 (find_RP1 string)
	  RP2K RP1)
    (loop while (not (isEmpty RP2K)) do
	 (printList RP2K)
	 (setq  RP2KList (append (list RP2K) RP2KList)
                RP2K (find_RP2K (car RP2KList)))
	 
    )

    (setq RPL (find_longest_RP (car RP2KList)))
    (printList RPL)

    (setq tree (make-instance 'RPTree))
    (build_RP_Tree tree RP2KList RPL 2)
    (print "Built RP Tree:")
    (traverseAndPrint tree)
    (print " ")
    (print "Refined RP Tree:")
    (refine_RP_Tree tree)
    (traverseAndPrint tree)
    (print " ")
    (print "Complete tree:")
    (generate_nontrivial_RP tree)
  )
)





