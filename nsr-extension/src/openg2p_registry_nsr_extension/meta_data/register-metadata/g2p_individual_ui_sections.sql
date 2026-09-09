-- GramStack Clean UI Sections for Individual Register & Intake Form (PDS-Only)
BEGIN;

-- 1. Delete previous mapping for individual intake tab
DELETE FROM g2p_intake_form_ui_tab_sections WHERE tab_id = 'nsr_form_tab_individual_intake';

-- 2. Clean up individual_info_tab in register (keep in_header_info)
DELETE FROM g2p_register_ui_tab_sections WHERE tab_id = 'individual_info_tab' AND section_id != 'in_header_info';

-- 3. Delete non-PDS sections from g2p_register_sections
DELETE FROM g2p_register_sections WHERE section_id IN ('in_section_shg', 'in_section_biharbhumi', 'in_section_agristack', 'in_section_pds', 'in_section_pension', 'in_section_student');

-- 4. Upsert clean in_section_demographics with only collected PDS fields
DELETE FROM g2p_register_sections WHERE section_id = 'in_section_demographics';
INSERT INTO g2p_register_sections (
    section_id, 
    register_id, 
    section_register_id, 
    is_core_section, 
    section_mnemonic, 
    documents_required, 
    no_of_verifications_required, 
    is_list, 
    section_weightage, 
    cr_auto_approve_for_bene_portal, 
    cr_auto_approve_for_agent_portal, 
    cr_auto_approve_for_staff_portal, 
    cr_auto_approve_for_partner, 
    section_ui_schema
) VALUES (
    'in_section_demographics', 
    'a0000000-0000-4000-8000-000000000001', 
    'a0000000-0000-4000-8000-000000000001', 
    false, 
    'in_section_demographics', 
    false, 
    0, 
    false, 
    10, 
    false, 
    false, 
    false, 
    false, 
    '{
      "panels": [
        {
          "panels": [
            {
              "widgets": [
                {
                  "widget": "text",
                  "widget-id": "first_name",
                  "widget-type": "input",
                  "widget-label": "First Name",
                  "widget-readonly": false,
                  "widget-required": true,
                  "widget-data-path": "a0000000-0000-4000-8000-000000000001.first_name"
                },
                {
                  "widget": "text",
                  "widget-id": "last_name",
                  "widget-type": "input",
                  "widget-label": "Last Name",
                  "widget-readonly": false,
                  "widget-required": true,
                  "widget-data-path": "a0000000-0000-4000-8000-000000000001.last_name"
                },
                {
                  "widget": "select",
                  "widget-id": "gender",
                  "widget-type": "input",
                  "widget-label": "Gender",
                  "widget-readonly": false,
                  "widget-required": true,
                  "widget-data-path": "a0000000-0000-4000-8000-000000000001.gender",
                  "widget-data-source": {
                    "type": "static",
                    "options": [
                      {"label": "MALE", "value": "MALE"},
                      {"label": "FEMALE", "value": "FEMALE"},
                      {"label": "OTHER", "value": "OTHER"},
                      {"label": "UNKNOWN", "value": "UNKNOWN"}
                    ]
                  }
                }
              ],
              "panel-id": "panel_in_section_demographics_col1",
              "panel-orientation": "vertical"
            },
            {
              "widgets": [
                {
                  "widget": "date",
                  "widget-id": "birth_date",
                  "widget-type": "input",
                  "widget-label": "Date of Birth",
                  "widget-readonly": false,
                  "widget-required": true,
                  "widget-data-path": "a0000000-0000-4000-8000-000000000001.birth_date"
                },
                {
                  "widget": "text",
                  "widget-id": "foundational_id",
                  "widget-type": "input",
                  "widget-label": "Aadhaar Number",
                  "widget-readonly": false,
                  "widget-required": false,
                  "widget-data-path": "a0000000-0000-4000-8000-000000000001.foundational_id"
                },
                {
                  "widget": "select",
                  "widget-id": "relationship_to_head",
                  "widget-type": "input",
                  "widget-label": "Relationship to Head",
                  "widget-readonly": false,
                  "widget-required": true,
                  "widget-data-path": "a0000000-0000-4000-8000-000000000001.relationship_to_head",
                  "widget-data-source": {
                    "type": "static",
                    "options": [
                      {"label": "Self / Head", "value": "SELF"},
                      {"label": "Spouse", "value": "SPOUSE"},
                      {"label": "Child (Son / Daughter)", "value": "CHILD"},
                      {"label": "Parent", "value": "PARENT"},
                      {"label": "Sibling", "value": "SIBLING"},
                      {"label": "Other Relative", "value": "OTHER_RELATIVE"},
                      {"label": "Non Relative", "value": "NON_RELATIVE"}
                    ]
                  }
                }
              ],
              "panel-id": "panel_in_section_demographics_col2",
              "panel-orientation": "vertical"
            }
          ],
          "panel-id": "panel_in_section_demographics_main",
          "panel-orientation": "horizontal"
        }
      ],
      "section-id": "in_section_demographics",
      "section-title": "Citizen Demographics & Identity",
      "section-editable": true,
      "section-supporting-documents": []
    }'::jsonb
);

-- 5. Map clean section in g2p_intake_form_ui_tab_sections
INSERT INTO g2p_intake_form_ui_tab_sections (tab_section_id, tab_id, section_id, section_order) 
VALUES ('f5b799ea-bc2c-56be-8c08-f2231d8565be', 'nsr_form_tab_individual_intake', 'in_section_demographics', 1);

-- 6. Map clean section in g2p_register_ui_tab_sections for individual_info_tab
INSERT INTO g2p_register_ui_tab_sections (tab_section_id, register_id, tab_id, section_id, section_order) 
VALUES ('b1000000-0000-4000-8000-000000000001', 'a0000000-0000-4000-8000-000000000001', 'individual_info_tab', 'in_section_demographics', 20);

-- 7. Remove unused tabs (Livelihood, Vulnerability, Programs)
DELETE FROM g2p_register_ui_tab_sections 
WHERE tab_id IN ('individual_livelihood_tab', 'individual_vulnerability_tab', 'individual_programs_tab');

DELETE FROM g2p_register_ui_tabs 
WHERE tab_id IN ('individual_livelihood_tab', 'individual_vulnerability_tab', 'individual_programs_tab');

-- 8. Clean up individual Household tab (keep only household lookup)
DELETE FROM g2p_register_ui_tab_sections 
WHERE tab_id = '7bf586e3-ba57-45d0-9093-1747f038da16' 
  AND section_id != 'd1e81461-ee90-483f-8cf2-19028657bca1';

COMMIT;