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





