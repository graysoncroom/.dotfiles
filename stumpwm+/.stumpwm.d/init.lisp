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
  "Run pywal using *wallpaper* as the image argument."
  (run-shell-command (format nil "wal -i ~a" *wallpaper*)))

(defcommand vol-up () ()
  "Increase system volume"
  (run-shell-command "pactl set-sink-volume 0 +5%"))

(defcommand vol-down () ()
  "Decrease system volume"
  (run-shell-command "pactl set-sink-volume 0 -5%"))

(defcommand vol-mute () ()
  "Toggle mute"
  (run-shell-command "pactl set-sink-mute 0 toggle"))

(defcommand media-play () ()
  "Media player 'play' action"
  (run-shell-command "playerctl play"))

(defcommand media-pause () ()
  "Media player 'pause' action"
  (run-shell-command "playerctl pause"))

(defcommand media-next () ()
  "Media player 'skip to next' action"
  (run-shell-command "playerctl next"))

(defcommand media-prev () ()
  "Media player 'skip to previous' action"
  (run-shell-command "playerctl previous"))

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
          ;; Multimedia Bindings
          ("XF86AudioRaiseVolume" "vol-up")
          ("XF86AudioLowerVolume" "vol-down")
          ("XF86AudioMute"        "vol-mute")
          ("XF86AudioPlay"        "media-play")
          ("XF86AudioPause"       "media-pause")
          ("XF86AudioNext"        "media-next")
          ("XF86AudioPrev"        "media-prev"))
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
                         ("l" "right"))))
        ;; Application Bindings
        (mapcar (lambda (binding)
                  (destructuring-bind
                    (key program &optional &key from (with-args "-e")) binding
                    (list key
                          (format nil "exec ~:[~*~A~;~:*~A ~A ~A~]" from with-args program))))
                `(("b"      ,*web-browser*)
                  ("Delete" ,*lock-screen*)
                  ("RET"    ,*terminal*)
                  ("r"      ,*file-browser*    :from ,*terminal*)
                  ("Menu"   ,*network-manager* :from ,*terminal*)
                  ("!"      "run"              :from ,*app-menu* :with-args "-show")))))

;; Init
(add-hook *start-hook* (lambda ()
                         (mapc #'run-shell-command
                               '("redshift"
                                 "xbanish"))
                         (mode-line)
                         (reload-wal)
                         (swank:create-server :port 4005
                                              :style swank:*communication-style*
                                              :dont-close t)))
