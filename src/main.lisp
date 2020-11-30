(defpackage cl-abacus
  (:use :cl))
(in-package :cl-abacus)


;(setf cl-json:*json-symbols-package* nil)
;(setf cl-json:*json-identifier-name-to-lisp* #'identity)

(define-condition event-conflict (error)
  ())

(defclass abacus-client ()
  ((host :initarg :host
         :initform "http://localhost:9993"
         :accessor host
         :documentation "Abacus server.")))

(defun new-client (host)
  (declare (type string host))
  (make-instance 'abacus-client :host host))

(defun query (client stat granularity &key (no-cache t) (from nil) (to nil) (csv nil) (group '()) (no-data nil))
  (let ((url (concatenate 'string (host client) "/query/" stat  "/" granularity))
        (params '()))
    (when from
      (push (concatenate 'string "from=" from) params))

    (when to
      (push (concatenate 'string "to=" to) params))

    (when csv
      (push "csv=true" params))

    (when no-data
      (setf url (concatenate 'string url "&data=false")))

    (when no-cache
      (push "cache=false" params))

    (when group
      (push (concatenate 'string "group=" (str:join "," group)) params))

    (setf url (concatenate 'string url "?" (str:join "&" params)))
    (multiple-value-bind (body code) (dex:post url :content "{}")
      (if (= code 200) 
        (cl-json:decode-json-from-string body)
        nil))))
  


(defun log-metric (client stat id ts data metrics &key (unsafe nil) (overwrite nil) (fail-on-conflict nil))
  "Saves a pair of values (data) and metric into abacus."
  (declare (type string id stat))
  (declare (type number ts))
  (declare (type cons data metrics))
  (declare (type abacus-client client))

  (let ((url (concatenate 'string (host client) "/event/" stat  "?unsafe=" 
                          (if unsafe
                              "true"
                              "false")))
        (body `( ( "id" . ,id) 
                 ( "timestamp" . ,ts)
                 ( "values" . ,data )
                 ( "metrics" . ,metrics))))
    (handler-case (when (dex:post url :content (cl-json:encode-json-to-string body))


                    t)
      (dexador.error:http-request-conflict (e)
        (if fail-on-conflict
          (error 'event-conflict)
          t)))))

