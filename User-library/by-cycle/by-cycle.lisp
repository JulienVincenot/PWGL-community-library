;;;  version 03-13 of by-cycle
;;;  http://by.cmsc.pagesperso-orange.fr/pwgl-by.html
;;;  use freely and at your own risk :)

(in-package :BY-CYCLE)

;;;---------------------------- LISP-PWGL ----------------------------
;;;              librairie formes cycliques (library by-cycle)


;;;-----------------------------------------------------------------
;;;-----------------------------------------------------------------

(defparameter *nbres-premiers-2->9973* '(
2	 3	 5	 7	 11	 13
17	 19	 23	 29	 31	 37
41	 43	 47	 53	 59	 61
67	 71	 73	 79	 83	 89
97	 101	 103	 107	 109	 113
127	 131	 137	 139	 149	 151
157	 163	 167	 173	 179	 181
191	 193	 197	 199	 211	 223
227	 229	 233	 239	 241	 251
257	 263	 269	 271	 277	 281
283	 293	 307	 311	 313	 317
331	 337	 347	 349	 353	 359
367	 373	 379	 383	 389	 397
401	 409	 419	 421	 431	 433
439	 443	 449	 457	 461	 463
467	 479	 487	 491	 499	 503					
509	 521	 523	 541	 547	 557
563	 569	 571	 577	 587	 593
599	 601	 607	 613	 617	 619
631	 641	 643	 647	 653	 659
661	 673	 677	 683	 691	 701
709	 719	 727	 733	 739	 743
751	 757	 761	 769	 773	 787
797	 809	 811	 821	 823	 827
829	 839	 853	 857	 859	 863
877	 881	 883	 887	 907	 911
919	 929	 937	 941	 947	 953
967	 971	 977	 983	 991	 997
1009	 1013	 1019	 1021	 1031	 1033
1039	 1049	 1051	 1061	 1063	 1069
1087	 1091	 1093	 1097	 1103	 1109
1117	 1123	 1129	 1151	 1153	 1163					
1171	 1181	 1187	 1193	 1201	 1213
1217	 1223	 1229	 1231	 1237	 1249
1259	 1277	 1279	 1283	 1289	 1291
1297	 1301	 1303	 1307	 1319	 1321
1327	 1361	 1367	 1373	 1381	 1399
1409	 1423	 1427	 1429	 1433	 1439
1447	 1451	 1453	 1459	 1471	 1481
1483	 1487	 1489	 1493	 1499	 1511
1523	 1531	 1543	 1549	 1553	 1559
1567	 1571	 1579	 1583	 1597	 1601
1607	 1609	 1613	 1619	 1621	 1627
1637	 1657	 1663	 1667	 1669	 1693
1697	 1699	 1709	 1721	 1723	 1733
1741	 1747	 1753	 1759	 1777	 1783
1787	 1789	 1801	 1811	 1823	 1831
1847	 1861	 1867	 1871	 1873	 1877					
1879	 1889	 1901	 1907	 1913	 1931
1933	 1949	 1951	 1973	 1979	 1987
1993	 1997	 1999	 2003	 2011	 2017
2027	 2029	 2039	 2053	 2063	 2069
2081	 2083	 2087	 2089	 2099	 2111
2113	 2129	 2131	 2137	 2141	 2143
2153	 2161	 2179	 2203	 2207	 2213
2221	 2237	 2239	 2243	 2251	 2267
2269	 2273	 2281	 2287	 2293	 2297
2309	 2311	 2333	 2339	 2341	 2347
2351	 2357	 2371	 2377	 2381	 2383
2389	 2393	 2399	 2411	 2417	 2423
2437	 2441	 2447	 2459	 2467	 2473
2477	 2503	 2521	 2531	 2539	 2543
2549	 2551	 2557	 2579	 2591	 2593
2609	 2617	 2621	 2633	 2647	 2657					
2659	 2663	 2671	 2677	 2683	 2687
2689	 2693	 2699	 2707	 2711	 2713
2719	 2729	 2731	 2741	 2749	 2753
2767	 2777	 2789	 2791	 2797	 2801
2803	 2819	 2833	 2837	 2843	 2851
2857	 2861	 2879	 2887	 2897	 2903
2909	 2917	 2927	 2939	 2953	 2957
2963	 2969	 2971	 2999	 3001	 3011
3019	 3023	 3037	 3041	 3049	 3061
3067	 3079	 3083	 3089	 3109	 3119
3121	 3137	 3163	 3167	 3169	 3181
3187	 3191	 3203	 3209	 3217	 3221
3229	 3251	 3253	 3257	 3259	 3271
3299	 3301	 3307	 3313	 3319	 3323
3329	 3331	 3343	 3347	 3359	 3361
3371	 3373	 3389	 3391	 3407	 3413					
3433	 3449	 3457	 3461	 3463	 3467
3469	 3491	 3499	 3511	 3517	 3527
3529	 3533	 3539	 3541	 3547	 3557
3559	 3571	 3581	 3583	 3593	 3607
3613	 3617	 3623	 3631	 3637	 3643
3659	 3671	 3673	 3677	 3691	 3697
3701	 3709	 3719	 3727	 3733	 3739
3761	 3767	 3769	 3779	 3793	 3797
3803	 3821	 3823	 3833	 3847	 3851
3853	 3863	 3877	 3881	 3889	 3907
3911	 3917	 3919	 3923	 3929	 3931
3943	 3947	 3967	 3989	 4001	 4003
4007	 4013	 4019	 4021	 4027	 4049
4051	 4057	 4073	 4079	 4091	 4093
4099	 4111	 4127	 4129	 4133	 4139
4153	 4157	 4159	 4177	 4201	 4211					
4217	 4219	 4229	 4231	 4241	 4243
4253	 4259	 4261	 4271	 4273	 4283
4289	 4297	 4327	 4337	 4339	 4349
4357	 4363	 4373	 4391	 4397	 4409
4421	 4423	 4441	 4447	 4451	 4457
4463	 4481	 4483	 4493	 4507	 4513
4517	 4519	 4523	 4547	 4549	 4561
4567	 4583	 4591	 4597	 4603	 4621
4637	 4639	 4643	 4649	 4651	 4657
4663	 4673	 4679	 4691	 4703	 4721
4723	 4729	 4733	 4751	 4759	 4783
4787	 4789	 4793	 4799	 4801	 4813
4817	 4831	 4861	 4871	 4877	 4889
4903	 4909	 4919	 4931	 4933	 4937
4943	 4951	 4957	 4967	 4969	 4973
4987	 4993	 4999	 5003	 5009	 5011					
5021	 5023	 5039	 5051	 5059	 5077
5081	 5087	 5099	 5101	 5107	 5113
5119	 5147	 5153	 5167	 5171	 5179
5189	 5197	 5209	 5227	 5231	 5233
5237	 5261	 5273	 5279	 5281	 5297
5303	 5309	 5323	 5333	 5347	 5351
5381	 5387	 5393	 5399	 5407	 5413
5417	 5419	 5431	 5437	 5441	 5443
5449	 5471	 5477	 5479	 5483	 5501
5503	 5507	 5519	 5521	 5527	 5531
5557	 5563	 5569	 5573	 5581	 5591
5623	 5639	 5641	 5647	 5651	 5653
5657	 5659	 5669	 5683	 5689	 5693
5701	 5711	 5717	 5737	 5741	 5743
5749	 5779	 5783	 5791	 5801	 5807
5813	 5821	 5827	 5839	 5843	 5849					
5851	 5857	 5861	 5867	 5869	 5879
5881	 5897	 5903	 5923	 5927	 5939
5953	 5981	 5987	 6007	 6011	 6029
6037	 6043	 6047	 6053	 6067	 6073
6079	 6089	 6091	 6101	 6113	 6121
6131	 6133	 6143	 6151	 6163	 6173
6197	 6199	 6203	 6211	 6217	 6221
6229	 6247	 6257	 6263	 6269	 6271
6277	 6287	 6299	 6301	 6311	 6317
6323	 6329	 6337	 6343	 6353	 6359
6361	 6367	 6373	 6379	 6389	 6397
6421	 6427	 6449	 6451	 6469	 6473
6481	 6491	 6521	 6529	 6547	 6551
6553	 6563	 6569	 6571	 6577	 6581
6599	 6607	 6619	 6637	 6653	 6659
6661	 6673	 6679	 6689	 6691	 6701					
6703	 6709	 6719	 6733	 6737	 6761
6763	 6779	 6781	 6791	 6793	 6803
6823	 6827	 6829	 6833	 6841	 6857
6863	 6869	 6871	 6883	 6899	 6907
6911	 6917	 6947	 6949	 6959	 6961
6967	 6971	 6977	 6983	 6991	 6997
7001	 7013	 7019	 7027	 7039	 7043
7057	 7069	 7079	 7103	 7109	 7121
7127	 7129	 7151	 7159	 7177	 7187
7193	 7207	 7211	 7213	 7219	 7229
7237	 7243	 7247	 7253	 7283	 7297
7307	 7309	 7321	 7331	 7333	 7349
7351	 7369	 7393	 7411	 7417	 7433
7451	 7457	 7459	 7477	 7481	 7487
7489	 7499	 7507	 7517	 7523	 7529
7537	 7541	 7547	 7549	 7559	 7561					
7573	 7577	 7583	 7589	 7591	 7603
7607	 7621	 7639	 7643	 7649	 7669
7673	 7681	 7687	 7691	 7699	 7703
7717	 7723	 7727	 7741	 7753	 7757
7759	 7789	 7793	 7817	 7823	 7829
7841	 7853	 7867	 7873	 7877	 7879
7883	 7901	 7907	 7919	 7927	 7933
7937	 7949	 7951	 7963	 7993	 8009
8011	 8017	 8039	 8053	 8059	 8069
8081	 8087	 8089	 8093	 8101	 8111
8117	 8123	 8147	 8161	 8167	 8171
8179	 8191	 8209	 8219	 8221	 8231
8233	 8237	 8243	 8263	 8269	 8273
8287	 8291	 8293	 8297	 8311	 8317
8329	 8353	 8363	 8369	 8377	 8387
8389	 8419	 8423	 8429	 8431	 8443					
8447	 8461	 8467	 8501	 8513	 8521
8527	 8537	 8539	 8543	 8563	 8573
8581	 8597	 8599	 8609	 8623	 8627
8629	 8641	 8647	 8663	 8669	 8677
8681	 8689	 8693	 8699	 8707	 8713
8719	 8731	 8737	 8741	 8747	 8753
8761	 8779	 8783	 8803	 8807	 8819
8821	 8831	 8837	 8839	 8849	 8861
8863	 8867	 8887	 8893	 8923	 8929
8933	 8941	 8951	 8963	 8969	 8971
8999	 9001	 9007	 9011	 9013	 9029
9041	 9043	 9049	 9059	 9067	 9091
9103	 9109	 9127	 9133	 9137	 9151
9157	 9161	 9173	 9181	 9187	 9199
9203	 9209	 9221	 9227	 9239	 9241
9257	 9277	 9281	 9283	 9293	 9311					
9319	 9323	 9337	 9341	 9343	 9349
9371	 9377	 9391	 9397	 9403	 9413
9419	 9421	 9431	 9433	 9437	 9439
9461	 9463	 9467	 9473	 9479	 9491
9497	 9511	 9521	 9533	 9539	 9547
9551	 9587	 9601	 9613	 9619	 9623
9629	 9631	 9643	 9649	 9661	 9677
9679	 9689	 9697	 9719	 9721	 9733
9739	 9743	 9749	 9767	 9769	 9781
9787	 9791	 9803	 9811	 9817	 9829
9833	 9839	 9851	 9857	 9859	 9871
9883	 9887	 9901	 9907	 9923	 9929
9931	 9941	 9949	 9967	 9973))

