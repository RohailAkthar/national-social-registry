-- ============================================================================
-- GramStack / OpenG2P NSR: Farmer Registry Setup Migration
-- Specification: https://docs.openg2p.org/products/registry/farmer-registry
-- ============================================================================

BEGIN;

-- 1. Create g2p_register_farmers
CREATE TABLE IF NOT EXISTS g2p_register_farmers (
    internal_record_id VARCHAR PRIMARY KEY,
    functional_record_id VARCHAR,
    record_name VARCHAR,
    record_status VARCHAR DEFAULT 'ACTIVE',
    record_status_reason VARCHAR,
    link_internal_record_id VARCHAR,
    link_foundational_id VARCHAR,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR,
    last_approved_at TIMESTAMP WITHOUT TIME ZONE,
    last_approved_by VARCHAR,
    search_text TEXT,
    application_reference VARCHAR,
    record_image_storage_id TEXT,
    record_image_document_id TEXT,

    -- Person fields
    foundational_id VARCHAR,
    first_name VARCHAR,
    last_name VARCHAR,
    given_name VARCHAR,
    family_name VARCHAR,
    lineage_name VARCHAR,
    gender VARCHAR,
    birth_date DATE,
    mobile_phone_number VARCHAR,
    email_address VARCHAR,
    marital_status VARCHAR,

    -- Geo fields
    region_code VARCHAR,
    zone_subcity_code VARCHAR,
    woreda_code VARCHAR,
    locality_ea_code VARCHAR,
    kebele_code VARCHAR,
    address_line_1 VARCHAR,
    address_line_2 VARCHAR,
    address_descriptor VARCHAR,
    postal_code VARCHAR,
    latitude VARCHAR,
    longitude VARCHAR,
    altitude VARCHAR,
    country_code VARCHAR,

    -- OpenG2P Farmer Domain fields
    estimated_age INTEGER,
    has_personal_phone BOOLEAN,
    disabled BOOLEAN,
    disability_type VARCHAR,
    disability_severity VARCHAR,
    source_of_income VARCHAR,
    source_of_income_other VARCHAR,
    language_spoken VARCHAR,
    education_level VARCHAR,
    national_id_masked VARCHAR,

    -- AgriStack / GramStack attributes
    farmer_id VARCHAR,
    farmer_name VARCHAR,
    relation_name VARCHAR,
    farmer_mobile_number VARCHAR,
    crop_type VARCHAR,
    land_area_acres NUMERIC(10, 2),
    land_ownership_type VARCHAR,
    khata_number VARCHAR,
    khesra_number VARCHAR,
    khatiyan_number VARCHAR,
    pm_kisan_enrolled BOOLEAN,
    pmfby_enrolled BOOLEAN,
    farmer_bank_account_no VARCHAR,
    bank_name VARCHAR,
    ifsc_code VARCHAR,
    village VARCHAR,
    block VARCHAR,
    district VARCHAR
);

CREATE INDEX IF NOT EXISTS idx_farmers_functional_record_id ON g2p_register_farmers(functional_record_id);
CREATE INDEX IF NOT EXISTS idx_farmers_foundational_id ON g2p_register_farmers(foundational_id);
CREATE INDEX IF NOT EXISTS idx_farmers_farmer_id ON g2p_register_farmers(farmer_id);

-- 2. Create g2p_register_history_farmers
CREATE TABLE IF NOT EXISTS g2p_register_history_farmers (
    history_record_id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::text,
    internal_record_id VARCHAR,
    tab_id VARCHAR,
    section_id VARCHAR,
    change_request_id VARCHAR,
    submission_id VARCHAR,
    change_request_source VARCHAR,
    is_primary_section BOOLEAN DEFAULT FALSE,
    functional_record_id VARCHAR,
    record_name VARCHAR,
    record_status VARCHAR,
    record_status_reason VARCHAR,
    link_internal_record_id VARCHAR,
    link_foundational_id VARCHAR,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR,
    approved_at TIMESTAMP WITHOUT TIME ZONE,
    approved_by VARCHAR,
    last_approved_at TIMESTAMP WITHOUT TIME ZONE,
    last_approved_by VARCHAR,
    search_text TEXT,
    application_reference VARCHAR,
    record_image_storage_id TEXT,
    record_image_document_id TEXT,

    foundational_id VARCHAR,
    first_name VARCHAR,
    last_name VARCHAR,
    given_name VARCHAR,
    family_name VARCHAR,
    lineage_name VARCHAR,
    gender VARCHAR,
    birth_date DATE,
    mobile_phone_number VARCHAR,
    email_address VARCHAR,
    marital_status VARCHAR,

    region_code VARCHAR,
    zone_subcity_code VARCHAR,
    woreda_code VARCHAR,
    locality_ea_code VARCHAR,
    kebele_code VARCHAR,
    address_line_1 VARCHAR,
    address_line_2 VARCHAR,
    address_descriptor VARCHAR,
    postal_code VARCHAR,
    latitude VARCHAR,
    longitude VARCHAR,
    altitude VARCHAR,
    country_code VARCHAR,

    estimated_age INTEGER,
    has_personal_phone BOOLEAN,
    disabled BOOLEAN,
    disability_type VARCHAR,
    disability_severity VARCHAR,
    source_of_income VARCHAR,
    source_of_income_other VARCHAR,
    language_spoken VARCHAR,
    education_level VARCHAR,
    national_id_masked VARCHAR,

    farmer_id VARCHAR,
    farmer_name VARCHAR,
    relation_name VARCHAR,
    farmer_mobile_number VARCHAR,
    crop_type VARCHAR,
    land_area_acres NUMERIC(10, 2),
    land_ownership_type VARCHAR,
    khata_number VARCHAR,
    khesra_number VARCHAR,
    khatiyan_number VARCHAR,
    pm_kisan_enrolled BOOLEAN,
    pmfby_enrolled BOOLEAN,
    farmer_bank_account_no VARCHAR,
    bank_name VARCHAR,
    ifsc_code VARCHAR,
    village VARCHAR,
    block VARCHAR,
    district VARCHAR
);

