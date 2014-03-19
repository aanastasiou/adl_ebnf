// Author: Bostjan Lah
// (c) Copyright, Marand, http://www.marand.com
// Licensed under LGPL: http://www.gnu.org/copyleft/lesser.html
// Based on AQL grammar by Ocean Informatics: http://www.openehr.org/wiki/download/attachments/2949295/EQL_v0.6.grm?version=1&modificationDate=1259650833000
grammar Aql;

options {
	output=AST;
	ASTLabelType=CommonTree;
	backtrack=true;
	memoize=true;
}

tokens {
	ORDERDESC;
	ORDERASC;
}

@header {
package com.marand.thinkehr.aql.antlr;
import com.marand.thinkehr.aql.AqlRecognitionException;
}

@lexer::header{
package com.marand.thinkehr.aql.antlr;
import com.marand.thinkehr.aql.AqlRecognitionException;
}

@members{
public void displayRecognitionError(String[] tokenNames, RecognitionException e)
{
  throw new AqlRecognitionException(e);
}
}

// Rule Definitions
//<Query> ::= <Select> <From>
//           | <Select> <From> <Where>
//            | <Select> <From> <OrderBy>   ! is this allowed?
//            | <Select> <From> <Where> <OrderBy>
query	:	select from where? orderBy? ';'!? EOF!;

//<Select> ::= 'SELECT' <SelectExpr>
//         | 'SELECT' <TOP> <SelectExpr>
select	:	SELECT top? selectExpr -> ^(SELECT top? selectExpr);

//<Top> ::= 'TOP' Integer
//          | 'TOP' Integer 'BACKWARD'
//          | 'TOP' Integer 'FORWARD'
top	:	TOP INTEGER FORWARD? -> ^(TOP INTEGER)
	|	TOP INTEGER BACKWARD -> ^(TOP INTEGER BACKWARD);


//<Where> ::= 'WHERE' <IdentifiedExpr>
where	:	WHERE identifiedExpr -> ^(WHERE identifiedExpr);

//<OrderBy> ::= 'ORDER BY' <OrderBySeq>
orderBy	:	ORDERBY orderBySeq -> ^(ORDERBY orderBySeq);

//<OrderBySeq>  ::= <OrderByExpr> 
//		| <OrderByExpr> ',' <OrderBySeq>
orderBySeq
	:	orderByExpr (','! orderByExpr)*;

//<OrderByExpr> ::= <IdentifiedPath>
//		| <IdentifiedPath> 'DESCENDING'
//		| <IdentifiedPath> 'ASCENDING'
//		| <IdentifiedPath> 'DESC'
//		| <IdentifiedPath> 'ASC'
orderByExpr
	:	identifiedPath (DESCENDING|DESC) -> ^(ORDERDESC identifiedPath)
	|	identifiedPath (ASCENDING|ASC)? -> ^(ORDERASC identifiedPath);

//<SelectExpr> ::= <IdentifiedPathSeq>
selectExpr
	:	identifiedPathSeq;

//! When multiple paths provided, each IdentifiedPath must represent an object of type DataValue
//<IdentifiedPathSeq> ::= <IdentifiedPath//>
//			| <IdentifiedPath> 'as' Identifier
//			| <IdentifiedPath> ',' <IdentifiedPathSeq>
//			| <IdentifiedPath> 'as' Identifier ',' <IdentifiedPathSeq>
identifiedPathSeq
	:	selectVar (','! selectVar)*;

selectVar
	:	identifiedPath^ asIdentifier?;
	
asIdentifier
	:	AS IDENTIFIER;
		
//<From> ::=   'FROM' <FromExpr>		! stop or/and without root class
//	    | 'FROM' <FromEHR> <ContainsExpr>
//           | 'FROM' <FromEHR>
//!          'FROM' <ContainsOr>
from	: FROM fromExpr -> ^(FROM fromExpr)
	| FROM ehrContains -> ^(FROM ehrContains);

