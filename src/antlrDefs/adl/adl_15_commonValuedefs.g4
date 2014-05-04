/*
 The Archetype Definition Language (ADL) is 'split' into a set of different
 specifications as described at: http://www.openehr.org/wiki/display/spec/ADL+1.5+parser+resources
 It is composed of the constrain ADL (cADL) and data ADL (dADL or ODIN).
 cADL is used to describe not only the structure of an archetype but also the 
 semantics of different types. dADL or ODIN, is essentially a data format.
 
 This document contains the lexical definitions of what constitutes a 'value' (V)
 (such as date, datetime, duration, integer, real, string and many others) in an 
 ADL document.
 
 Copyright (C) 2014  Athanasios Anastasiou

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

lexer grammar adl_15_commonValuedefs;

import adl_15_commonSymbols;


/*TODO: HIGH, Is this really a terminal? Does it always have to be lower case?
Maybe it should become a SYM? */
ID_CODE_LEADER                      :'id';

IDCHAR                              :[a-zA-Z0-9_];
VALUE_STR                            :[a-zA-Z0-9._\-]+;
NAMESTR                             :([a-zA-Z][a-zA-Z0-9_]+);
ALPHANUM_CHAR                       :[a-zA-Z0-9_]+;

V_IDENTIFIER                        :NAMESTR;
V_CONCEPT_CODE                      :SYM_START_SBLOCK ID_CODE_LEADER '1' (SYM_DOT '1')* SYM_END_SBLOCK;
V_VALUE                             :VALUE_STR;

//TODO: HIGH, need to clarify the definitions of these
V_CADL_TEXT                         : .*?; 
V_ODIN_TEXT                         : .*?;
V_RULES_TEXT                        : .*?;


ARCHETYPE_ID                        :(NAMESTR(SYM_DOT ALPHANUM_CHAR)* SYM_COLON SYM_COLON)? NAMESTR SYM_MINUS ALPHANUM_CHAR SYM_MINUS NAMESTR SYM_DOT NAMESTR (SYM_MINUS ALPHANUM_CHAR)* SYM_DOT 'v'[0-9]+((SYM_DOT [0-9]+)*((SYM_MINUS [rc]| SYM_PLUS 'u'|SYM_PLUS)[0-9]+)?)?;
//ORIGINAL DEFINITION:
//ARCHETYPE_ID::=({NAMESTR}(\.{ALPHANUM_STR})*::)?{NAMESTR}-{ALPHANUM_STR}-{NAMESTR}\.{NAMESTR}(-{ALPHANUM_STR})*\.v[0-9]+((\.[0-9]+){0,2}((-rc|\+u|\+)[0-9]+)?)?
PATH_SEG                        :([a-z] ALPHANUM_CHAR)* (SYM_START_SBLOCK (ID_CODE|ARCHETYPE_ID) SYM_END_SBLOCK)?;

V_ABS_PATH                      :(SYM_DIV PATH_SEG)+;
V_ATTRIBUTE_IDENTIFIER          :[a-z] IDCHAR*;

/* TODO: HIGH, Need to clarify the definitions of these */
//V_EXPANDED_VALUE_SET_DEF::=
//V_EXTERNAL_VALUE_SET_DEF

V_EXT_REF                       :SYM_START_SBLOCK ARCHETYPE_ID SYM_END_SBLOCK;
V_GENERIC_TYPE_IDENTIFIER       :[A-Z] IDCHAR* SYM_LT [a-zA-Z0-9,_\<\>]+ SYM_GT;
V_ID_CODE                       :SYM_START_SBLOCK ID_CODE SYM_END_SBLOCK;
V_INTEGER                       :([0-9]+) | ([0-9]+ (SYM_COMA [0-9]+)+);
//ORIGINAL DEFINITION:
//V_INTEGER::=([0-9]+) | ([0-9]{1,3}(,[0-9]{3})+);

