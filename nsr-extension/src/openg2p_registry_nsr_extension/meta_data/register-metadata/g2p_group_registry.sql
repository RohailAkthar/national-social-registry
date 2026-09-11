-- ============================================================================
-- GramStack - JEEViKA Registry Platform
-- Pure Standalone Group Registry (Master & Child Tables, Schemas, AWE Workflow)
-- Register ID: a0000000-0000-4000-8000-000000000005
-- ============================================================================

-- ============================================================================
-- 1. Create Core Tables for Group Master Register
-- ============================================================================

CREATE TABLE IF NOT EXISTS g2p_register_groups (
    internal_record_id VARCHAR PRIMARY KEY,
    functional_record_id VARCHAR,
    record_name VARCHAR,
    record_status VARCHAR NOT NULL DEFAULT 'ACTIVE',
    record_status_reason VARCHAR,
    link_internal_record_id VARCHAR,
    link_foundational_id VARCHAR,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR NOT NULL DEFAULT 'system',
    approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    approved_by VARCHAR NOT NULL DEFAULT 'system',
    last_approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_approved_by VARCHAR NOT NULL DEFAULT 'system',
    search_text TEXT,
    application_reference VARCHAR,
    record_image_storage_id TEXT,
    record_image_document_id TEXT,

    -- Group Identification & Hierarchy
    group_name VARCHAR,
    group_type VARCHAR DEFAULT 'SHG',
    shg_id VARCHAR,
    shg_code VARCHAR,
    lokos_id VARCHAR,
    vo_id VARCHAR,
    vo_name VARCHAR,
    clf_id VARCHAR,
    clf_name VARCHAR,

    -- Key Representative / Office Bearer
    member_id VARCHAR,
    key_member_name VARCHAR,
    key_member_aadhaar VARCHAR,
    key_member_role VARCHAR,
    key_member_mobile VARCHAR,

    -- Banking & Financial Metrics
    bank_name VARCHAR,
    bank_account_no VARCHAR,
    ifsc_code VARCHAR,
    monthly_savings_amount NUMERIC(12, 2),
    internal_loan_outstanding NUMERIC(12, 2),
    ccl_limit NUMERIC(12, 2),
    ccl_utilised NUMERIC(12, 2),

    -- Governance & Operational Attributes
    shg_grading VARCHAR,
    formation_date DATE,
    meeting_frequency VARCHAR,

    -- Geographic & Address
    address_line_1 VARCHAR,
    address_line_2 VARCHAR,
    village VARCHAR,
    gram_panchayat VARCHAR,
    block VARCHAR,
    district VARCHAR,
    state VARCHAR DEFAULT 'Bihar',
    postal_code VARCHAR,
    pin_code VARCHAR,
    latitude VARCHAR,
    longitude VARCHAR,
    altitude VARCHAR,
    country_code VARCHAR,
    plus_code VARCHAR,
    geo_lowest_level_value_id VARCHAR,
    geo_code_hierarchy_json JSONB
);

CREATE TABLE IF NOT EXISTS g2p_register_history_groups (
    history_record_id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::text,
    internal_record_id VARCHAR NOT NULL,
    tab_id VARCHAR,
    section_id VARCHAR,
    change_request_id VARCHAR,
    submission_id VARCHAR,
    change_request_source VARCHAR,
    is_primary_section BOOLEAN DEFAULT FALSE,
    functional_record_id VARCHAR,
    record_name VARCHAR,
    record_status VARCHAR NOT NULL DEFAULT 'ACTIVE',
    record_status_reason VARCHAR,
    link_internal_record_id VARCHAR,
    link_foundational_id VARCHAR,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR NOT NULL DEFAULT 'system',
    approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    approved_by VARCHAR NOT NULL DEFAULT 'system',
    last_approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_approved_by VARCHAR NOT NULL DEFAULT 'system',
    search_text TEXT,
    application_reference VARCHAR,
    record_image_storage_id TEXT,
    record_image_document_id TEXT,

    -- Group Identification & Hierarchy
    group_name VARCHAR,
    group_type VARCHAR DEFAULT 'SHG',
    shg_id VARCHAR,
    shg_code VARCHAR,
    lokos_id VARCHAR,
    vo_id VARCHAR,
    vo_name VARCHAR,
    clf_id VARCHAR,
    clf_name VARCHAR,

    -- Key Representative / Office Bearer
    member_id VARCHAR,
    key_member_name VARCHAR,
    key_member_aadhaar VARCHAR,
    key_member_role VARCHAR,
    key_member_mobile VARCHAR,

    -- Banking & Financial Metrics
    bank_name VARCHAR,
    bank_account_no VARCHAR,
    ifsc_code VARCHAR,
    monthly_savings_amount NUMERIC(12, 2),
    internal_loan_outstanding NUMERIC(12, 2),
    ccl_limit NUMERIC(12, 2),
    ccl_utilised NUMERIC(12, 2),

    -- Governance & Operational Attributes
    shg_grading VARCHAR,
    formation_date DATE,
    meeting_frequency VARCHAR,

    -- Geographic & Address
    address_line_1 VARCHAR,
    address_line_2 VARCHAR,
    village VARCHAR,
    gram_panchayat VARCHAR,
    block VARCHAR,
    district VARCHAR,
    state VARCHAR DEFAULT 'Bihar',
    postal_code VARCHAR,
    pin_code VARCHAR,
    latitude VARCHAR,
    longitude VARCHAR,
    altitude VARCHAR,
    country_code VARCHAR,
    plus_code VARCHAR,
    geo_lowest_level_value_id VARCHAR,
    geo_code_hierarchy_json JSONB
);

