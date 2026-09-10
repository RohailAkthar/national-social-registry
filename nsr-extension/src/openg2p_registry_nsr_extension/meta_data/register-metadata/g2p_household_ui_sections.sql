-- GramStack Clean UI Sections for Household Register & Intake Form
-- Configures:
-- 1. Tab 1: Household Information (Location, Headship & Composition, Housing & Dwelling Services)
-- 2. Tab 2: Family Members Roster (Household Members table)
-- 3. Tab 3: Food & Civil Supplies (PDS) (PDS Ration Card table)
-- Also seeds Simon Mangat (HH-BR-0000003) sample household with members and PDS entitlement.

BEGIN;

-- 1. Ensure UI tabs for Household Register
DELETE FROM g2p_register_ui_tab_sections WHERE register_id = 'a0000000-0000-4000-8000-000000000002';
DELETE FROM g2p_register_ui_tabs WHERE register_id = 'a0000000-0000-4000-8000-000000000002';

INSERT INTO g2p_register_ui_tabs (tab_id, register_id, tab_label, tab_order, is_active) VALUES
('household_info_tab', 'a0000000-0000-4000-8000-000000000002', 'Household Information', 1, true),
('household_membership_tab', 'a0000000-0000-4000-8000-000000000002', 'Family Members Roster', 2, true),
('household_pds_tab', 'a0000000-0000-4000-8000-000000000002', 'Food & Civil Supplies (PDS)', 3, true)
ON CONFLICT (tab_id) DO UPDATE SET
    tab_label = EXCLUDED.tab_label,
    tab_order = EXCLUDED.tab_order,
    is_active = EXCLUDED.is_active;

-- 2. Upsert Register Sections
-- 2a. Location Details (Bihar)
DELETE FROM g2p_register_sections WHERE section_id = 'hh_location_details';
INSERT INTO g2p_register_sections (
    section_id, register_id, section_register_id, is_core_section, section_mnemonic,
    documents_required, no_of_verifications_required, is_list, section_weightage,
    cr_auto_approve_for_bene_portal, cr_auto_approve_for_agent_portal,
    cr_auto_approve_for_staff_portal, cr_auto_approve_for_partner, section_ui_schema
) VALUES (
    'hh_location_details', 'a0000000-0000-4000-8000-000000000002', 'a0000000-0000-4000-8000-000000000002',
    false, 'household_location_details', false, 0, false, 10, false, false, false, false,
    '{
        "panels": [
            {
                "panels": [
                    {
                        "widgets": [
                            {"widget": "text", "widget-id": "state", "widget-type": "input", "widget-label": "State", "widget-readonly": true, "widget-data-path": "a0000000-0000-4000-8000-000000000002.region_code"},
                            {"widget": "text", "widget-id": "district", "widget-type": "input", "widget-label": "District", "widget-data-path": "a0000000-0000-4000-8000-000000000002.zone_subcity_code"},
                            {"widget": "text", "widget-id": "block", "widget-type": "input", "widget-label": "Block / Anchal", "widget-data-path": "a0000000-0000-4000-8000-000000000002.woreda_code"}
                        ],
                        "panel-id": "panel_loc_col1",
                        "panel-orientation": "vertical"
                    },
                    {
                        "widgets": [
                            {"widget": "text", "widget-id": "gp", "widget-type": "input", "widget-label": "Gram Panchayat", "widget-data-path": "a0000000-0000-4000-8000-000000000002.locality_ea_code"},
                            {"widget": "text", "widget-id": "mauza", "widget-type": "input", "widget-label": "Village / Mauza", "widget-data-path": "a0000000-0000-4000-8000-000000000002.kebele_code"},
                            {"widget": "textarea", "widget-id": "address_descriptor", "widget-type": "input", "widget-label": "Full Address", "widget-data-path": "a0000000-0000-4000-8000-000000000002.address_descriptor"}
                        ],
                        "panel-id": "panel_loc_col2",
                        "panel-orientation": "vertical"
                    }
                ],
                "panel-id": "panel_location_details_main",
                "panel-orientation": "horizontal"
            }
        ],
        "section-id": "household_location_details",
        "section-title": "Location Details (Bihar)",
        "section-editable": true
    }'::jsonb
);