//<FromEHR> ::= 'EHR' <StandardPredicate>
//              | 'EHR' Identifier <StandardPredicate>
//              | 'EHR' Identifier
fromEHR	: EHR IDENTIFIER -> ^(EHR IDENTIFIER)
	| EHR IDENTIFIER standardPredicate -> ^(EHR IDENTIFIER standardPredicate)
	| EHR standardPredicate -> ^(EHR standardPredicate);

ehrContains
	: fromEHR (CONTAINS^ contains)?;
	
//<IdentifiedExpr> ::= <IdentifiedEquality>
//                   | <IdentifiedExprBoolean>
//                   |'(' <IdentifiedExprBoolean> ')'
//identifiedExpr
//	: identifiedExprBoolean;
//        | '('! identifiedExprBoolean ')'!;

//<IdentifiedExprBoolean> ::= <IdentifiedExpr> 'OR' <IdentifiedExpr>
//                              | <IdentifiedExpr> 'AND' <IdentifiedExpr>
//                              | <IdentifiedExpr> 'XOR' <IdentifiedExpr>
//                              | 'NOT''(' <IdentifiedExprBoolean> ')'
//                              | 'NOT' <IdentifiedEquality>
identifiedExpr
 	: identifiedExprAnd ((OR|XOR)^ identifiedExprAnd)*;

identifiedExprAnd
	: identifiedEquality (AND^ identifiedEquality)*;


//<IdentifiedEquality> ::= <IdentifiedOperand> ComparableOperator <IdentifiedOperand>
//			     | <IdentifiedOperand> 'matches' '{' <MatchesOperand> '}'
//                          | <IdentifiedOperand> 'matches' RegExPattern
//                          | 'EXISTS' <IdentifiedPath>
identifiedEquality
 	: identifiedOperand ((MATCHES^ '{'! matchesOperand '}'!)|(COMPARABLEOPERATOR^ identifiedOperand))
        | EXISTS identifiedPath -> ^(EXISTS identifiedPath)
        | '('! identifiedExpr ')'!
        | NOT^ identifiedEquality
 	;
// 	| identifiedOperand 'matches' '{' matchesOperand '}'
//        | identifiedOperand 'matches' REGEXPATTERN
//        | 'EXISTS' identifiedPath;

//<IdentifiedOperand> ::= <Operand> | <IdentifiedPath>
identifiedOperand
 	: operand | identifiedPath;
//!<IdentifiedOperand> ::= <Operand> | <RelativePath>

//<IdentifiedPath>::= Identifier
//                    | Identifier <Predicate>
//                    | Identifier '/' <ObjectPath>
//                    | Identifier <Predicate> '/' <ObjectPath>
identifiedPath
	 : IDENTIFIER predicate? ('/' objectPath)? -> ^(IDENTIFIER predicate? objectPath?);
//!		| Identifer <AbsolutePath>
//!		| Identifer <Predicate> <AbsolutePath>


//<Predicate> ::= <NodePredicate>
predicate
 	: nodePredicate;

//<NodePredicate> ::= '['<NodePredicateOr>']'
nodePredicate
 	: OPENBRACKET nodePredicateOr CLOSEBRACKET;

//<NodePredicateOr> ::= <NodePredicateAnd>
//                 | <NodePredicateOr> 'or' <NodePredicateAnd>
nodePredicateOr
 	: nodePredicateAnd (OR^ nodePredicateAnd)*;

//<NodePredicateAnd> ::= <NodePredicateComparable>
//                 | <NodePredicateAnd> 'and' <NodePredicateComparable>
nodePredicateAnd
 	: nodePredicateComparable (AND^ nodePredicateComparable)*;

