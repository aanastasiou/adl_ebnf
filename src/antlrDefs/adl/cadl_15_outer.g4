/*
 The Archetype Definition Language (ADL) is 'split' into a set of different
 specifications as described at: http://www.openehr.org/wiki/display/spec/ADL+1.5+parser+resources
 It is composed of the constrain ADL (cADL) and data ADL (dADL or ODIN).
 cADL is used to describe not only the structure of an archetype but also the 
 semantics of different types. dADL or ODIN, is essentially a data format.
 
 This document contains the definition of the 'outer' part of a cADL document.
 
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

grammar cadl_15_outer;

import adl_15_commonSymbols, adl_15_commonValuedefs, cadl_15_symbols;

cadl_definition             :c_complex_object|assertions;

c_complex_object            :(c_complex_object_head SYM_MATCHES SYM_START_CBLOCK c_complex_object_body SYM_END_CBLOCK) | 
                             c_complex_object_head;

c_complex_object_head       :c_complex_object_id c_occurrences;
  
c_complex_object_id         :(type_identifier V_ROOT_ID_CODE) |
                             (type_identifier V_ID_CODE) |
                             (sibling_order type_identifier V_ID_CODE) | 
                             type_identifier;

sibling_order               :SYM_AFTER V_ID_CODE |
                             SYM_BEFORE V_ID_CODE;

c_complex_object_body       :c_any | c_attribute_defs;

c_object                    :c_complex_object | 
                             c_archetype_root | 
                             c_complex_object_proxy |
                             archetype_slot | 
                             c_primitive_object;

c_archetype_root            :(SYM_USE_ARCHETYPE type_identifier V_SLOT_FILLER c_occurrences) |
                             (SYM_USE_ARCHETYPE type_identifier V_EXT_REF c_occurrences);
                    
c_complex_object_proxy      :(SYM_USE_NODE type_identifier V_ID_CODE c_occurrences V_ABS_PATH) |
                             (SYM_USE_NODE type_identifier c_occurrences V_ABS_PATH);
                        
archetype_slot              :(c_archetype_slot_head SYM_MATCHES SYM_START_CBLOCK c_includes c_excludes SYM_END_CBLOCK) |
                             c_archetype_slot_head;

c_archetype_slot_head       :c_archetype_slot_id c_occurrences;
  
c_archetype_slot_id         :(SYM_ALLOW_ARCHETYPE type_identifier V_ID_CODE) |
                             (sibling_order SYM_ALLOW_ARCHETYPE type_identifier V_ID_CODE) |
                             (SYM_ALLOW_ARCHETYPE type_identifier V_ID_CODE SYM_CLOSED) |
                             (SYM_ALLOW_ARCHETYPE type_identifier);

c_primitive_object          :c_integer | 
                             c_real | 
                             c_date | 
                             c_time | 
                             c_date_time |
                             c_duration | 
                             c_string | 
                             c_terminology_code | 
                             c_boolean;

c_any                       :SYM_STAR;

//TODO: HIGH, Simplify this list
c_attribute_defs            :c_attribute_def | 
                             (c_attribute_defs c_attribute_def);

c_attribute_def             :c_attribute | c_attribute_tuple;

c_attribute                 :(c_attr_head SYM_MATCHES SYM_START_CBLOCK c_attr_values SYM_END_CBLOCK) |
                             c_attr_head;

c_attr_head                 :(V_ATTRIBUTE_IDENTIFIER c_existence c_cardinality) |
                             (V_ABS_PATH c_existence c_cardinality);
             
c_attr_values               :c_object | c_attr_values c_object | c_any;

c_attribute_tuple           :SYM_START_SBLOCK c_tuple_attr_ids SYM_END_SBLOCK SYM_MATCHES SYM_START_CBLOCK c_object_tuples SYM_END_CBLOCK;

c_tuple_attr_ids            :(V_ATTRIBUTE_IDENTIFIER (SYM_COMA V_ATTRIBUTE_IDENTIFIER)*);

c_object_tuples             :(c_object_tuple (SYM_COMA c_object_tuple)*);

c_object_tuple              :SYM_START_SBLOCK c_object_tuple_items SYM_END_SBLOCK;

c_object_tuple_items        :(SYM_START_CBLOCK c_primitive_object SYM_END_CBLOCK) |
                             (c_object_tuple_items SYM_COMA SYM_START_CBLOCK c_primitive_object SYM_END_CBLOCK)

c_includes                  :| SYM_INCLUDE assertions;
c_excludes                  :| SYM_EXCLUDE assertions;

assertions                  :assertion+;

assertion                   :(any_identifier SYM_COLON boolean_node) |
                             boolean_node |
                             arch_outer_constraint_expr;

boolean_node                :boolean_leaf | boolean_expr;

boolean_expr                :boolean_unop_expr | boolean_binop_expr;

boolean_leaf                :boolean_literal | 
                             boolean_constraint | 
                             (SYM_START_PBLOCK boolean_node SYM_END_PBLOCK)|
                            arithmetic_relop_expr;
                
arch_outer_constraint_expr  :V_REL_PATH SYM_MATCHES SYM_START_CBLOCK c_primitive_object SYM_END_CBLOCK;

boolean_constraint          :(V_ABS_PATH SYM_MATCHES SYM_START_CBLOCK c_primitive_object SYM_END_CBLOCK) |
                             (V_ABS_PATH SYM_MATCHES SYM_START_CBLOCK c_terminology_code SYM_END_CBLOCK);
                      
boolean_unop_expr           :SYM_EXISTS V_ABS_PATH | 
                             SYM_NOT V_ABS_PATH | 
                             SYM_NOT SYM_START_PBLOCK boolean_node SYM_END_PBLOCK;

boolean_binop_expr          :boolean_node boolean_binop_symbol boolean_leaf;

boolean_binop_symbol        :SYM_OR | SYM_AND | SYM_XOR | SYM_IMPLIES;

boolean_literal             :SYM_TRUE | SYM_FALSE;

arithmetic_relop_expr       :arithmetic_node relational_binop_symbol arithmetic_node;

arithmetic_node             :arithmetic_leaf | arithmetic_arith_binop_expr;

arithmetic_leaf             :arithmetic_value | (SYM_START_PBLOCK arithmetic_node SYM_END_PBLOCK);

arithmetic_arith_binop_expr :arithmetic_node arithmetic_binop_symbol arithmetic_leaf;

arithmetic_value            :integer_value | real_value | V_ABS_PATH;

relational_binop_symbol     :SYM_EQ | SYM_NE | SYM_LE | SYM_LT | SYM_GE | SYM_GT;

arithmetic_binop_symbol     :SYM_DIV | SYM_STAR | SYM_PLUS | SYM_MINUS | SYM_EXPON; 

c_existence                 :ANY | (SYM_EXISTENCE SYM_MATCHES SYM_START_CBLOCK existence SYM_END_CBLOCK);

existence                   :V_INTEGER | (V_INTEGER SYM_ELLIPSIS V_INTEGER);

c_cardinality               :ANY | (SYM_CARDINALITY SYM_MATCHES SYM_START_CBLOCK cardinality SYM_END_CBLOCK);

cardinality                 :multiplicity | 
                             (multiplicity SYM_SEMI_COLON SYM_ORDERED) |
                             (multiplicity SYM_SEMI_COLON SYM_UNORDERED) |
                             (multiplicity SYM_SEMI_COLON SYM_UNIQUE) |
                             (multiplicity SYM_SEMI_COLON SYM_ORDERED SYM_SEMI_COLON SYM_UNIQUE) |
                             (multiplicity SYM_SEMI_COLON SYM_UNORDERED SYM_SEMI_COLON SYM_UNIQUE) |
                             (multiplicity SYM_SEMI_COLON SYM_UNIQUE SYM_SEMI_COLON SYM_ORDERED) |
                             (multiplicity SYM_SEMI_COLON SYM_UNIQUE SYM_SEMI_COLON SYM_UNORDERED);
               
c_occurrences               :ANY | (SYM_OCCURRENCES SYM_MATCHES SYM_START_CBLOCK multiplicity SYM_END_CBLOCK);

multiplicity                :integer_value | 
                             SYM_STAR | 
                             (V_INTEGER SYM_ELLIPSIS integer_value) | 
                             (V_INTEGER SYM_ELLIPSIS SYM_STAR);
                
c_integer                   :integer_value | 
                             integer_list | 
                             integer_interval | 
                             integer_interval_list | 
                             (c_integer SYM_SEMI_COLON integer_value);

c_real                      :real_value | 
                             real_list | 
                             real_interval | 
                             real_interval_list | 
                             (c_real SYM_SEMI_COLON real_value);

c_date                      :V_ISO8601_DATE_CONSTRAINT_PATTERN | 
                             date_value | 
                             date_list | 
                             date_interval | 
                             date_interval_list | 
                             (c_date SYM_SEMI_COLON date_value);

c_time                      :V_ISO8601_TIME_CONSTRAINT_PATTERN |
                             time_value |
                             time_list |
                             time_interval |
                             time_interval_list |
                             (c_time SYM_SEMI_COLON time_value);

c_date_time                 :V_ISO8601_DATE_TIME_CONSTRAINT_PATTERN |
                             date_time_value |
                             date_time_list |
                             date_time_interval |
                             date_time_interval_list |
                             (c_date_time SYM_SEMI_COLON date_time_value);
               
c_duration                  :(V_ISO8601_DURATION_CONSTRAINT_PATTERN SYM_DIV duration_interval) |
                             (V_ISO8601_DURATION_CONSTRAINT_PATTERN SYM_DIV duration_value) |
                             V_ISO8601_DURATION_CONSTRAINT_PATTERN |
                            duration_value |
                            duration_list |
                            duration_interval |
                            duration_interval_list|
                            (c_duration SYM_SEMI_COLON duration_value);

c_string                    :V_STRING | 
                             string_list | 
                             V_REGEXP | 
                             (c_string SYM_SEMI_COLON string_value);

c_terminology_code          :V_VALUE_SET_REF | 
                             V_VALUE_SET_REF_ASSUMED |
                             V_VALUE_DEF | 
                             V_EXPANDED_VALUE_SET_DEF | 
                             V_EXTERNAL_VALUE_SET_DEF;
                      
//| ERR_VALUE_SET_MISSING_CODES /*TODO: HIGH, Are these simply marking the error conditions or are they parsable? */
//| ERR_VALUE_SET_DEF_DUP_CODE
//| ERR_VALUE_SET_DEF_ASSUMED
//| ERR_VALUE_SET_DEF

