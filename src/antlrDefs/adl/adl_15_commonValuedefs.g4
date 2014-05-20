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

grammar adl_15_commonValuedefs;

import adl_15_commonSymbols;

genericDotNum                         :(SYM_DOT NUM+)*;
genericDotNumList                     :NUM+ genericDotNum;

//NOTE: genericDotNumList stands in as a replacement to the original definition's CODE_STR::=(0|[1-9][0-9]*)(\.(0|[1-9][0-9]*))*
id_code                               :SYM_ID genericDotNumList;
at_code                               :SYM_AT genericDotNumList;
ac_code                               :SYM_AC genericDotNumList;


alphanum_char                         :(LALPHA|UALPHA|SYM_UNDER|NUM);
identifier                            :(LALPHA|UALPHA) alphanum_char*;
v_identifier                          :identifier (SYM_DOT identifier)*;

//NOTE: genericDotNumList stands in as a replacement to the original definition "... SYM_ID '1' (SYM_DOT '1')*..."
v_concept_code                        :SYM_START_SBLOCK SYM_ID genericDotNumList SYM_END_SBLOCK;
//v_value                               :(LALPHA|UALPHA|NUM|SYM_DOT|SYM_UNDER|SYM_MINUS|SYM_PLUS)+;
v_dotted_numeric                      :genericDotNumList;

//NOTE: In the original definition V_INTEGER::=([0-9]+) | ([0-9]{1,3}(,[0-9]{3})+);
v_integer                             :NUM+ | (NUM+ (SYM_COMA NUM+)+);

//NOTE: In the original definition -->"...((\.[0-9]+){0,2}((-rc|\+u|\+)[0-9]+)?"
v_archetype_id                        :(v_identifier SYM_COLON SYM_COLON)? identifier SYM_MINUS identifier SYM_MINUS identifier SYM_DOT identifier (SYM_MINUS identifier)* SYM_DOT 'v' NUM+ (genericDotNum ((SYM_MINUS 'r'|'c'| SYM_PLUS 'u'|SYM_PLUS) NUM+)?)?;


//TODO: HIGH, need to clarify the definitions of these
//V_CADL_TEXT                         : .*?; 
//V_ODIN_TEXT                         : .*?
//V_RULES_TEXT                        : .*?;

//v_real                                :(NUM+ SYM_DOT NUM+) | (NUM* SYM_DOT NUM+ ('e'|'E') ('+'|'-')?NUM+);


path_seg                               :identifier (SYM_START_SBLOCK (id_code|v_archetype_id) SYM_END_SBLOCK)?;

v_abs_path                             :(SYM_DIV path_seg)+;
v_attribute_identifier                 :LALPHA alphanum_char*;

/* TODO: HIGH, Need to clarify the definitions of these */
//V_EXPANDED_VALUE_SET_DEF::=
//V_EXTERNAL_VALUE_SET_DEF

v_ext_ref                              :SYM_START_SBLOCK v_archetype_id SYM_END_SBLOCK;
v_generic_type_identifier              :identifier SYM_LT (LALPHA|UALPHA|NUM|SYM_UNDER|SYM_COMA|SYM_LT|SYM_GT)+ SYM_GT;
v_id_code                              :SYM_START_SBLOCK id_code SYM_END_SBLOCK;


//TODO: HIGH, v_regexp is to be expressed with antlr modes.
//V_REGEXP                        :SYM_DIV .*? SYM_DIV;
v_rel_path                             :path_seg v_abs_path; 
//NOTE: In the original definition, the dotnumlist is a 1(.1)*
v_root_id_code                         :SYM_START_SBLOCK SYM_ID genericDotNumList SYM_END_SBLOCK;
v_slot_filler                          :SYM_START_SBLOCK id_code SYM_COMA v_archetype_id SYM_END_SBLOCK;
//V_STRING                        :SYM_DBQUOTE ([^\\\n]|SYM_DBQUOTE)* SYM_DBQUOTE;
//V_TYPE_IDENTIFIER               :([A-Z] IDCHAR*);
//V_URI                           :[a-z]+ (SYM_COLON SYM_DIV SYM_DIV) [^<>|\\{}^~"\[\] ]*;
//ORIGINAL DEFINITION
//V_URI                       :[a-z]+:\/\/[^<>|\\{}^~"\[\] ]*;

//V_VALUE_DEF                     :SYM_START_SBLOCK AT_CODE SYM_END_SBLOCK;
//V_VALUE_SET_REF_ASSUMED         :SYM_START_SBLOCK AC_CODE [ \t]* SYM_SEMI_COLON [ \t]* AT_CODE SYM_END_SBLOCK;
//V_VALUE_SET_REF                 :SYM_START_SBLOCK AC_CODE SYM_END_SBLOCK;


