# -*- coding: utf-8 -*-
##############################################################################
# Copyright (c) 2007, Timothy W. Cook and Contributors. All rights reserved.
# Redistribution and use are governed by the Mozilla Public License Version 1.1 - see docs/OSHIP-LICENSE.txt
#
# Use and/or redistribution of this file assumes you have read and accepted the
# terms of the license.
##############################################################################


__author__  = 'Paul McGuire <paul@alanweberassociates.com>'
__docformat__ = 'plaintext'
__version__ = '1.1'
__contributors__ = ['Timothy Cook <timothywayne.cook@gmail.com>', "Athanasios Anastasiou <A.anastasiou@swansea.ac.uk>"]
__all__ = "archetypeDefinition"

from pyparsing import *

#Definition of key literals
LT,GT,EQ,LPAR,RPAR,LBRK,RBRK,BAR,QUOT,SEMI,LBRC,RBRC,STAR,COLON,COMMA = map(Suppress,"<>=()[]|';{}*:,")
ELLIPSIS = Literal("...")

#Further elementary definitions (some of which are not necessary)
uppers = srange("[A-Z]")
lowers = uppers.lower()
idchars = alphanums+"_"

v_type_identifier = Word(uppers, idchars)
v_generic_type_identifier = Regex(r"[A-Z][a-zA-Z0-9_]*<[a-zA-Z0-9,_<>]+>")

type_identifier = Regex(r"[A-Z][a-zA-Z0-9_]*(<[a-zA-Z0-9,_<>]+>)?")
attr_identifier = Word(lowers, idchars)

any_identifier = type_identifier | attr_identifier

local_term_code_ref = Regex(r"\[[a-zA-Z0-9][a-zA-Z0-9._\-]*\]")
local_code = Regex(r"a[ct][0-9.]+")

quotedString = QuotedString('"',unquoteResults=True,multiline=True) | QuotedString("[",endQuoteChar="]",unquoteResults=False)
fileref = delimitedList(Word(alphanums+"-_"),".",combine=True)
regex = QuotedString("/",escQuote='\\',unquoteResults=False)
string_ = QuotedString('"',escQuote='\\') | regex

path_segment = attr_identifier + Optional(local_term_code_ref)
relative_path = delimitedList(path_segment,'/',combine=True)
absolute_path = Combine('/' + Optional(relative_path))

key = attr_identifier | (LBRK + quotedString + RBRK)
real = Combine(Word("+-"+nums,nums)+"."+Optional(Word(nums)))
sign = oneOf("+ -")
integer = Combine( Optional(sign) + (Combine(Word(nums,max=3)+OneOrMore(','+Word(nums,exact=3))
                 ).setParseAction(lambda t:t[0].replace(',','')) | Word(nums) ) )
integer.setParseAction(lambda t:int(t[0]))


realLead = ((Word(nums,max=3)+OneOrMore('_'+Word(nums,exact=3))).setParseAction(lambda t:t[0].replace('_','')) | Word(nums) ) + FollowedBy('.') + ~FollowedBy('..')
real = Combine(Optional(sign) + (realLead + '.' + Optional(Word(nums)) + Optional(Regex('[eE][+-]?[0-9]+')) | '.' + Word(nums) + Optional(Regex('[eE][+-]?[0-9]+')) ) )
real.setParseAction(lambda t:float(t[0]))

uri = Combine(Word(alphas) + '://' + CharsNotIn(" >"))
val = real | integer | attr_identifier
valueDef = Forward()
valueDef << Group( key + EQ + LT +
        Optional( Dict(OneOrMore( valueDef )) |
          (quotedString + ~Literal(",")) |
          Group(delimitedList(quotedString | ELLIPSIS) ) |
          QuotedString("|", unquoteResults=False) |
          real | integer | uri
        ) + GT )

# expressions specific to the Definition section (uses cADL)
#Again, define literals
MATCHES, IS_IN, OCCURRENCES, EXISTENCE, CARDINALITY, ORDERED, UNORDERED, UNIQUE, INFINITY = map(CaselessKeyword, "matches is_in occurrences existence cardinality ordered unordered unique infinity".split())
MATCHES = MATCHES.suppress()
IS_IN = IS_IN.suppress()
USE_NODE, USE_ARCHETYPE, ALLOW_ARCHETYPE = map(CaselessKeyword, "use_node use_archetype allow_archetype".split())
THEN, ELSE, AND, OR, XOR, NOT, IMPLIES, EXISTS, TRUE, FALSE, FORALL = map(CaselessKeyword, "then else and or xor not implies exists true false forall".split())
INCLUDE, EXCLUDE = map(CaselessKeyword, "include exclude".split())

str_ = dblQuotedString
character = Combine("'" + ( Word(printables.replace("\\"," "),exact=1) |
                            Word('\\',r"\ntrf'",exact=2) |
                            Word('\\',nums,min=2) |
                            Word('&',alphanums+"_") + ";" |
                            "&#x" + Word(nums,exact=4) ) + "'")