c_boolean                   :(SYM_TRUE | 
                             SYM_FALSE | 
                             boolean_list | 
                             (c_boolean SYM_SEMI_COLON boolean_value));

any_identifier              :type_identifier | V_ATTRIBUTE_IDENTIFIER;

type_identifier             :V_TYPE_IDENTIFIER | V_GENERIC_TYPE_IDENTIFIER;

string_value                :V_STRING ;

//TODO: HIGH, Simplify this list
string_list                 :(V_STRING SYM_COMA V_STRING) | 
                             (string_list SYM_COMA V_STRING) |
                             (string_list SYM_COMA SYM_LIST_CONTINUE) |
                             (V_STRING SYM_COMA SYM_LIST_CONTINUE);
               
integer_value               :SYM_SIGN? V_INTEGER;

//TODO: HIGH, Simplify this list
integer_list                :(integer_value SYM_COMA integer_value) |
                             (integer_list SYM_COMA integer_value) |
                             (integer_value SYM_COMA SYM_LIST_CONTINUE);
                
integer_interval            :(SYM_INTERVAL_DELIM integer_value SYM_ELLIPSIS integer_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT integer_value SYM_ELLIPSIS integer_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM integer_value SYM_ELLIPSIS SYM_LT integer_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT integer_value SYM_ELLIPSIS SYM_LT integer_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_LT integer_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_LE integer_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT integer_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GE integer_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM integer_value SYM_INTERVAL_DELIM);
                  