-- 3. Create g2p_intake_form_farmers
CREATE TABLE IF NOT EXISTS g2p_intake_form_farmers (
    submission_id UUID,
    internal_record_id VARCHAR,
    functional_record_id VARCHAR,
    record_name VARCHAR,
    record_status VARCHAR,
    record_status_reason VARCHAR,
    link_internal_record_id VARCHAR,
    link_foundational_id VARCHAR,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR,
    last_approved_at TIMESTAMP WITHOUT TIME ZONE,
    last_approved_by VARCHAR,
    search_text TEXT,
    application_reference VARCHAR,
    record_image_storage_id TEXT,
    record_image_document_id TEXT,

    foundational_id VARCHAR,
    first_name VARCHAR,
    last_name VARCHAR,
    given_name VARCHAR,
    family_name VARCHAR,
    lineage_name VARCHAR,
    gender VARCHAR,
    birth_date DATE,
    mobile_phone_number VARCHAR,
    email_address VARCHAR,
    marital_status VARCHAR,

    region_code VARCHAR,
    zone_subcity_code VARCHAR,
    woreda_code VARCHAR,
    locality_ea_code VARCHAR,
    kebele_code VARCHAR,
    address_line_1 VARCHAR,
    address_line_2 VARCHAR,
    address_descriptor VARCHAR,
    postal_code VARCHAR,
    latitude VARCHAR,
    longitude VARCHAR,
    altitude VARCHAR,
    country_code VARCHAR,

    estimated_age INTEGER,
    has_personal_phone BOOLEAN,
    disabled BOOLEAN,
    disability_type VARCHAR,
    disability_severity VARCHAR,
    source_of_income VARCHAR,
    source_of_income_other VARCHAR,
    language_spoken VARCHAR,
    education_level VARCHAR,
    national_id_masked VARCHAR,

    farmer_id VARCHAR,
    farmer_name VARCHAR,
    relation_name VARCHAR,
    farmer_mobile_number VARCHAR,
    crop_type VARCHAR,
    land_area_acres NUMERIC(10, 2),
    land_ownership_type VARCHAR,
    khata_number VARCHAR,
    khesra_number VARCHAR,
    khatiyan_number VARCHAR,
    pm_kisan_enrolled BOOLEAN,
    pmfby_enrolled BOOLEAN,
    farmer_bank_account_no VARCHAR,
    bank_name VARCHAR,
    ifsc_code VARCHAR,
    village VARCHAR,
    block VARCHAR,
    district VARCHAR
);

-- 4. Create child tables: Land and Crops
CREATE TABLE IF NOT EXISTS g2p_register_lands (
    internal_record_id VARCHAR PRIMARY KEY,
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
    land_ownership_type VARCHAR,
    certificate_storage_id TEXT,
    land_size VARCHAR,
    unit VARCHAR,
    soil_fertility VARCHAR,
    current_land_use VARCHAR,
    farming_type VARCHAR,
    year_of_acquisition INTEGER,
    means_of_acquisition VARCHAR,
    khata_number VARCHAR,
    khesra_numbers VARCHAR,
    jamabandi_number VARCHAR,
    mauza VARCHAR,
    anchal VARCHAR,
    district VARCHAR,
    rakba_area NUMERIC(10, 2)
);

ALTER TABLE g2p_register_lands ADD COLUMN IF NOT EXISTS link_foundational_id VARCHAR;
ALTER TABLE g2p_register_lands ADD COLUMN IF NOT EXISTS record_image_storage_id TEXT;
ALTER TABLE g2p_register_lands ADD COLUMN IF NOT EXISTS created_by VARCHAR NOT NULL DEFAULT 'system';
ALTER TABLE g2p_register_lands ADD COLUMN IF NOT EXISTS last_approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE g2p_register_lands ADD COLUMN IF NOT EXISTS last_approved_by VARCHAR NOT NULL DEFAULT 'system';
ALTER TABLE g2p_register_lands ADD COLUMN IF NOT EXISTS search_text TEXT;
ALTER TABLE g2p_register_lands ADD COLUMN IF NOT EXISTS record_status_reason VARCHAR;

