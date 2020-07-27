(defpackage cl-abacus
  (:use :cl))
(in-package :cl-abacus)

(defclass abacus-client ()
  ((host :initarg host
         :initform "http://localhost:9993"
         :accessor host
         :documentation "Abacus server.")))

(defun query (client stat granularity &key (from nil) (to nil) (csv nil) (group '()) (no-data nil))
  (let ((url (concatenate 'string (host client) "/query/" granularity)))
    (when from
      (setf url (concatenate 'string url "&from=" from)))
    (when to
      (setf url (concatenate 'string url "&to=" from)))
    (when csv
      (setf url (concatenate 'string url "&csv=true")))

    (when no-data
      (setf url (concatenate 'string url "&data=false")))

    (when group
      (setf url (concatenate 'string url "&group=" (str:join "," group))))

  ))
  
