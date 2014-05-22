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

//genericDotNum                         :(SYM_DOT NUM+);
//genericDotNumList                     :NUM+ genericDotNum*;

//NOTE: genericDotNumList stands in as a replacement to the original definition's CODE_STR::=(0|[1-9][0-9]*)(\.(0|[1-9][0-9]*))*
id_code                               :SYM_ID (NUM+ (SYM_DOT NUM+)*);
at_code                               :SYM_AT (NUM+ (SYM_DOT NUM+)*);
ac_code                               :SYM_AC (NUM+ (SYM_DOT NUM+)*);


alphanum_char                         :(LALPHA|UALPHA|SYM_UNDER|NUM);
identifier                            :(LALPHA|UALPHA) alphanum_char*;
v_identifier                          :identifier (SYM_DOT identifier)*;

//NOTE: genericDotNumList stands in as a replacement to the original definition "... SYM_ID '1' (SYM_DOT '1')*..."
v_concept_code                        :SYM_START_SBLOCK SYM_ID (NUM+ (SYM_DOT NUM+)*) SYM_END_SBLOCK;
//v_value                               :(LALPHA|UALPHA|NUM|SYM_DOT|SYM_UNDER|SYM_MINUS|SYM_PLUS)+;
v_dotted_numeric                      :(NUM+ (SYM_DOT NUM+)*);

//NOTE: In the original definition V_INTEGER::=([0-9]+) | ([0-9]{1,3}(,[0-9]{3})+);
v_integer                             :NUM+ | (NUM+ (SYM_COMA NUM+)+);

v_real                                :(SYM_PLUS|SYM_MINUS)? NUM* (SYM_DOT NUM+) 
                                      |(NUM* SYM_DOT NUM+ ('e'|'E') ('+'|'-')?NUM+);

//NOTE: In the original definition -->"...((\.[0-9]+){0,2}((-rc|\+u|\+)[0-9]+)?"
v_archetype_id                        :(v_identifier SYM_COLON SYM_COLON)? identifier SYM_MINUS identifier SYM_MINUS identifier SYM_DOT identifier (SYM_MINUS identifier)* SYM_DOT 'v' NUM+ ((SYM_DOT NUM+)* ((SYM_MINUS 'r'|'c'| SYM_PLUS 'u'|SYM_PLUS) NUM+)?);


//NOTE: Placeholder definitions, will be expanded in due course
v_cadl_text                           :.*?; //A simple placeholder for cadl content specified in cadl_15_outer.g4
v_odin_text                           :.*?; //Placeholder for odin content specified in odin_outer.g4;
v_rules_text                          :.*?; //Placeholder for rules

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
v_root_id_code                         :SYM_START_SBLOCK SYM_ID (NUM+ (SYM_DOT NUM+)*) SYM_END_SBLOCK;
v_slot_filler                          :SYM_START_SBLOCK id_code SYM_COMA v_archetype_id SYM_END_SBLOCK;
v_string                               :SYM_DBQUOTE ~('\n'|'\\'|SYM_DBQUOTE)* SYM_DBQUOTE;
v_type_identifier                      :identifier;
//NOTE: The definition of v_uri was based entirely on RFC3986 (http://tools.ietf.org/html/rfc3986 page 51)
v_uri                                  : ((~(':'|'/'|'?'|'#')+) SYM_COLON)? (SYM_DIV SYM_DIV (~(':'|'/'|'?'|'#')*))? (~('?'|'#')*) ('?' ~('#')*)? ('#' .*)?;
v_value_def                            :SYM_START_SBLOCK at_code SYM_END_SBLOCK;
v_value_set_ref_assumed                :SYM_START_SBLOCK ac_code SYM_SEMI_COLON at_code SYM_END_SBLOCK;
v_value_set_ref                        :SYM_START_SBLOCK ac_code SYM_END_SBLOCK;

