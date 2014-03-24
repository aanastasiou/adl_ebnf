/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
lexer grammar adl_15_symbols;

SYM_ADL_VERSION                 :'adl_version'|'ADL_VERSION';
/* TODO: HIGH, All marked definitions in the following code fragment are supposed to have a '^' to denote start of string.*/
SYM_ANNOTATIONS                 :('annotations'|'ANNOTATIONS'); /*Mark*/
SYM_ARCHETYPE                   :('archetype'|'ARCHETYPE'); /*Mark*/
SYM_COMPONENT_TERMINOLOGIES     :'component_terminologies' | 'COMPONENT_TERMINOLOGIES';
SYM_CONCEPT                     :('concept'|'CONCEPT'); /*Mark*/
SYM_DEFINITION                  :('definition'|'DEFINITION'); /*Mark*/
SYM_DESCRIPTION                 :('description'|'DESCRIPTION'); /*Mark*/
SYM_IS_CONTROLLED               :'controlled'|'CONTROLLED';
SYM_IS_GENERATED                :'generated'|'GENERATED';
SYM_LANGUAGE                    :('language'|'LANGUAGE'); /*Mark*/
SYM_OPERATIONAL_TEMPLATE        :('operational_template'|'OPERATIONAL_TEMPLATE'); /*Mark*/
SYM_RULES                       :('rules'|'RULES'); /*Mark*/
SYM_SPECIALIZE                  :('specialise'|'specialize'|'SPECIALISE'|'SPECIALIZE'); /*Mark*/
SYM_TEMPLATE                    :('template'|'TEMPLATE'); /*Mark*/
SYM_TEMPLATE_OVERLAY            :('template_overlay'|'TEMPLATE_OVERLAY'); /*Mark*/
SYM_TERMINOLOGY                 :('terminology'|'TERMINOLOGY'); /*Mark*/
SYM_UID                         :'uid'|'UID';