CREATE TABLE IF NOT EXISTS g2p_register_history_lands (
    history_record_id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::text,
    internal_record_id VARCHAR NOT NULL,
    tab_id VARCHAR,
    section_id VARCHAR,
    change_request_id VARCHAR,
    submission_id VARCHAR,
    change_request_source VARCHAR,
    is_primary_section BOOLEAN DEFAULT FALSE,
    version_id VARCHAR,
    valid_from TIMESTAMP WITHOUT TIME ZONE,
    valid_to TIMESTAMP WITHOUT TIME ZONE,
    is_current BOOLEAN DEFAULT TRUE,
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
    land_ownership_type VARCHAR,
    certificate_storage_id TEXT,
    land_size VARCHAR,
    unit VARCHAR,
    soil_fertility VARCHAR,
    current_land_use VARCHAR,
    farming_type VARCHAR,
    year_of_acquisition INTEGER,
    means_of_acquisition VARCHAR,
    khata_number VARCHAR,
    khesra_numbers VARCHAR,
    jamabandi_number VARCHAR,
    mauza VARCHAR,
    anchal VARCHAR,
    district VARCHAR,
    rakba_area NUMERIC(10, 2)
);

CREATE TABLE IF NOT EXISTS g2p_intake_form_lands (
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
    land_ownership_type VARCHAR,
    certificate_storage_id TEXT,
    land_size VARCHAR,
    unit VARCHAR,
    soil_fertility VARCHAR,
    current_land_use VARCHAR,
    farming_type VARCHAR,
    year_of_acquisition INTEGER,
    means_of_acquisition VARCHAR,
    khata_number VARCHAR,
    khesra_numbers VARCHAR,
    jamabandi_number VARCHAR,
    mauza VARCHAR,
    anchal VARCHAR,
    district VARCHAR,
    rakba_area NUMERIC(10, 2)
);

CREATE TABLE IF NOT EXISTS g2p_register_crops (
    internal_record_id VARCHAR PRIMARY KEY,
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
    commodity VARCHAR,
    planted_date DATE,
    season VARCHAR,
    end_use VARCHAR,
    area_cultivated_acres NUMERIC(10, 2)
);

ALTER TABLE g2p_register_crops ADD COLUMN IF NOT EXISTS link_foundational_id VARCHAR;
ALTER TABLE g2p_register_crops ADD COLUMN IF NOT EXISTS record_image_storage_id TEXT;
ALTER TABLE g2p_register_crops ADD COLUMN IF NOT EXISTS created_by VARCHAR NOT NULL DEFAULT 'system';
ALTER TABLE g2p_register_crops ADD COLUMN IF NOT EXISTS last_approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE g2p_register_crops ADD COLUMN IF NOT EXISTS last_approved_by VARCHAR NOT NULL DEFAULT 'system';
ALTER TABLE g2p_register_crops ADD COLUMN IF NOT EXISTS search_text TEXT;
ALTER TABLE g2p_register_crops ADD COLUMN IF NOT EXISTS record_status_reason VARCHAR;

CREATE TABLE IF NOT EXISTS g2p_register_history_crops (
    history_record_id VARCHAR PRIMARY KEY DEFAULT gen_random_uuid()::text,
    internal_record_id VARCHAR NOT NULL,
    tab_id VARCHAR,
    section_id VARCHAR,
    change_request_id VARCHAR,
    submission_id VARCHAR,
    change_request_source VARCHAR,
    is_primary_section BOOLEAN DEFAULT FALSE,
    version_id VARCHAR,
    valid_from TIMESTAMP WITHOUT TIME ZONE,
    valid_to TIMESTAMP WITHOUT TIME ZONE,
    is_current BOOLEAN DEFAULT TRUE,
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
    commodity VARCHAR,
    planted_date DATE,
    season VARCHAR,
    end_use VARCHAR,
    area_cultivated_acres NUMERIC(10, 2)
);

CREATE TABLE IF NOT EXISTS g2p_intake_form_crops (
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
    commodity VARCHAR,
    planted_date DATE,
    season VARCHAR,
    end_use VARCHAR,
    area_cultivated_acres NUMERIC(10, 2)
);


-- ============================================================================
-- 5. OpenG2P Register Metadata Definitions
-- ============================================================================

-- Register Definition for Farmer
DELETE FROM g2p_register_definitions WHERE register_id = 'a0000000-0000-4000-8000-000000000003';
INSERT INTO g2p_register_definitions (
    register_id, register_mnemonic, register_subject, register_description,
    master_register_id, register_rank, functional_id_generation_required,
    register_purpose, program_id, program_mnemonic, register_icon,
    has_image, dedup_is_enabled, dedup_threshold_score,
    completion_score_required, outgest_applicable,
    requires_registrant_authentication, registrant_authentication_validity_days,
    registrant_re_auth_warning_days_before
) VALUES (
    'a0000000-0000-4000-8000-000000000003', 'Farmer', 'Farmers',
    'Farmer register — personal demographics, landholdings, crop cultivation, agricultural inputs and PM-KISAN entitlements',
    NULL, 3, 'TRUE', 'REGISTER',
    NULL, NULL, 'tractor', 'FALSE', 'TRUE', 0.75, 'FALSE', 'FALSE', 'FALSE', 730, 30
);

