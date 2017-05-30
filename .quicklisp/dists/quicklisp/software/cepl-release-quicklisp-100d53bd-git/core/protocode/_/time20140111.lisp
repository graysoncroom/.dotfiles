;; Functions and macros for handling time in games
;; This area is very prone to change as time is so integral
;; to game building.

(in-package :base-time)

(defmacro def-time-units (&body forms)
  (unless (numberp (second (first forms)))
    (error "base unit must be specified as a constant"))
  (let ((defined nil))
    `(progn
       ,@(loop :for (type expression) :in forms
            :for count = (if (numberp expression)
                             expression
                             (if (and (listp expression)
                                      (= (length expression) 2)
                                      (numberp (second expression))
                                      (assoc (first expression) defined))
                                 (* (second expression)
                                    (cdr (assoc (first expression) defined)))
                                 (error "invalid time expression")))
            :collect `(defun ,type (quantity) (* quantity ,count))
            :do (push (cons type count) defined)))))

(def-time-units
  (milliseconds 1)
  (seconds (milliseconds 1000))
  (minutes (seconds 60))
  (hours (minutes 60)))

;;------------------------------------------------------------

(defparameter *default-time-source* #'absolute-system-time)

(define-condition c-expired (condition) ())

(defun signal-expired () (signal 'c-expired) nil)

;;{TODO} hmm what if the true state pulses? The the expire is incorrect
(defmacro defcon (name args condition &body body)
  (let ((lived (gensym "lived")))
    `(let ((,lived nil))
       (defun ,name ,args
         (if ,condition
             (progn (setf ,lived t) ,@body)
             (when ,lived (signal 'c-expired) nil))))))

(defmacro conditional (args condition &body body)
  (let ((lived (gensym "lived"))
        (condit (gensym "condition")))
    `(let ((,lived nil)
           (,condit ,(if (eq (first condition) 'cl:function)
                         condition
                         `(lambda () ,condition))))
       (lambda ,args
         (if (funcall ,condit)
             (progn (setf ,lived t) ,@body)
             (when ,lived (signal 'c-expired) nil))))))

(defmacro cfn (args condition &body body)
  `(conditional ,args ,condition &body ,body))

;; like compose for conditions, makes a lambda that when evaluated runs each
;; form until it expires and then moves to the next, at the end it will return
;; nil and release an expired condition
(defmacro then (args &body forms)
  (let ((step (gensym "step")))
    `(let ((,step 0))
       (lambda (,args)
         (case step
           ,@(loop :for form :in forms :for i :from 0 :collect
                `(,i (handler-case ,form
                       (c-expired (c) (ignore c) (incf ,step) nil))))
           (,(length forms) (signal-expired)))))))

;;--------------------------------------------------------------------
;; 'every' is the temporal implementation of steppers, they eat time from a
;; relative source and call functions when 'time-buffer is full'
;; 'every*' is a version that handles multiple things with one source, perfect
;; for main loops

(defun make-rel-time (&optional (time-source *default-time-source*))
  (let* ((last 0) (step 0)
         (func (lambda (&optional trigger)
                 (when (eq trigger :step)
                   (let ((new (funcall time-source)))
                     (setf step (- new last) last new)))
                 step)))
    (funcall func :step)
    func))

(defun make-time-source (&key (type :absolute) (parent *default-time-source*)
                           (transform nil))
  (case type
    (:absolute (if transform
                   (lambda (&optional x)
                     (declare (ignore x))
                     (funcall transform (funcall parent)))
                   (lambda (&optional x)
                     (declare (ignore x))
                     (funcall parent))))
    (:relative (if transform
                   (error "transforms cant currently be used on relative time")
                   ;; (make-rel-time parent)
                   (let ((result (make-instance 'rel-time :source parent)))
                     (t-step result)
                     result)))
    (t (error "unknown time-source type"))))

(defun from-now (time-offset &optional (time-source *default-time-source*))
  (+ time-offset (funcall time-source)))

(defun before (time &optional (time-source *default-time-source*))
  (let ((current-time (funcall time-source)))
    (when (< current-time time) current-time)))

(defun after (time &optional (time-source *default-time-source*))
  (let ((current-time (funcall time-source)))
    (when (> current-time time) current-time)))

(defun between (start-time end-time
                &optional (time-source *default-time-source*))
  (let ((current-time (funcall time-source)))
    (when (and (>=  start-time) (<= current-time end-time)) current-time)))

(defmethod t-step ((time function)) (funcall time :step))

(defmacro with-time-source (time-source &body body)
  `(let ((*default-time-source* ,time-source))
     ,@body))

(defun make-stepper (step-size &optional (default-source *default-time-source*))
  "this takes absolute sources"
  (let ((time-cache 0)
        (last-val (funcall default-source)))
    (lambda (&optional (time-source default-source))
      (if (eq time-source t)
          step-size
          (let* ((time (abs (funcall time-source)))
                 (dif (- time last-val)))
            (setf last-val time)
            (incf time-cache dif)
            (when (> time-cache step-size)
              (setf time-cache (- time-cache step-size))
              (min 1.0 (/ time-cache step-size))))))))


;; (every-t (seconds 1) (print "hi"))
(defmacro every-t (timestep &body forms)
  (let* ((stepper (gensym "stepper"))
         (source (if (eq (first forms) :default-source)
                     (second forms)
                     '*default-time-source*))
         (forms (if (eq (first forms) :default-source)
                    (cddr forms) forms)))
    `(let ((,stepper (make-stepper ,timestep ,source)))
       (lambda (&optional (time-source ,source))
         (when (funcall ,stepper time-source)
           ,@forms)))))

;;{TODO} this gets the behaviour right but performance isnt great

(defmacro every-t* ((&optional (time-source *default-time-source*)) &body forms)
  (loop :for (timestep form) :in forms :for name = (gensym "stepper")
     :collect `(,name (make-stepper ,timestep ,time-source)) :into steppers
     :collect `(when (funcall ,name time-source) ,form) :into clauses
     :finally (return
                `(let (,@steppers)
                   (lambda (&optional (time-source ,time-source)) ,@clauses)))))

;;------------------------------------------------------------
;; ;; dammnit now I am wondering about objects again
;; ;; what could this be
;; (let ((deadline (from-now (milliseconds 500))))
;;       (loop :until (after deadline) :finally (print "hi")))
;; ;; well 'after' could call the get-time method passing in the timesource
;; (get-time timesource)
;; ;; for absolute just returns the parent passed into the transform func
;; ;; for relative it would get the time using and t-step would update the
;; ;; timesource
;; (let ((deadline (from-now (milliseconds 1500)))
;;           (rel (make-time-source)))
;;       (loop :until (after deadline) :finally
;;          (format t "timediff=~a" (t-step rel))))

;; ;; why is this any better? seems slower for a start
;; ;; well I was worried that steppers would be fed relative time objects and that
;; ;; seemed like a lot of function calls.... I guess its not too bad.
;;------------------------------------------------------------
;; Coundlt generic functions make it feel similar

(defmethod get-time ((time-source function))
  (funcall time-source))

(let ((deadline (from-now (milliseconds 500))))
  (loop :until (after deadline) :finally (print "hi")))

;; this can now be a struct
(defclass rel-time ()
  ((time-value :initform 0)
   (last-value :initform 0)
   (parent :initform nil :initarg :source :accessor parent)))

(defmethod get-time ((time-source rel-time))
  (slot-value time-source 'time-value))

(defmethod t-step ((time-source rel-time))
  (let ((ctime (get-time (parent time-source))))
    (setf (slot-value time-source 'time-value)
          (- ctime (slot-value time-source 'last-value)))
    (setf (slot-value time-source 'last-value) ctime)
    (slot-value time-source 'time-value)))