//TODO: HIGH, Simplify this list
integer_interval_list       :(integer_interval SYM_COMA integer_interval) |
                             (integer_interval_list SYM_COMA integer_interval)  |
                             (integer_interval SYM_COMA SYM_LIST_CONTINUE);

real_value                  :SYM_SIGN? V_REAL;

//TODO: HIGH, Simplify this list
real_list                   :(real_value SYM_COMA real_value) |
                             (real_list SYM_COMA real_value) |
                             (real_value SYM_COMA SYM_LIST_CONTINUE);

real_interval               :(SYM_INTERVAL_DELIM real_value SYM_ELLIPSIS real_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT real_value SYM_ELLIPSIS real_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM real_value SYM_ELLIPSIS SYM_LT real_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT real_value SYM_ELLIPSIS SYM_LT real_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_LT real_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_LE real_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT real_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GE real_value SYM_INTERVAL_DELIM)
                             (SYM_INTERVAL_DELIM real_value SYM_INTERVAL_DELIM);
                 
//TODO: HIGH, Simplify this list
real_interval_list          :(real_interval SYM_COMA real_interval) |
                             (real_interval_list SYM_COMA real_interval) |
                             (real_interval SYM_COMA SYM_LIST_CONTINUE);

boolean_value               :SYM_TRUE | SYM_FALSE;

