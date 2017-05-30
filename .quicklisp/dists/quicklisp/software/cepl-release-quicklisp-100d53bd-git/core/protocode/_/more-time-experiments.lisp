;; Functions and macros for handling time in games
;; This area is very prone to change as time is so integral
;; to game building.

(in-package :base-time)

;;----------------------------------------------------------------------

;; 1. body -
;; 2. test -
;; 3. expired-test -
;; 4. inner-let -
;; 5. closed-vars - proper let form


(tlambda (x y) (+ x y))

;;{TODO} should "every time" stil print after it expires?
(tlambda ()
  ((before (from-now 100)) (print "moo"))
  (print "every time"))

(tlambda ()
  ((each (seconds 1))
   (print "hi")))

(tlambda ()
  ((and (each (seconds 1)) (before (from-now (seconds 4))))
   (print "hi")))

(tlambda ()
  (then ((before (from-now 100)) (print "--1"))
        ((before (from-now 200)) (print "--2"))
        ((before (from-now 300)) (print "--3"))))

(tlambda ()
  (repeat ((before (from-now 100)) (print "--1"))
          ((before (from-now 200)) (print "--2"))
          ((before (from-now 300)) (print "--3"))
          ((before (from-now 400)) (print "--4"))))

(tlambda ()
  (repeat (then ((before (from-now (seconds 2))) (print "1"))
                ((before (from-now (seconds 3))) (print "2")))
          ((before (from-now 100)) (print "moo"))
          ((before (from-now 999)) (print "wwwwww"))
          ((before (from-now 200)) (print "woo"))))

(tlambda ()
  (repeat (then ((before (from-now (seconds 2))) (print "1")))
          ((before (from-now 100)) (print "moo"))))