//ISO8601 Related defs
v_iso8601_duration              :('P'(NUM+ 'y'|'Y')? (NUM+ 'm'|'M')? (NUM+ 'w'|'W')? (NUM+ 'd'|'D')? 'T' (NUM+ 'h'|'H')? (NUM+ 'm'|'M')? (NUM+ ('.'|',' NUM+)? 's'|'S')?) | ('P' (NUM+ 'y'|'Y')? (NUM+ 'm'|'M')? (NUM+ 'w'|'W')? (NUM+ 'd'|'D')?);
//V_ISO8601_DURATION              :('P'([0-9]+[yY])?([0-9]+[mM])?([0-9]+[wW])?([0-9]+[dD])?'T'([0-9]+[hH])?([0-9]+[mM])?([0-9]+([\.,][0-9]+)?[sS])?) | ('P'([0-9]+[yY])?([0-9]+[mM])?([0-9]+[wW])?([0-9]+[dD])?);
//V_ISO8601_DATE_CONSTRAINT_PATTERN       :[yY][yY][yY][yY] SYM_MINUS [mM?X][mM?X] SYM_MINUS [dD?X][dD?X];

/*TODO: HIGH, According to the current CADL notes the first part of this def should be removed when archetypes with a missing 'T' have gone */
//V_ISO8601_DATE_TIME_CONSTRAINT_PATTERN  :([yY][yY][yY][yY] SYM_MINUS [mM?][mM?] SYM_MINUS [dD?X][dD?X][ ][hH?X][hH?X] SYM_COLON [mM?X][mM?X] SYM_COLON [sS?X][sS?X])|([yY][yY][yY][yY] SYM_MINUS [mM?][mM?] SYM_MINUS [dD?X][dD?X]'T'[hH?X][hH?X] SYM_COLON [mM?X][mM?X] SYM_COLON [sS?X][sS?X]);

/*TODO: HIGH, Check the documentation about the note on the following definition, particularly for the '}' symbol*/
//V_ISO8601_DURATION_CONSTRAINT_PATTERN   :('P'[yY]?[mM]?[Ww]?[dD]?('T'[hH]?[mM]?[sS]?)? SYM_DIV)|('P'[yY]?[mM]?[Ww]?[dD]?('T'[hH]?[mM]?[sS]?)?);

//V_ISO8601_EXTENDED_DATE                 :([0-9]+ SYM_MINUS [0-1][0-9] SYM_MINUS [0-3][0-9]) | ([0-9]+ SYM_MINUS [0-1][0-9]);
//ORIGINAL DEFINITION:
//V_ISO8601_EXTENDED_DATE::=([0-9]{4} SYM_MINUS [0-1][0-9] SYM_MINUS [0-3][0-9]) | ([0-9]{4} SYM_MINUS [0-1][0-9]);

//V_ISO8601_EXTENDED_DATE_TIME            :([0-9]+ SYM_MINUS [0-1][0-9] SYM_MINUS [0-3][0-9]'T'[0-2][0-9] SYM_COLON [0-6][0-9] SYM_COLON [0-6][0-9]([\.,][0-9]+)?('Z'|[+-][0-9]+)?) |
//                                         ([0-9]+ SYM_MINUS [0-1][0-9] SYM_MINUS [0-3][0-9]'T'[0-2][0-9] SYM_COLON [0-6][0-9]('Z'|[+-][0-9]+)?) |
//                                         ([0-9]+ SYM_MINUS [0-1][0-9] SYM_MINUS [0-3][0-9]'T'[0-2][0-9]('Z'|[+-][0-9]+)?);
//ORIGINAL DEFINITION:
//V_ISO8601_EXTENDED_DATE_TIME::=([0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-6][0-9]:[0-6][0-9]([\.,][0-9]+)?(Z|[+-][0-9]{4})?) |
//                               ([0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-6][0-9](Z|[+-][0-9]{4})?) |
//                               ([0-9]{4}-[0-1][0-9]-[0-3][0-9]T[0-2][0-9](Z|[+-][0-9]{4})?)

//V_ISO8601_EXTENDED_TIME                 :([0-2][0-9] SYM_COLON [0-6][0-9] SYM_COLON [0-6][0-9]([\.,][0-9]+)?('Z'|[+-][0-9]+)?) | ([0-2][0-9] SYM_COLON [0-6][0-9]('Z'|[+-][0-9]+)?);

/* TODO: HIGH, First pattern to be removed when all archetypes with a leading T have gone according to cadl15 doc */
//V_ISO8601_TIME_CONSTRAINT_PATTERN       :('T'[hH][hH] SYM_COLON [mM?X][mM?X] SYM_COLON [sS?X][sS?X]) | ([hH][hH] SYM_COLON [mM?X][mM?X] SYM_COLON [sS?X][sS?X]);