V_REAL                          :([0-9]+ SYM_DOT [0-9]+) | ([0-9]+ SYM_DOT [0-9]+[eE][+-]?[0-9]+);
//TODO: HIGH, Need to clarify the definition of V_REGEX here.
V_REGEXP                        :SYM_DIV .*? SYM_DIV;
V_REL_PATH                      :PATH_SEG (SYM_DIV PATH_SEG)+; 
V_ROOT_ID_CODE                  :SYM_START_SBLOCK ID_CODE_LEADER '1' (SYM_DOT '1')* SYM_END_SBLOCK;
V_SLOT_FILLER                   :SYM_START_SBLOCK ID_CODE[ \t]*','[ \t]*ARCHETYPE_ID SYM_END_SBLOCK;
V_STRING                        :SYM_DBQUOTE ([^\\\n]|SYM_DBQUOTE)* SYM_DBQUOTE;
V_TYPE_IDENTIFIER               :([A-Z] IDCHAR*);
V_URI                           :[a-z]+ (SYM_COLON SYM_DIV SYM_DIV) [^<>|\\{}^~"\[\] ]*;
//ORIGINAL DEFINITION
//V_URI                       :[a-z]+:\/\/[^<>|\\{}^~"\[\] ]*;

V_VALUE_DEF                     :SYM_START_SBLOCK AT_CODE SYM_END_SBLOCK;
V_VALUE_SET_REF_ASSUMED         :SYM_START_SBLOCK AC_CODE [ \t]* SYM_SEMI_COLON [ \t]* AT_CODE SYM_END_SBLOCK;
V_VALUE_SET_REF                 :SYM_START_SBLOCK AC_CODE SYM_END_SBLOCK;


//ISO8601 Related defs
V_ISO8601_DURATION              :('P'([0-9]+[yY])?([0-9]+[mM])?([0-9]+[wW])?([0-9]+[dD])?'T'([0-9]+[hH])?([0-9]+[mM])?([0-9]+([\.,][0-9]+)?[sS])?) | ('P'([0-9]+[yY])?([0-9]+[mM])?([0-9]+[wW])?([0-9]+[dD])?);
V_ISO8601_DATE_CONSTRAINT_PATTERN       :[yY][yY][yY][yY] SYM_MINUS [mM?X][mM?X] SYM_MINUS [dD?X][dD?X];

/*TODO: HIGH, According to the current CADL notes the first part of this def should be removed when archetypes with a missing 'T' have gone */
V_ISO8601_DATE_TIME_CONSTRAINT_PATTERN  :([yY][yY][yY][yY] SYM_MINUS [mM?][mM?] SYM_MINUS [dD?X][dD?X][ ][hH?X][hH?X] SYM_COLON [mM?X][mM?X] SYM_COLON [sS?X][sS?X])|([yY][yY][yY][yY] SYM_MINUS [mM?][mM?] SYM_MINUS [dD?X][dD?X]'T'[hH?X][hH?X] SYM_COLON [mM?X][mM?X] SYM_COLON [sS?X][sS?X]);

/*TODO: HIGH, Check the documentation about the note on the following definition, particularly for the '}' symbol*/
V_ISO8601_DURATION_CONSTRAINT_PATTERN   :('P'[yY]?[mM]?[Ww]?[dD]?('T'[hH]?[mM]?[sS]?)? SYM_DIV)|('P'[yY]?[mM]?[Ww]?[dD]?('T'[hH]?[mM]?[sS]?)?);

V_ISO8601_EXTENDED_DATE                 :([0-9]+ SYM_MINUS [0-1][0-9] SYM_MINUS [0-3][0-9]) | ([0-9]+ SYM_MINUS [0-1][0-9]);
//ORIGINAL DEFINITION:
//V_ISO8601_EXTENDED_DATE::=([0-9]{4} SYM_MINUS [0-1][0-9] SYM_MINUS [0-3][0-9]) | ([0-9]{4} SYM_MINUS [0-1][0-9]);

V_ISO8601_EXTENDED_DATE_TIME            :([0-9]+ SYM_MINUS [0-1][0-9] SYM_MINUS [0-3][0-9]'T'[0-2][0-9] SYM_COLON [0-6][0-9] SYM_COLON [0-6][0-9]([\.,][0-9]+)?('Z'|[+-][0-9]+)?) |
                                         ([0-9]+ SYM_MINUS [0-1][0-9] SYM_MINUS [0-3][0-9]'T'[0-2][0-9] SYM_COLON [0-6][0-9]('Z'|[+-][0-9]+)?) |
                                         ([0-9]+ SYM_MINUS [0-1][0-9] SYM_MINUS [0-3][0-9]'T'[0-2][0-9]('Z'|[+-][0-9]+)?);
//ORIGINAL DEFINITION:
//V_ISO8601_EXTENDED_DATE_TIME::=([0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-6][0-9]:[0-6][0-9]([\.,][0-9]+)?(Z|[+-][0-9]{4})?) |
//                               ([0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-6][0-9](Z|[+-][0-9]{4})?) |
//                               ([0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9](Z|[+-][0-9]{4})?)

V_ISO8601_EXTENDED_TIME                 :([0-2][0-9] SYM_COLON [0-6][0-9] SYM_COLON [0-6][0-9]([\.,][0-9]+)?('Z'|[+-][0-9]{4})?) | ([0-2][0-9] SYM_COLON [0-6][0-9]('Z'|[+-][0-9]{4})?);

/* TODO: HIGH, First pattern to be removed when all archetypes with a leading T have gone according to cadl15 doc */
V_ISO8601_TIME_CONSTRAINT_PATTERN       :('T'[hH][hH] SYM_COLON [mM?X][mM?X] SYM_COLON [sS?X][sS?X]) | ([hH][hH] SYM_COLON [mM?X][mM?X] SYM_COLON [sS?X][sS?X]);

