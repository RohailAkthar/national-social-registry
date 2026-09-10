-- ============================================================================
-- GramStack - JEEViKA Registry Platform
-- Pure Standalone Student Registry (Master & Child Tables, Schemas, AWE Workflow)
-- Register ID: a0000000-0000-4000-8000-000000000004
-- ============================================================================

-- ============================================================================
-- 1. Create Core Tables for Student Master Register
-- ============================================================================

CREATE TABLE IF NOT EXISTS g2p_register_students (
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

    -- Demographics & Identity
    foundational_id VARCHAR,
    first_name VARCHAR,
    middle_name VARCHAR,
    last_name VARCHAR,
    given_name VARCHAR,
    prefix VARCHAR,
    suffix VARCHAR,
    gender VARCHAR,
    birth_date DATE,
    phone_numbers JSONB,
    emails JSONB,
    marital_status VARCHAR,
    occupation VARCHAR,
    income_level VARCHAR,
    language_code VARCHAR,
    registration_date DATE,
    guardian_aadhaar_number VARCHAR,
    father_name VARCHAR,
    mother_name VARCHAR,
    guardian_name VARCHAR,
    social_category VARCHAR,
    mobile_phone_number VARCHAR,
    email VARCHAR,

    -- Geographic & Address
    address_line_1 VARCHAR,
    address_line_2 VARCHAR,
    village VARCHAR,
    block VARCHAR,
    district VARCHAR,
    state VARCHAR DEFAULT 'Bihar',
    postal_code VARCHAR,
    latitude VARCHAR,
    longitude VARCHAR,
    altitude VARCHAR,
    country_code VARCHAR,
    plus_code VARCHAR,
    geo_lowest_level_value_id VARCHAR,
    geo_code_hierarchy_json JSONB,

    -- Educational Profile & UDISE+
    student_id VARCHAR,
    udise_student_id VARCHAR,
    apaar_id VARCHAR,
    pen_number VARCHAR,
    school_name VARCHAR,
    school_udise_code VARCHAR,
    education_level VARCHAR,
    class_grade VARCHAR,
    stream VARCHAR,
    roll_number VARCHAR,
    enrollment_date DATE,
    attendance_percentage NUMERIC(5, 2),
    medium_of_instruction VARCHAR,

    -- Entitlements & Banking
    scholarship_status VARCHAR,
    bank_account_no VARCHAR,
    bank_name VARCHAR,
    ifsc_code VARCHAR
);

CREATE TABLE IF NOT EXISTS g2p_register_history_students (
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

    -- Demographics & Identity
    foundational_id VARCHAR,
    first_name VARCHAR,
    middle_name VARCHAR,
    last_name VARCHAR,
    given_name VARCHAR,
    prefix VARCHAR,
    suffix VARCHAR,
    gender VARCHAR,
    birth_date DATE,
    phone_numbers JSONB,
    emails JSONB,
    marital_status VARCHAR,
    occupation VARCHAR,
    income_level VARCHAR,
    language_code VARCHAR,
    registration_date DATE,
    guardian_aadhaar_number VARCHAR,
    father_name VARCHAR,
    mother_name VARCHAR,
    guardian_name VARCHAR,
    social_category VARCHAR,
    mobile_phone_number VARCHAR,
    email VARCHAR,

    -- Geographic & Address
    address_line_1 VARCHAR,
    address_line_2 VARCHAR,
    village VARCHAR,
    block VARCHAR,
    district VARCHAR,
    state VARCHAR DEFAULT 'Bihar',
    postal_code VARCHAR,
    latitude VARCHAR,
    longitude VARCHAR,
    altitude VARCHAR,
    country_code VARCHAR,
    plus_code VARCHAR,
    geo_lowest_level_value_id VARCHAR,
    geo_code_hierarchy_json JSONB,

    -- Educational Profile & UDISE+
    student_id VARCHAR,
    udise_student_id VARCHAR,
    apaar_id VARCHAR,
    pen_number VARCHAR,
    school_name VARCHAR,
    school_udise_code VARCHAR,
    education_level VARCHAR,
    class_grade VARCHAR,
    stream VARCHAR,
    roll_number VARCHAR,
    enrollment_date DATE,
    attendance_percentage NUMERIC(5, 2),
    medium_of_instruction VARCHAR,

    -- Entitlements & Banking
    scholarship_status VARCHAR,
    bank_account_no VARCHAR,
    bank_name VARCHAR,
    ifsc_code VARCHAR
);

