/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
grammar cadl_15_valuedefs;

import adl_15_commonSymbols;

IDCHAR                          :[a-zA-Z0-9_];
VALUESTR                        :[a-zA-Z0-9._\-]+;
NAMESTR                         :([a-zA-Z][a-zA-Z0-9_]+);

//This is ALPHANUM_STR in ADL outer
ALPHANUM_CHAR                   :[a-zA-Z0-9_]+;

ARCHETYPE_ID                    :(NAMESTR(SYM_DOT ALPHANUM_STR)* SYM_COLON SYM_COLON)? NAMESTR SYM_MINUS ALPHANUM_STR SYM_MINUS NAMESTR SYM_DOT NAMESTR (SYM_MINUS ALPHANUM_STR)* SYM_DOT 'v'[0-9]+((SYM_DOT [0-9]+)*((SYM_MINUS [rc]| SYM_PLUS 'u'|SYM_PLUS)[0-9]+)?)?;
//ORIGINAL DEFINITION:
//ARCHETYPE_ID::=({NAMESTR}(\.{ALPHANUM_STR})*::)?{NAMESTR}-{ALPHANUM_STR}-{NAMESTR}\.{NAMESTR}(-{ALPHANUM_STR})*\.v[0-9]+((\.[0-9]+){0,2}((-rc|\+u|\+)[0-9]+)?)?
PATH_SEG                        :([a-z] ALPHANUM_CHAR)* (SYM_START_SBLOCK (ID_CODE|ARCHETYPE_ID) SYM_END_SBLOCK)?;

V_ABS_PATH                      :(SYM_DIV PATH_SEG)+;
V_ATTRIBUTE_IDENTIFIER          :[a-z] IDCHAR*;

/* TODO: HIGH, A bit difficult to understand the definition of this */
//V_EXPANDED_VALUE_SET_DEF::=
//V_EXTERNAL_VALUE_SET_DEF

V_EXT_REF                       :SYM_START_SBLOCK ARCHETYPE_ID SYM_END_SBLOCK;
V_GENERIC_TYPE_IDENTIFIER       :[A-Z] IDCHAR* SYM_LT [a-zA-Z0-9,_\<\>]+ SYM_GT;
V_ID_CODE                       :SYM_START_SBLOCK ID_CODE SYM_END_SBLOCK;
V_INTEGER                       :([0-9]+) | [0-9]+ (SYM_COMA [0-9]+)+;
//ORIGINAL DEFINITION:
//V_INTEGER::=([0-9]+) | ([0-9]{1,3}(,[0-9]{3})+);

V_REAL                          :([0-9]+ SYM_DOT [0-9]+) | ([0-9]+ SYM_DOT [0-9]+[eE][+-]?[0-9]+);
//V_REGEXP                    :PATH_SEG ('/' PATH_SEG)+;
V_REL_PATH                      :PATH_SEG ('/' PATH_SEG)+; 
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

/*TODO: HIGH, Check the documentation about the note on the following definition */
V_ISO8601_DURATION_CONSTRAINT_PATTERN   :('P'[yY]?[mM]?[Ww]?[dD]?('T'[hH]?[mM]?[sS]?)?)|('P'[yY]?[mM]?[Ww]?[dD]?('T'[hH]?[mM]?[sS]?)?);

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

V_ISO8601_EXTENDED_TIME                 :([0-2][0-9] SYM_COLON [0-6][0-9] SYM_COLON [0-6][0-9]([\.,][0-9]+)?('Z'|[+-][0-9]{4})?) | ([0-2][0-9] SYM_COLON [0-6][0-9]('Z'|[+-][0-9]{4})?)

/* TODO: HIGH, First pattern to be removed when all archetypes with a leading T have gone according to cadl15 doc */
V_ISO8601_TIME_CONSTRAINT_PATTERN       :('T'[hH][hH] SYM_COLON [mM?X][mM?X] SYM_COLON [sS?X][sS?X]) | ([hH][hH] SYM_COLON [mM?X][mM?X] SYM_COLON [sS?X][sS?X]);