-- Register Definition for FarmerLand (Child Table)
DELETE FROM g2p_register_definitions WHERE register_id = 'b0000000-0000-4000-8000-000000000050';
INSERT INTO g2p_register_definitions (
    register_id, register_mnemonic, register_subject, register_description,
    master_register_id, register_rank, functional_id_generation_required, register_purpose,
    program_id, program_mnemonic, register_icon,
    has_image, dedup_is_enabled, dedup_threshold_score,
    completion_score_required, outgest_applicable,
    requires_registrant_authentication, registrant_authentication_validity_days,
    registrant_re_auth_warning_days_before
) VALUES (
    'b0000000-0000-4000-8000-000000000050', 'FarmerLand', 'Farmer Land Parcels',
    'Agricultural land parcels owned or operated by farmer',
    'a0000000-0000-4000-8000-000000000003', 50, 'FALSE', 'TABLE',
    NULL, NULL, NULL,
    'FALSE', 'FALSE', 0, 'FALSE', 'FALSE', 'FALSE', 730, 30
);

-- Register Definition for FarmerCrop (Child Table)
DELETE FROM g2p_register_definitions WHERE register_id = 'b0000000-0000-4000-8000-000000000051';
INSERT INTO g2p_register_definitions (
    register_id, register_mnemonic, register_subject, register_description,
    master_register_id, register_rank, functional_id_generation_required, register_purpose,
    program_id, program_mnemonic, register_icon,
    has_image, dedup_is_enabled, dedup_threshold_score,
    completion_score_required, outgest_applicable,
    requires_registrant_authentication, registrant_authentication_validity_days,
    registrant_re_auth_warning_days_before
) VALUES (
    'b0000000-0000-4000-8000-000000000051', 'FarmerCrop', 'Farmer Crops',
    'Standing and seasonal crops cultivated by farmer',
    'a0000000-0000-4000-8000-000000000003', 51, 'FALSE', 'TABLE',
    NULL, NULL, NULL,
    'FALSE', 'FALSE', 0, 'FALSE', 'FALSE', 'FALSE', 730, 30
);

-- ============================================================================
-- 6. Register Sections & UI Schemas for Farmer
-- ============================================================================

DELETE FROM g2p_register_sections WHERE section_id IN ('farmer_personal_section', 'farmer_agristack_section', 'farmer_lands_table', 'farmer_crops_table');