-- 2b. Household Headship & Composition
DELETE FROM g2p_register_sections WHERE section_id = 'hh_composition_headship';
INSERT INTO g2p_register_sections (
    section_id, register_id, section_register_id, is_core_section, section_mnemonic,
    documents_required, no_of_verifications_required, is_list, section_weightage,
    cr_auto_approve_for_bene_portal, cr_auto_approve_for_agent_portal,
    cr_auto_approve_for_staff_portal, cr_auto_approve_for_partner, section_ui_schema
) VALUES (
    'hh_composition_headship', 'a0000000-0000-4000-8000-000000000002', 'a0000000-0000-4000-8000-000000000002',
    false, 'hh_composition_headship', false, 0, false, 10, false, false, false, false,
    '{
        "panels": [
            {
                "panels": [
                    {
                        "widgets": [
                            {"widget": "text", "widget-id": "household_head_person_id", "widget-type": "input", "widget-label": "Household Head Aadhaar ID", "widget-readonly": false, "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000002.household_head_person_id"},
                            {"widget": "text", "widget-id": "household_head_name", "widget-type": "input", "widget-label": "Head of Household Name", "widget-readonly": false, "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000002.household_head_name"},
                            {"widget": "select", "widget-id": "headship_type", "widget-type": "input", "widget-label": "Headship Type", "widget-readonly": false, "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000002.headship_type", "widget-data-source": {"type": "static", "options": [{"label": "Male Headed", "value": "MALE_HEADED"}, {"label": "Female Headed", "value": "FEMALE_HEADED"}, {"label": "Child Headed", "value": "CHILD_HEADED"}, {"label": "Elderly Headed", "value": "ELDERLY_HEADED"}, {"label": "Disabled Headed", "value": "DISABLED_HEADED"}]}},
                            {"widget": "number", "widget-id": "size_total", "widget-type": "input", "widget-label": "Total Family Members", "widget-readonly": false, "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000002.size_total"}
                        ],
                        "panel-id": "panel_headship_col1",
                        "panel-orientation": "vertical"
                    },
                    {
                        "widgets": [
                            {"widget": "number", "widget-id": "size_adults", "widget-type": "input", "widget-label": "Adults Count (18+)", "widget-readonly": false, "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000002.size_adults"},
                            {"widget": "number", "widget-id": "size_children_u5", "widget-type": "input", "widget-label": "Children Under 5", "widget-readonly": false, "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000002.size_children_u5"},
                            {"widget": "number", "widget-id": "size_school_age", "widget-type": "input", "widget-label": "School-Age Children (5-17)", "widget-readonly": false, "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000002.size_school_age"},
                            {"widget": "number", "widget-id": "size_elderly", "widget-type": "input", "widget-label": "Elderly Members (60+)", "widget-readonly": false, "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000002.size_elderly"}
                        ],
                        "panel-id": "panel_headship_col2",
                        "panel-orientation": "vertical"
                    },
                    {
                        "widgets": [
                            {"widget": "number", "widget-id": "number_of_female_members", "widget-type": "input", "widget-label": "Female Members", "widget-readonly": false, "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000002.number_of_female_members"},
                            {"widget": "number", "widget-id": "number_of_male_members", "widget-type": "input", "widget-label": "Male Members", "widget-readonly": false, "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000002.number_of_male_members"},
                            {"widget": "boolean", "widget-id": "elderly_member_present", "widget-type": "input", "widget-label": "Elderly Member Present", "widget-readonly": false, "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000002.elderly_member_present"}
                        ],
                        "panel-id": "panel_headship_col3",
                        "panel-orientation": "vertical"
                    }
                ],
                "panel-id": "panel_headship_main",
                "panel-orientation": "horizontal"
            }
        ],
        "section-id": "hh_composition_headship",
        "section-title": "Household Headship & Composition",
        "section-editable": true,
        "section-supporting-documents": []
    }'::jsonb
);