//TODO: HIGH, Simplify this list
boolean_list                :(boolean_value SYM_COMA boolean_value) |
                             (boolean_list SYM_COMA boolean_value) |
                             (boolean_value SYM_COMA SYM_LIST_CONTINUE);
                
date_value                  :V_ISO8601_EXTENDED_DATE;

//TODO: HIGH, Simplify this list
date_list                   :(date_value SYM_COMA date_value) |
                             (date_list SYM_COMA date_value) |
                             (date_value SYM_COMA SYM_LIST_CONTINUE);
             
date_interval               :(SYM_INTERVAL_DELIM date_value SYM_ELLIPSIS date_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT date_value SYM_ELLIPSIS date_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM date_value SYM_ELLIPSIS SYM_LT date_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT date_value SYM_ELLIPSIS SYM_LT date_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_LT date_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_LE date_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT date_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GE date_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM date_value SYM_INTERVAL_DELIM);
                 
//TODO: HIGH, Simplify this list
date_interval_list          :(date_interval SYM_COMA date_interval) |
                             (date_interval_list SYM_COMA date_interval) |
                             (date_interval SYM_COMA SYM_LIST_CONTINUE);
                      
time_value                  :V_ISO8601_EXTENDED_TIME;

//TODO: HIGH, Simplify this list
time_list                   :(time_value SYM_COMA time_value) | 
                             (time_list SYM_COMA time_value) |
                             (time_value SYM_COMA SYM_LIST_CONTINUE);
             
time_interval               :(SYM_INTERVAL_DELIM time_value SYM_ELLIPSIS time_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT time_value SYM_ELLIPSIS time_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM time_value SYM_ELLIPSIS SYM_LT time_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT time_value SYM_ELLIPSIS SYM_LT time_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_LT time_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_LE time_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT time_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GE time_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM time_value SYM_INTERVAL_DELIM);
                 
//TODO: HIGH, Simplify this list
time_interval_list          :(time_interval SYM_COMA time_interval) |
                             (time_interval_list SYM_COMA time_interval) |
                             (time_interval SYM_COMA SYM_LIST_CONTINUE);
                      
date_time_value             :V_ISO8601_EXTENDED_DATE_TIME;

//TODO: HIGH, Simplify this list
date_time_list              :(date_time_value SYM_COMA date_time_value) |
                             (date_time_list SYM_COMA date_time_value) |
                             (date_time_value SYM_COMA SYM_LIST_CONTINUE);
                  
date_time_interval          :(SYM_INTERVAL_DELIM date_time_value SYM_ELLIPSIS date_time_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT date_time_value SYM_ELLIPSIS date_time_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM date_time_value SYM_ELLIPSIS SYM_LT date_time_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT date_time_value SYM_ELLIPSIS SYM_LT date_time_value SYM_INTERVAL_DELIM)
                             (SYM_INTERVAL_DELIM SYM_LT date_time_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_LE date_time_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT date_time_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GE date_time_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM date_time_value SYM_INTERVAL_DELIM);
                      
//TODO: HIGH, Simplify this list
date_time_interval_list     :(date_time_interval SYM_COMA date_time_interval) |
                             (date_time_interval_list SYM_COMA date_time_interval) |
                             (date_time_interval SYM_COMA SYM_LIST_CONTINUE);
                           
duration_value              :V_ISO8601_DURATION;

//TODO: HIGH, Simplify this list
duration_list               :(duration_value SYM_COMA duration_value) |
                             (duration_list SYM_COMA duration_value) |
                             (duration_value SYM_COMA SYM_LIST_CONTINUE);
                 
duration_interval           :(SYM_INTERVAL_DELIM duration_value SYM_ELLIPSIS duration_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT duration_value SYM_ELLIPSIS duration_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM duration_value SYM_ELLIPSIS SYM_LT duration_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT duration_value SYM_ELLIPSIS SYM_LT duration_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_LT duration_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_LE duration_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM SYM_GT duration_value SYM_INTERVAL_DELIM) | 
                             (SYM_INTERVAL_DELIM SYM_GE duration_value SYM_INTERVAL_DELIM) |
                             (SYM_INTERVAL_DELIM duration_value SYM_INTERVAL_DELIM);

//TODO: HIGH, Simplify this list
duration_interval_list      :(duration_interval SYM_COMA duration_interval) |
                             (duration_interval_list SYM_COMA duration_interval) |
                             (duration_interval SYM_COMA SYM_LIST_CONTINUE);

uri_value                   :V_URI;              