//<NodePredicateComparable> ::= <PredicateOperand> ComparableOperator <PredicateOperand>
//                          | NodeId
//                          | NodeId ',' String        ! <NodeId> and name/value = <String> shortcut
//                          | NodeId ',' parameter     ! <NodeId> and name/value = <Parameter> shortcut
//                          | <NodePredicateRegEx>     ! /items[{/at0001.*/}], /items[at0001 and name/value matches {//}]
//                          | ArchetypeId
//                          | ArchetypeId ',' String        ! <NodeId> and name/value = <String> shortcut
//                          | ArchetypeId ',' parameter     ! <NodeId> and name/value = <Parameter> shortcut
nodePredicateComparable
 	: NODEID (COMMA^ (STRING|PARAMETER))?
 	| ARCHETYPEID (COMMA^ (STRING|PARAMETER))?
 	| predicateOperand ((COMPARABLEOPERATOR^ predicateOperand)|(MATCHES^ REGEXPATTERN)) 
        | REGEXPATTERN     //! /items[{/at0001.*/}], /items[at0001 and name/value matches {//}]
        ;

//<NodePredicateRegEx>    ::= RegExPattern
//                          | <PredicateOperand> 'matches' RegExPattern
nodePredicateRegEx
 	: REGEXPATTERN
 	| predicateOperand MATCHES^ REGEXPATTERN;

//<MatchesOperand> ::= <ValueListItems>
//			| UriValue
matchesOperand
 	: valueListItems | URIVALUE;

//! <ValueList> ::= '{'<ValueListItems>'}'
//<ValueListItems> ::= <Operand>
//                     |<Operand> ',' <ValueListItems>
valueListItems
 	: operand (','! operand)*;

//<URI>     ::= '{' UriValue '}'
uri 	: '{' URIVALUE '}';


//<ArchetypePredicate> ::= '[' ArchetypeId ']'
//			 | '[' Parameter ']'
//                      | '[' RegExPattern ']'
archetypePredicate
 	: OPENBRACKET (archetypeId|PARAMETER|REGEXPATTERN) CLOSEBRACKET;

archetypeId
	:	ARCHETYPEID;
	
//<VersionPredicate> ::= '[' <VersionPredicateOptions> ']'
versionPredicate
 	: OPENBRACKET versionPredicateOptions CLOSEBRACKET;

//<VersionPredicateOptions> ::= 'latest_version' | 'all_versions'
versionPredicateOptions
 	: 'latest_version' | ALL_VERSIONS;

//<StandardPredicate> ::= '[' <PredicateExpr> ']'
standardPredicate
 	: '['! predicateExpr ']'!;

//<PredicateExpr> ::= <PredicateOr>
predicateExpr
 	: predicateOr;

//<PredicateOr> ::= <PredicateAnd>
//                 | <PredicateOr> 'or' <PredicateAnd>
predicateOr
 	: predicateAnd (OR^ predicateAnd)*;
// 	: (predicateOr 'or')? predicateAnd; !!!

//<PredicateAnd> ::= <PredicateEquality>
//                 | <PredicateAnd> 'and' <PredicateEquality>
predicateAnd
 	: predicateEquality (AND^ predicateEquality)*;
// 	: (predicateAnd 'and')? predicateEquality; !!!

//<PredicateEquality> ::= <PredicateOperand> ComparableOperator <PredicateOperand>
predicateEquality
 	: predicateOperand COMPARABLEOPERATOR^ predicateOperand;

//<PredicateOperand> ::= !Identifier
//			!| Identifier PathItem
//                     | <ObjectPath>
//                     | <Operand>
predicateOperand
 	: objectPath | operand;

//<Operand> ::= String | Integer | Float | Date | Parameter | Boolean
operand: STRING | INTEGER | FLOAT | DATE | PARAMETER | BOOLEAN;


//<ObjectPath> ::=  <PathPart>
//                | <PathPart> '/' <ObjectPath>
objectPath
 	: pathPart ('/' pathPart)*;


//<PathPart> ::= Identifier
//           | Identifier <Predicate>
pathPart
 	: IDENTIFIER predicate?;

//<FromExpr> ::=  <SimpleClassExpr>
//		| <SimpleClassExpr> <ContainsExpr>
fromExpr: containsExpression;

contains:	simpleClassExpr (CONTAINS^ containsExpression)?;

//! Check thislass
//<ContainsExpr>::= 'CONTAINS' <ContainsExpression>
//                  !'CONTAINS' <ContainsOr>
//<ContainsExpression> ::= <ClassExpr>
//                        | <ContainExpressionBoolean>
//                        |'(' <ContainExpressionBoolean> ')'
containsExpression
 	: containExpressionBool (boolOp containsExpression)?
