(in-package studioflat)

(defun chaos1 (x0 delta n)
  (let ((x x0))
    (cons x0
          (loop for n from 1 to n
                collect (setf x (* delta x (- 1 x)))))))

(system::PWGLDef dx[1-x] ((x0 0.3)
                          (delta 4)
                          (n 30))
    "A function that is an itterative process:

X(n+1) =  Xn * delta * (1 - Xn)

"
    (:groupings '(3)  :x-proportions '((0.2 0.2 0.2)) :w 0.5)
  (chaos1 x0 delta n))


(defun chaos2 (z0 c n)
  (let ((z z0))
    (cons z0
          (loop for n from 1 to n
                collect (setf z (+ (* z z) c))))))

(system::PWGLDef mandelbrot ((z0 0)
                             (c -1.38)
                             (n 30))
    "The mandelbrot set. 

Z(n+1) =  (Zn * Zn) - c
"
    (:groupings '(3)  :x-proportions '((0.2 0.2 0.2)) :w 0.5)
  (chaos2 z0 c n))

(defun henon-attractor (phi d x0 y0 n)
  (let ((y y0)
        (x x0)
        y1 x1)
    (loop for n from 1 to n
          collect (progn (setf y1 (* d x))
                    (setf x1 (+ 1 y (- (* phi x x))))
                    (list (setf x x1)
                          (setf y y1))))))

(system::PWGLDef henon ((phi 1.4)
                        (d .3)
                        (x0 0.2)
                        (y0 0.2)
                        (n 30))
    "The henon attractor. 

x(n+1) =  yn + 1 - (phi * xn * xn)
y(n+1) =  d * xn
"
    (:groupings '(2 3)  :x-proportions '((0.2 0.2)(0.2 0.2 0.2)) :w 0.5)
  (henon-attractor phi d x0 y0 n))