-- 2c. Housing & Dwelling Services
DELETE FROM g2p_register_sections WHERE section_id = 'hh_dwelling_services';
INSERT INTO g2p_register_sections (
    section_id, register_id, section_register_id, is_core_section, section_mnemonic,
    documents_required, no_of_verifications_required, is_list, section_weightage,
    cr_auto_approve_for_bene_portal, cr_auto_approve_for_agent_portal,
    cr_auto_approve_for_staff_portal, cr_auto_approve_for_partner, section_ui_schema
) VALUES (
    'hh_dwelling_services', 'a0000000-0000-4000-8000-000000000002', 'a0000000-0000-4000-8000-000000000002',
    false, 'dwelling_and_services', false, 0, false, 10, false, false, false, false,
    '{
        "panels": [
            {
                "panels": [
                    {
                        "widgets": [
                            {"widget": "select", "widget-id": "dwelling_type", "widget-type": "input", "widget-label": "Dwelling Type", "widget-data-path": "a0000000-0000-4000-8000-000000000002.dwelling_type", "widget-data-source": {"type": "static", "options": [{"label": "Permanent", "value": "PERMANENT"}, {"label": "Semi-Permanent", "value": "SEMI"}, {"label": "Temporary", "value": "TEMPORARY"}]}}
                        ],
                        "panel-id": "panel_dwelling_col1",
                        "panel-orientation": "vertical"
                    },
                    {
                        "widgets": [
                            {"widget": "select", "widget-id": "tenure_status", "widget-type": "input", "widget-label": "Tenure Status", "widget-data-path": "a0000000-0000-4000-8000-000000000002.tenure_status", "widget-data-source": {"type": "static", "options": [{"label": "Owned", "value": "OWNED"}, {"label": "Rented", "value": "RENTED"}]}}
                        ],
                        "panel-id": "panel_dwelling_col2",
                        "panel-orientation": "vertical"
                    }
                ],
                "panel-id": "panel_dwelling_main",
                "panel-orientation": "horizontal"
            }
        ],
        "section-id": "hh_dwelling_services",
        "section-title": "Housing & Dwelling Services",
        "section-editable": true
    }'::jsonb
);

-- 2d. Household Members (Roster Table)
DELETE FROM g2p_register_sections WHERE section_id = 'hh_members';
INSERT INTO g2p_register_sections (
    section_id, register_id, section_register_id, is_core_section, section_mnemonic,
    documents_required, no_of_verifications_required, is_list, section_weightage,
    cr_auto_approve_for_bene_portal, cr_auto_approve_for_agent_portal,
    cr_auto_approve_for_staff_portal, cr_auto_approve_for_partner, section_ui_schema
) VALUES (
    'hh_members', 'a0000000-0000-4000-8000-000000000002', 'a0000000-0000-4000-8000-000000000001',
    false, 'household_members', false, 0, true, 0, false, false, false, false,
    '{
        "panels": [
            {
                "widgets": [
                    {
                        "widget": "table",
                        "widget-id": "members_table",
                        "widget-label": "Household Members (Roster)",
                        "widget-readonly": false,
                        "widget-data-path": "a0000000-0000-4000-8000-000000000001.records",
                        "widget-data-columns": [
                            {"widget": "text", "column-key": "foundational_id", "widget-label": "Aadhaar Number", "widget-required": false, "widget-data-path": "foundational_id"},
                            {"widget": "text", "column-key": "first_name", "widget-label": "First Name", "widget-required": true, "widget-data-path": "first_name"},
                            {"widget": "text", "column-key": "last_name", "widget-label": "Last Name", "widget-required": true, "widget-data-path": "last_name"},
                            {"widget": "text", "column-key": "relationship_to_head", "widget-label": "Relationship", "widget-required": false, "widget-data-path": "relationship_to_head"},
                            {"widget": "date", "column-key": "birth_date", "widget-label": "Birth Date", "widget-required": true, "widget-data-path": "birth_date"},
                            {"widget": "select", "column-key": "gender", "widget-label": "Gender", "widget-required": true, "widget-data-path": "gender", "widget-data-source": {"type": "static", "options": [{"label": "MALE", "value": "MALE"}, {"label": "FEMALE", "value": "FEMALE"}, {"label": "OTHER", "value": "OTHER"}]}}
                        ],
                        "widget-data-add-label": "Add Member",
                        "widget-data-operations": {"add": true, "edit": true, "remove": true}
                    }
                ],
                "panel-id": "panel_household_members",
                "panel-column-span": 12,
                "panel-orientation": "vertical"
            }
        ],
        "section-id": "hh_members",
        "section-title": "Household Members",
        "section-editable": true
    }'::jsonb
);