// 	| '(' containExpressionBool ')' -> ^(OPEN containExpressionBool)
        ;

//<ContainExpressionBoolean> ::= <ContainsExpression> 'OR' <ContainsExpression>
//                              | <ContainsExpression> 'AND' <ContainsExpression>
//                              | <ContainsExpression> 'XOR' <ContainsExpression>
containExpressionBool
 	: contains
 	| '(' containsExpression ')' -> ^(OPEN containsExpression CLOSE);

boolOp	:	OR|XOR|AND;
	
//<ClassExpr>::=   <SimpleClassExpr>
//		   | '(' <SimpleClassExpr> <ContainsExpr> ')'
//		   | <SimpleClassExpr> <ContainsExpr>
//classExpr
// 	: '(' simpleClassExpr ')'
//	| simpleClassExpr
//	;

//<SimpleClassExpr>::= Identifier							! RM_TYPE_NAME
//               | Identifier Identifier					! RM_TYPE_NAME variable
//               | <ArchetypedClassExpr>
//		 | <VersionedClassExpr>
//		 | <VersionClassExpr>
//		 ! | <IdentifiedObjectExpr>                           ! need to be used once VersionedClassExpr is removed
simpleClassExpr
	: IDENTIFIER IDENTIFIER?					//! RM_TYPE_NAME .. RM_TYPE_NAME variable
        | archetypedClassExpr
        | versionedClassExpr
	| versionClassExpr;
//		 ! | <IdentifiedObjectExpr>                           ! need to be used once VersionedClassExpr is removed

//<ArchetypedClassExpr>::= Identifier <ArchetypePredicate>	! RM_TYPE_NAME [archetype_id]
//               | Identifier Identifier <ArchetypePredicate>	! RM_TYPE_NAME variable [archetype_id]
archetypedClassExpr
 	: IDENTIFIER^ IDENTIFIER? archetypePredicate;	//! RM_TYPE_NAME variable? [archetype_id]

//! need to be used once VersionedClassExpr is removed
//!<IdentifiedObjectExpr>::= Identifier <StandardPredicate>	! RM_TYPE_NAME [path operator operand]
//!               | Identifier Identifier <StandardPredicate>	! RM_TYPE_NAME variable [path operator operand]
//<VersionedClassExpr>::= 'VERSIONED_OBJECT'
//               | 'VERSIONED_OBJECT' Identifier
//               | 'VERSIONED_OBJECT' <StandardPredicate>
//               | 'VERSIONED_OBJECT' Identifier <StandardPredicate>
versionedClassExpr
 	: VERSIONED_OBJECT^ IDENTIFIER? standardPredicate?;

//<VersionClassExpr>::= 'VERSION'
//               | 'VERSION' Identifier
//               | 'VERSION' <StandardPredicate>
//               | 'VERSION' Identifier <StandardPredicate>
//		 | 'VERSION' <VersionPredicate>
//               | 'VERSION' Identifier <VersionPredicate>
versionClassExpr
 	: VERSION^ IDENTIFIER? (standardPredicate|versionPredicate)?;

//
// LEXER PATTERNS
//

WS  :   ( ' '
        | '\t'
        | '\r'
        | '\n'
        ) {$channel=HIDDEN;}
    ;

