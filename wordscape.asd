(defsystem "wordscape"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "wordscape/tests"))))

(defsystem "wordscape/tests"
  :author ""
  :license ""
  :depends-on ("wordscape"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for wordscape"
  :perform (test-op (op c) (symbol-call :rove :run c)))