-- 2e. PDS Food Security (Ration Card Table)
DELETE FROM g2p_register_sections WHERE section_id = 'hh_table_pds';
INSERT INTO g2p_register_sections (
    section_id, register_id, section_register_id, is_core_section, section_mnemonic,
    documents_required, no_of_verifications_required, is_list, section_weightage,
    cr_auto_approve_for_bene_portal, cr_auto_approve_for_agent_portal,
    cr_auto_approve_for_staff_portal, cr_auto_approve_for_partner, section_ui_schema
) VALUES (
    'hh_table_pds', 'a0000000-0000-4000-8000-000000000002', 'b0000000-0000-4000-8000-000000000095',
    false, 'hh_table_pds', false, 0, true, 0, false, false, false, false,
    '{
        "panels": [
            {
                "panels": [
                    {
                        "widgets": [
                            {
                                "widget": "table",
                                "widget-id": "pds_programs_table",
                                "widget-type": "table",
                                "widget-label": "PDS Food Security (Ration Card)",
                                "widget-readonly": false,
                                "widget-data-path": "b0000000-0000-4000-8000-000000000095.records",
                                "widget-data-columns": [
                                    {"widget": "text", "column-key": "ration_card_number", "widget-type": "input", "widget-label": "Ration Card Number", "widget-data-path": "ration_card_number"},
                                    {"widget": "text", "column-key": "ration_card_type", "widget-type": "input", "widget-label": "Ration Card Type", "widget-data-path": "ration_card_type"},
                                    {"widget": "text", "column-key": "head_of_household_name", "widget-type": "input", "widget-label": "Head of Household Name", "widget-data-path": "head_of_household_name"},
                                    {"widget": "number", "column-key": "family_member_count", "widget-type": "input", "widget-label": "Family Member Count", "widget-data-path": "family_member_count"},
                                    {"widget": "text", "column-key": "fps_shop_code", "widget-type": "input", "widget-label": "FPS Shop Code", "widget-data-path": "fps_shop_code"},
                                    {"widget": "text", "column-key": "dealer_name", "widget-type": "input", "widget-label": "Dealer Name", "widget-data-path": "dealer_name"},
                                    {"widget": "text", "column-key": "e_kyc_status", "widget-type": "input", "widget-label": "e-KYC Status", "widget-data-path": "e_kyc_status"},
                                    {"widget": "text", "column-key": "last_transaction_date", "widget-type": "input", "widget-label": "Last Transaction Date", "widget-data-path": "last_transaction_date"},
                                    {"widget": "number", "column-key": "monthly_entitlement_kg", "widget-type": "input", "widget-label": "Monthly Entitlement (kg)", "widget-data-path": "monthly_entitlement_kg"},
                                    {"widget": "text", "column-key": "district", "widget-type": "input", "widget-label": "District", "widget-data-path": "district"},
                                    {"widget": "text", "column-key": "block", "widget-type": "input", "widget-label": "Block", "widget-data-path": "block"}
                                ],
                                "widget-data-add-label": "Add Ration Card",
                                "widget-data-operations": {"add": true, "edit": true, "remove": true}
                            }
                        ],
                        "panel-id": "vertical_panel_pds",
                        "panel-column-span": 3,
                        "panel-orientation": "vertical"
                    }
                ],
                "panel-id": "horizontal_panel_pds",
                "panel-orientation": "horizontal"
            }
        ],
        "section-id": "hh_table_pds",
        "section-title": "PDS Food Security (Ration Card)",
        "section-editable": true
    }'::jsonb
);

-- 3. Link Sections to Register Tabs in g2p_register_ui_tab_sections
INSERT INTO g2p_register_ui_tab_sections (tab_section_id, register_id, tab_id, section_id, section_order) VALUES
('b2000000-0000-4000-8000-000000000001', 'a0000000-0000-4000-8000-000000000002', 'household_info_tab', 'hh_header_info', 10),
('b2000000-0000-4000-8000-000000000002', 'a0000000-0000-4000-8000-000000000002', 'household_info_tab', 'hh_location_details', 20),
('b2000000-0000-4000-8000-000000000003', 'a0000000-0000-4000-8000-000000000002', 'household_info_tab', 'hh_composition_headship', 30),
('b2000000-0000-4000-8000-000000000004', 'a0000000-0000-4000-8000-000000000002', 'household_info_tab', 'hh_dwelling_services', 40),
('b2000000-0000-4000-8000-000000000005', 'a0000000-0000-4000-8000-000000000002', 'household_membership_tab', 'hh_members', 10),
('b2000000-0000-4000-8000-000000000006', 'a0000000-0000-4000-8000-000000000002', 'household_pds_tab', 'hh_table_pds', 10);

