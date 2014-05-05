/*
WORK IN PROGRESS
 */

grammar odin;


input       : attr_vals
            | complex_object_block;

attr_vals   :attr_val
            |attr_vals attr_val
            |attr_vals SYM_SEMI attr_val;

attr_val    : attr_id SYM_EQ object_block;
              
attr_id     :V_ATTRIBUTE_IDENTIFIER;

object_block:complex_object_block
            | primitive_object_block
            | object_reference_block
            | SYM_START_DBLOCK SYM_END_DBLOCK;

complex_object_block:
  single_attr_object_block
| container_attr_object_block
container_attr_object_block:
  untyped_container_attr_object_block
| type_identifier untyped_container_attr_object_block
untyped_container_attr_object_block:
  container_attr_object_block_head keyed_objects SYM_END_DBLOCK
container_attr_object_block_head:
  SYM_START_DBLOCK
keyed_objects:
  keyed_object
| keyed_objects keyed_object
keyed_object:
  object_key SYM_EQ object_block
object_key:
  [ primitive_value ]
single_attr_object_block:
  untyped_single_attr_object_block
| type_identifier untyped_single_attr_object_block
untyped_single_attr_object_block:
  single_attr_object_complex_head attr_vals SYM_END_DBLOCK
single_attr_object_complex_head:
  SYM_START_DBLOCK
primitive_object_block:
  untyped_primitive_object_block
| type_identifier untyped_primitive_object_block
untyped_primitive_object_block:
  SYM_START_DBLOCK primitive_object SYM_END_DBLOCK
primitive_object:
  primitive_value
| primitive_list
| primitive_interval
| primitive_interval_list
| term_code
| term_code_list
primitive_value:
  string_value
| integer_value
| real_value
| boolean_value
| character_value
| date_value
| time_value
| date_time_value
| duration_value
| uri_value
primitive_list:
  string_list
| integer_list
| real_list
| boolean_list
| character_list
| date_list
| time_list
| date_time_list
| duration_list
primitive_interval:
  integer_interval
| real_interval
| date_interval
| time_interval
| date_time_interval
| duration_interval
primitive_interval_list:
  integer_interval_list
| real_interval_list
| date_interval_list
| time_interval_list
| date_time_interval_list
| duration_interval_list
type_identifier:
  ( V_TYPE_IDENTIFIER )
| ( V_GENERIC_TYPE_IDENTIFIER )
| V_TYPE_IDENTIFIER
| V_GENERIC_TYPE_IDENTIFIER
string_value:
  V_STRING
string_list:
  V_STRING , V_STRING
| string_list , V_STRING
| string_list , SYM_LIST_CONTINUE
| V_STRING , SYM_LIST_CONTINUE
integer_value:
  V_INTEGER
| + V_INTEGER
| - V_INTEGER
integer_list:
  integer_value , integer_value
| integer_list , integer_value
| integer_value , SYM_LIST_CONTINUE
integer_interval:
  SYM_INTERVAL_DELIM integer_value SYM_ELLIPSIS integer_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT integer_value SYM_ELLIPSIS integer_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM integer_value SYM_ELLIPSIS SYM_LT integer_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT integer_value SYM_ELLIPSIS SYM_LT integer_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_LT integer_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_LE integer_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT integer_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GE integer_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM integer_value SYM_INTERVAL_DELIM
integer_interval_list:
  integer_interval , integer_interval
| integer_interval_list , integer_interval
| integer_interval , SYM_LIST_CONTINUE
real_value:
  V_REAL
| + V_REAL
| - V_REAL
real_list:
  real_value , real_value
| real_list , real_value
| real_value , SYM_LIST_CONTINUE
real_interval:
  SYM_INTERVAL_DELIM real_value SYM_ELLIPSIS real_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT real_value SYM_ELLIPSIS real_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM real_value SYM_ELLIPSIS SYM_LT real_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT real_value SYM_ELLIPSIS SYM_LT real_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_LT real_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_LE real_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT real_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GE real_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM real_value SYM_INTERVAL_DELIM
real_interval_list:
  real_interval , real_interval
| real_interval_list , real_interval
| real_interval , SYM_LIST_CONTINUE
boolean_value:
  SYM_TRUE