(defun facto (x)
  (let (a r)
    (setf a x)
    (loop for i in *nbres-premiers-2->9973*
       until (= (apply #'* r) x)
       do
	 (if (integerp (/ a i))
	     (loop until (not (integerp (/ a i)))
		do
		  (push i r) (setf a (/ a i)))))
    (reverse r)))

(defun test-lst-nbre (lst)
  (when (listp lst) (loop for i in lst always (numberp i))))
   
(defun test-integer (x min)
  (if (numberp x)
      (when (and (integerp x) (not (< x min))) t)
    nil))

(defun test-integer-list (l min)
  "return t if all items from a list are integer and positive"
  (when (and (listp l) (not (eq l nil)))
    (loop for i in l
       always (test-integer i min))))

(defun flatten (lst)
  (if (endp lst)
      lst
      (if (atom (car lst))
	  (append (list (car lst)) (flatten (cdr lst)))
	  (append (flatten (car lst)) (flatten (cdr lst))))))

(defun xor (a b)
  (if (eq a nil) 
      (if (eq b nil) nil t)
    (if (eq b nil) t nil)))

(defun drop-element (e set)
  (cond ((null set) '())
	((equal e (first set)) (rest set))
	(t (cons (first set) (drop-element e (rest set))))))   
                      
(defun complementary (subset set)
  (cond ((null subset) set)
	((member (first subset) set)
	 (complementary (rest subset) (drop-element (first subset) set)))
	(t (complementary (rest subset) set))))

;;;-----------------------------------------------------------------------
;;;-----------------------------------------------------------------------
 
;;;;        ------------------------ (1) ------------------------
;;;;        algorithme de kaprekar en base n appliqué à une liste

(defun n->10-a (lst n)
  (when (and (listp lst) (test-integer-list lst 0) (test-integer n 2)) 
    (let (r)
      (dolist (e lst r)
        (push (* e (expt n (- (- (length lst) 1) (length r)))) r))
      (apply '+ r))))

(defun 10->n-a (x n)
  (when (and (test-integer x 0) (test-integer n 2))
    (let (r)
      (if (zerop x) (push 0 r)
        (loop until (= 0 x)
              do 
              (push (rem x n) r)
              (setf x (floor x n))))
      r)))

(defun kaprek (l n)
  (- (n->10-a (sort (copy-tree l) '>) n) (n->10-a (sort (copy-tree l) '<) n)))

(defun cycle-k (a)
  "le résultat est une liste indiquant la boucle de l'algotithme de kaprekar appliqué à la liste"
  (let (r)
    (loop for i in (cdr a)
          until (equalp i (car a))
          do
          (push i r))
    (cons (car a) r)))

(defun trans-k (a)
  "le résultat est une liste indiquant la transition - si elle existe - vers la boucle de l'algoithme de kaprekar"
  (reverse (cdr (set-difference (reverse a) (cycle-k a)))))

(defun result-k (a)
  (if (equal (trans-k a) nil) 
      a
    (list (trans-k a) (cycle-k a))))

(defun option-k1 (list-k n)
  (when (and (test-integer-list list-k 0) (test-integer n 2))
    (10->n-a (n->10-a list-k n) n)))

(defun kaprekar-l1 (list-k n)
      (cond ((not (test-integer n 2)) nil)
	    ((not (test-integer-list list-k 0)) nil)
	    ((not (> n (apply #'max list-k))) nil)
	    (t 
	     (let ((r (list list-k)))
	       (loop until (member (car r) (cdr r) :test #'equalp)
		  do
		    (push 
		     (append (make-list (- (length list-k) (length (10->n-a (kaprek (car r) n) n))) :initial-element 0) (10->n-a (kaprek (car r) n) n))
		     r))
	       (result-k r)))))

(defun kaprekar-l2 (list-k n option-k)
  (case option-k
    (:no (kaprekar-l1 list-k n))
    (:yes (kaprekar-l1 (option-k1 list-k n) n))))

;;;;                  ----------------- (2) ---------------------
;;;;                  permutations symétriques d'Olivier Messiaen

(defun perm (list-p code-list-p)
  (mapcar #'second (sort (mapcar #'list code-list-p list-p) #'< :key #'car)))

(defun perm-sym1 (list-p code-list-p)
  (if (loop for i in code-list-p
            always (numberp i))
      (let ((r (list list-p)) (p nil))
        (loop until (eq t p)
              do 
              (push (perm (car r) code-list-p) r)
              (dolist (e (cdr r))
                (if (equal (car r) e)
                    (setf p t))))  
        (reverse r))
    list-p))

;;;;           ---------------------- (3) ----------------------
;;;;           métabole cyclique inspirée des cribles de Xenakis

(defun groupn (lst n)
  (let (r)
    (dotimes (i n (reverse r)) (push (nth i lst) r))))

(defun all-sub-g (lst)
  (let (r)
    (loop for x from 1 to (- (length lst) 1)
          do
          (dotimes (y (+ (- (length lst) x) 1))
            (push (groupn (nthcdr y lst) x) r)))
    (remove-duplicates r :test #'equalp)))

(defun soust-mult-x (a b)
  (- (apply #'* a) (apply #'* (complementary a (facto b)))))
   
(defun voir-x (x)
  (let (r)
    (loop for i in (all-sub-g (facto x))
          do
          (when (and (= 1 (gcd (apply #'* i) (apply #'* (complementary i (facto x))))) (not (= 0 (soust-mult-x i x))))
            (push (list (abs (soust-mult-x i x)) i (complementary i (facto x))) r)))
    (car (mapcar #'cdr (sort r #'< :key #'car)))))

(defun i&j1 (a) ; a est égal à (max crible) ou field
  (sort (list (apply #'* (car (voir-x a))) (apply #'* (cadr (voir-x a)))) '<))

(defun opt-plus (x)
  (if (not (= 0 (apply #'- (i&j1 x))))
      (if (< (abs (apply #'- (i&j1 (1+ x)))) (abs (apply #'- (i&j1 x))))
          (if (= 0 (apply #'- (i&j1 (1+ x)))) (i&j1 x)
            (opt-plus (1+ x)))
        (i&j1 x))
    (opt-plus (1+ x))))

(defun opt-moins (x)
  (if (not (= 0 (apply #'- (i&j1 x))))
      (if (< (abs (apply #'- (i&j1 (1- x)))) (abs (apply #'- (i&j1 x))))
          (if (= 0 (apply #'- (i&j1 (1- x)))) (i&j1 x)
            (opt-moins (1- x)))
        (i&j1 x))
    (opt-moins (1- x))))

(defun i&j (x &key key)
  (cond ((equal key :plus-no) (if (null (voir-x x)) (i&j1 (1+ x)) (i&j1 x)))
        ((equal key :plus-yes) (opt-plus x))
        ((equal key :moins-no) (if (null (voir-x x)) (i&j1 (1- x)) (i&j1 x)))
        ((equal key :moins-yes) (opt-moins x))
        (t nil)))

(defun iorj1 (k x)
  (when (> x (* 2 k))
    (if (= 0 (rem x k))
        (if (= 1 (gcd k (/ x k)))
            (list k (/ x k)) nil)
      nil)))

(defun iorj-plus (k x) ; k = i ou j
  (when (> x (* 2 k))
    (if (= 0 (rem x k))
        (if (= 1 (gcd k (/ x k)))
            (sort (list k (/ x k)) '<)
          (iorj-plus k (1+ x)))
      (iorj-plus k (1+ x)))))

(defun iorj-moins (k x) ; k = i ou j
  (when (> x (* 2 k))
    (if (= 0 (rem x k))
        (if (= 1 (gcd k (/ x k)))
            (sort (list k (/ x k)) '<)
          (iorj-moins k (1- x)))
      (iorj-moins k (1- x)))))

(defun in-f-x (a b k)
  (if (eq k nil)
      (let (r)
        (loop for i from 0 to (- b a)
              do
              (when (voir-x (+ i a))
                (push (list (- (cadr (i&j1 (+ i a))) (car (i&j1 (+ i a))))
                            (i&j1 (+ i a))) r)))
        (if (null r) nil
          (cadr (assoc (apply #'min (mapcar 'car r)) r))))
    (when (< k (/ b 2))
      (let (r)
        (loop for i from 0 to (- b a)
              do
              (when (not (equal (iorj1 k (+ i a)) nil))
                (push (list (abs (- (cadr (iorj1 k (+ i a))) (car (iorj1 k (+ i a)))))
                            (iorj1 k (+ i a))) r)))
        (when (not (null r)) (cadr (assoc (apply #'min (mapcar 'car r)) r)))))))
    
(defun list-module (a)
  (let ((r nil))
    (dotimes (i a (reverse r)) (push i r))))

(defun mod-by1 (i j)
  "make a list of i element in modulo i*j"
  (let (r)
    (loop for a in (list-module i)
       do (push
	   (mod (* a (+ i 1)) (* i j))
	   r))
    (reverse r)))

(defun mod-by2 (i j list-from-mod-by1)
  "make a new list like mod-by1 from its last element (list-from-mod-by1)"
  (let ((r) (n (list (1+ (car (last list-from-mod-by1))))))
    (loop for a in (mapcar '* (make-list i :initial-element (+ i 1)) (list-module i))
       do (push
	   (mod (+ a (car n)) (* i j))
	   r))
    (reverse r)))

(defun x-matrice-mod (i j)
  "build a matrice of dimension i and j"
  (let ((r (list (mod-by1 i j))))
    (loop repeat (- j 1)
       do (push (mod-by2 i j (car r)) r))
    (reverse r)))

(defun mat-pairlst (i j)
  "assigns the matrix elements in their respective position"
  (mapcar #'list (flatten (x-matrice-mod i j)) (list-module (* i j))))

(defun place-crible-mat (cribl i j)
  "assigns the crible elements in their respective position"
  (let (r)
    (dolist (e cribl (reverse r)) 
      (push (assoc e (mat-pairlst i j)) r))))

(defun decall-crible-mat (new-crible i j)
  (let (r)
    (dolist (e (place-crible-mat new-crible i j) (reverse r))
      (push (cadr (assoc (mod (+ (cadr e) i) (* i j)) (let (r) (dolist (e (mat-pairlst i j) r) (push (reverse e) r))))) r))))

(defun cy (cribl i-j)
  (let (i j)
    (setq i (car i-j))
    (setq j (cadr i-j))
    (when (and (= 1 (gcd i j)) (not (= 1 i)) (not (= 1 j)))
      (let ((r (list (mapcar 'car (place-crible-mat cribl i j)))))
	(loop until (member (car r) (cdr r) :test #'equalp)
	   do
	     (push (decall-crible-mat (car r) i j) r))
	(reverse r)))))

(defun cy-x (cribl i-j)
  (when (and (not (null i-j)) (> (* (car i-j) (cadr i-j)) (apply #'max cribl)))
    (if (eq (cy cribl i-j) nil) nil
      (list (cy cribl i-j) (cy cribl (reverse i-j))))))

(defun cycle-x1 (crible field-x i j option-x)
  (when (listp crible)
    (cond ((and (not (eq field-x nil)) (not (test-integer field-x (apply #'max crible)))) nil)
          ((and (not (eq i nil)) (not (test-integer i 2))) nil)
          ((and (not (eq j nil)) (not (test-integer j 2))) nil)
          (t
           (when (test-integer-list crible 0)
	     (let (a k)
	       (setq a (1+ (apply #'max crible)))
	       (setq k (when (or (null i) (null j)) (if (null i) j i)))
	       (cond ((and (null field-x) (null i) (null j))
		      (case option-x
			(:no (cy-x crible (i&j a :key :plus-no)))
			(:yes (cy-x crible (i&j a :key :plus-yes)))
			(:in-field-x nil)))
		     ((and (not (null field-x)) (null i) (null j))
		      (case option-x
			(:no (cy-x crible (i&j field-x :key :moins-no)))
			(:yes (cy-x crible (i&j field-x :key :moins-yes)))
			(:in-field-x (cy-x crible (in-f-x a field-x k)))))
		     ((and (null field-x) (xor (null i) (null j)))
		      (case option-x
			(:in-field-x nil)
			(otherwise (cy-x crible (iorj-plus k a)))))
		     ((and (not (null field-x)) (xor (null i) (null j)))
		      (case option-x
			(:in-field-x (cy-x crible (in-f-x a field-x k)))
			(otherwise (when (>= (apply #'* (iorj-moins k field-x)) a)
				     (cy-x crible (iorj-moins k field-x))))))
		     ((and (null field-x) (not (null i)) (not (null j)))
		      (case option-x
			(:in-field-x nil)
			(otherwise (when (and (= 1 (gcd i j)) (>= (* i j) a)) (cy-x crible (list i j))))))
		     ((not (and (null field-x) (null i) (null j)))
		      (case option-x
			(otherwise (when (and (= 1 (gcd i j)) (>= (* i j) a) (>= field-x (* i j)))
				     (cy-x crible (list i j)))))))))))))

;;;                                   ------- (4) --------
;;;                                   commentaire cyclique

(defun count-1 (lst)
  (let (r)
    (dolist (e (remove-duplicates lst) r)
      (push (list (count e lst) e) r))
    (sort r '< :key 'cadr)))

(defun commentaire-cyclique1 (lst)
  (if (test-integer-list lst 0)
      (let ((r (list lst)))
        (loop until (member (car r) (cdr r) :test #'equalp)
              do
              (push (flatten (count-1 (car r))) r))
        (result-k r))
    nil))

;;;                            ------------- (5) --------------
;;;                            permutation circulaire en base n

(defun pop-circ (lst)
  (flatten (list (cdr lst) (car lst))))

(defun perm-circ (lst)
  (let ((r (list lst)))
    (loop repeat (length lst)
          do
          (push (pop-circ (car r)) r))
    (reverse r)))

(defun perm-circ-base1 (lst n-lst n-circ)
  (cond ((not (test-integer n-lst 2)) nil)
        ((not (test-integer n-circ 2)) nil)
        ((not (test-integer-list lst 0)) nil)
        ;((not (> n-lst (apply #'max lst))) nil)
        (t
         (let ((r (perm-circ (10->n-a (n->10-a lst n-lst) n-circ))) (s))
           (dolist (e r (reverse s))
             (push (10->n-a (n->10-a e n-circ) n-lst) s))))))

(defun p-c-b (lst opt n-lst n-circ)
  (case opt
    (:yes (perm-circ-base1 lst n-lst n-circ))
    (:no (when (> n-lst (apply #'max lst)) (perm-circ-base1 lst n-lst n-circ)))))

;;;                        ------------ (6) ------------
;;;                        décomposition de permutations

(defun list-mod (a)
  (let ((r nil))
    (dotimes (i a (reverse r)) (push (1+ i) r))))

(defun 2list (l)
  (mapcar #'list (list-mod (length l)) l))

(defun boucle (l) ;l = (2list l)
  (if (null l) nil
    (let ((r (list (car l)))) 
      (loop until (assoc (cadr (car r)) r)
            do
            (push (assoc (cadr (car r)) l) r)) (reverse r))))

(defun rem-assoc (l1 l2)
  (let (r)
    (loop for i in (complementary (mapcar #'cadr l1) (mapcar #'cadr l2))
          do
          (push (assoc i l2) r)) r))

(defun c-f-p (l &optional r)
  (let ((b (boucle l)))
    (push (mapcar #'car b) r)
    (if (not (rem-assoc b l)) (reverse r)
	(c-f-p (reverse (rem-assoc b l)) r))))

(defun test-number-list (l)
  (when (listp l) 
    (loop for i in l
          always (numberp i))))

(defun cfp1 (lst)
  (when (test-number-list lst)
    (let ((r) (s (mapcar 'list (list-mod (length lst)) (sort (copy-tree lst) '<))))
      (loop for i in (c-f-p (2list lst))
            do
            (push 
             (let (z)
               (dolist (e i (mapcar #'cadr (reverse z)))
                 (push (assoc e s) z))) r)) (reverse r))))

;;;                            ------------- (7) -------------
;;;                            utilitaire --> ratio-from-scope

(defun make-scope (lst)
  (let ((scope-value lst) (r))
    (loop for e in scope-value
	 do
	 (dotimes (i e) (push (/ (1+ i) e) r))) (cons '0 (sort (remove-duplicates r) '<))))

(defun diff-scope (nbre scope)
   (let* ((scope-staff (make-scope scope))
	  (mult-value (cadr (multiple-value-list (floor nbre))))
	  (list-diff (mapcar #'(lambda (x y) (abs (- x y))) scope-staff (make-list (length scope-staff) :initial-element mult-value)))
	  (ratio-value (nth (position (eval (cons 'min list-diff)) list-diff) scope-staff)))
     (+ (floor nbre) ratio-value)))

(defun rat-from-sc (input scope)
  (when (test-integer-list scope 1)
    (cond ((numberp input) (diff-scope input scope))
	  ((and (listp input) (test-lst-nbre input)) (let (r) (dolist (e input (reverse r)) (push (diff-scope e scope) r))))
	  (t nil))))

(defun apply-sc-in-lst (lst scope)
  (when (and (test-integer-list scope 1) (and (listp lst) (test-lst-nbre lst) (loop for i in lst always (not (= 0 i)))))
    (let ((a 1))
    (loop 
       (setq a (+ a 1))
       (when (and 
	      (not (member 0 (rat-from-sc (mapcar #'(lambda (x) (* a x)) lst) scope)))
	      (= (length (remove-duplicates lst)) (length (remove-duplicates (rat-from-sc (mapcar #'(lambda (x) (* a x)) lst) scope)))))
	 (return (rat-from-sc (mapcar #'(lambda (x) (* a x)) lst) scope)))))))


(defun rat-fr-sc (input scope option-rat)
  (case option-rat
    (:no (rat-from-sc input scope))
    (:yes (apply-sc-in-lst input scope))))

;;;            -------------------------- (8) ----------------------------
;;;            rechercher des rythmes-non-rétrogradables dans une séquence
;;;        avec pour option une tolérance de ressemblance exprimée en pourcentage
;;;            et la possibilité de définir un <scope> de <length> de RNR

(defun by-flat-once (lst)
  (let (r)
    (loop for i in lst
          do
          (if (listp i) (dolist (e i r) (push e r)) (push nil r)))
    (reverse r)))

(defun r-n-rp (lst thres)
  (loop for i from 0 to (ceiling (/ (length lst) 2))
        always (>= thres (abs (- (nth i lst) (nth (- (1- (length lst)) i) lst))))))

(defun display-lst (lst n)
  "rÈalise une liste de sous-liste de length n avec un pas de 1"
  (let ((r lst) (s))
    (dotimes (i (- (length lst) (1- n)) r)
      (push (subseq r 0 (min (length r) n)) s)
      (pop r)) (reverse s)))

(defun display-length-seq (seq length-rnr-list)
  "execute la fonction display-lst autant de fois que le length de length-rnr-list avec leur valeur respective."
  (let (r)
    (loop for e in length-rnr-list
          do
          (push (display-lst seq e) r))
    (by-flat-once (reverse r))))

(defun test-equal-item-in-lst (lst)
  (loop for i in lst always (= (car lst) i)))

(defun make-length-rnr-list (seq)
  "attribue un scope (de length possible de rnr) maximal à une sequence"
  (let (r)
    (dotimes (i (1+ (length seq)) (cdddr (reverse r))) (push i r))))

(defun search-rnr2 (seq &optional threshold length-rnr-list)
  (when (and (numberp threshold) (or (null length-rnr-list) (test-integer-list length-rnr-list 2))) 
    (let (r)
      (loop for e in (display-length-seq seq (if (null length-rnr-list) (make-length-rnr-list seq) length-rnr-list))
            do
            (when (and (not (test-equal-item-in-lst e)) (r-n-rp e threshold)) (push e r))) (remove-duplicates (reverse r) :test 'equalp))))

;;;             ------------------------------ (9) ------------------------------
;;;             rechercher un rythme dans une séquence tenant compte du monnayage
;;;           avec pour option une tolérance de ressemblance exprimée en pourcentage

(defun ratio-pattern (rtm)
  (let ((a (apply #'+ rtm)))
  (mapcar #'(lambda (x) (/ x a)) rtm )))

(defun check-pattern-in-lst (pattern lst thr)
  (cond ((null pattern) t)
    	((> (length pattern) (length lst)) nil)
        ((< (car pattern) (- (car lst) (* thr (car lst)))) nil)
        ((and
          (<= (- (car lst) (* thr (car lst))) (car pattern))
          (<= (car pattern) (+ (car lst) (* thr (car lst)))))
         (check-pattern-in-lst (cdr pattern) (cdr lst) thr))
        ((> (car pattern) (+ (car lst) (* thr (car lst)))) (check-pattern-in-lst pattern (cons (+ (car lst) (cadr lst)) (cddr lst)) thr))
        (t nil)))

(defun make-win (lst a)  ; a = (length pattern)
  (let (r)
    (loop for i from a to (length lst)
          do
          (push (groupn lst i) r)) (reverse r)))

(defun c-p-i-l (pattern lst thres)
  (let (r)
    (loop for i in (make-win lst (length pattern))
          do 
          (when (check-pattern-in-lst (ratio-pattern pattern) (ratio-pattern i) thres) (push i r)))
    (reverse r)))

(defun make-pop-lst (lst a)  ; a = (length pattern)
  (let ((r lst) (s))
    (dotimes (i (- (length lst) (1- a)) r)
      (push r s) (pop r)) (reverse s)))

(defun search-pattern-in-lst (pattern lst &optional threshold)
  (when (and (test-lst-nbre pattern) (test-lst-nbre lst) (numberp threshold) (>= threshold 0))
    (let (r)
      (loop for e in (make-pop-lst lst (length pattern))
	 do
	   (push (c-p-i-l pattern e threshold) r)) (remove-duplicates (by-flat-once (reverse r)) :test #'equalp :from-end t))))

;;;                             ------------ (10) ------------
;;;                              utilitaires --> streamline-seq
;;;                                          --> streamline-wind

(defun test-seq (seq)
  (and
   (listp seq)
   (loop for i in seq always (test-lst-nbre i)))) 

(defun arithm-weight-mean (lst)
  (if (= 1 (length lst)) (car lst)
      (let ((lst1 (mapcar #'car lst)) (lst2 (if (zerop (eval (cons '+ (mapcar #'cadr lst))))
						(mapcar #'(lambda (x) (1+ x)) (mapcar #'cadr lst))
						(mapcar #'cadr lst))))
	(list
	 (* 1.0 (/ (eval (cons '+ (mapcar #'* lst1 lst2))) (eval (cons '+ lst2))))
	 (* 1.0 (/ (eval (cons '+ (mapcar #'* lst2 lst1))) (eval (cons '+ lst1))))))))

(defun streamline (seq threshold)
  (when (and (test-seq seq) (numberp threshold))
    (let ((look-lst (list (car seq))) (temp-lst (list (car seq))) (out-lst) (thres (abs threshold)))
      (loop for e in (cdr seq)
            do
            (if (> (abs (- (cadar look-lst) (cadr e))) thres)
                (progn (push e look-lst) (push (arithm-weight-mean temp-lst) out-lst) (setq temp-lst '()) (push e temp-lst))
              (progn (push e look-lst) (push e temp-lst)))) (reverse out-lst))))

(defun streamline-w (seq wind) 
  (when (and (test-seq seq) (integerp wind) (>= wind 1))
    (if (= 1 wind) seq
      (remove nil (maplist #'(lambda (x) (if (> wind (length x)) nil (arithm-weight-mean (subseq x 0 wind)))) seq)))))

;;;                             ------------ (11) ------------
;;;                             utilitaires --> peaks-from-seq
;;;                                         --> valley-from-seq 
;;;                                         --> streamline-V        

(defun minmax (seq)
  (let ((r (list (cons 0 (car seq)))))
    (loop for i in (cdr seq)
          do
          (cond ((= (caddar r) (cadr i)) (push (cons 0 i) r))
                ((< (caddar r) (cadr i)) (push (cons 1 i) r))
                ((> (caddar r) (cadr i)) (push (cons -1 i) r))))
    r))

(defun stream-minmax (seq)
  (let ((r (list (car seq))))
    (loop for e in (cdr seq)
       do
	 (when (not (or (equalp (car e) (caar r)) (equalp (car e) 0))) (push e r))) r))

;; streamline-V
(defun stream-V (seq)
  (when (test-seq seq) (mapcar #'cdr (stream-minmax (minmax seq)))))

;; peaks-from-seq
(defun peaks (seq)
  (when (test-seq seq)
    (let (r) (loop for i in (stream-minmax (minmax seq)) do (when (= 1 (car i)) (push i r)))
      (mapcar #'cdr (reverse r)))))

;; valleys-from-seq
(defun valleys (seq)
  (when (test-seq seq)
    (let (r) (loop for i in (stream-minmax (minmax seq)) do (when (= -1 (car i)) (push i r)))
      (mapcar #'cdr (reverse r)))))

;;;                             ------------ (12) ------------
;;;                             utilitaires --> mk-integer-lst 
;;;                                         --> fill-lst

(defun mk-int-lst (lstIn short-lst)
  (loop for i in lstIn
        collect (cadr (assoc i (mapcar #'list short-lst (list-module (length short-lst))) :test #'equalp))))  

(defun mk-integer-by (lst)
  (when (listp lst)
    (if (test-lst-nbre lst)
        (mk-int-lst lst (sort (copy-tree (remove-duplicates lst)) '<))
      (mk-int-lst lst (remove-duplicates lst :from-end t :test #'equalp)))))

(defun comp-lst (lst n)
  (if (= n (length lst)) lst
    (let ((l lst))
      (loop until (= n (length l))
          do
          (setf l (cons 0 l))) l)))

(defun fill-list (lst &optional m)
  (when (and (listp lst) (loop for e in lst always (listp e)))
    (let* ((w (loop for i in lst maximize (length i)))
           (n (if (and m (integerp m) (>= m w)) m w)))
      (loop for x in lst
            collect (comp-lst x n)))))

;;;                             ------------ (END) ------------
