(in-package :cepl.context)

;;------------------------------------------------------------

(defclass gl-context ()
  ((handle :initarg :handle :reader handle)
   (version-major :initarg :version-major :reader major-version)
   (version-minor :initarg :version-minor :reader minor-version)
   (version-float :initarg :version-float :reader version-float)))

;;------------------------------------------------------------

(let ((available-extensions nil))
  (defun has-feature (x)
    (unless available-extensions
      (let* ((exts (if (>= (gl:major-version) 3)
                       (loop :for i :below (gl:get-integer :num-extensions)
                          :collect (%gl:get-string-i :extensions i))
                       ;; OpenGL version < 3
                       (cepl-utils:split-string
                        #\space (gl:get-string :extensions))))
             (exts (append exts
                           (mapcar (lambda (x)
                                     (cepl-utils:kwd (string-upcase (subseq x 3))))
                                   exts))))
        (setf available-extensions exts)))
    (not (null (find x available-extensions :test #'equal)))))

;;------------------------------------------------------------
;; Homeless stuff

(let ((cache 0))
  (defun max-draw-buffers (context)
    (declare (ignore context))
    (if (= cache 0)
        (setf cache (cl-opengl:get* :max-draw-buffers))
        cache)))

;; GL_DRAW_BUFFERi (symbolic constant, see glDrawBuffers)
;;     params returns one value, a symbolic constant indicating which buffers are being drawn to by the corresponding output color. This is selected from the currently bound GL_DRAW_FRAMEBUFFER The initial value of GL_DRAW_BUFFER0 is GL_BACK if there are back buffers, otherwise it is GL_FRONT. The initial values of draw buffers for all other output colors is GL_NONE. i can be from 0 up to the value of MAX_DRAW_BUFFERS minus one.
(defgeneric draw-buffer-i (context buffer-num))

(defmethod draw-buffer-i ((context gl-context) (buffer-num integer))
  (declare (ignore context))
  (cl-opengl:get* (kwd :draw-buffer buffer-num)))
