(in-package :sl)

(esrap:defrule <sl-definitions> (and (* <ws>) (+ <rule-definition>) (* <ws>) <eof>))

(esrap:defrule <rule-definition> (and EQ <rule-name> (+ <body>)))

(esrap:defrule <body> (or <call-external> <call-rule> <must-see-token> <output> <look-ahead>))

(esrap:defrule <call-external> <ident>)
(esrap:defrule <call-rule> <rule-name>)
(esrap:defrule <must-see-token> (and ":" <token>))
(esrap:defrule <output> (and <output-chars> (* <ws>)) (:function second))
(esrap:defrule <output-chars> (and "'" <not-squote-star> "'") (:function second))
(esrap:defrule <look-ahead> (and "[" QUESTION <token> (+ <body>) "]"))

(esrap:defrule <rule-name> (and LT <ident> GT))
(esrap:defrule <ident> (and <ident-chars> (* <ws>)) (:function first))
(esrap:defrule <ident-chars> (and <ident-first> (* <ident-follow>)) (:text t))
(esrap:defrule <ident-first> (esrap:character-ranges (#\A #\Z) (#\a #\z)))
(esrap:defrule <ident-follow> (esrap:character-ranges #\- (#\A #\Z) (#\a #\z) (#\0 #\9)))
(esrap:defrule <not-squote-star> (* <not-squote>) (:text t))
(esrap:defrule <not-squote> (and (esrap:! "'") character))
(esrap:defrule <token> <ident>)

(esrap:defrule LT (and "<" (* <ws>)))
(esrap:defrule GT (and ">" (* <ws>)))
(esrap:defrule EQ (and "=" (* <ws>)))
(esrap:defrule QUESTION (and "?" (* <ws>)))

(esrap:defrule <ws> (or #\Space #\Newline #\Tab))
(esrap:defrule <eof> (esrap:! character))

(defun parse (str)
  (esrap:parse '<sl-definitions> str))

(defun cl-user::clear ()
  (esrap::clear-rules)
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :sl))