v_iso8601_duration                     :('P'(NUM+ ('y'|'Y'))? (NUM+ ('m'|'M'))? (NUM+ ('w'|'W'))? (NUM+ ('d'|'D'))? 'T' (NUM+ ('h'|'H'))? (NUM+ ('m'|'M'))? (NUM+ (('.'|',') NUM+)? ('s'|'S'))?) | ('P' (NUM+ ('y'|'Y'))? (NUM+ ('m'|'M'))? (NUM+ ('w'|'W'))? (NUM+ ('d'|'D'))?);

v_iso8601_date_constraint_pattern      :('y'|'Y') ('y'|'Y') SYM_MINUS ('m'|'M'|'X'|'?') ('m'|'M'|'X'|'?') SYM_MINUS ('d'|'D'|'?'|'X') ('d'|'D'|'?'|'X');

//NOTE: This is the final form without taking into account the "archetypes with a missing 'T'" as specified at https://github.com/openEHR/adl-tools/blob/master/components/adl_compiler/src/syntax/cadl/parser/cadl_15_scanner.l#L495
v_iso8601_date_time_constraint_pattern :('y'|'Y') ('y'|'Y') ('y'|'Y') ('y'|'Y') SYM_MINUS ('m'|'M'|'?') ('m'|'M'|'?') SYM_MINUS ('d'|'D'|'?'|'X') ('d'|'D'|'?'|'X') 'T' ('h'|'H'|'?'|'X') ('h'|'H'|'?'|'X') SYM_COLON ('m'|'M'|'?'|'X') ('m'|'M'|'?'|'X') SYM_COLON ('s'|'S'|'?'|'X') ('s'|'S'|'?'|'X');

//NOTE: Includes openEHR deviation from iso8601 as per https://github.com/openEHR/adl-tools/blob/master/components/adl_compiler/src/syntax/cadl/parser/cadl_15_scanner.l#L512
v_iso8601_duration_constraint_pattern  :'P' ('y'|'Y')? ('m'|'M')? ('w'|'W')? ('d'|'D')? ('T' ('h'|'H')? ('m'|'M')? ('s'|'S')?)?; 

//NOTE: In the original definition, some of the NUM+ are actually [0-9]{4} as per https://github.com/openEHR/adl-tools/blob/master/components/adl_compiler/src/syntax/cadl/parser/cadl_15_scanner.l#L441
v_iso8601_extended_date                :(NUM+ SYM_MINUS NUM+ SYM_MINUS NUM+) 
                                       |(NUM+ SYM_MINUS NUM+);

//NOTE: In the original definition some of the NUM+ are actually further constrained (e.g. {4}) as per https://github.com/openEHR/adl-tools/blob/master/components/adl_compiler/src/syntax/cadl/parser/cadl_15_scanner.l#L424
v_iso8601_extended_date_time           :(NUM+ SYM_MINUS NUM+ SYM_MINUS NUM+ 'T' NUM+ SYM_COLON NUM+ SYM_COLON NUM+ (('.'|',') NUM+)? ('Z'|(('+'|'-') NUM+))?)
                                       |(NUM+ SYM_MINUS NUM+ SYM_MINUS NUM+ 'T' NUM+ SYM_COLON NUM+ ('Z'|(('+'|'-') NUM+))?)
                                       |(NUM+ SYM_MINUS NUM+ SYM_MINUS NUM+ 'T' NUM+ ('Z'|(('+'|'-') NUM+))?);

v_iso8601_extended_time                :(NUM+ SYM_COLON NUM+ SYM_COLON NUM+ (('.'|',') NUM+)? ('Z'|(('+'|'-') NUM+))?) 
                                       |(NUM+ SYM_COLON NUM+ ('Z'|(('+'|'-') NUM+))?);

//NOTE: This is the final form without taking into account "archetype with a missing 'T'" as specified at https://github.com/openEHR/adl-tools/blob/master/components/adl_compiler/src/syntax/cadl/parser/cadl_15_scanner.l#L472
v_iso8601_time_constraint_patter       :('h'|'H') ('h'|'H') SYM_COLON ('m'|'M'|'?'|'X') ('m'|'M'|'?'|'X') SYM_COLON ('s'|'S'|'?'|'X') ('s'|'S'|'?'|'X');