| SYM_FALSE
boolean_list:
  boolean_value , boolean_value
| boolean_list , boolean_value
| boolean_value , SYM_LIST_CONTINUE
character_value:
  V_CHARACTER
character_list:
  character_value , character_value
| character_list , character_value
| character_value , SYM_LIST_CONTINUE
date_value:
  V_ISO8601_EXTENDED_DATE
date_list:
  date_value , date_value
| date_list , date_value
| date_value , SYM_LIST_CONTINUE
date_interval:
  SYM_INTERVAL_DELIM date_value SYM_ELLIPSIS date_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT date_value SYM_ELLIPSIS date_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM date_value SYM_ELLIPSIS SYM_LT date_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT date_value SYM_ELLIPSIS SYM_LT date_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_LT date_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_LE date_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT date_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GE date_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM date_value SYM_INTERVAL_DELIM
date_interval_list:
  date_interval , date_interval
| date_interval_list , date_interval
| date_interval , SYM_LIST_CONTINUE
time_value:
  V_ISO8601_EXTENDED_TIME
time_list:
  time_value , time_value
| time_list , time_value
| time_value , SYM_LIST_CONTINUE
time_interval:
  SYM_INTERVAL_DELIM time_value SYM_ELLIPSIS time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT time_value SYM_ELLIPSIS time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM time_value SYM_ELLIPSIS SYM_LT time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT time_value SYM_ELLIPSIS SYM_LT time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_LT time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_LE time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GE time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM time_value SYM_INTERVAL_DELIM
time_interval_list:
  time_interval , time_interval
| time_interval_list , time_interval
| time_interval , SYM_LIST_CONTINUE
date_time_value:
  V_ISO8601_EXTENDED_DATE_TIME
date_time_list:
  date_time_value , date_time_value
| date_time_list , date_time_value
| date_time_value , SYM_LIST_CONTINUE
date_time_interval:
  SYM_INTERVAL_DELIM date_time_value SYM_ELLIPSIS date_time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT date_time_value SYM_ELLIPSIS date_time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM date_time_value SYM_ELLIPSIS SYM_LT date_time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT date_time_value SYM_ELLIPSIS SYM_LT date_time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_LT date_time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_LE date_time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT date_time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GE date_time_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM date_time_value SYM_INTERVAL_DELIM
date_time_interval_list:
  date_time_interval , date_time_interval
| date_time_interval_list , date_time_interval
| date_time_interval , SYM_LIST_CONTINUE
duration_value:
  V_ISO8601_DURATION
duration_list:
  duration_value , duration_value
| duration_list , duration_value
| duration_value , SYM_LIST_CONTINUE
duration_interval:
  SYM_INTERVAL_DELIM duration_value SYM_ELLIPSIS duration_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT duration_value SYM_ELLIPSIS duration_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM duration_value SYM_ELLIPSIS SYM_LT duration_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT duration_value SYM_ELLIPSIS SYM_LT duration_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_LT duration_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_LE duration_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GT duration_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM SYM_GE duration_value SYM_INTERVAL_DELIM
| SYM_INTERVAL_DELIM duration_value SYM_INTERVAL_DELIM
duration_interval_list:
  duration_interval , duration_interval
| duration_interval_list , duration_interval
| duration_interval , SYM_LIST_CONTINUE
term_code:
  V_QUALIFIED_TERM_CODE_REF
| V_TERMINOLOGY_ID
| ERR_V_QUALIFIED_TERM_CODE_REF
term_code_list:
  term_code , term_code
| term_code_list , term_code
| term_code , SYM_LIST_CONTINUE
uri_value:
  V_URI
object_reference_block:
  SYM_START_DBLOCK absolute_path_object_value SYM_END_DBLOCK
absolute_path_object_value:
  absolute_path
| absolute_path_list
absolute_path_list:
  absolute_path , absolute_path
| absolute_path_list , absolute_path
| absolute_path , SYM_LIST_CONTINUE
absolute_path:
  /
| / relative_path
| absolute_path / relative_path
relative_path:
  path_segment
| relative_path / path_segment
path_segment:
  V_ATTRIBUTE_IDENTIFIER [ V_STRING ]
| V_ATTRIBUTE_IDENTIFIER