CREATE TABLE IF NOT EXISTS g2p_intake_form_students (
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

    -- Demographics & Identity
    foundational_id VARCHAR,
    first_name VARCHAR,
    middle_name VARCHAR,
    last_name VARCHAR,
    given_name VARCHAR,
    prefix VARCHAR,
    suffix VARCHAR,
    gender VARCHAR,
    birth_date DATE,
    phone_numbers JSONB,
    emails JSONB,
    marital_status VARCHAR,
    occupation VARCHAR,
    income_level VARCHAR,
    language_code VARCHAR,
    registration_date DATE,
    guardian_aadhaar_number VARCHAR,
    father_name VARCHAR,
    mother_name VARCHAR,
    guardian_name VARCHAR,
    social_category VARCHAR,
    mobile_phone_number VARCHAR,
    email VARCHAR,

    -- Geographic & Address
    address_line_1 VARCHAR,
    address_line_2 VARCHAR,
    village VARCHAR,
    block VARCHAR,
    district VARCHAR,
    state VARCHAR DEFAULT 'Bihar',
    postal_code VARCHAR,
    latitude VARCHAR,
    longitude VARCHAR,
    altitude VARCHAR,
    country_code VARCHAR,
    plus_code VARCHAR,
    geo_lowest_level_value_id VARCHAR,
    geo_code_hierarchy_json JSONB,

    -- Educational Profile & UDISE+
    student_id VARCHAR,
    udise_student_id VARCHAR,
    apaar_id VARCHAR,
    pen_number VARCHAR,
    school_name VARCHAR,
    school_udise_code VARCHAR,
    education_level VARCHAR,
    class_grade VARCHAR,
    stream VARCHAR,
    roll_number VARCHAR,
    enrollment_date DATE,
    attendance_percentage NUMERIC(5, 2),
    medium_of_instruction VARCHAR,

    -- Entitlements & Banking
    scholarship_status VARCHAR,
    bank_account_no VARCHAR,
    bank_name VARCHAR,
    ifsc_code VARCHAR
);

-- ============================================================================
-- 2. Create Child Tables: Academic Records
-- ============================================================================

CREATE TABLE IF NOT EXISTS g2p_register_student_academics (
    internal_record_id VARCHAR PRIMARY KEY,
    link_internal_record_id VARCHAR,
    link_foundational_id VARCHAR,
    functional_record_id VARCHAR,
    record_name VARCHAR,
    record_image_storage_id TEXT,
    record_image_document_id TEXT,
    created_by VARCHAR NOT NULL DEFAULT 'system',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    approved_by VARCHAR NOT NULL DEFAULT 'system',
    last_approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_approved_by VARCHAR NOT NULL DEFAULT 'system',
    search_text TEXT,
    record_status VARCHAR NOT NULL DEFAULT 'ACTIVE',
    record_status_reason VARCHAR,

    exam_name VARCHAR,
    board_or_university VARCHAR,
    passing_year INTEGER,
    marks_obtained NUMERIC(6, 2),
    total_marks NUMERIC(6, 2),
    percentage_or_cgpa NUMERIC(5, 2),
    division_or_grade VARCHAR
);

CREATE TABLE IF NOT EXISTS g2p_register_history_student_academics (
    history_record_id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::text,
    internal_record_id VARCHAR NOT NULL,
    tab_id VARCHAR,
    section_id VARCHAR,
    change_request_id VARCHAR,
    submission_id VARCHAR,
    change_request_source VARCHAR,
    is_primary_section BOOLEAN DEFAULT FALSE,
    link_internal_record_id VARCHAR,
    link_foundational_id VARCHAR,
    functional_record_id VARCHAR,
    record_name VARCHAR,
    record_image_storage_id TEXT,
    record_image_document_id TEXT,
    created_by VARCHAR NOT NULL DEFAULT 'system',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    approved_by VARCHAR NOT NULL DEFAULT 'system',
    last_approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_approved_by VARCHAR NOT NULL DEFAULT 'system',
    search_text TEXT,
    record_status VARCHAR NOT NULL DEFAULT 'ACTIVE',
    record_status_reason VARCHAR,

    exam_name VARCHAR,
    board_or_university VARCHAR,
    passing_year INTEGER,
    marks_obtained NUMERIC(6, 2),
    total_marks NUMERIC(6, 2),
    percentage_or_cgpa NUMERIC(5, 2),
    division_or_grade VARCHAR
);

