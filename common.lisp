(in-package :sl)

(esrap:defrule <ident> (and <ident-chars> (* <ws>)) (:function first))
(esrap:defrule <ident-chars> (and <ident-first> (* <ident-follow>)) (:text t))
(esrap:defrule <ident-first> (esrap:character-ranges (#\A #\Z) (#\a #\z)))
(esrap:defrule <ident-follow> (esrap:character-ranges #\- #\/ (#\A #\Z) (#\a #\z) (#\0 #\9)))
(esrap:defrule <not-squote-star> (* <not-squote>) (:text t))
(esrap:defrule <not-squote> (and (esrap:! "'") character))
(esrap:defrule LT (and "<" (* <ws>)))
(esrap:defrule GT (and ">" (* <ws>)))
(esrap:defrule EQ (and "=" (* <ws>)))
(esrap:defrule OPENBRACKET (and "[" (* <ws>)))
(esrap:defrule CLOSEBRACKET (and "]" (* <ws>)))
(esrap:defrule ORBAR (and "|" (* <ws>)))
(esrap:defrule BANG (and "!" (* <ws>)) (:constant T))
(esrap:defrule COLON (and ":" (* <ws>)) (:constant T))


(esrap:defrule <ws> (or <comment-to-eol> #\Space #\Newline #\Tab))
(esrap:defrule <comment-to-eol> (and "%" (* <not-percent-nor-eol>) #\Newline))
(esrap:defrule <eof> (esrap:! character))

(esrap:defrule <not-percent-nor-eol> (and (esrap:! "%") (esrap:! #\Newline) character))

(esrap:defrule DIGIT2to9 (and (esrap:character-ranges (#\2 #\9)) (* <ws>)) (:function first) (:text t))
(esrap:defrule QUESTION (and "?" (* <ws>)))
(esrap:defrule DOT (and "." (* <ws>)))
(esrap:defrule LBRACE (and "{" (* <ws>)))
(esrap:defrule RBRACE (and "}" (* <ws>)))

