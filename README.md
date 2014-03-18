adl_ebnf
========

openEHR ADL 1.5 EBNF description

Background
----------
The openEHR foundation (openehr.org) is producing a set of 
specifications towards defining an end-to-end platform that enables a 
meaningful and helpful integration of information communication 
technolologies with the healthcare domain.

The current set of specifications includes the openEHR data model, the
Archetype Definition Language (ADL) and the Archetype Querying Language
(AQL).

The ADL and AQL are context-free domain specific languages whose sole 
purpose is to describe the structure and content of data model entities
and also query these structures.

The structure of context-free domain specific languages such as ADL 
and AQL can be described through a standardised notation called 
(Extended) Backus Naur Form (E?BNF).

An E?BNF description of a language is a very useful resource because it
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
resource, the existing definition of a parser for ADL _1.4_, available
from the OSHIP openEHR reference implementation in Python was used.

That project includes a(n almost) complete definition of ADL _1.4_
expressed via pyparsing constructs which are very closely following
the semantics of the operators and operands required for the language
definition.

Therefore, the plan is to derive the ADL _1.4_ EBNF from its pyparsing
expression and then update that with the ADL _1.5_ modifications.

What is the current status and where do i go from here?
-------------------------------------------------------
This is still work in progress with the following rough TODO list:

*) The definitions are already complex enough and several shortcuts have
been used to make strings shorter. These shortcuts come in the form of
generic lambda functions.

*) Certain classes need careful revision of their definitions, these are
(regex, quotedString, uri, real)

*) Even at the level of EBNF it is possible to perform some
optimisations. However at this point it is best to express everything
as simply as possible to first conclude with clear definitions for all
classes.