CREATE TABLE IF NOT EXISTS g2p_intake_form_student_academics (
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

    exam_name VARCHAR,
    board_or_university VARCHAR,
    passing_year INTEGER,
    marks_obtained NUMERIC(6, 2),
    total_marks NUMERIC(6, 2),
    percentage_or_cgpa NUMERIC(5, 2),
    division_or_grade VARCHAR
);

-- ============================================================================
-- 3. Create Child Tables: Scholarships & Entitlements
-- ============================================================================

CREATE TABLE IF NOT EXISTS g2p_register_student_scholarships (
    internal_record_id VARCHAR PRIMARY KEY,
    link_internal_record_id VARCHAR,
    link_foundational_id VARCHAR,
    functional_record_id VARCHAR,
    record_name VARCHAR,
    record_image_storage_id TEXT,
    record_image_document_id TEXT,
    created_by VARCHAR NOT NULL DEFAULT 'system',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    approved_by VARCHAR NOT NULL DEFAULT 'system',
    last_approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_approved_by VARCHAR NOT NULL DEFAULT 'system',
    search_text TEXT,
    record_status VARCHAR NOT NULL DEFAULT 'ACTIVE',
    record_status_reason VARCHAR,

    scheme_name VARCHAR,
    academic_year VARCHAR,
    sanctioned_amount NUMERIC(10, 2),
    disbursement_status VARCHAR,
    disbursement_date DATE,
    transaction_reference VARCHAR
);

CREATE TABLE IF NOT EXISTS g2p_register_history_student_scholarships (
    history_record_id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::text,
    internal_record_id VARCHAR NOT NULL,
    tab_id VARCHAR,
    section_id VARCHAR,
    change_request_id VARCHAR,
    submission_id VARCHAR,
    change_request_source VARCHAR,
    is_primary_section BOOLEAN DEFAULT FALSE,
    link_internal_record_id VARCHAR,
    link_foundational_id VARCHAR,
    functional_record_id VARCHAR,
    record_name VARCHAR,
    record_image_storage_id TEXT,
    record_image_document_id TEXT,
    created_by VARCHAR NOT NULL DEFAULT 'system',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    approved_by VARCHAR NOT NULL DEFAULT 'system',
    last_approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_approved_by VARCHAR NOT NULL DEFAULT 'system',
    search_text TEXT,
    record_status VARCHAR NOT NULL DEFAULT 'ACTIVE',
    record_status_reason VARCHAR,

    scheme_name VARCHAR,
    academic_year VARCHAR,
    sanctioned_amount NUMERIC(10, 2),
    disbursement_status VARCHAR,
    disbursement_date DATE,
    transaction_reference VARCHAR
);

CREATE TABLE IF NOT EXISTS g2p_intake_form_student_scholarships (
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

    scheme_name VARCHAR,
    academic_year VARCHAR,
    sanctioned_amount NUMERIC(10, 2),
    disbursement_status VARCHAR,
    disbursement_date DATE,
    transaction_reference VARCHAR
);

-- ============================================================================
-- 4. OpenG2P Register Metadata Definitions
-- ============================================================================

-- Register Definition for Student (Master Register)
DELETE FROM g2p_register_definitions WHERE register_id = 'a0000000-0000-4000-8000-000000000004';
INSERT INTO g2p_register_definitions (
    register_id, register_mnemonic, register_subject, register_description,
    master_register_id, register_rank, functional_id_generation_required, register_purpose,
    program_id, program_mnemonic, register_icon,
    has_image, dedup_is_enabled, dedup_threshold_score,
    completion_score_required, outgest_applicable,
    requires_registrant_authentication, registrant_authentication_validity_days,
    registrant_re_auth_warning_days_before
) VALUES (
    'a0000000-0000-4000-8000-000000000004', 'Student', 'Students',
    'Student registry tracking educational enrollment, UDISE+, academic records, and scholarships',
    NULL, 4, 'TRUE', 'REGISTER',
    NULL, NULL, 'school',
    'TRUE', 'FALSE', 0, 'FALSE', 'FALSE', 'FALSE', 730, 30
);

