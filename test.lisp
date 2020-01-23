(in-package :sl)

(defparameter *test-string* "
= <ir> 
:lpar :string 'kindName : ' print-text nl
              'metaData : \"\"' nl
  'inputs : {' <inputs> <outputs> <react> <first-time> <part-declarations> <wiring> :rpar '}' nl


= <inputs> 
  'inputs : [' <pin-list> ']'

= <outputs> 
  'outputs : [' <pin-list> ']'

= <part-declarations> 
  :lpar '{' <part-decl-list> '}' :rpar

= <wiring> 
  :lpar 'wiring : {' <wire-list> '}' :rpar

= <pin-list> 
  [ :symbol symbol-must-be-nil  | :lpar '{' <ident-list> '}' :rpar ]

= <ident-list> 
  :ident [ ?ident <ident-list>]

= <part-decl-list> 
  :lpar '{' <part-decl> '}' [ ?lpar ', ' <part-decl-list> ] :rpar

= <part-decl>
  <name> <kind> <inputs> <outputs> <react> <first-time>

= <name>
  :string print-text

= <kind>
  :string print-text

= <react>
  :string print-text

= <first-time>
  :string print-text

= <wire-list>
  :lpar 'wires : [' <wire> [ ?lpar ',' <wire-list> ] ']'

= <wire>
  :lpar '{ wire : ' :integer print-text :lpar <part-pin-list> :rpar :lpar <part-pin-list> :rpar ' }'

= <pin-list>
  :ident print-text [ ?ident ',' <pin-list>]

= <part-pin-list> 
  :lpar <part> <pin> :rpar 
  [ ?lpar <part-pin-list>]

= <part>
  :ident print-text
= <pin>
  :ident print-text
")