SELECT : ('S'|'s')('E'|'e')('L'|'l')('E'|'e')('C'|'c')('T'|'t') ;
TOP : ('T'|'t')('O'|'o')('P'|'p') ;
FORWARD : ('F'|'f')('O'|'o')('R'|'r')('W'|'w')('A'|'a')('R'|'r')('D'|'d') ;
BACKWARD : ('B'|'b')('A'|'a')('C'|'c')('K'|'k')('W'|'w')('A'|'a')('R'|'r')('D'|'d') ;
AS : ('A'|'a')('S'|'s') ;
CONTAINS : ('C'|'c')('O'|'o')('N'|'n')('T'|'t')('A'|'a')('I'|'i')('N'|'n')('S'|'s') ;
WHERE : ('W'|'w')('H'|'h')('E'|'e')('R'|'r')('E'|'e') ;
ORDERBY : ('O'|'o')('R'|'r')('D'|'d')('E'|'e')('R'|'r')(' ')('B'|'b')('Y'|'y') ;
FROM : ('F'|'f')('R'|'r')('O'|'o')('M'|'m') ;
DESCENDING : ('D'|'d')('E'|'e')('S'|'s')('C'|'c')('E'|'e')('N'|'n')('D'|'d')('I'|'i')('N'|'n')('G'|'g') ;
ASCENDING : ('A'|'a')('S'|'s')('C'|'c')('E'|'e')('N'|'n')('D'|'d')('I'|'i')('N'|'n')('G'|'g') ;
DESC : ('D'|'d')('E'|'e')('S'|'s')('C'|'c') ;
ASC : ('A'|'a')('S'|'s')('C'|'c') ;
EHR : 'EHR';
AND : ('A'|'a')('N'|'n')('D'|'d') ;
OR : ('O'|'o')('R'|'r') ;
XOR : ('X'|'x')('O'|'o')('R'|'r') ;
NOT : ('N'|'n')('O'|'o')('T'|'t') ;
MATCHES : ('M'|'m')('A'|'a')('T'|'t')('C'|'c')('H'|'h')('E'|'e')('S'|'s') ;
EXISTS: ('E'|'e')('X'|'x')('I'|'i')('S'|'s')('T'|'t')('S'|'s') ;
VERSION	:	'VERSION';
VERSIONED_OBJECT	:	'VERSIONED_OBJECT';
ALL_VERSIONS
	:	'all_versions';
	
fragment
ESC_SEQ
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    |   UNICODE_ESC
    |   OCTAL_ESC
    ;

fragment
OCTAL_ESC
    :   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7')
    ;

fragment
UNICODE_ESC
    :   '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
    ;

fragment
HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F') ;

QUOTE	:	'\'';

fragment
DIGIT	:	'0'..'9';

fragment
HEXCHAR	:	 DIGIT|'a'|'A'|'b'|'B'|'c'|'C'|'d'|'D'|'e'|'E'|'f'|'F';

fragment
LETTER
	:	'a'..'z'|'A'..'Z';

fragment
ALPHANUM
	:	LETTER|DIGIT;

fragment
LETTERMINUSA
	:	'b'..'z'|'B'..'Z';

fragment
LETTERMINUST
	:	'a'..'s'|'A'..'S'|'u'..'z'|'U'..'Z';

fragment
IDCHAR	:	ALPHANUM|'_';

fragment
IDCHARMINUST
	:	LETTERMINUST|DIGIT|'_';

fragment
URISTRING
	:	ALPHANUM|'_'|'-'|'/'|':'|'.'|'?'|'&'|'%'|'$'|'#'|'@'|'!'|'+'|'='|'*';

fragment
REGEXCHAR
	:	URISTRING|'('|')'|'\\'|'^'|'{'|'}'|']'|'[';


// Terminal Definitions

//Boolean     = 'true' | 'false'
BOOLEAN	:	'true' | 'false' | 'TRUE' | 'FALSE' ;

//!NodeId      = 'a''t'{Digit}{Digit}{Digit}{Digit}
//! conflict with Identifier
//!NodeId	     = 'at'({Digit}{Digit}{Digit}{Digit}('.0'*('.'{NonZeroDigit}{Digit}*)+|('.'{NonZeroDigit}{Digit}*)*)|'0''.0'*('.'{NonZeroDigit}{Digit}*)+|('.'{NonZeroDigit}{Digit}*)+)
//NodeId	     = 'at'({Digit}+('.'{Digit}+)*)
//NODEID	:	'at' DIGIT+ ('.' DIGIT+)*;
NODEID	:	'at' DIGIT+ ('.' DIGIT+)*; // DIGIT DIGIT DIGIT DIGIT;

