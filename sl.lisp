(in-package :sl)

(esrap:defrule <sl-definitions> (and (* <ws>) (+ <rule-definition>) (* <ws>) <eof>)
  (:function second)
  (:lambda (x)
     (cons 'progn x)))

(esrap:defrule <rule-definition> (and EQ <rule-name> (+ <body>))
  (:destructure (eq name body)
   (declare (ignore eq))
   `(defmethod ,(mangle name) ((p parser)) ,@body)))

(esrap:defrule <body> (or <call-external> <call-rule> <must-see-token> <look-ahead-token> <output> <conditional> <ok> ))

(esrap:defrule <call-external> <ident> (:lambda (x) `(call-external p #',(intern (string-upcase x)))))
(esrap:defrule <call-rule> <rule-name> (:lambda (x) `(call-rule p #',(mangle-name x))))
(esrap:defrule <must-see-token> (and ":" <token>) (:function second) (:lambda (token) `(must-see p ,token)))
(esrap:defrule <look-ahead-token> (and "?" <token>) (:function second) (:lambda (token) `(look-ahead p ,token)))
(esrap:defrule <output> (and <output-chars> (* <ws>)) (:function first) (:lambda (x) `(output p ,x)))
(esrap:defrule <output-chars> (and "'" <not-squote-star> "'") (:function second))
(esrap:defrule <ok> BANG (:constant T))

(esrap:defrule <conditional> (and OPENBRACKET <condition-with-body> (* <or-bar-conditions>) CLOSEBRACKET)
  (:destructure (lb condition-with-body other-conditions rb)
   (declare (ignore lb rb))
   `(cond ,condition-with-body ,@other-conditions)))

(esrap:defrule <condition-with-body> (and <condition> (* <body>))
  (:destructure (c blist)
   `(,c ,@blist)))

(esrap:defrule <or-bar-conditions> (and ORBAR <condition-with-body>) (:function second))
(esrap:defrule <condition> (or BANG <must-see-token> <look-ahead-token>))

(esrap:defrule <rule-name> (and LT <ident> GT) (:function second) (:lambda (x) (intern (string-upcase x))))
(esrap:defrule <token> <ident> (:lambda (id) (intern (string-upcase id) "KEYWORD")))

(defparameter *suffix* nil)

(defun parse (str &optional (suffix nil))
  (setf *suffix* suffix)
  (remove-packages (esrap:parse '<sl-definitions> str)))

(defun mangle (sym)
  (if *suffix*
      (intern (format nil "~A~A" (symbol-name sym) *suffix*))
    sym))

(defun cl-user::sl-clear ()
  (esrap::clear-rules)
  (asdf::run-program "rm -rf ~/.cache/common-lisp")
  (ql:quickload :sl))


#| raw grammar, no semantic rules

(esrap:defrule <sl-definitions> (and (* <ws>) (+ <rule-definition>) (* <ws>) <eof>))

(esrap:defrule <rule-definition> (and EQ <rule-name> (+ <body>)))

(esrap:defrule <body> (or <call-external> <call-rule> <must-see-token> <look-ahead-token> <output> <if>))

(esrap:defrule <call-external> <ident>)
(esrap:defrule <call-rule> <rule-name>)
(esrap:defrule <must-see-token> (and ":" <token>))
(esrap:defrule <look-ahead-token> (and "?" <token>))
(esrap:defrule <output> (and <output-chars> (* <ws>)) (:function second))
(esrap:defrule <output-chars> (and "'" <not-squote-star> "'") (:function second))
(esrap:defrule <if> (and OPENBRACKET (* <ws>) (+ <body>) (* <else>) CLOSEBRACKET))
(esrap:defrule <else> (and ORBAR (* <ws>) (+ <body>)))

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
(esrap:defrule OPENBRACKET (and "[" (* <ws>)))
(esrap:defrule CLOSEBRACKET (and "]" (* <ws>)))
(esrap:defrule ORBAR (and "|" (* <ws>)))


(esrap:defrule <ws> (or #\Space #\Newline #\Tab))
(esrap:defrule <eof> (esrap:! character))
|#
