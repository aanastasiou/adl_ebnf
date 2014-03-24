/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
lexer grammar adl_commonSymbols;

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
SYM_SIGN                :(SYM_PLUS|SYM_MINUS);