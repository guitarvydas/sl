(in-package :sl)

(esrap:defrule <ident> (and <ident-chars> (* <ws>)) (:function first))
(esrap:defrule <ident-chars> (and <ident-first> (* <ident-follow>)) (:text t))
(esrap:defrule <ident-first> (esrap:character-ranges (#\A #\Z) (#\a #\z)))
(esrap:defrule <ident-follow> (esrap:character-ranges #\- #\/ (#\A #\Z) (#\a #\z) (#\0 #\9)))
(esrap:defrule <not-squote-star> (* <not-squote>) (:text t))
(esrap:defrule <not-squote> (and (esrap:! "'") character))
(esrap:defrule LT (and "<" (* <ws>)) (:constant #\<))
(esrap:defrule GT (and ">" (* <ws>)) (:constant #\>))
(esrap:defrule EQ (and "=" (* <ws>)) (:constant #\=))
(esrap:defrule OPENBRACKET (and "[" (* <ws>)) (:constant #\[))
(esrap:defrule CLOSEBRACKET (and "]" (* <ws>)) (:constant #\]))
(esrap:defrule ORBAR (and "|" (* <ws>)) (:constant #\|))
(esrap:defrule BANG (and "!" (* <ws>)) (:constant #\!))
(esrap:defrule COLON (and ":" (* <ws>)) (:constant #\:))


(esrap:defrule <ws> (or <comment-to-eol> #\Space #\Newline #\Tab) (:constant #\Space))
(esrap:defrule <comment-to-eol> (and "%" (* <not-percent-nor-eol>) #\Newline) (:constant 'comment))
(esrap:defrule <eof> (esrap:! character))

(esrap:defrule <not-percent-nor-eol> (and (esrap:! "%") (esrap:! #\Newline) character))

(esrap:defrule DIGIT2to9 (and (esrap:character-ranges (#\2 #\9)) (* <ws>)) (:function first) (:text t))
(esrap:defrule QUESTION (and "?" (* <ws>)) (:constant #\?))
(esrap:defrule DOT (and "." (* <ws>)) (:constant #\.))
(esrap:defrule LBRACE (and "{" (* <ws>)) (:constant #\{))
(esrap:defrule RBRACE (and "}" (* <ws>)) (:constant #\}))


(defun cl-user::sl-test-all ()
  (values
   (sl:parse sl::*test-string*)
   (sl:unparse sl::*unparse-test-string*)))

(defun cl-user::sl-clear ()
  (esrap::clear-rules)
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :sl))

(defun append-lets (x)
  ;; create a nested list of LETs from a flat list of LETs, eg.
  ;;; ( (let ((x 1)))
  ;;;   (let ((y 2)))
  ;;;   (let ((z 3)) (c)) )
  ;;; ->
  ;;; ( (let ((x 1))
  ;;;     (let ((y 2))
  ;;;       (let ((z 3))
  ;;;         (c)))) )
  ;;;
  (car (append-lets-helper x)))

  ;;;  ( (let ((x 1))) (let ((y 2))) (let ((z 3)) (c)) ) -> ((LET ((X 1)) (LET ((Y 2)) (LET ((Z 3)) (C)))))
(defun append-lets-helper (x)
  (let ((len (length x)))
    (if (< len 2)
        x
      `( ,(append (first x) (append-lets (rest x))) ))))

