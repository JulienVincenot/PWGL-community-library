;;; -*- Mode: Lisp; Syntax: Common-Lisp; -*- File: utils.lisp

;; code for doing a very inefficient minimum spanning tree
;; using Kruskal's algorithm.

;; Assumption: a tree is a list of edges such as: (n1 n2 w)  where 
;; n1 and n2 are nodes and w is a weight.  Note that graphs are undirected,
;; so the algorithm assumes that it will not see (n2 n1 w).
;;
;; To call, simply execute a form like: (mst '((1 2 .3) (1 3 .6) (2 3 .1)))
;;    or (mst '((A B 10) (A C 3) (B C 2)))

;;;;;;;;;;;;;;;;;;;;;
(in-package :k-lib);;
;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;; helper functions

;; sort by the third element in a list
(defun sorter-third (x y)
  (< (third x) (third y)))
(defun rsorter-third (x y)
  (> (third x) (third y)))
;; calls member with #'equal :test
(defun memberequal (item list)
  (member item list :test #'equal))
;; slices element pos out of a list
(defun list-slice (pos l)
  (append (subseq l 0 pos)
	  (subseq l (1+ pos))))

;;;;;;;;;; union find functions

;; returns non-nil if the two vertices are in the same equiv class
(defun uf-connected (e uf)
  (member-if #'(lambda (set) (and (member (first e) set)
				  (member (second e) set)))
	     uf))
;; makes two classes equivalent by position in the union-find
(defun uf-merge (uf p1 p2)
  (if (= p1 p2) 
      uf
    (let* ((np1 (if (< p1 p2) p1 p2))
	   (np2 (if (< p1 p2) p2 p1))
	   (uf1 (nth p1 uf))
	   (uf2 (nth p2 uf)))
      (cons (union uf1 uf2) (list-slice np1 (list-slice np2 uf))))))
;; inserts an item into an equivalence class
(defun uf-insert (uf e p)
  (cons (cons e (nth p uf)) (list-slice p uf)))
;; given an old union-find returns a new union-find with the added assertion
;;  that two vertices should be in the same equivalence class. Should be
;;  called only if not already uf-connected but will work regardless.
(defun union-find (e uf)
  (let* ((e1 (first e))
	 (e2 (second e))
	 (p1 (position e1 uf :test #'memberequal))
	 (p2 (position e2 uf :test #'memberequal)))
    (cond ((and (null p1) (null p2)) (cons (list e1 e2) uf))
	  ((null p1) (uf-insert uf e1 p2))
	  ((null p2) (uf-insert uf e2 p1))
	  (t (uf-merge uf p1 p2)))))

;; Finds a minimum spanning tree, using Kruskal's algorithm.  This is
;;  *not* meant to be an efficient implementation by any means.  The idea
;;  is only that it works.  In this implementation, you may pass in
;;  #'rsorter-third and get a maximum spanning tree instead.
(defun mst (graph &optional (sorter #'sorter-third))
  (let ((sgraph (sort (copy-list graph) sorter))
	(ret nil)
	(uf nil))
    (dolist (e sgraph)
      (unless (uf-connected e uf)
	(setf uf (union-find e uf))
	(push e ret)))
    ret))

;; Lisp code found on 2 april 2014 at 21h18 at the following link:
;; http://www.cc.gatech.edu/~isbell/classes/2003/cs4600_fall/projects/project3/utils.lisp
;; thanks for the hacker ...
