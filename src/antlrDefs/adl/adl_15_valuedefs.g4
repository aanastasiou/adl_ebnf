/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
lexer grammar adl_15_valuedefs;

V_IDENTIFIER                        :NAMESTR;

/*TODO: HIGH, Is this a terminal? Does it always have to be lower case? */
ID_CODE_LEADER                      :'id';

V_ARCHETYPE_ID                      :(NAMESTR(SYM_DOT ALPHANUM_STR)* SYM_COLON SYM_COLON)? NAMESTR SYM_MINUS ALPHANUM_STR SYM_MINUS NAMESTR SYM_DOT NAMESTR (SYM_MINUS ALPHANUM_STR)* SYM_DOT 'v' [0-9]+(( SYM_DOT [0-9]+){0,2}((-rc|\+u|\+)[0-9]+)?)?;

/*TODO: HIGH, Ask about this: This value needs the definition of code leader */
//V_CONCEPT_CODE::=
V_VALUE                             :VALUE_STR;

VALUESTR                            :[a-zA-Z0-9._\-]+;
NAMESTR                             :[a-zA-Z][a-zA-Z0-9_]+;
ALPHANUM_STR                        :[a-zA-Z0-9_]+;

V_CADL_TEXT                         :; 
V_ODIN_TEXT                         :;
V_RULES_TEXT                        :;
