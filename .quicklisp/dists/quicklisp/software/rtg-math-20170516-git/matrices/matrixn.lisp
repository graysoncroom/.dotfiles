(in-package :rtg-math.matrixn)

(defun convolve (array)
  (let ((data (loop for y across array append
                   (loop for x across array collect
                        (* x y)))))
    (make-array (length data) :initial-contents data)))

(defun copy-array (a)
  (make-array (length a) :initial-contents (loop :for i :across a :collect i)))

(defun normalize-array (array &optional non-consing)
  (let ((array (if non-consing array (copy-array array))))
    (let ((sum (loop :for i :below (length array) :sum i)))
      (loop :for i :below (length array) :do
         (setf (aref array i) (/ (float (aref array i)) sum))))
    array))


(defun pascal (n)
  (let ((line (make-array (1+ n) :initial-element 1)))
    (loop :for k :below n :for i :from 1 :do
       (setf (aref line i) (* (aref line k) (/ (- n k) (1+ k)))))
    line))
