(defsystem "cl-abacus"
  :version "0.1.0"
  :author "Diego Guraieb"
  :license ""
  :depends-on ( "str" "dexador" "cl-json" "cl-csv")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "Abacus API."
  :in-order-to ((test-op (test-op "cl-abacus/tests"))))

(defsystem "cl-abacus/tests"
  :author "Diego Guraieb"
  :license ""
  :depends-on ("cl-abacus"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for cl-abacus"
  :perform (test-op (op c) (symbol-call :rove :run c)))