-- 4. Clean Intake Form for Household (only the 5 matching sections)
DELETE FROM g2p_intake_form_ui_tab_sections WHERE tab_id = 'nsr_form_tab_household_intake';
INSERT INTO g2p_intake_form_ui_tab_sections (tab_section_id, tab_id, section_id, section_order) VALUES
('07e72227-de88-4aab-a5d3-1fb515c0e696', 'nsr_form_tab_household_intake', 'hh_composition_headship', 1),
('6fb0fdf0-476f-4640-a297-20ecf395b093', 'nsr_form_tab_household_intake', 'hh_location_details', 2),
('6a887079-4cbb-4fde-9d0f-9df578569bd4', 'nsr_form_tab_household_intake', 'hh_table_pds', 3),
('4d197087-c86c-489d-b7ce-18287892ac86', 'nsr_form_tab_household_intake', 'hh_members', 4),
('bb939dca-a7be-409e-b8e3-9ee05abf3905', 'nsr_form_tab_household_intake', 'hh_dwelling_services', 5);

-- 5. Seed Simon Mangat (HH-BR-0000003) Sample Household & Members
INSERT INTO g2p_register_households (
    internal_record_id, functional_record_id, record_name,
    created_by, created_at, last_approved_at, last_approved_by,
    record_status, household_head_name, household_head_person_id,
    headship_type, size_total, size_adults, size_children_u5,
    size_school_age, size_elderly, number_of_male_members,
    number_of_female_members, elderly_member_present,
    dwelling_type, tenure_status, region_code,
    zone_subcity_code, woreda_code, locality_ea_code,
    address_line_1, address_descriptor, search_text
) VALUES (
    '423b19c8-9d0a-40d3-95bd-d00357b87f70', 'HH-BR-0000003', 'Household of Simon Mangat',
    'Staff BPM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Staff BPM',
    'ACTIVE', 'Simon Mangat', '036544241352',
    'MALE_HEADED', 6, 3, 0,
    3, 1, 3,
    3, true,
    'PERMANENT', 'OWNED', 'Bihar',
    'Nalanda', 'Rajgir', 'Rajgir',
    'Rajgir, Nalanda, Bihar', 'Ration Card #10-645-516-978688, Aggarwal Store (FPS-4534), Rajgir, Nalanda',
    'Simon Mangat 036544241352 10-645-516-978688 Nalanda Rajgir HH-BR-0000003 Aggarwal Store'
) ON CONFLICT (internal_record_id) DO UPDATE SET
    functional_record_id = EXCLUDED.functional_record_id,
    record_name = EXCLUDED.record_name,
    household_head_name = EXCLUDED.household_head_name,
    household_head_person_id = EXCLUDED.household_head_person_id,
    headship_type = EXCLUDED.headship_type,
    size_total = EXCLUDED.size_total,
    size_adults = EXCLUDED.size_adults,
    size_children_u5 = EXCLUDED.size_children_u5,
    size_school_age = EXCLUDED.size_school_age,
    size_elderly = EXCLUDED.size_elderly,
    number_of_male_members = EXCLUDED.number_of_male_members,
    number_of_female_members = EXCLUDED.number_of_female_members,
    elderly_member_present = EXCLUDED.elderly_member_present,
    dwelling_type = EXCLUDED.dwelling_type,
    tenure_status = EXCLUDED.tenure_status,
    region_code = EXCLUDED.region_code,
    zone_subcity_code = EXCLUDED.zone_subcity_code,
    woreda_code = EXCLUDED.woreda_code,
    locality_ea_code = EXCLUDED.locality_ea_code,
    address_line_1 = EXCLUDED.address_line_1,
    address_descriptor = EXCLUDED.address_descriptor,
    search_text = EXCLUDED.search_text;