-- Section 1: Farmer Personal Details
INSERT INTO g2p_register_sections (
    section_id, register_id, section_register_id, is_core_section, section_mnemonic,
    documents_required, no_of_verifications_required, is_list, section_weightage,
    cr_auto_approve_for_bene_portal, cr_auto_approve_for_agent_portal,
    cr_auto_approve_for_staff_portal, cr_auto_approve_for_partner, section_ui_schema
) VALUES (
    'farmer_personal_section', 'a0000000-0000-4000-8000-000000000003', 'a0000000-0000-4000-8000-000000000003',
    true, 'farmer_personal_section', false, 0, false, 20, false, false, false, false,
    '{
        "panels": [
            {
                "panels": [
                    {
                        "widgets": [
                            {"widget": "text", "widget-id": "foundational_id", "widget-type": "input", "widget-label": "Aadhaar Number", "widget-required": true, "widget-data-path": "a0000000-0000-4000-8000-000000000003.foundational_id"},
                            {"widget": "text", "widget-id": "first_name", "widget-type": "input", "widget-label": "First Name", "widget-required": true, "widget-data-path": "a0000000-0000-4000-8000-000000000003.first_name"},
                            {"widget": "text", "widget-id": "last_name", "widget-type": "input", "widget-label": "Last Name", "widget-required": true, "widget-data-path": "a0000000-0000-4000-8000-000000000003.last_name"}
                        ],
                        "panel-id": "farmer_col_1",
                        "panel-orientation": "vertical"
                    },
                    {
                        "widgets": [
                            {"widget": "select", "widget-id": "gender", "widget-type": "input", "widget-label": "Gender", "widget-required": true, "widget-data-path": "a0000000-0000-4000-8000-000000000003.gender", "widget-data-source": {"type": "static", "options": [{"label": "MALE", "value": "MALE"}, {"label": "FEMALE", "value": "FEMALE"}, {"label": "OTHER", "value": "OTHER"}]}},
                            {"widget": "date", "widget-id": "birth_date", "widget-type": "input", "widget-label": "Date of Birth", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.birth_date"},
                            {"widget": "text", "widget-id": "mobile_phone_number", "widget-type": "input", "widget-label": "Mobile Phone Number", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.mobile_phone_number"}
                        ],
                        "panel-id": "farmer_col_2",
                        "panel-orientation": "vertical"
                    },
                    {
                        "widgets": [
                            {"widget": "text", "widget-id": "district", "widget-type": "input", "widget-label": "District", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.district"},
                            {"widget": "text", "widget-id": "block", "widget-type": "input", "widget-label": "Block / Anchal", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.block"},
                            {"widget": "text", "widget-id": "village", "widget-type": "input", "widget-label": "Village / Mauza", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.village"}
                        ],
                        "panel-id": "farmer_col_3",
                        "panel-orientation": "vertical"
                    }
                ],
                "panel-id": "farmer_personal_main",
                "panel-orientation": "horizontal"
            }
        ],
        "section-id": "farmer_personal_section",
        "section-title": "Farmer Identity & Demographics",
        "section-editable": true,
        "section-supporting-documents": []
    }'::jsonb
);

-- Section 2: Farmer AgriStack & PM-KISAN Details
INSERT INTO g2p_register_sections (
    section_id, register_id, section_register_id, is_core_section, section_mnemonic,
    documents_required, no_of_verifications_required, is_list, section_weightage,
    cr_auto_approve_for_bene_portal, cr_auto_approve_for_agent_portal,
    cr_auto_approve_for_staff_portal, cr_auto_approve_for_partner, section_ui_schema
) VALUES (
    'farmer_agristack_section', 'a0000000-0000-4000-8000-000000000003', 'a0000000-0000-4000-8000-000000000003',
    false, 'farmer_agristack_section', false, 0, false, 30, false, false, false, false,
    '{
        "panels": [
            {
                "panels": [
                    {
                        "widgets": [
                            {"widget": "text", "widget-id": "farmer_id", "widget-type": "input", "widget-label": "AgriStack Farmer ID", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.farmer_id"},
                            {"widget": "text", "widget-id": "relation_name", "widget-type": "input", "widget-label": "Father / Relative Name", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.relation_name"},
                            {"widget": "text", "widget-id": "crop_type", "widget-type": "input", "widget-label": "Standing Crops", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.crop_type"}
                        ],
                        "panel-id": "agristack_col_1",
                        "panel-orientation": "vertical"
                    },
                    {
                        "widgets": [
                            {"widget": "number", "widget-id": "land_area_acres", "widget-type": "input", "widget-label": "Operated Land Area (Acres)", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.land_area_acres"},
                            {"widget": "text", "widget-id": "land_ownership_type", "widget-type": "input", "widget-label": "Ownership Type", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.land_ownership_type"},
                            {"widget": "text", "widget-id": "khata_number", "widget-type": "input", "widget-label": "Khata Ledger Number", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.khata_number"},
                            {"widget": "text", "widget-id": "khesra_number", "widget-type": "input", "widget-label": "Plot / Khesra", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.khesra_number"},
                            {"widget": "text", "widget-id": "khatiyan_number", "widget-type": "input", "widget-label": "Khatiyan Reference", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.khatiyan_number"}
                        ],
                        "panel-id": "agristack_col_2",
                        "panel-orientation": "vertical"
                    },
                    {
                        "widgets": [
                            {"widget": "boolean", "widget-id": "pm_kisan_enrolled", "widget-type": "input", "widget-label": "PM-KISAN Enrolled", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.pm_kisan_enrolled"},
                            {"widget": "boolean", "widget-id": "pmfby_enrolled", "widget-type": "input", "widget-label": "PMFBY Insurance Enrolled", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.pmfby_enrolled"},
                            {"widget": "text", "widget-id": "farmer_bank_account_no", "widget-type": "input", "widget-label": "DBT Bank Account", "widget-required": false, "widget-data-path": "a0000000-0000-4000-8000-000000000003.farmer_bank_account_no"}
                        ],
                        "panel-id": "agristack_col_3",
                        "panel-orientation": "vertical"
                    }
                ],
                "panel-id": "farmer_agristack_main",
                "panel-orientation": "horizontal"
            }
        ],
        "section-id": "farmer_agristack_section",
        "section-title": "Farmer AgriStack & Entitlements",
        "section-editable": true,
        "section-supporting-documents": []
    }'::jsonb
);

-- Section 3: Land Parcels Table
INSERT INTO g2p_register_sections (
    section_id, register_id, section_register_id, is_core_section, section_mnemonic,
    documents_required, no_of_verifications_required, is_list, section_weightage,
    cr_auto_approve_for_bene_portal, cr_auto_approve_for_agent_portal,
    cr_auto_approve_for_staff_portal, cr_auto_approve_for_partner, section_ui_schema
) VALUES (
    'farmer_lands_table', 'a0000000-0000-4000-8000-000000000003', 'b0000000-0000-4000-8000-000000000050',
    false, 'farmer_lands_table', false, 0, true, 25, false, false, false, false,
    '{
        "panels": [
            {
                "widgets": [
                    {
                        "widget": "table",
                        "widget-id": "lands_table",
                        "widget-type": "table",
                        "widget-label": "Operated Land Parcels",
                        "widget-readonly": false,
                        "widget-data-path": "b0000000-0000-4000-8000-000000000050.records",
                        "widget-data-columns": [
                            {"widget": "text", "column-key": "jamabandi_number", "widget-label": "Jamabandi Number", "widget-data-path": "jamabandi_number"},
                            {"widget": "text", "column-key": "khata_number", "widget-label": "Khata", "widget-data-path": "khata_number"},
                            {"widget": "text", "column-key": "khesra_numbers", "widget-label": "Plot / Khesra", "widget-data-path": "khesra_numbers"},
                            {"widget": "number", "column-key": "rakba_area", "widget-label": "Area (Acres)", "widget-data-path": "rakba_area", "widget-data-format": {"numericType": "decimal", "decimalPlaces": 2}},
                            {"widget": "text", "column-key": "land_ownership_type", "widget-label": "Ownership Type", "widget-data-path": "land_ownership_type"},
                            {"widget": "text", "column-key": "mauza", "widget-label": "Mauza / Village", "widget-data-path": "mauza"},
                            {"widget": "text", "column-key": "anchal", "widget-label": "Anchal / Block", "widget-data-path": "anchal"},
                            {"widget": "text", "column-key": "district", "widget-label": "District", "widget-data-path": "district"}
                        ],
                        "widget-data-add-label": "Add Land Parcel",
                        "widget-data-operations": {"add": true, "edit": true, "remove": true}
                    }
                ],
                "panel-id": "panel_farmer_lands",
                "panel-column-span": 12,
                "panel-orientation": "vertical"
            }
        ],
        "section-id": "farmer_lands_table",
        "section-title": "Agricultural Land Records",
        "section-editable": true
    }'::jsonb
);

-- Section 4: Crops Cultivated Table
INSERT INTO g2p_register_sections (
    section_id, register_id, section_register_id, is_core_section, section_mnemonic,
    documents_required, no_of_verifications_required, is_list, section_weightage,
    cr_auto_approve_for_bene_portal, cr_auto_approve_for_agent_portal,
    cr_auto_approve_for_staff_portal, cr_auto_approve_for_partner, section_ui_schema
) VALUES (
    'farmer_crops_table', 'a0000000-0000-4000-8000-000000000003', 'b0000000-0000-4000-8000-000000000051',
    false, 'farmer_crops_table', false, 0, true, 25, false, false, false, false,
    '{
        "panels": [
            {
                "widgets": [
                    {
                        "widget": "table",
                        "widget-id": "crops_table",
                        "widget-type": "table",
                        "widget-label": "Crops Cultivated",
                        "widget-readonly": false,
                        "widget-data-path": "b0000000-0000-4000-8000-000000000051.records",
                        "widget-data-columns": [
                            {"widget": "text", "column-key": "commodity", "widget-label": "Crop / Commodity", "widget-data-path": "commodity"},
                            {"widget": "text", "column-key": "season", "widget-label": "Agricultural Season", "widget-data-path": "season"},
                            {"widget": "number", "column-key": "area_cultivated_acres", "widget-label": "Cultivated Area (Acres)", "widget-data-path": "area_cultivated_acres", "widget-data-format": {"numericType": "decimal", "decimalPlaces": 2}},
                            {"widget": "text", "column-key": "end_use", "widget-label": "End Use", "widget-data-path": "end_use"}
                        ],
                        "widget-data-add-label": "Add Crop",
                        "widget-data-operations": {"add": true, "edit": true, "remove": true}
                    }
                ],
                "panel-id": "panel_farmer_crops",
                "panel-column-span": 12,
                "panel-orientation": "vertical"
            }
        ],
        "section-id": "farmer_crops_table",
        "section-title": "Standing Crops & Production",
        "section-editable": true
    }'::jsonb
);

-- ============================================================================
-- 7. Register UI Tabs & Tab Sections Mapping
-- ============================================================================

DELETE FROM g2p_register_ui_tabs WHERE tab_id = 'farmer_info_tab';
INSERT INTO g2p_register_ui_tabs (
    tab_id, register_id, tab_label, tab_order, is_active
) VALUES (
    'farmer_info_tab', 'a0000000-0000-4000-8000-000000000003', 'Farmer Profile', 1, true
);

DELETE FROM g2p_register_ui_tab_sections WHERE tab_id = 'farmer_info_tab';
INSERT INTO g2p_register_ui_tab_sections (tab_section_id, register_id, tab_id, section_id, section_order) VALUES
('b3000000-0000-4000-8000-000000000001', 'a0000000-0000-4000-8000-000000000003', 'farmer_info_tab', 'farmer_personal_section', 10),
('b3000000-0000-4000-8000-000000000002', 'a0000000-0000-4000-8000-000000000003', 'farmer_info_tab', 'farmer_agristack_section', 20),
('b3000000-0000-4000-8000-000000000003', 'a0000000-0000-4000-8000-000000000003', 'farmer_info_tab', 'farmer_lands_table', 30),
('b3000000-0000-4000-8000-000000000004', 'a0000000-0000-4000-8000-000000000003', 'farmer_info_tab', 'farmer_crops_table', 40);

-- ============================================================================
-- 8. Intake Form Definition & Intake Tab Sections
-- ============================================================================

DELETE FROM g2p_intake_form_definitions WHERE form_id = 'c1000000-0000-4000-8000-000000000003';
INSERT INTO g2p_intake_form_definitions (
    form_id, register_id, form_mnemonic, form_description, number_of_verifications, used_only_in_ingestion_pipeline
) VALUES (
    'c1000000-0000-4000-8000-000000000003', 'a0000000-0000-4000-8000-000000000003',
    'farmer_intake_form', 'Farmer Intake Form', 0, false
);

DELETE FROM g2p_intake_form_ui_tabs WHERE tab_id = 'nsr_form_tab_farmer_intake';
INSERT INTO g2p_intake_form_ui_tabs (
    tab_id, form_id, tab_label, tab_order
) VALUES (
    'nsr_form_tab_farmer_intake', 'c1000000-0000-4000-8000-000000000003',
    'Farmer Registration', 1
);

DELETE FROM g2p_intake_form_ui_tab_sections WHERE tab_id = 'nsr_form_tab_farmer_intake';
INSERT INTO g2p_intake_form_ui_tab_sections (tab_section_id, tab_id, section_id, section_order) VALUES
('c2000000-0000-4000-8000-000000000001', 'nsr_form_tab_farmer_intake', 'farmer_personal_section', 1),
('c2000000-0000-4000-8000-000000000002', 'nsr_form_tab_farmer_intake', 'farmer_agristack_section', 2),
('c2000000-0000-4000-8000-000000000003', 'nsr_form_tab_farmer_intake', 'farmer_lands_table', 3),
('c2000000-0000-4000-8000-000000000004', 'nsr_form_tab_farmer_intake', 'farmer_crops_table', 4);

-- 9. Register Schema for Farmer (Search & Filters)
INSERT INTO g2p_register_schemas (register_id, search_result_schema, filter_schema)
VALUES (
    'a0000000-0000-4000-8000-000000000003',
    '[
        {"field_name": "farmer_id", "display_label": "Farmer ID", "order": 1},
        {"field_name": "farmer_name", "display_label": "Farmer Name", "order": 2},
        {"field_name": "foundational_id", "display_label": "Aadhaar ID", "order": 3},
        {"field_name": "village", "display_label": "Village", "order": 4},
        {"field_name": "block", "display_label": "Block", "order": 5},
        {"field_name": "district", "display_label": "District", "order": 6},
        {"field_name": "crop_type", "display_label": "Crops", "order": 7},
        {"field_name": "land_area_acres", "display_label": "Land (Acres)", "order": 8}
    ]'::json,
    '[
        {"field_name": "farmer_name", "display_label": "Farmer Name", "filter_type": "text", "order": 1, "allowed_operators": ["eq", "contains"]},
        {"field_name": "farmer_id", "display_label": "Farmer ID", "filter_type": "text", "order": 2, "allowed_operators": ["eq", "contains"]},
        {"field_name": "foundational_id", "display_label": "Aadhaar", "filter_type": "text", "order": 3, "allowed_operators": ["eq", "contains"]},
        {"field_name": "district", "display_label": "District", "filter_type": "text", "order": 4, "allowed_operators": ["eq", "contains"]},
        {"field_name": "block", "display_label": "Block", "filter_type": "text", "order": 5, "allowed_operators": ["eq", "contains"]},
        {"field_name": "crop_type", "display_label": "Crop Type", "filter_type": "text", "order": 6, "allowed_operators": ["eq", "contains"]},
        {"field_name": "record_status", "display_label": "Record Status", "filter_type": "dropdown", "order": 7, "allowed_operators": ["eq", "in"], "options_source": [{"value": "ACTIVE", "label": "ACTIVE"}, {"value": "INACTIVE", "label": "INACTIVE"}, {"value": "ARCHIVED", "label": "ARCHIVED"}]}
    ]'::json
)
ON CONFLICT (register_id) DO UPDATE SET
    search_result_schema = EXCLUDED.search_result_schema,
    filter_schema = EXCLUDED.filter_schema;

-- 10. Base Person & Geo column compatibility
ALTER TABLE g2p_register_farmers ADD COLUMN IF NOT EXISTS plus_code VARCHAR;
ALTER TABLE g2p_register_farmers ADD COLUMN IF NOT EXISTS geo_lowest_level_value_id VARCHAR;
ALTER TABLE g2p_register_farmers ADD COLUMN IF NOT EXISTS geo_code_hierarchy_json JSONB;
ALTER TABLE g2p_register_farmers ADD COLUMN IF NOT EXISTS middle_name VARCHAR;
ALTER TABLE g2p_register_farmers ADD COLUMN IF NOT EXISTS prefix VARCHAR;
ALTER TABLE g2p_register_farmers ADD COLUMN IF NOT EXISTS suffix VARCHAR;
ALTER TABLE g2p_register_farmers ADD COLUMN IF NOT EXISTS phone_numbers JSON;
ALTER TABLE g2p_register_farmers ADD COLUMN IF NOT EXISTS emails JSON;
ALTER TABLE g2p_register_farmers ADD COLUMN IF NOT EXISTS occupation VARCHAR;
ALTER TABLE g2p_register_farmers ADD COLUMN IF NOT EXISTS income_level VARCHAR;
ALTER TABLE g2p_register_farmers ADD COLUMN IF NOT EXISTS language_code VARCHAR;
ALTER TABLE g2p_register_farmers ADD COLUMN IF NOT EXISTS registration_date DATE;

ALTER TABLE g2p_register_history_farmers ADD COLUMN IF NOT EXISTS plus_code VARCHAR;
ALTER TABLE g2p_register_history_farmers ADD COLUMN IF NOT EXISTS geo_lowest_level_value_id VARCHAR;
ALTER TABLE g2p_register_history_farmers ADD COLUMN IF NOT EXISTS geo_code_hierarchy_json JSONB;
ALTER TABLE g2p_register_history_farmers ADD COLUMN IF NOT EXISTS middle_name VARCHAR;
ALTER TABLE g2p_register_history_farmers ADD COLUMN IF NOT EXISTS prefix VARCHAR;
ALTER TABLE g2p_register_history_farmers ADD COLUMN IF NOT EXISTS suffix VARCHAR;
ALTER TABLE g2p_register_history_farmers ADD COLUMN IF NOT EXISTS phone_numbers JSON;
ALTER TABLE g2p_register_history_farmers ADD COLUMN IF NOT EXISTS emails JSON;
ALTER TABLE g2p_register_history_farmers ADD COLUMN IF NOT EXISTS occupation VARCHAR;
ALTER TABLE g2p_register_history_farmers ADD COLUMN IF NOT EXISTS income_level VARCHAR;
ALTER TABLE g2p_register_history_farmers ADD COLUMN IF NOT EXISTS language_code VARCHAR;
ALTER TABLE g2p_register_history_farmers ADD COLUMN IF NOT EXISTS registration_date DATE;

ALTER TABLE g2p_intake_form_farmers ADD COLUMN IF NOT EXISTS plus_code VARCHAR;
ALTER TABLE g2p_intake_form_farmers ADD COLUMN IF NOT EXISTS geo_lowest_level_value_id VARCHAR;
ALTER TABLE g2p_intake_form_farmers ADD COLUMN IF NOT EXISTS geo_code_hierarchy_json JSONB;
ALTER TABLE g2p_intake_form_farmers ADD COLUMN IF NOT EXISTS middle_name VARCHAR;
ALTER TABLE g2p_intake_form_farmers ADD COLUMN IF NOT EXISTS prefix VARCHAR;
ALTER TABLE g2p_intake_form_farmers ADD COLUMN IF NOT EXISTS suffix VARCHAR;
ALTER TABLE g2p_intake_form_farmers ADD COLUMN IF NOT EXISTS phone_numbers JSON;
ALTER TABLE g2p_intake_form_farmers ADD COLUMN IF NOT EXISTS emails JSON;
ALTER TABLE g2p_intake_form_farmers ADD COLUMN IF NOT EXISTS occupation VARCHAR;
ALTER TABLE g2p_intake_form_farmers ADD COLUMN IF NOT EXISTS income_level VARCHAR;
ALTER TABLE g2p_intake_form_farmers ADD COLUMN IF NOT EXISTS language_code VARCHAR;
ALTER TABLE g2p_intake_form_farmers ADD COLUMN IF NOT EXISTS registration_date DATE;

ALTER TABLE g2p_intake_form_lands ADD COLUMN IF NOT EXISTS application_reference VARCHAR;
ALTER TABLE g2p_intake_form_lands ADD COLUMN IF NOT EXISTS link_foundational_id VARCHAR;
ALTER TABLE g2p_intake_form_lands ADD COLUMN IF NOT EXISTS record_image_storage_id TEXT;
ALTER TABLE g2p_intake_form_lands ADD COLUMN IF NOT EXISTS created_by VARCHAR NOT NULL DEFAULT 'system';
ALTER TABLE g2p_intake_form_lands ADD COLUMN IF NOT EXISTS last_approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE g2p_intake_form_lands ADD COLUMN IF NOT EXISTS last_approved_by VARCHAR NOT NULL DEFAULT 'system';
ALTER TABLE g2p_intake_form_lands ADD COLUMN IF NOT EXISTS search_text TEXT;
ALTER TABLE g2p_intake_form_lands ADD COLUMN IF NOT EXISTS record_status_reason VARCHAR;

ALTER TABLE g2p_intake_form_crops ADD COLUMN IF NOT EXISTS application_reference VARCHAR;
ALTER TABLE g2p_intake_form_crops ADD COLUMN IF NOT EXISTS link_foundational_id VARCHAR;
ALTER TABLE g2p_intake_form_crops ADD COLUMN IF NOT EXISTS record_image_storage_id TEXT;
ALTER TABLE g2p_intake_form_crops ADD COLUMN IF NOT EXISTS created_by VARCHAR NOT NULL DEFAULT 'system';
ALTER TABLE g2p_intake_form_crops ADD COLUMN IF NOT EXISTS last_approved_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE g2p_intake_form_crops ADD COLUMN IF NOT EXISTS last_approved_by VARCHAR NOT NULL DEFAULT 'system';
ALTER TABLE g2p_intake_form_crops ADD COLUMN IF NOT EXISTS search_text TEXT;
ALTER TABLE g2p_intake_form_crops ADD COLUMN IF NOT EXISTS record_status_reason VARCHAR;

ALTER TABLE g2p_register_lands ADD COLUMN IF NOT EXISTS record_image_document_id TEXT;
ALTER TABLE g2p_register_history_lands ADD COLUMN IF NOT EXISTS record_image_document_id TEXT;
ALTER TABLE g2p_intake_form_lands ADD COLUMN IF NOT EXISTS record_image_document_id TEXT;

ALTER TABLE g2p_register_crops ADD COLUMN IF NOT EXISTS record_image_document_id TEXT;
ALTER TABLE g2p_register_history_crops ADD COLUMN IF NOT EXISTS record_image_document_id TEXT;
ALTER TABLE g2p_intake_form_crops ADD COLUMN IF NOT EXISTS record_image_document_id TEXT;

-- 11. Farmer AWE Approval Workflow Policy Configuration
INSERT INTO g2p_registry_awe_policy_configurations (
    awe_policy_config_id, policy_scope, register_id, intake_form_id, section_id, policy_type, policy_key, context_field_names
) VALUES
    ('a2000000-0000-4000-8000-000000000003', 'REGISTER', 'a0000000-0000-4000-8000-000000000003', '', '', 'registry.change_request', 'registry.change_request.individual', 'null'),
    ('a2000000-0000-4000-8000-000000000013', 'INTAKE_FORM', 'a0000000-0000-4000-8000-000000000003', 'c1000000-0000-4000-8000-000000000003', '', 'registry.intake_form', 'registry.intake_form.individual', 'null')
ON CONFLICT (awe_policy_config_id) DO NOTHING;

COMMIT;