-- Register Definition for StudentAcademic (Child Table)
DELETE FROM g2p_register_definitions WHERE register_id = 'b0000000-0000-4000-8000-000000000060';
INSERT INTO g2p_register_definitions (
    register_id, register_mnemonic, register_subject, register_description,
    master_register_id, register_rank, functional_id_generation_required, register_purpose,
    program_id, program_mnemonic, register_icon,
    has_image, dedup_is_enabled, dedup_threshold_score,
    completion_score_required, outgest_applicable,
    requires_registrant_authentication, registrant_authentication_validity_days,
    registrant_re_auth_warning_days_before
) VALUES (
    'b0000000-0000-4000-8000-000000000060', 'StudentAcademic', 'Academic History',
    'Examination and academic performance records linked to student',
    'a0000000-0000-4000-8000-000000000004', 60, 'FALSE', 'TABLE',
    NULL, NULL, NULL,
    'FALSE', 'FALSE', 0, 'FALSE', 'FALSE', 'FALSE', 730, 30
);

-- Register Definition for StudentScholarship (Child Table)
DELETE FROM g2p_register_definitions WHERE register_id = 'b0000000-0000-4000-8000-000000000061';
INSERT INTO g2p_register_definitions (
    register_id, register_mnemonic, register_subject, register_description,
    master_register_id, register_rank, functional_id_generation_required, register_purpose,
    program_id, program_mnemonic, register_icon,
    has_image, dedup_is_enabled, dedup_threshold_score,
    completion_score_required, outgest_applicable,
    requires_registrant_authentication, registrant_authentication_validity_days,
    registrant_re_auth_warning_days_before
) VALUES (
    'b0000000-0000-4000-8000-000000000061', 'StudentScholarship', 'Scholarships & Entitlements',
    'Scholarships, stipends, and educational grants received by student',
    'a0000000-0000-4000-8000-000000000004', 61, 'FALSE', 'TABLE',
    NULL, NULL, NULL,
    'FALSE', 'FALSE', 0, 'FALSE', 'FALSE', 'FALSE', 730, 30
);

-- ============================================================================
-- 5. Register Sections & UI Schemas for Student
-- ============================================================================

DELETE FROM g2p_register_sections WHERE section_id IN (
    'student_personal_section',
    'student_education_section',
    'student_academics_table',
    'student_scholarships_table'
);