//!Identifier  = {Letter}({Alphanumeric}|'_')*   ! Conflicts with UID
//!Identifier  = {Letter}{IdChar}*   ! Conflicts with extended NodeId
//! restricted to allow only letters after the 4th character due to conflict with extended NodeId
//!Identifier  = {Letter}{IdChar}?{IdChar}?{IdChar}?({Letter}|'_')*  !Conficts with NodeId which may have any length of digit, such as at0.9
//Identifier = {LetterMinusA}{IdCharMinusT}?{IdChar}* | 'a''t'?(({letter}|'_')*|{LetterMinusT}{Alphanumeric}*)
// ???
IDENTIFIER
	:	('a'|'A') (ALPHANUM|'_')*
	| 	LETTERMINUSA IDCHAR*
	;

//!PathItem = '/'{Letter}({Alphanumeric}|'_')*

//Integer     = {Digit}+
INTEGER	:	'-'? DIGIT+;

//Float       = {Digit}+'.'{Digit}+
FLOAT	:	'-'? DIGIT+ '.' DIGIT+;

//Date        = ''{Digit}{Digit}{Digit}{Digit}'-'{Digit}{Digit}'-'{Digit}{Digit}''
DATE	:	'\'' DIGIT DIGIT DIGIT DIGIT DIGIT DIGIT DIGIT DIGIT 'T' DIGIT DIGIT DIGIT DIGIT DIGIT DIGIT '.' DIGIT DIGIT DIGIT '+' DIGIT DIGIT DIGIT DIGIT '\'';

//!Parameter   = '$'{letter}({Alphanumeric}|'_')*
//Parameter   = '$'{letter}{IdChar}*
PARAMETER
	:	'$' LETTER IDCHAR*;

//! could constrain UID further
//UniqueId    = {digit}+('.'{digit}+)+'.'{digit}+  ! OID
//          | {Hex Char}+('-'{Hex Char}+)+       ! UUID
UNIQUEID:	DIGIT+ ('.' DIGIT+)+ '.' DIGIT+  // OID
            | HEXCHAR+ ('-' HEXCHAR+)+       // UUID
	;

//! could constrain ArchetypeId further
//!ArchetypeId = {Letter}+'-'{Letter}+'-'({Letter}|'_')+'.'({Letter}|'_'|'-')+'.v'{Digit}+('.'{Digit}+)?  ! not allow a number in archetype id concept, such as openEHR-EHR-OBSERVATION.laboratory-hba1c.v1
//ArchetypeId = {Letter}+'-'{Letter}+'-'({Letter}|'_')+'.'({IdChar}|'-')+'.v'{Digit}+('.'{Digit}+)?
ARCHETYPEID
	:	LETTER+ '-' LETTER+ '-' (LETTER|'_')+ '.' (IDCHAR|'-')+ '.v' DIGIT+ ('.' DIGIT+)?
	;

//ComparableOperator = '=' | '!=' | '>' | '>=' | '<' | '<='
COMPARABLEOPERATOR
	:	'=' | '!=' | '>' | '>=' | '<' | '<='
	;

//UriValue   = {Letter}+'://'({UriString}|'['|']'|', '''|'')*
//            |{Letter}+':'({UriString}|'['|']'|'')*
URIVALUE: LETTER+ '://' (URISTRING|'['|']'|', \''|'\'')*
//	| LETTER+ ':' (URISTRING|'['|']'|'\'')*
        ;

//RegExPattern = '{/'{RegExChar}+'/}'
REGEXPATTERN
	:	'{/' REGEXCHAR+ '/}';

//String      = '"'{String Char}*'"'
  //          | ''{String Char}*''
STRING
    	:  '\'' ( ESC_SEQ | ~('\\'|'\'') )* '\''
    	|  '"' ( ESC_SEQ | ~('\\'|'"') )* '"'
    	;

SLASH	:	'/';

COMMA	:	',';

OPENBRACKET
	:	'[';

CLOSEBRACKET
	:	']';
	
OPEN	:	'(';
CLOSE	:	')';