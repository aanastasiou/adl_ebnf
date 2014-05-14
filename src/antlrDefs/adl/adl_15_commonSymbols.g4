/*
 The Archetype Definition Language (ADL) is 'split' into a set of different
 specifications as described at: http://www.openehr.org/wiki/display/spec/ADL+1.5+parser+resources
 It is composed of the constrain ADL (cADL) and data ADL (dADL or ODIN).
 cADL is used to describe not only the structure of an archetype but also the 
 semantics of different types. dADL or ODIN, is essentially a data format.
 
 This document contains the lexical definitions of a set of symbols (such as 
 the coma, slash, star and others) that are used throughout the ADL 1.5 documents.
  
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

lexer grammar adl_15_commonSymbols;

SYM_ELLIPSIS            :'..';
SYM_LE                  :'<=';
SYM_GE                  :'>=';
SYM_GT                  :'>';
SYM_LT                  :'<';
SYM_NE                  :'!=';
SYM_EQ                  :'=';
SYM_INTERVAL_DELIM      :'|';
SYM_LIST_CONTINUE       :'...';
SYM_START_CBLOCK        :'{';
SYM_END_CBLOCK          :'}'; //_C_urly block
SYM_START_SBLOCK        :'[';
SYM_END_SBLOCK          :']'; //_S_quare block
SYM_START_PBLOCK        :'(';
SYM_END_PBLOCK          :')'; //_P_arenthesis block
SYM_SEMI_COLON          :';';
SYM_COLON               :':';
SYM_COMA                :',';
SYM_DOT                 :'.';
SYM_PLUS                :'+';
SYM_MINUS               :'-';
SYM_DIV                 :'/';
SYM_STAR                :'*';
SYM_EXPON               :'^';
SYM_DBQUOTE             :'"';
SYM_UNDER               :'_';
SYM_SPACE               :' ';

SYM_ID                  :'id';
SYM_AT                  :'at';
SYM_AC                  :'ac';

SYM_SIGN                :('+'|'-');

//Larger character classes
UALPHA                  :[A-Z];
LALPHA                  :[a-z];
NUM                     :[1-9];
//ONUM                    :[1-9];