;; -*-lisp-*-

(in-package :stumpwm)

(set-module-dir "~/.stumpwm.d/contrib")

(load-module "swm-gaps")

(require :swank)
(swank-loader:init)

(set-prefix-key (kbd "C-SPC"))

;; Applications
(defparameter *terminal*        "urxvt")
(defparameter *file-browser*    "ranger")
(defparameter *web-browser*     "firefox")
(defparameter *process-browser* "htop")
(defparameter *app-menu*        "rofi")
(defparameter *lock-screen*     "~/.i3/lock")
(defparameter *network-manager* "nmtui")

(defparameter *wallpaper* "~/.wallpapers/desert-light-mountain.png")

;;; Abstraction over boilerplate program execution code.
(defmacro launch (program &optional &key from (with-args "-e"))
  `(format nil "exec ~:[~*~A~;~:*~A ~A ~A~]" ,from ,with-args ,program))

(defmacro program-with-layout (name &key (command (string-downcase (string name)))
                               (props `'(:class ,(string-capitalize command))))
  (with-gensyms (s w h files-path layout rules)
    `(defcommand ,name () ()
       (let* ((,s (current-screen))
              (,w (prin1-to-string (screen-width ,s)))
              (,h (prin1-to-string (screen-height ,s)))
              (,files-path "~/.stumpwm.d/stumpwm-files/")
              (,layout (concat ,files-path ,command "-layout-" ,w "x" ,h))
              (,rules (concat ,files-path ,command "-rules")))
         (gnew ,command)
         (restore-from-file ,layout)
         (restore-window-placement-rules ,rules)
         (run-or-raise ,command ,props)
         (place-existing-windows)))))

;; Stumpwm Commands
(defcommand colon1 (&optional (initial "")) (:rest)
  (let ((cmd (read-one-line (current-screen) ": " :initial-input initial)))
    (when cmd
      (eval-command cmd t))))

(defcommand reload-wal () ()
  "Run the py-wall command using globally defined wallpaper as an argument."
  (run-shell-command (format nil "wal -i ~a" *wallpaper*)))

(program-with-layout gimp)

;; Environment Variables
(setf *startup-message*        nil
      *window-border-style*    :thin
      *message-window-gravity* :center
      *input-window-gravity*   :center
      *timeout-wait*           3)

(setf swm-gaps:*inner-gaps-size* 10
      swm-gaps:*outer-gaps-size* 20)

(setf *shell-program* (stumpwm::getenv "SHELL"))

(setf *mode-line-background-color* "black"
      *mode-line-foreground-color* "white")

;; Key Bindings
(mapc (lambda (binding)
        (define-key (if (search "XF86Audio" (car binding))
                      *top-map*
                      *root-map*)
                    (kbd (car binding))
                    (cadr binding)))
      (append
        `(;; General Bindings
          ("C-f" "fullscreen")
          ("C-g" "toggle-gaps")
          ("t"   "time")
          ("-"   "vsplit")
          ("|"   "hsplit")
          ("/"   "fselect")
          ;; Application Bindings
          ("b"      ,(launch *web-browser*))
          ("Delete" ,(launch *lock-screen*))
          ("RET"    ,(launch *terminal*))
          ("r"      ,(launch *file-browser* :from *terminal*))
          ("Menu"   ,(launch *network-manager* :from *terminal*))
          ("!"      ,(format nil "~A -show run" *app-menu*))
          ;; Multimedia Bindings
          ("XF86AudioRaiseVolume" "exec pactl set-sink-volume 0 +5%")
          ("XF86AudioLowerVolume" "exec pactl set-sink-volume 0 -5%")
          ("XF86AudioMute"        "exec pactl set-sink-mute 0 toggle")
          ("XF86AudioPause"       "exec playerctl pause")
          ("XF86AudioPlay"        "exec playerctl play")
          ("XF86AudioNext"        "exec playerctl next")
          ("XF86AudioPrev"        "exec playerctl previous"))
        ;; Movement Bindings
        (apply #'append
               (mapcar (lambda (binding)
                         (let* ((key (car binding))
                                (ctrl-key (concatenate 'string "C-" key))
                                (dir (cadr binding)))
                           (list
                             (list key (format nil "move-focus ~A" dir))
                             (list ctrl-key (format nil "move-window ~A" dir)))))
                       '(("h" "left")
                         ("j" "down")
                         ("k" "up")
                         ("l" "right"))))))

;; Init
(add-hook *start-hook* (lambda ()
                         (mapc #'run-shell-command
                               '("redshift"
                                 "xbanish"))
                         (mode-line)
                         (swank:create-server :port 4005
                                              :style swank:*communication-style*
                                              :dont-close t)))
