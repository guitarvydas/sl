This is the syntax language, sl (inspired by https://en.wikipedia.org/wiki/S/SL_programming_language).

testing:

> (sl:parse sl::\*test-string\*)

See the raw grammar (PEG) in sl.lisp.

Roughly (inexactly):

sl-definitions <- ws* rule-definition+ ws* eof
rule-definition <- '=' rule-name body+
body <- call-eternal / call-rule / must-see-token / look-ahead-token / output / if
call-external <- ident
call-rule <- rule-name
rule-name <- '<' ident '>'
ident <- [-A-Za-z] [-A-Za-z0-9]*
must-see-token <- ':' ident
look-ahead-token <- '?' ident
output <- '\'' .* '\''
if <- '[' <body>+ <else>* ']'
else <- '|' <body>+


All rules have a distinct left-hand handle (i.e. this grammar can be parsed using raw recursive descent).

I've written this grammar in ESRAP (a PEG parsing library for Common Lisp).
The semantic rules emit Common Lisp code.
One can find PEG parsing libraries for most other languages and one can (easily?) rewrite this grammar to emit other languages.

This mini-language does not need trees (ast's, cst's, etc.).

Idents are not case sensitive.  Internally they are all converted to upper case.

Token types (kinds) are converted to upper case keyworks (begin with ":").


