/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
lexer grammar cadl_15_symbols;

SYM_AFTER           :'after'|'AFTER';
SYM_ALLOW_ARCHETYPE :'allow_archetype'|'ALLOW_ARCHETYPE';
SYM_BEFORE          :'before'|'BEFORE'; 
SYM_CARDINALITY     :'cardinality'|'CARDINALITY';
SYM_EXISTENCE       :'existence'|'EXISTENCE';
SYM_FALSE           :'false'|'FALSE';
SYM_INCLUDE         :'include'|'INCLUDE';
SYM_MATCHES         :'matches'|'MATCHES';
SYM_NOT             :'not'|'NOT';
SYM_ORDERED         :'ordered'|'ORDERED';
SYM_TRUE            :'true'|'TRUE';
SYM_UNIQUE          :'unique'|'UNIQUE';
SYM_UNORDERED       :'unordered'|'UNORDERED';
SYM_USE_ARCHETYPE   :'use_archetype'|'USE_ARCHETYPE';
SYM_USE_NODE        :'use_node'|'USE_NODE';
SYM_CLOSED          :'closed'|'CLOSED';
SYM_AND             :'and'|'AND';
SYM_XOR             :'xor'|'XOR';
SYM_EXCLUDE         :'exclude'|'EXCLUDE';
SYM_EXISTS          :'exists'|'EXISTS';
SYM_IMPLIES         :'implies'|'IMPLIES';
SYM_OCCURRENCES     :'occurrences'|'OCCURRENCES';
SYM_OR              :'or'|'OR';