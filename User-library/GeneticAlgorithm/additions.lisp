(in-package geneticalgorithm)

;Additions to the Genetic Algorithm library by Alan Nagelberg.
;The additions are proposed and coded by Orjan Sandred.
;
;June 21, 2011
;The following two main functions should be used:
;
; wildcard-loop (creates a fitnes function from a heurstic wildcard rule)
; conv-jbsrule (takes a HEURISTIC pmc rule from the JBS-constraints library and creates a fitnes function)

(defun range-filter (list first-n n-elements)
  "n-elements cannot point after list end"
  (let ((cut-list (nthcdr first-n list)))
    (butlast cut-list (- (length cut-list) n-elements))))

(defun first-n (list n)
  "n is the number of variables to keep in the list"
  (butlast list (- (length list) n)))


(defun wildcard-loop (wildcard-rule)
  "This function creates a fitnes function from a heurstic wildcard rule.
The weight that the fitness function will output is the average weight of
he looped wildcard rule."
  (let ((no-of-args (length (system::function-lambda-list wildcard-rule))))
    

    #'(lambda (list) (progn
                       (when (> no-of-args (length list))
                         (error "Number of arguments in the rule is greater than the length of the list"))
                       (/ (loop for n from 0 to (- (length list) no-of-args)
                                sum (apply wildcard-rule (range-filter list n no-of-args)))
                          (+ 1.0 (- (length list) no-of-args)))
                       ))))


(defun wildcard-loop-jbs (wildcard-rule)
  (let* ((no-of-args (- (length (system::function-lambda-list wildcard-rule)) 3))
         (no-of-testvar (if (= no-of-args 0) 1 no-of-args))) ;if there is no argument, this distinction is essential to avoid errors
    
    (compile nil 
             (lambda (list) (progn
                              (when (> no-of-args (length list))
                                (error "Number of arguments in the rule is greater than the length of the desired solution. The rule will never be checked."))
                              (1+ (/ (loop for n from 0 to (- (length list) no-of-testvar) ;The 1+ is to avoid an error in the genetic algorithm. If the bug is fixed, it should be removed.
                                           sum (apply wildcard-rule (append (range-filter list n no-of-args)  
                                                                            (list (first-n list (+ n no-of-testvar)) (+ n no-of-testvar) (length list)) 
                                                                            )))
                                     (+ 1.0 (- (length list) no-of-testvar))))
                              )))))




;----------

(defun jbs-index-rule? (jbsrule)
  "This seems pretty complex because the jbs-constraints library typically leaves the '* also for the index rules. It also has to check that the items are symbols not to potentially crach rthe program. "
  (or
   (if (symbolp (second jbsrule))
       (equal (aref (symbol-name (second jbsrule)) 0)  #\I)
     nil)
   (if (symbolp (third jbsrule))
       (equal (aref (symbol-name (third jbsrule)) 0)  #\I)
     nil)))


(defun jbs-wildcard-rule? (jbsrule)
  "Since the jbs-constraint library often saves the '* even in the index rules, this is not a sure test. Only test this AFTER the jbs-index-rule? failed."
  (equal (aref (symbol-name (second jbsrule)) 0)  #\*)
       )


(defun geneticalgorithm-ify-a-symbol (tree symbol)
  "Puts symbols into the cluster-engine package. This solves package-problem with the m symbol"
  (cond
    ((null tree)
     nil)
    ((consp tree)
     
     (cons (geneticalgorithm-ify-a-symbol (car tree) symbol)
	   (geneticalgorithm-ify-a-symbol (cdr tree) symbol)))
    ;; convert symbols that are not keywords
    ((and (symbolp tree) (not (keywordp tree)))
     (if (equal (symbol-name tree) (symbol-name symbol))
         (intern (symbol-name tree) #.(find-package 'geneticalgorithm))
       tree))
    (t tree)))


(defun substitute-in-tree (newitem olditem tree)
  (cond ((equal tree olditem) newitem)
        ((listp tree) (loop for subtree in tree collect (substitute-in-tree newitem olditem subtree)))
        ((equal tree olditem) newitem)
        (t tree)))

(defun item-in-tree? (item tree)
  "Returns T if item exist somewhere in tree (on any level)."
  (cond ((equal tree item) t)
        ((listp tree) (eval (cons 'or (loop for subtree in tree collect (item-in-tree? item subtree)))))
        ((equal tree item) t)
        (t nil)))



(defun convert-jbs-rule-to-lambda-include-l-and-index (rule)
  "This conversion works for both true/false and heuristic rules."


  (setf rule (geneticalgorithm-ify-a-symbol rule 'cur-slen))
  

  (cond ((jbs-index-rule? rule)
         (error "Index rule is not yet supported")
         )
        ((jbs-wildcard-rule? rule)
         (setf rule (remove ':TRUE/FALSE rule))
         (setf rule (remove ':HEURISTIC rule))
         (let ((arg-list (cdr (loop for element in rule
                                    while (not (listp element))
                                    collect element)))
               (rule-code (cadr (loop for element in rule
                                      while (not (listp element))
                                      finally (return element)))))



           (setf rule-code (geneticalgorithm-ify-a-symbol rule-code 'l))
           (setf rule-code (substitute-in-tree 'all-variables 'l rule-code)) ;must look into subtrees

           (setf rule-code (geneticalgorithm-ify-a-symbol rule-code 'rl))
           (setf rule-code (substitute-in-tree '(reverse all-variables) 'rl rule-code)) ;must look into subtrees

           (setf rule-code (geneticalgorithm-ify-a-symbol rule-code 'cur-index))
           (setf rule-code (substitute-in-tree 'current-index '(cur-index) rule-code))

           (setf rule-code (geneticalgorithm-ify-a-symbol rule-code 'len))
           (setf rule-code (substitute-in-tree '(length all-variables) 'len rule-code))

           (setf rule-code (geneticalgorithm-ify-a-symbol rule-code 'cur-slen))
           (setf rule-code (substitute-in-tree 'cur-slen '(cur-slen) rule-code))

           (compile nil (list 'lambda (append arg-list '(all-variables current-index cur-slen)) rule-code))))))

(defun conv-jbsrule (rule)
  "This function takes a HEURISTIC pmc rule from the JBS-constraints library and creates a fitnes function for a Genetic Algorithm."
  (wildcard-loop-jbs (convert-jbs-rule-to-lambda-include-l-and-index rule)))