(in-package :morph)

(defun list! (thing)
  (if (listp thing) thing (list thing)))

(defun mat-trans (matrix)
  (assert (apply #'= (mapcar #'length matrix)) nil
	  "this should not happen. Please report this to Kilian Sprotte")
  (when matrix (apply #'mapcar #'list matrix)))

(defun group-list (list segmentation mode)  
  "Segments a <list> in successives sublists 
which lengths are successive values of the list <segmentation>.
 <mode> indicates if <list> is to be read in a circular way."
  (let ((list2 list) (res nil))
    (catch 'gl
      (loop for segment in segmentation
	 while (or list2 (eq mode 'circular))
	 do (push (loop for i from 1 to segment
		     when (null list2)
		     do (ecase mode
			  (linear (push sublist res) (throw 'gl 0))
			  (circular (setf list2 list)))
		     end
		     collect (pop list2) into sublist
		     finally (return sublist))
		  res)))
    (nreverse res)))

;;; TODO rename this to deep-sort-list
(defun sort-list (list &optional (pred '<))
  (cond ((null list) nil)
        ((atom (first list)) (sort list pred))
        (t (cons (sort-list (first list) pred) (sort-list (rest list) pred)))))

(defun flat-once (list)
  (if (consp (car list))
      (apply 'append list)  list))

