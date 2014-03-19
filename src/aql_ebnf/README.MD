AQL definition in EBNF
=====================

Diagram rendered with:
http://railroad.my28msec.com/rr/ui

Data from:
http://www.openehr.org/wiki/display/spec/ANTLR+AQL+grammar

Older diagram at:
http://www.openehr.org/wiki/display/spec/Archetype+Query+Language+Grammar

Process:
1) Downloaded the ANTLR specification
2) cat Aql.g|egrep "^//">AQL_edited.txt
3) Removed certain syntax terms to make it compatible to the RRDG generator's EBNF (W3 version)
4) Performed simplification
5) Rendered the result


Dictionary ::= '{' key ':' value '}' | {'{' (key ':' value ',')+ '}'};

key ::= [a-zA-Z_]+[0-9]?

value ::= Numeric | String | Dictionary | HexValue

Numeric ::= [0-9]+ | [0-9]+('.'[0-9]+)?

String ::= '"' [a-zA-Z0-9_\-]* '"'

HexValue ::= '#'[0-9A-F]+
