(defun copy-file (file new)
  (with-open-file (in file :element-type '(unsigned-byte 8))
    (with-open-file (out new
                         :direction :output
                         :element-type '(unsigned-byte 8)
                         :if-exists :supersede
                         :if-does-not-exist :create)
      (loop :with buffer-size = 8192
            :with buffer = (make-array (list buffer-size) :element-type '(unsigned-byte 8))
            :for end = (read-sequence buffer in)
            :until (zerop end)
            :do (write-sequence buffer out :end end)
                (when (< end buffer-size) (return))))))

(defun copy-directory (target new)
  (let* ((old-dir (pathname-directory target))
         (new-dir (pathname-directory new))
         (old-dir-length (length old-dir)))
    (loop for file in (directory
                       (make-pathname :name :wild :type :wild
                                      :directory (append old-dir '(:wild-inferiors))
                                      :defaults target))
          for new-file = (make-pathname
                          :name (pathname-name file) :type (pathname-type file)
                          :directory (append new-dir (subseq (pathname-directory file) old-dir-length))
                          :defaults new)
          when (and (or (pathname-name file) (pathname-type file))
                    (not (member ".git" (pathname-directory file) :test #'string=))
                    (not (member "gnupg" (pathname-directory file) :test #'string=))
		    (not (string= "elc" (pathname-type file))))
            do (ensure-directories-exist new-file)
               (copy-file file new-file))
    new))

(format t "[Lisp] Cleaning old elpa/ and old ~~/.emacs.d/...~&")
(when (probe-file "./site-lisp/elpa/")
  (delete-directory "./site-lisp/elpa/" :recursive t))
(when (and (probe-file "~/.emacs.d")
           (not (probe-file "~/.emacs.d.bak")))
  (rename-file "~/.emacs.d" "~/.emacs.d.bak"))
(ensure-directories-exist "~/.emacs.d/")
(ensure-directories-exist "site-lisp/")

(format t "[Lisp] Running '/usr/bin/emacs --script ./init-bootstrap.el'...~&")
(run-program "/usr/bin/emacs" '("--script" "./init-bootstrap.el") :output t)

(format t "[Lisp] Copying new elpa directory...~&")
(copy-directory "~/.emacs.d/elpa/" "./site-lisp/")

(format t "[Lisp] Producing init.el...~&")
(with-open-file (out "./site-lisp/init.el"
                     :direction :output
                     :if-exists :supersede
                     :if-does-not-exist :create)
  (with-open-file (in "./init-bootstrap.el")
    (loop for line = (read-line in nil)
          while line
          unless (or (search ":ensure" line)
                     (search "package-vc-install" line)
                     (search "native-comp-speed" line))
            do (write-line line out))))

(format t "[Lisp] Remove ~~/.emacs.d/ to avoid local conflict...~&")
(delete-directory "~/.emacs.d/" :recursive t)
(when (probe-file "~/.emacs.d.bak")
  (rename-file "~/.emacs.d.bak" "~/.emacs.d"))

(format t "[Lisp] Lisp script finished.~&")
