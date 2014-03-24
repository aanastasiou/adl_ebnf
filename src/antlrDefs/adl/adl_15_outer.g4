/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 * Athanasios Anastasiou, Work in progress in defining ADL in antlr
 */
grammar adl_15_outer;

import adl_commonSymbols, adl_15_symbols, adl_15_valuedefs;

/* Starting rule */
archetype_definition                :archetype | specialised_archetype | template | 
                                    template_overlay | operational_template | 
                                    transitional_archetype | 
                                    transitional_specialised_archetype;

archetype                           :SYM_ARCHETYPE arch_meta_data archetype_id arch_language arch_description arch_definition arch_rules arch_terminology arch_annotations;
            
specialised_archetype               :SYM_ARCHETYPE arch_meta_data archetype_id arch_specialisation arch_language arch_description arch_definition arch_rules arch_terminology arch_annotations;
                        
template                            :SYM_TEMPLATE arch_meta_data archetype_id arch_specialisation arch_language arch_description arch_definition arch_rules arch_terminology arch_annotations;
            
template_overlay                    :SYM_TEMPLATE_OVERLAY arch_meta_data archetype_id arch_specialisation arch_language arch_definition arch_terminology;
                    
operational_template                :SYM_OPERATIONAL_TEMPLATE arch_meta_data archetype_id arch_language arch_description arch_definition arch_rules arch_terminology arch_annotations;
                        
transitional_archetype              :SYM_ARCHETYPE arch_meta_data archetype_id arch_concept arch_language arch_description arch_definition arch_rules arch_terminology arch_annotations;
                            
transitional_specialised_archetype  :SYM_ARCHETYPE arch_meta_data archetype_id arch_specialisation arch_concept arch_language arch_description arch_definition arch_rules arch_terminology arch_annotations;
                                       
arch_concept                        :SYM_CONCEPT V_CONCEPT_CODE | SYM_CONCEPT;

arch_meta_data                      :|arch_meta_data_items;

arch_meta_data_items                :arch_meta_data_item (SYM_SEMI_COLON arch_meta_data_item)*;

arch_meta_data_item                 :(SYM_ADL_VERSION SYM_EQ V_DOTTED_NUMERIC) |
                                     (SYM_UID SYM_EQ V_DOTTED_NUMERIC) | 
                                     (SYM_UID SYM_EQ V_VALUE) |
                                     SYM_IS_CONTROLLED |
                                     SYM_IS_GENERATED |
                                     (V_IDENTIFIER SYM_EQ V_IDENTIFIER) |
                                     (V_IDENTIFIER SYM_EQ V_VALUE) |
                                     V_IDENTIFIER |
                                     V_VALUE;

arch_specialisation                 :SYM_SPECIALIZE V_ARCHETYPE_ID;

arch_language                       :SYM_LANGUAGE V_ODIN_TEXT;

arch_description                    :SYM_DESCRIPTION V_ODIN_TEXT;

arch_definition                     :SYM_DEFINITION V_CADL_TEXT;

arch_rules                          :|(SYM_RULES V_RULES_TEXT);
arch_terminology                    :SYM_TERMINOLOGY V_ODIN_TEXT;
arch_annotations                    :|(SYM_ANNOTATIONS V_ODIN_TEXT);
arch_component_terminologies        :SYM_COMPONENT_TERMINOLOGIES V_ODIN_TEXT;

archetype_id                        :V_ARCHETYPE_ID;