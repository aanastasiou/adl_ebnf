/*
 The 'outer' definition of ADL 1.5, describing an openEHR archetype in human
 readable text form. This document aims at providing a compact
 description of the Archetype Definition Language in a form that it can be
 re-usable by software in different programming languages, whether this is
 achieved through an ANTLR target or 'simply' by transcribing the rules to
 a different form.
 
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
grammar adl_15_outer;

import adl_15_commonSymbols, adl_15_symbols, adl_15_commonValuedefs;

/* Starting rule */
archetype_definition                :archetype 
                                    |specialised_archetype
                                    |template
                                    |template_overlay
                                    |operational_template
                                    |transitional_archetype
                                    |transitional_specialised_archetype;

archetype                           :SYM_ARCHETYPE arch_meta_data archetype_id arch_language arch_description arch_definition arch_rules arch_terminology arch_annotations;
            
specialised_archetype               :SYM_ARCHETYPE arch_meta_data archetype_id arch_specialisation arch_language arch_description arch_definition arch_rules arch_terminology arch_annotations;
                        
template                            :SYM_TEMPLATE arch_meta_data archetype_id arch_specialisation arch_language arch_description arch_definition arch_rules arch_terminology arch_annotations;
            
template_overlay                    :SYM_TEMPLATE_OVERLAY arch_meta_data archetype_id arch_specialisation arch_language arch_definition arch_terminology;
                    
operational_template                :SYM_OPERATIONAL_TEMPLATE arch_meta_data archetype_id arch_language arch_description arch_definition arch_rules arch_terminology arch_annotations;
                        
transitional_archetype              :SYM_ARCHETYPE arch_meta_data archetype_id arch_concept arch_language arch_description arch_definition arch_rules arch_terminology arch_annotations;
                            
transitional_specialised_archetype  :SYM_ARCHETYPE arch_meta_data archetype_id arch_specialisation arch_concept arch_language arch_description arch_definition arch_rules arch_terminology arch_annotations;
                                       
arch_concept                        :SYM_CONCEPT v_concept_code | SYM_CONCEPT;

arch_meta_data                      :|(SYM_START_PBLOCK arch_meta_data_items SYM_END_PBLOCK);

arch_meta_data_items                :arch_meta_data_item (SYM_SEMI_COLON arch_meta_data_item)*;

arch_meta_data_item                 :(SYM_ADL_VERSION SYM_EQ v_dotted_numeric) 
                                    |(SYM_UID SYM_EQ v_dotted_numeric)
                                    |(SYM_UID SYM_EQ V_VALUE)
                                    |SYM_IS_CONTROLLED
                                    |SYM_IS_GENERATED
                                    |(v_identifier SYM_EQ v_identifier)
                                    |(v_identifier SYM_EQ V_VALUE)
                                    |v_identifier
                                    |V_VALUE;

arch_specialisation                 :SYM_SPECIALIZE v_archetype_id;

arch_language                       :SYM_LANGUAGE v_odin_text;

arch_description                    :SYM_DESCRIPTION v_odin_text;

arch_definition                     :SYM_DEFINITION v_cadl_text;

arch_rules                          :|(SYM_RULES v_rules_text);
arch_terminology                    :SYM_TERMINOLOGY v_odin_text;
arch_annotations                    :|(SYM_ANNOTATIONS v_odin_text);
arch_component_terminologies        :SYM_COMPONENT_TERMINOLOGIES v_odin_text;

archetype_id                        :v_archetype_id;

//NOTE: Skipping whitespace is left as a rule in each file in case whitespace
//gets to be treated differently depending on file type.
WS:[\t\r\n ]+ -> skip;