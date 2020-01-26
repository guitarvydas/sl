(in-package :sl)

#|

= id  -- define a rule, check that 1 item is on the stack
=N id -- define a rule, check that N [2-9] items are on the stack
: id  -- send id as a token kind with nothing as its token-text
! id  -- push id onto stack, pop id
? id  -- pop into id
?. id -- dup tos into id, no pop
. id  -- (push field "id" of top item on stack) onto stack
$foreach id -- map through list, binding each successive element to id
#foreach id -- map through table, binding each successive element to id
<id> -- call "id" (internally defined rule)
ident -- call "ident" (externally defined method)

|#


;; defined in sl.lisp: <ident>, <ws>, COLON, BANG

(esrap:defrule <unparse-definitions> (and (* <ws>) (+ <unparse-definition>) (* <ws>) <eof>)
  (:function second))

(esrap:defrule <unparse-definition> (and <unparse-rule-name> (+ <unparse-body>))
  (:destructure (name body)
   `(defmethod ,name ((u unparser)) ,(append-lets body))))

(esrap:defrule <unparse-rule-name> (and EQ <rule-name>) (:function second))

;; each of these must return a (LET ()) environment even if there are no new bindings, e.g. pop-> (let (...))
(esrap:defrule <unparse-body> (or <token-emit-kind> <push> <pop-into-id> <dup-into-id> <get-field> <foreach-in-list> <foreach-in-table> <unparse-call-rule> <unparse-call-external>)) 

(esrap:defrule <token-emit-kind> (and COLON <ident>)
  (:function second)
  (:lambda (str) `(let () (unparse-emit-token ,(intern (string-upcase str) "KEYWORD")))))

(esrap:defrule <push> (and BANG (or <ident> <get-field>))
  (:function second)
  (:lambda (str-or-get)
    (let ((rhs (if (stringp str-or-get)
                   (intern (string-upcase str-or-get))
                 str-or-get)))
      `(let () (unparse-push u ,rhs)))))

(esrap:defrule <pop-into-id> (and QUESTION <ident>)
  (:function second)
  (:lambda (str)
    (let ((id (intern (string-upcase str))))
      `(let ((,id (unparse-pop u))) ,id ))))

(esrap:defrule <dup-into-id> (and QUESTION DOT <ident>)
  (:function third)
  (:lambda (str)
    (let ((id (intern (string-upcase str))))
      `(let ((,id (unparse-tos u))) ,id))))

(esrap:defrule <get-field> (and DOT <ident>)
  (:function second)
  (:lambda (str)
    (let ((id (intern (string-upcase str))))
      `(let ((,id (slot-value (unparse-tos u) ',id))) ,id))))

(esrap:defrule <foreach-in-list> (and "~" "foreach" (* <ws>) <ident> LBRACE (+ <unparse-body>) RBRACE)
  (:destructure (tilde foreach ws id lb body rb)
   (declare (ignore tilde foreach ws lb rb))
  `(let () (mapc (,id) ,body))))

(esrap:defrule <foreach-in-table> (and "$" "foreach" (* <ws>) <ident> LBRACE (+ <unparse-body>) RBRACE)
  (:destructure (tilde foreach ws id lb body rb)
   (declare (ignore tilde foreach ws lb rb))
   (let ((key (gensym)))
     `(let () (maphash (,key ,id) (declare (ignore ,key)) ,body)))))

(esrap:defrule <unparse-call-rule> (and LT <ident> GT)
  (:function second)
  (:lambda (x)
    `(let () (unparse-call-rule u #',(intern (string-upcase x))))))

(esrap:defrule <unparse-call-external> (and "@" <ident>)
  (:function second)
  (:lambda (x)
    `(let () (unparse-call-external u #',(intern (string-upcase x))))))

(defun unparse (str)
#|
  (esrap:trace-rule '<unparse-definitions> :recursive t)
  (esrap:untrace-rule '<ident-first>)
  (esrap:untrace-rule '<ident-follow>)
  (esrap:untrace-rule '<ws>)
  (esrap:untrace-rule '<comment-to-eol>)
|#
  (esrap:parse '<unparse-definitions> str))

#| raw grammar

(esrap:defrule <unparse-definitions> (and (* <ws>) (+ <unparse-definition>) (* <ws>) <eof>))

(esrap:defrule <unparse-definition> (and <unparse-rule-name> (+ <unparse-body>)))

(esrap:defrule <unparse-rule-name> (and EQ LT <ident> GT))

(esrap:defrule <unparse-body> (or <token-emit-kind> <push> <pop-into-id> <dup-into-id> <get-field> <foreach-in-list> <foreach-in-table> <unparse-call-rule> <unparse-call-external>))

(esrap:defrule <token-emit-kind> (and COLON <ident>))
(esrap:defrule <push> (and BANG (or <ident> <get-field>)))
(esrap:defrule <pop-into-id> (and QUESTION <ident>))
(esrap:defrule <dup-into-id> (and QUESTION DOT <ident>))
(esrap:defrule <get-field> (and DOT <ident>))
(esrap:defrule <foreach-in-list> (and "~" "foreach" (* <ws>) <ident> LBRACE (+ <unparse-body>) RBRACE))
(esrap:defrule <foreach-in-table> (and "$" "foreach" (* <ws>) <ident> LBRACE (+ <unparse-body>) RBRACE))
(esrap:defrule <unparse-call-rule> (and LT <ident> GT))
(esrap:defrule <unparse-call-external> (and "@" <ident>))

|#
