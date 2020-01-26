(defsystem :sl
  :depends-on (:esrap)
  :around-compile (lambda (next)
                    (proclaim '(optimize (debug 3) (safety 3) (speed 0)))
                    (funcall next))
  :components ((:module "source"
                        :pathname "./"
                        :components ((:file "package")
                                     (:file "common" :depends-on ("package"))
                                     (:file "sl" :depends-on ("package" "common"))
                                     (:file "unparse" :depends-on ("package" "sl"))
                                     (:file "test" :depends-on ("package" "sl"))
                                     (:file "test-unparse" :depends-on ("package""unparse"))))))
