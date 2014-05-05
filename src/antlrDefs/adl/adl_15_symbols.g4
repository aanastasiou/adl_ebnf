/*
 The Archetype Definition Language (ADL) is 'split' into a set of different
 specifications as described at: http://www.openehr.org/wiki/display/spec/ADL+1.5+parser+resources
 It is composed of the constrain ADL (cADL) and data ADL (dADL or ODIN).
 cADL is used to describe not only the structure of an archetype but also the 
 semantics of different types. dADL or ODIN, is essentially a data format.
 
 This document contains the lexical definitions of symbols required specifically
 but the ADL 1.5 outer syntax (adl_15_outer.g4).
 
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
 
lexer grammar adl_15_symbols;

/* TODO: HIGH, All marked definitions in the following code fragment are supposed to have a '^' to denote start of string.*/
SYM_ADL_VERSION                 :'adl_version'|'ADL_VERSION';
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