arithOperand = real | integer | str_ | character | absolute_path | attr_identifier
arithExpr = operatorPrecedence(arithOperand,
    [
    ("-", 1, opAssoc.RIGHT),
    (oneOf("+ - / * ^"), 2, opAssoc.LEFT),
    ])

comparisonOperator = oneOf("= != < > <= >=")
arithComparison = arithExpr + comparisonOperator + arithExpr


c_primitive = Forward()
boolOperand = (EXISTS + absolute_path  |
    Group(relative_path + (MATCHES | IS_IN) + Group(LBRC + c_primitive + RBRC)) |
    TRUE | FALSE | arithComparison )
boolExpr = operatorPrecedence(boolOperand,
    [
    (NOT, 1, opAssoc.RIGHT),
    ((AND | OR | XOR | IMPLIES), 2, opAssoc.LEFT),
    ] )

c_object = Forward()
complex_object_id = Combine(type_identifier + Optional(local_term_code_ref))
occurrence_spec = (integer("min") + '..' + (integer|"*")("max"))("range") | integer("exact") | Literal("*")("any")
defaultOccurrences = ParseResults([1, '..', 1])
#defaultOccurrences["min"] = 1
#defaultOccurrences["max"] = 1
#defaultOccurrences["exact"] = 1
c_occurrences = Optional(Group(OCCURRENCES + (MATCHES|IS_IN) + Group(LBRC + occurrence_spec + RBRC)), default=defaultOccurrences)("occurrences")
complex_object_head = complex_object_id("id") + c_occurrences
existence_spec = Group(integer("min") + '..' + integer("max"))("range") | integer("exact")
c_existence = EXISTENCE + (MATCHES | IS_IN) + Group(LBRC + existence_spec + RBRC)
cardinality_spec = Group(occurrence_spec)("occurs") + ( Optional(SEMI + (ORDERED|UNORDERED)("order")) & Optional(SEMI + UNIQUE("unique")) )
c_cardinality = CARDINALITY + (MATCHES | IS_IN) + Group(LBRC + cardinality_spec + RBRC)
c_attribute_head = attr_identifier + Optional(c_existence)("existence") + Optional(c_cardinality)("cardinality")
c_attribute = c_attribute_head + (MATCHES | IS_IN) + Group(LBRC + OneOrMore(c_object) + RBRC)
complex_object_body = Literal("*")("any") | Dict(OneOrMore(Group(c_attribute)))("attributes")
c_complex_object = \
    Group(complex_object_head + (MATCHES | IS_IN) + Group( LBRC + complex_object_body + RBRC )("body"))
archetype_internal_ref = USE_NODE + type_identifier + c_occurrences + absolute_path

assertion = ( any_identifier("id") + COLON + Group(boolExpr) | Group(boolExpr) )
c_includes = Group(INCLUDE + OneOrMore(assertion))
c_excludes = Group(EXCLUDE + OneOrMore(assertion))
archetype_slot = (ALLOW_ARCHETYPE + type_identifier + Optional(local_term_code_ref) + c_occurrences + \
    MATCHES + Group( LBRC + (Optional(c_includes, default=["include",[]]) & Optional(c_excludes, default=["exclude",[]])) + RBRC ))
constraint_ref = local_term_code_ref
code = Regex(r"[a-zA-Z0-9._\-]+")
c_term_code_constraint = Group(LBRK + Regex(r"[a-zA-Z0-9()._\-]+::")("terminologyId") + 
    Optional(delimitedList(code)("term_codes") +
             Optional(SEMI + code("assumedValue"))) +
    RBRK)
qualified_term_code_ref = Regex(r"[[a-zA-Z0-9._\-()]+::[a-zA-Z0-9._\-]+\]")
c_code_phrase = c_term_code_constraint | qualified_term_code_ref
ordinal = Group( integer + "|" + qualified_term_code_ref )
c_ordinal = delimitedList(ordinal) + Optional(SEMI + integer)
make_interval = lambda expr : \
    Group("|" + ( expr("min") + ".." + expr("max") |
        ">" + expr("min") + ".." + expr("max") |
        expr("min") + ".." + "<" + expr("max") |
        ">" + expr("min") + ".." + "<" + expr("max") |
        "<=" + expr |
        "<" + expr |
        ">=" + expr |
        ">" + expr |
        expr ) + "|" )