CREATE TABLE IF NOT EXISTS g2p_intake_form_groups (
    submission_id UUID,
    application_reference VARCHAR,
    internal_record_id VARCHAR,
    link_internal_record_id VARCHAR,
    link_foundational_id VARCHAR,
    functional_record_id VARCHAR,
    record_name VARCHAR,
    record_image_storage_id TEXT,
    record_image_document_id TEXT,
    created_by VARCHAR NOT NULL DEFAULT 'system',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_approved_by VARCHAR NOT NULL DEFAULT 'system',
    search_text TEXT,
    record_status VARCHAR NOT NULL DEFAULT 'ACTIVE',
    record_status_reason VARCHAR,

    -- Group Identification & Hierarchy
    group_name VARCHAR,
    group_type VARCHAR DEFAULT 'SHG',
    shg_id VARCHAR,
    shg_code VARCHAR,
    lokos_id VARCHAR,
    vo_id VARCHAR,
    vo_name VARCHAR,
    clf_id VARCHAR,
    clf_name VARCHAR,

    -- Key Representative / Office Bearer
    member_id VARCHAR,
    key_member_name VARCHAR,
    key_member_aadhaar VARCHAR,
    key_member_role VARCHAR,
    key_member_mobile VARCHAR,

    -- Banking & Financial Metrics
    bank_name VARCHAR,
    bank_account_no VARCHAR,
    ifsc_code VARCHAR,
    monthly_savings_amount NUMERIC(12, 2),
    internal_loan_outstanding NUMERIC(12, 2),
    ccl_limit NUMERIC(12, 2),
    ccl_utilised NUMERIC(12, 2),

    -- Governance & Operational Attributes
    shg_grading VARCHAR,
    formation_date DATE,
    meeting_frequency VARCHAR,

    -- Geographic & Address
    address_line_1 VARCHAR,
    address_line_2 VARCHAR,
    village VARCHAR,
    gram_panchayat VARCHAR,
    block VARCHAR,
    district VARCHAR,
    state VARCHAR DEFAULT 'Bihar',
    postal_code VARCHAR,
    pin_code VARCHAR,
    latitude VARCHAR,
    longitude VARCHAR,
    altitude VARCHAR,
    country_code VARCHAR,
    plus_code VARCHAR,
    geo_lowest_level_value_id VARCHAR,
    geo_code_hierarchy_json JSONB
);

CREATE INDEX IF NOT EXISTS idx_groups_functional_record_id ON g2p_register_groups(functional_record_id);
CREATE INDEX IF NOT EXISTS idx_groups_shg_id ON g2p_register_groups(shg_id);
CREATE INDEX IF NOT EXISTS idx_groups_key_member_aadhaar ON g2p_register_groups(key_member_aadhaar);
CREATE INDEX IF NOT EXISTS idx_intake_groups_submission_id ON g2p_intake_form_groups(submission_id);

-- ============================================================================
-- 2. OpenG2P Register Metadata Definitions
-- ============================================================================