-- -- Section 1: Student Personal & Demographic Details
INSERT INTO g2p_register_sections (
    section_id, register_id, section_register_id, is_core_section, section_mnemonic,
    documents_required, no_of_verifications_required, is_list, section_weightage,
    cr_auto_approve_for_bene_portal, cr_auto_approve_for_agent_portal,
    cr_auto_approve_for_staff_portal, cr_auto_approve_for_partner, section_ui_schema
) VALUES (
    'student_personal_section', 'a0000000-0000-4000-8000-000000000004', 'a0000000-0000-4000-8000-000000000004',
    true, 'student_personal_section', false, 0, false, 50, false, false, false, false,
    '{
        "panels": [
            {
                "panels": [
                    {
                        "widgets": [
                            {"widget": "text", "widget-id": "foundational_id", "widget-type": "input", "widget-label": "Student Aadhaar Number", "widget-required": true, "widget-data-path": "a0000000-0000-4000-8000-000000000004.foundational_id"},
                            {"widget": "text", "widget-id": "first_name", "widget-type": "input", "widget-label": "First Name", "widget-required": true, "widget-data-path": "a0000000-0000-4000-8000-000000000004.first_name"},
                            {"widget": "text", "widget-id": "last_name", "widget-type": "input", "widget-label": "Last Name", "widget-required": true, "widget-data-path": "a0000000-0000-4000-8000-000000000004.last_name"},
                            {"widget": "select", "widget-id": "gender", "widget-type": "input", "widget-label": "Gender", "widget-required": true, "widget-data-path": "a0000000-0000-4000-8000-000000000004.gender", "widget-data-source": {"type": "static", "options": [{"label": "MALE", "value": "MALE"}, {"label": "FEMALE", "value": "FEMALE"}, {"label": "OTHER", "value": "OTHER"}]}},
                            {"widget": "date", "widget-id": "birth_date", "widget-type": "input", "widget-label": "Date of Birth", "widget-required": true, "widget-data-path": "a0000000-0000-4000-8000-000000000004.birth_date"}
                        ],
                        "panel-id": "panel_student_basic",
                        "panel-orientation": "vertical"
                    },
                    {
                        "widgets": [
                            {"widget": "text", "widget-id": "guardian_aadhaar_number", "widget-type": "input", "widget-label": "Guardian Aadhaar Number", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000004.guardian_aadhaar_number"},
                            {"widget": "text", "widget-id": "district", "widget-type": "input", "widget-label": "District", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000004.district"},
                            {"widget": "text", "widget-id": "block", "widget-type": "input", "widget-label": "Block", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000004.block"},
                            {"widget": "text", "widget-id": "state", "widget-type": "input", "widget-label": "State", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000004.state"}
                        ],
                        "panel-id": "panel_student_location",
                        "panel-orientation": "vertical"
                    }
                ],
                "panel-id": "panel_student_personal_main",
                "panel-orientation": "horizontal"
            }
        ],
        "section-id": "student_personal_section",
        "section-title": "Student Personal & Demographic Details",
        "section-editable": true
    }'::jsonb
);

-- Section 2: Student Educational & Institutional Details
INSERT INTO g2p_register_sections (
    section_id, register_id, section_register_id, is_core_section, section_mnemonic,
    documents_required, no_of_verifications_required, is_list, section_weightage,
    cr_auto_approve_for_bene_portal, cr_auto_approve_for_agent_portal,
    cr_auto_approve_for_staff_portal, cr_auto_approve_for_partner, section_ui_schema
) VALUES (
    'student_education_section', 'a0000000-0000-4000-8000-000000000004', 'a0000000-0000-4000-8000-000000000004',
    false, 'student_education_section', false, 0, false, 50, false, false, false, false,
    '{
        "panels": [
            {
                "panels": [
                    {
                        "widgets": [
                            {"widget": "text", "widget-id": "udise_student_id", "widget-type": "input", "widget-label": "UDISE+ Student ID", "widget-required": true, "widget-data-path": "a0000000-0000-4000-8000-000000000004.udise_student_id"},
                            {"widget": "text", "widget-id": "school_name", "widget-type": "input", "widget-label": "School / Institution Name", "widget-required": true, "widget-data-path": "a0000000-0000-4000-8000-000000000004.school_name"},
                            {"widget": "text", "widget-id": "school_udise_code", "widget-type": "input", "widget-label": "School UDISE Code", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000004.school_udise_code"},
                            {"widget": "select", "widget-id": "education_level", "widget-type": "input", "widget-label": "Education Level", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000004.education_level", "widget-data-source": {"type": "static", "options": [{"label": "PRIMARY", "value": "PRIMARY"}, {"label": "MIDDLE", "value": "MIDDLE"}, {"label": "SECONDARY", "value": "SECONDARY"}, {"label": "HIGHER_SECONDARY", "value": "HIGHER_SECONDARY"}, {"label": "UNDERGRADUATE", "value": "UNDERGRADUATE"}, {"label": "POSTGRADUATE", "value": "POSTGRADUATE"}]}}
                        ],
                        "panel-id": "panel_edu_institution",
                        "panel-orientation": "vertical"
                    },
                    {
                        "widgets": [
                            {"widget": "text", "widget-id": "class_grade", "widget-type": "input", "widget-label": "Current Class / Grade", "widget-required": true, "widget-data-path": "a0000000-0000-4000-8000-000000000004.class_grade"},
                            {"widget": "date", "widget-id": "enrollment_date", "widget-type": "input", "widget-label": "Admission Date", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000004.enrollment_date"},
                            {"widget": "number", "widget-id": "attendance_percentage", "widget-type": "input", "widget-label": "Attendance Percentage (%)", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000004.attendance_percentage", "widget-data-format": {"numericType": "decimal", "decimalPlaces": 2}},
                            {"widget": "select", "widget-id": "scholarship_status", "widget-type": "input", "widget-label": "Scholarship Enrolled", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000004.scholarship_status", "widget-data-source": {"type": "static", "options": [{"label": "Active", "value": "Active"}, {"label": "None", "value": "None"}, {"label": "Pending", "value": "Pending"}]}}
                        ],
                        "panel-id": "panel_edu_academic",
                        "panel-orientation": "vertical"
                    }
                ],
                "panel-id": "panel_student_education_main",
                "panel-orientation": "horizontal"
            }
        ],
        "section-id": "student_education_section",
        "section-title": "Educational Profile & School Affiliation",
        "section-editable": true
    }'::jsonb
);

-- ============================================================================
-- 6. Register UI Tabs & Tab-Section Mapping
-- ============================================================================

DELETE FROM g2p_register_ui_tabs WHERE tab_id = 'student_info_tab';
INSERT INTO g2p_register_ui_tabs (
    tab_id, register_id, tab_label, tab_order, is_active
) VALUES (
    'student_info_tab', 'a0000000-0000-4000-8000-000000000004', 'Student Profile', 1, true
);

DELETE FROM g2p_register_ui_tab_sections WHERE tab_id = 'student_info_tab';
INSERT INTO g2p_register_ui_tab_sections (tab_section_id, register_id, tab_id, section_id, section_order) VALUES
('b4000000-0000-4000-8000-000000000001', 'a0000000-0000-4000-8000-000000000004', 'student_info_tab', 'student_personal_section', 10),
('b4000000-0000-4000-8000-000000000002', 'a0000000-0000-4000-8000-000000000004', 'student_info_tab', 'student_education_section', 20);

-- ============================================================================
-- 7. Intake Form Definition, Tabs & Tab-Section Mapping
-- ============================================================================

DELETE FROM g2p_intake_form_definitions WHERE form_id = 'c1000000-0000-4000-8000-000000000004';
INSERT INTO g2p_intake_form_definitions (
    form_id, register_id, form_mnemonic, form_description, number_of_verifications, used_only_in_ingestion_pipeline
) VALUES (
    'c1000000-0000-4000-8000-000000000004', 'a0000000-0000-4000-8000-000000000004',
    'student_intake_form', 'Student Intake Form', 0, false
);

DELETE FROM g2p_intake_form_ui_tabs WHERE tab_id = 'nsr_form_tab_student_intake';
INSERT INTO g2p_intake_form_ui_tabs (
    tab_id, form_id, tab_label, tab_order
) VALUES (
    'nsr_form_tab_student_intake', 'c1000000-0000-4000-8000-000000000004',
    'Student Registration', 1
);

DELETE FROM g2p_intake_form_ui_tab_sections WHERE tab_id = 'nsr_form_tab_student_intake';
INSERT INTO g2p_intake_form_ui_tab_sections (tab_section_id, tab_id, section_id, section_order) VALUES
('c3000000-0000-4000-8000-000000000001', 'nsr_form_tab_student_intake', 'student_personal_section', 1),
('c3000000-0000-4000-8000-000000000002', 'nsr_form_tab_student_intake', 'student_education_section', 2);

-- ============================================================================
-- 8. Register Search & Filter Schemas
-- ============================================================================

DELETE FROM g2p_register_schemas WHERE register_id = 'a0000000-0000-4000-8000-000000000004';
INSERT INTO g2p_register_schemas (register_id, search_result_schema, filter_schema)
VALUES (
    'a0000000-0000-4000-8000-000000000004',
    '[
        {"field_name": "student_name", "display_label": "Student Name", "order": 1},
        {"field_name": "udise_student_id", "display_label": "UDISE Student ID", "order": 2},
        {"field_name": "foundational_id", "display_label": "Aadhaar ID", "order": 3},
        {"field_name": "school_name", "display_label": "School Name", "order": 4},
        {"field_name": "class_grade", "display_label": "Class / Grade", "order": 5},
        {"field_name": "district", "display_label": "District", "order": 6},
        {"field_name": "block", "display_label": "Block", "order": 7},
        {"field_name": "scholarship_status", "display_label": "Scholarship", "order": 8}
    ]'::jsonb,
    '[
        {"field_name": "district", "display_label": "District", "type": "text"},
        {"field_name": "block", "display_label": "Block", "type": "text"},
        {"field_name": "class_grade", "display_label": "Class / Grade", "type": "text"},
        {"field_name": "scholarship_status", "display_label": "Scholarship Status", "type": "select", "options": [{"label": "Active", "value": "Active"}, {"label": "None", "value": "None"}, {"label": "Pending", "value": "Pending"}]}
    ]'::jsonb
);

-- ============================================================================
-- 9. AWE Multi-Stage Approval Policy Configurations
-- Stage 1: Alex Carter (Maker) -> Stage 2: Nina Patel (Checker) -> Ingest
-- ============================================================================

DELETE FROM g2p_registry_awe_policy_configurations WHERE awe_policy_config_id IN (
    'a2000000-0000-4000-8000-000000000004',
    'a2000000-0000-4000-8000-000000000014'
);

INSERT INTO g2p_registry_awe_policy_configurations (
    awe_policy_config_id, policy_scope, register_id, intake_form_id,
    policy_type, policy_key, context_field_names
) VALUES
    ('a2000000-0000-4000-8000-000000000004', 'REGISTER', 'a0000000-0000-4000-8000-000000000004', NULL, 'registry.change_request', 'registry.change_request.individual', NULL),
    ('a2000000-0000-4000-8000-000000000014', 'INTAKE_FORM', 'a0000000-0000-4000-8000-000000000004', 'c1000000-0000-4000-8000-000000000004', 'registry.intake_form', 'registry.intake_form.individual', NULL);