-- PDS Entitlement Record for Simon Mangat
INSERT INTO g2p_register_household_pds (
    internal_record_id, functional_record_id, link_internal_record_id,
    record_name, created_by, created_at, last_approved_at, last_approved_by,
    record_status, ration_card_number, ration_card_type,
    head_of_household_name, family_member_count, fps_shop_code,
    dealer_name, e_kyc_status, last_transaction_date,
    monthly_entitlement_kg, district, block, search_text
) VALUES (
    '407fd625-d4c8-46c1-83b1-d7fd7ce4abe4', 'PDS-10645516978688', '423b19c8-9d0a-40d3-95bd-d00357b87f70',
    'Ration Card (10-645-516-978688)', 'Staff BPM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Staff BPM',
    'ACTIVE', '10-645-516-978688', 'State',
    'Simon Mangat', 6, 'FPS-4534',
    'Aggarwal Store', 'Pending', '2026-02-02',
    30.00, 'Nalanda', 'Rajgir',
    '10-645-516-978688 Simon Mangat Aggarwal Store FPS-4534 Nalanda'
) ON CONFLICT (internal_record_id) DO UPDATE SET
    link_internal_record_id = EXCLUDED.link_internal_record_id,
    ration_card_number = EXCLUDED.ration_card_number,
    ration_card_type = EXCLUDED.ration_card_type,
    head_of_household_name = EXCLUDED.head_of_household_name,
    family_member_count = EXCLUDED.family_member_count,
    fps_shop_code = EXCLUDED.fps_shop_code,
    dealer_name = EXCLUDED.dealer_name,
    e_kyc_status = EXCLUDED.e_kyc_status,
    last_transaction_date = EXCLUDED.last_transaction_date,
    monthly_entitlement_kg = EXCLUDED.monthly_entitlement_kg,
    district = EXCLUDED.district,
    block = EXCLUDED.block;

-- 6 Household Members (Roster)
INSERT INTO g2p_register_individuals (
    internal_record_id, functional_record_id, link_internal_record_id,
    record_name, foundational_id, first_name, last_name, full_name,
    gender, birth_date, relationship_to_head,
    created_by, created_at, last_approved_at, last_approved_by,
    record_status, search_text
) VALUES
('0e0aace1-71ae-4bc9-b3bf-ecc642d809bb', 'IND-PDS-10645516978688-01', '423b19c8-9d0a-40d3-95bd-d00357b87f70', 'Simon Mangat', '036544241352', 'Simon', 'Mangat', 'Simon Mangat', 'MALE', '1992-05-08', 'Head', 'Staff BPM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Staff BPM', 'ACTIVE', 'Simon Mangat 036544241352'),
('bd519644-c4fa-44ff-8aab-53faab45283e', 'IND-PDS-10645516978688-02', '423b19c8-9d0a-40d3-95bd-d00357b87f70', 'Gautami Mangat', '574653232237', 'Gautami', 'Mangat', 'Gautami Mangat', 'FEMALE', '1953-03-18', 'Mother', 'Staff BPM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Staff BPM', 'ACTIVE', 'Gautami Mangat 574653232237'),
('cfc98bbf-6ce3-4b66-b45c-30df94ca0ae7', 'IND-PDS-10645516978688-03', '423b19c8-9d0a-40d3-95bd-d00357b87f70', 'Alka Bera', '663813307571', 'Alka', 'Bera', 'Alka Bera', 'FEMALE', '1988-04-18', 'Spouse', 'Staff BPM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Staff BPM', 'ACTIVE', 'Alka Bera 663813307571'),
('4b1b777c-4089-474c-b61a-4218a9b5f46f', 'IND-PDS-10645516978688-04', '423b19c8-9d0a-40d3-95bd-d00357b87f70', 'Ekta Mangat', '642652962949', 'Ekta', 'Mangat', 'Ekta Mangat', 'FEMALE', '2009-07-08', 'Daughter', 'Staff BPM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Staff BPM', 'ACTIVE', 'Ekta Mangat 642652962949'),
('473d90cf-8164-499e-9482-0201e60d1e9a', 'IND-PDS-10645516978688-05', '423b19c8-9d0a-40d3-95bd-d00357b87f70', 'Zashil Mangat', '927871774904', 'Zashil', 'Mangat', 'Zashil Mangat', 'MALE', '2016-08-15', 'Son', 'Staff BPM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Staff BPM', 'ACTIVE', 'Zashil Mangat 927871774904'),
('fe8a7f8f-cb3a-4151-b4a2-be25b15a26a0', 'IND-PDS-10645516978688-06', '423b19c8-9d0a-40d3-95bd-d00357b87f70', 'Krishna Mangat', '343169011866', 'Krishna', 'Mangat', 'Krishna Mangat', 'MALE', '2019-12-30', 'Son', 'Staff BPM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Staff BPM', 'ACTIVE', 'Krishna Mangat 343169011866')
ON CONFLICT (internal_record_id) DO UPDATE SET
    link_internal_record_id = EXCLUDED.link_internal_record_id,
    foundational_id = EXCLUDED.foundational_id,
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    full_name = EXCLUDED.full_name,
    gender = EXCLUDED.gender,
    birth_date = EXCLUDED.birth_date,
    relationship_to_head = EXCLUDED.relationship_to_head;

COMMIT;
