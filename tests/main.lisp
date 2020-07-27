(defpackage cl-abacus/tests/main
  (:use :cl
        :cl-abacus
        :rove))
(in-package :cl-abacus/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :cl-abacus)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