DELETE FROM g2p_register_definitions WHERE register_id = 'a0000000-0000-4000-8000-000000000005';
INSERT INTO g2p_register_definitions (
    register_id, register_mnemonic, register_subject, register_description,
    master_register_id, register_rank, functional_id_generation_required,
    register_purpose, program_id, program_mnemonic, register_icon, has_image,
    dedup_is_enabled, dedup_threshold_score, completion_score_required,
    outgest_applicable, requires_registrant_authentication,
    registrant_authentication_validity_days, registrant_re_auth_warning_days_before
) VALUES (
    'a0000000-0000-4000-8000-000000000005', 'Group', 'Groups',
    'Self-Help Groups, Village Organisations, and Community Institutions from JEEViKA LokOS',
    NULL, 5, 'TRUE', 'REGISTER', NULL, NULL, 'groups', 'FALSE', 'TRUE', 85.00, 'TRUE',
    'TRUE', 'FALSE', 730, 30
);

-- ============================================================================
-- 3. UI Section Definitions for Group Register
-- ============================================================================

DELETE FROM g2p_register_sections WHERE section_id IN ('group_basic_section', 'group_financial_section');

-- Section 1: Institution & Representative Profile
INSERT INTO g2p_register_sections (
    section_id, register_id, section_register_id, is_core_section, section_mnemonic,
    documents_required, no_of_verifications_required, is_list, section_weightage,
    cr_auto_approve_for_bene_portal, cr_auto_approve_for_agent_portal,
    cr_auto_approve_for_staff_portal, cr_auto_approve_for_partner, section_ui_schema
) VALUES (
    'group_basic_section', 'a0000000-0000-4000-8000-000000000005', 'a0000000-0000-4000-8000-000000000005',
    true, 'group_basic_section', false, 0, false, 50, false, false, false, false,
    '{
        "panels": [
            {
                "panels": [
                    {
                        "widgets": [
                            {"widget": "text", "widget-id": "group_name", "widget-type": "input", "widget-label": "Group / SHG Name", "widget-required": true, "widget-data-path": "a0000000-0000-4000-8000-000000000005.group_name"},
                            {"widget": "text", "widget-id": "shg_id", "widget-type": "input", "widget-label": "LokOS SHG ID", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.shg_id"},
                            {"widget": "text", "widget-id": "lokos_id", "widget-type": "input", "widget-label": "LokOS ID", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.lokos_id"},
                            {"widget": "text", "widget-id": "shg_code", "widget-type": "input", "widget-label": "SHG Code", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.shg_code"},
                            {"widget": "select", "widget-id": "group_type", "widget-type": "input", "widget-label": "Group Type", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.group_type", "widget-data-source": {"type": "static", "options": [{"label": "Self-Help Group (SHG)", "value": "SHG"}, {"label": "Village Organisation (VO)", "value": "VO"}, {"label": "Cluster Level Federation (CLF)", "value": "CLF"}]}}
                        ],
                        "panel-id": "panel_shg_id",
                        "panel-orientation": "vertical"
                    },
                    {
                        "widgets": [
                            {"widget": "text", "widget-id": "vo_name", "widget-type": "input", "widget-label": "Village Organisation (VO)", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.vo_name"},
                            {"widget": "text", "widget-id": "clf_name", "widget-type": "input", "widget-label": "Cluster Federation (CLF)", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.clf_name"},
                            {"widget": "text", "widget-id": "member_id", "widget-type": "input", "widget-label": "Member ID", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.member_id"},
                            {"widget": "text", "widget-id": "key_member_name", "widget-type": "input", "widget-label": "Key Representative Name", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.key_member_name"},
                            {"widget": "text", "widget-id": "key_member_role", "widget-type": "input", "widget-label": "Representative Role", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.key_member_role"}
                        ],
                        "panel-id": "panel_shg_rep",
                        "panel-orientation": "vertical"
                    },
                    {
                        "widgets": [
                            {"widget": "text", "widget-id": "key_member_aadhaar", "widget-type": "input", "widget-label": "Representative Aadhaar", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.key_member_aadhaar"},
                            {"widget": "text", "widget-id": "key_member_mobile", "widget-type": "input", "widget-label": "Contact Mobile", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.key_member_mobile"},
                            {"widget": "text", "widget-id": "district", "widget-type": "input", "widget-label": "District", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.district"},
                            {"widget": "text", "widget-id": "block", "widget-type": "input", "widget-label": "Block", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.block"},
                            {"widget": "text", "widget-id": "village", "widget-type": "input", "widget-label": "Village", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.village"}
                        ],
                        "panel-id": "panel_shg_location",
                        "panel-orientation": "vertical"
                    }
                ],
                "panel-id": "panel_group_basic_main",
                "panel-orientation": "horizontal"
            }
        ],
        "section-id": "group_basic_section",
        "section-title": "Group Institution & Representative Profile",
        "section-editable": true
    }'::jsonb
);

-- Section 2: Financial Profile & Governance
INSERT INTO g2p_register_sections (
    section_id, register_id, section_register_id, is_core_section, section_mnemonic,
    documents_required, no_of_verifications_required, is_list, section_weightage,
    cr_auto_approve_for_bene_portal, cr_auto_approve_for_agent_portal,
    cr_auto_approve_for_staff_portal, cr_auto_approve_for_partner, section_ui_schema
) VALUES (
    'group_financial_section', 'a0000000-0000-4000-8000-000000000005', 'a0000000-0000-4000-8000-000000000005',
    false, 'group_financial_section', false, 0, false, 50, false, false, false, false,
    '{
        "panels": [
            {
                "panels": [
                    {
                        "widgets": [
                            {"widget": "text", "widget-id": "bank_name", "widget-type": "input", "widget-label": "Bank Name", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.bank_name"},
                            {"widget": "text", "widget-id": "bank_account_no", "widget-type": "input", "widget-label": "Account Number", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.bank_account_no"},
                            {"widget": "text", "widget-id": "ifsc_code", "widget-type": "input", "widget-label": "IFSC Code", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.ifsc_code"}
                        ],
                        "panel-id": "panel_shg_banking",
                        "panel-orientation": "vertical"
                    },
                    {
                        "widgets": [
                            {"widget": "number", "widget-id": "monthly_savings_amount", "widget-type": "input", "widget-label": "Monthly Savings (₹)", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.monthly_savings_amount", "widget-data-format": {"numericType": "decimal", "decimalPlaces": 2}},
                            {"widget": "number", "widget-id": "internal_loan_outstanding", "widget-type": "input", "widget-label": "Internal Loan Outstanding (₹)", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.internal_loan_outstanding", "widget-data-format": {"numericType": "decimal", "decimalPlaces": 2}},
                            {"widget": "number", "widget-id": "ccl_limit", "widget-type": "input", "widget-label": "CCL Sanctioned Limit (₹)", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.ccl_limit", "widget-data-format": {"numericType": "decimal", "decimalPlaces": 2}},
                            {"widget": "number", "widget-id": "ccl_utilised", "widget-type": "input", "widget-label": "CCL Utilised (₹)", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.ccl_utilised", "widget-data-format": {"numericType": "decimal", "decimalPlaces": 2}}
                        ],
                        "panel-id": "panel_shg_credit",
                        "panel-orientation": "vertical"
                    },
                    {
                        "widgets": [
                            {"widget": "select", "widget-id": "shg_grading", "widget-type": "input", "widget-label": "SHG Grading", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.shg_grading", "widget-data-source": {"type": "static", "options": [{"label": "Grade A", "value": "A"}, {"label": "Grade B", "value": "B"}, {"label": "Grade C", "value": "C"}]}},
                            {"widget": "date", "widget-id": "formation_date", "widget-type": "input", "widget-label": "Formation Date", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.formation_date"},
                            {"widget": "select", "widget-id": "meeting_frequency", "widget-type": "input", "widget-label": "Meeting Frequency", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000005.meeting_frequency", "widget-data-source": {"type": "static", "options": [{"label": "Weekly", "value": "Weekly"}, {"label": "Fortnightly", "value": "Fortnightly"}, {"label": "Monthly", "value": "Monthly"}]}}
                        ],
                        "panel-id": "panel_shg_governance",
                        "panel-orientation": "vertical"
                    }
                ],
                "panel-id": "panel_group_financial_main",
                "panel-orientation": "horizontal"
            }
        ],
        "section-id": "group_financial_section",
        "section-title": "Financial & Governance Profile",
        "section-editable": true
    }'::jsonb
);

-- ============================================================================
-- 4. Register UI Tabs & Tab-Section Mapping
-- ============================================================================

DELETE FROM g2p_register_ui_tabs WHERE tab_id = 'group_info_tab';
INSERT INTO g2p_register_ui_tabs (
    tab_id, register_id, tab_label, tab_order, is_active
) VALUES (
    'group_info_tab', 'a0000000-0000-4000-8000-000000000005', 'Group Profile', 1, true
);

DELETE FROM g2p_register_ui_tab_sections WHERE tab_id = 'group_info_tab';
INSERT INTO g2p_register_ui_tab_sections (tab_section_id, register_id, tab_id, section_id, section_order) VALUES
('b4000000-0000-4000-8000-000000000011', 'a0000000-0000-4000-8000-000000000005', 'group_info_tab', 'group_basic_section', 10),
('b4000000-0000-4000-8000-000000000012', 'a0000000-0000-4000-8000-000000000005', 'group_info_tab', 'group_financial_section', 20);

-- ============================================================================
-- 5. Intake Form Definition, Tabs & Tab-Section Mapping
-- ============================================================================

DELETE FROM g2p_intake_form_definitions WHERE form_id = 'c1000000-0000-4000-8000-000000000005';
INSERT INTO g2p_intake_form_definitions (
    form_id, register_id, form_mnemonic, form_description, number_of_verifications, used_only_in_ingestion_pipeline
) VALUES (
    'c1000000-0000-4000-8000-000000000005', 'a0000000-0000-4000-8000-000000000005',
    'group_intake_form', 'Self-Help Group Intake Form', 0, false
);

DELETE FROM g2p_intake_form_ui_tabs WHERE tab_id = 'nsr_form_tab_group_intake';
INSERT INTO g2p_intake_form_ui_tabs (
    tab_id, form_id, tab_label, tab_order
) VALUES (
    'nsr_form_tab_group_intake', 'c1000000-0000-4000-8000-000000000005',
    'Group Registration', 1
);

DELETE FROM g2p_intake_form_ui_tab_sections WHERE tab_id = 'nsr_form_tab_group_intake';
INSERT INTO g2p_intake_form_ui_tab_sections (tab_section_id, tab_id, section_id, section_order) VALUES
('c3000000-0000-4000-8000-000000000011', 'nsr_form_tab_group_intake', 'group_basic_section', 1),
('c3000000-0000-4000-8000-000000000012', 'nsr_form_tab_group_intake', 'group_financial_section', 2);

-- ============================================================================
-- 6. Register Search & Filter Schemas
-- ============================================================================

DELETE FROM g2p_register_schemas WHERE register_id = 'a0000000-0000-4000-8000-000000000005';
INSERT INTO g2p_register_schemas (register_id, search_result_schema, filter_schema)
VALUES (
    'a0000000-0000-4000-8000-000000000005',
    '[
        {"field_name": "group_name", "display_label": "Group Name", "order": 1},
        {"field_name": "shg_id", "display_label": "SHG ID", "order": 2},
        {"field_name": "key_member_name", "display_label": "Representative", "order": 3},
        {"field_name": "key_member_aadhaar", "display_label": "Rep. Aadhaar", "order": 4},
        {"field_name": "district", "display_label": "District", "order": 5},
        {"field_name": "block", "display_label": "Block", "order": 6},
        {"field_name": "shg_grading", "display_label": "Grading", "order": 7},
        {"field_name": "monthly_savings_amount", "display_label": "Savings (₹)", "order": 8}
    ]'::jsonb,
    '[
        {"field_name": "district", "display_label": "District", "type": "text"},
        {"field_name": "block", "display_label": "Block", "type": "text"},
        {"field_name": "shg_grading", "display_label": "Grading", "type": "select", "options": [{"label": "Grade A", "value": "A"}, {"label": "Grade B", "value": "B"}, {"label": "Grade C", "value": "C"}]},
        {"field_name": "group_type", "display_label": "Group Type", "type": "select", "options": [{"label": "SHG", "value": "SHG"}, {"label": "VO", "value": "VO"}, {"label": "CLF", "value": "CLF"}]}
    ]'::jsonb
);

-- ============================================================================
-- 7. AWE Multi-Stage Approval Policy Configurations
-- Stage 1: Alex Carter (Maker) -> Stage 2: Nina Patel (Checker) -> Ingest
-- ============================================================================

DELETE FROM g2p_registry_awe_policy_configurations WHERE awe_policy_config_id IN (
    'a2000000-0000-4000-8000-000000000005',
    'a2000000-0000-4000-8000-000000000015'
);

INSERT INTO g2p_registry_awe_policy_configurations (
    awe_policy_config_id, policy_scope, register_id, intake_form_id,
    policy_type, policy_key, context_field_names
) VALUES
    ('a2000000-0000-4000-8000-000000000005', 'REGISTER', 'a0000000-0000-4000-8000-000000000005', NULL, 'registry.change_request', 'registry.change_request.individual', NULL),
    ('a2000000-0000-4000-8000-000000000015', 'INTAKE_FORM', 'a0000000-0000-4000-8000-000000000005', 'c1000000-0000-4000-8000-000000000005', 'registry.intake_form', 'registry.intake_form.individual', NULL);
