
(package-initialize)

(load (expand-file-name "~/.quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")
(slime-setup '(slime-company))
