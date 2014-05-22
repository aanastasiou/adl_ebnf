openEHR ADL 1.5 in EBNF
=======================

Current progress (Last updated 22/05/2014):

* Slight backtracking into reviewing the ADL ANTLR definitions. Plain transcription 
from the eifer yacc resources resulted in complex rule clashes. For this reason, each
rule definition within [adl_15_commonValuedefs.g4](https://github.com/aanastasiou/adl_ebnf/blob/master/src/antlrDefs/adl/adl_15_commonValuedefs.g4) 
was reviewed and modified so that it gets parsed properly by ANTLR.

* The reviewing criteria were: Tokens should be unique in their definitions, rules
should be composed of tokens, rules should be as less overlapping as it is possible 
in their definitions, rules cannot contain structural constraints (e.g. `[0-9]{0-3}`)
and these should be taken care of at the semantic parsing level. 

* These simple guidelines lead to the revision of a few rules that were re-used in 
different places (v_identifier, v_dotted_numeric, v_value).

* Please note: The project also includes [a definition of AQL in EBNF](https://github.com/aanastasiou/adl_ebnf/tree/master/src/aql_ebnf) 
which was used primarily to generate [syntax diagrams for that DSL previously](http://lists.openehr.org/pipermail/openehr-technical_lists.openehr.org/2013-July/007876.html).



Background
----------
The [openEHR foundation](http://www.openehr.org) is producing a set of 
specifications towards defining an end-to-end platform that enables a 
meaningful and helpful integration of information communication 
technolologies with the healthcare domain.

The current set of specifications includes the openEHR data model, the
Archetype Definition Language (ADL) and the Archetype Querying Language
(AQL).

The ADL and AQL are context-free domain specific languages whose purpose 
is to describe the structure and content of data model entities
and also query these structures.

The structure of context-free domain specific languages such as ADL 
and AQL can be described through a standardised notation called 
(Extended) Backus Naur Form (E?BNF one could say).

An EBNF description of a language is a very useful resource because it
enables:

*) The development of software to parse ADL files and
transform their content in to computable form (parsers)

*) The rendering of syntax diagrams which are an excellent way to
quickly lookup the structure of a language.

*) Data validation

...and more.

What is this then?
------------------
The objective of this piece of work is to arrive at a generic expression
of _ADL 1.5_ in E?BNF.

Currently, the structure of ADL is described in detail at: 
http://www.openehr.org/wiki/display/spec/ADL+1.5+parser+resources

These are files required by specific software (similar to yacc) that 
accept some form of language definition and produce code that implements
a parser / compiler that can comprehend the language definition at its 
input. However, this is not in a standard BNF form (or wherver it is, 
it is not detailed enough) making its comprehension difficult.


How is it done?
---------------
Due to the way the grammar is defined in the yacc-type files, its
transcription to EBNF and the derivation of the essential rules that 
define the language is difficult.

Therefore, instead of basing the derivation of the rules on that
resource, the existing definition of a parser for ADL _1.4_ (http://bazaar.launchpad.net/~higorpinto/oship/cr-ehr/view/head:/oship/src/oship/openehr/adl_1_4.py)
, available from the OSHIP openEHR reference implementation in Python 
was used.


That project includes a(n almost) complete definition of ADL _1.4_
expressed via pyparsing constructs which are very closely following
the semantics of the operators and operands required for the language
definition.

Therefore, the plan is to derive the ADL _1.4_ EBNF from its pyparsing
expression and then update that with the ADL _1.5_ modifications.

What is the current status and where do i go from here?
-------------------------------------------------------
This is still work in progress with the following rough TODO list:

*) Certain classes need careful revision of their definitions. This seems
to be an ongoing effort but at the moment the focus is to express the regex
parsing rule using modes to be able to report problems with their parsing.

*) ODIN is very early in its development...and very complex.