c_real_interval = make_interval(real)
c_real = (real + "," + "..." | delimitedList(real) | c_real_interval) + Optional(SEMI + real("assumedValue"))
date_constraint_pattern = Regex(r"[yY][yY][yY][yY]-[mM?X][mM?X]-[dD?X][dD?X]")
date_value = Regex(r"[0-9]{4}-[0-1][0-9](-[0-3][0-9])?")
date_interval = make_interval(date_value)
c_date_constraint = date_constraint_pattern | date_value | date_interval
c_date = c_date_constraint + Optional(SEMI + date_value("assumedValue"))
time_constraint_pattern = Regex(r"[hH][hH]:[mM?X][mM?X]:[sS?X][sS?X]")
time_value = Regex(r"[0-2][0-9]:[0-6][0-9]:[0-6][0-9](,[0-9]+)?(Z|[+-][0-9]{4})?|[0-2][0-9]:[0-6][0-9](Z|[+-][0-9]{4})?")
time_interval = make_interval(time_value)
c_time_constraint = time_constraint_pattern | time_value | time_interval
c_time = c_time_constraint + Optional(SEMI + time_value("assumedValue"))
date_time_constraint_pattern = Regex(r"[yY][yY][yY][yY]-[mM?][mM?]-[dD?X][dD?X][T ][hH?X][hH?X]:[mM?X][mM?X]:[sS?X][sS?X]")
datetime_value = Regex(r"[0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-6][0-9]:[0-6][0-9](,[0-9]+)?(Z|[+-][0-9]{4})?|"
    r"[0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-6][0-9](Z|[+-][0-9]{4})?|"
    r"[0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9](Z|[+-][0-9]{4})?")
datetime_interval = make_interval(datetime_value)
c_datetime_constraint = date_time_constraint_pattern | datetime_value | datetime_interval
c_datetime = c_datetime_constraint + Optional(SEMI + datetime_value("assumedValue"))
duration_constraint_pattern = Regex(r"P[yY]?[mM]?[Ww]?[dD]?T[hH]?[mM]?[sS]?|P[yY]?[mM]?[Ww]?[dD]?")
duration_value = Regex(r"P([0-9]+[yY])?([0-9]+[mM])?([0-9]+[wW])?([0-9]+[dD])?[T ]([0-9]+[hH])?([0-9]+[mM])?([0-9]+[sS])?|"
    r"P([0-9]+[yY])?([0-9]+[mM])?([0-9]+[wW])?([0-9]+[dD])?")
duration_interval = make_interval(duration_value)
c_duration_constraint = duration_constraint_pattern | duration_value | duration_interval
c_duration = c_duration_constraint + Optional(SEMI + duration_value("assumedValue"))
c_integer_interval = make_interval(integer)
c_integer = (integer + "," + "..." | delimitedList(integer) | c_integer_interval) + Optional(SEMI + integer("assumedValue"))
c_string = (string_ + "," + "..." | delimitedList(string_)) + Optional(SEMI + string_("assumedValue"))
c_boolean = (TRUE + "," + FALSE | FALSE + "," + TRUE | TRUE | FALSE) + Optional(SEMI + (TRUE | FALSE)("assumedValue"))
c_primitive << (c_real | c_datetime | c_date | c_time | c_duration | c_integer | c_string | c_boolean)

domain_value = Forward()
array_ref = LBRK + dblQuotedString + RBRK
domain_value << ( LT + Optional( Dict(OneOrMore( Group((attr_identifier|array_ref) + EQ + domain_value) ) ) |
                        QuotedString('"',escQuote='\\',multiline=True) | qualified_term_code_ref | c_primitive
                                    ) + GT )
domain_type = (type_identifier + domain_value)

c_object << Group( (c_complex_object | archetype_internal_ref | archetype_slot | constraint_ref |
                c_code_phrase | c_ordinal | domain_type ) | c_primitive )

# section names
ARCHETYPE, CONCEPT, LANGUAGE, DESCRIPTION, DEFINITION, INVARIANT, ONTOLOGY, REVISION_HISTORY = \
    map(CaselessKeyword,
        "archetype concept language description "
        "definition invariant ontology revision_history".split())
SPECIALIZE = CaselessKeyword("specialize") | CaselessKeyword("specialise")

# ADL file sections:
versionNum = delimitedList(Word(nums),'.',combine=True)
archetypeSection = ARCHETYPE + LPAR + \
                    Dict(delimitedList(Group(key + EQ + (versionNum | val) |
                                             "controlled" | "uncontrolled"),";")) + \
                    RPAR + fileref("name_version")
specializeSection = SPECIALIZE + fileref("name_version")
conceptSection = CONCEPT + quotedString
languageSection = LANGUAGE + Dict(OneOrMore(valueDef))
descriptionSection = DESCRIPTION + Dict(OneOrMore(valueDef))
definitionSection = DEFINITION + c_object
invariantSection = INVARIANT + Dict(ZeroOrMore(attr_identifier + COLON + boolExpr) )
ontologySection = ONTOLOGY + Dict(OneOrMore(valueDef))
revisionHistorySection = REVISION_HISTORY + Dict(OneOrMore(valueDef))
archetypeDefinition = SkipTo(archetypeSection)("headerBytes") + Dict(
    Group(archetypeSection) + \
    Optional(Group(specializeSection), default=["specialize",[]]) + \
    Optional(Group(conceptSection), default=["concept",[]]) + \
    Group(languageSection) + \
    Group(descriptionSection) + \
    Group(definitionSection) + \
    Optional(invariantSection, default=["invariant",[]]) + \
    Group(ontologySection) + \
    Optional(Group(revisionHistorySection), default=["revision_history",[]])) + \
    StringEnd()

comment = "--" + restOfLine
archetypeDefinition.ignore(comment)
