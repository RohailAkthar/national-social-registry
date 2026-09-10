# ruff: noqa: E402
import asyncio
import logging

from .config import Settings

_config = Settings.get_config()

from openg2p_fastapi_common.app import Initializer as BaseInitializer
from openg2p_registry_core.app import Initializer as CoreInitializer

from .register_domain.models import (
    G2PRegisterIndividual,
    G2PRegisterHistoryIndividual,
    G2PIntakeFormIndividual,
    G2PRegisterIndividualDisability,
    G2PRegisterHistoryIndividualDisability,
    G2PIntakeFormIndividualDisability,
    G2PRegisterHousehold,
    G2PRegisterHistoryHousehold,
    G2PIntakeFormHousehold,
    G2PRegisterIndividualProgram,
    G2PRegisterHistoryIndividualProgram,
    G2PIntakeFormIndividualProgram,
    G2PRegisterHouseholdProgram,
    G2PRegisterHistoryHouseholdProgram,
    G2PIntakeFormHouseholdProgram,
    G2PRegisterHouseholdAsset,
    G2PRegisterHistoryHouseholdAsset,
    G2PIntakeFormHouseholdAsset,
    G2PRegisterIndividualShock,
    G2PRegisterHistoryIndividualShock,
    G2PIntakeFormIndividualShock,
    G2PRegisterHouseholdHousingAndServices,
    G2PRegisterHistoryHouseholdHousingAndServices,
    G2PIntakeFormHouseholdHousingAndServices,
    G2PRegisterIndividualLand,
    G2PRegisterHistoryIndividualLand,
    G2PIntakeFormIndividualLand,
    G2PRegisterIndividualLivelihood,
    G2PRegisterHistoryIndividualLivelihood,
    G2PIntakeFormIndividualLivelihood,
    G2PRegisterIndividualLivestock,
    G2PRegisterHistoryIndividualLivestock,
    G2PIntakeFormIndividualLivestock,
    G2PRegisterIndividualVulnerability,
    G2PRegisterHistoryIndividualVulnerability,
    G2PIntakeFormIndividualVulnerability,
    G2PRegisterHouseholdPds,
    G2PRegisterHistoryHouseholdPds,
    G2PIntakeFormHouseholdPds,
)
from .register_domain.factory import G2PRegisterDomainFactory
from .register_domain.services import (
    G2PRegisterDomainServiceIndividual,
    G2PRegisterDomainServiceHousehold,
    G2PRegisterDomainServiceFarmer,
)

_logger = logging.getLogger(_config.logging_default_logger_name)


class Initializer(BaseInitializer):
    def initialize(self, **kwargs):
        super().initialize()
        CoreInitializer().initialize()

        G2PRegisterDomainFactory()
        G2PRegisterDomainServiceIndividual()
        G2PRegisterDomainServiceHousehold()
        G2PRegisterDomainServiceFarmer()

    async def fastapi_app_startup(self, app):
        await super().fastapi_app_startup(app)

        # 1. Execute GramStack database migrations and core fixes first
        import os
        from openg2p_fastapi_common.context import dbengine

        direct_sqls = [
            "ALTER TABLE g2p_registry_configuration ADD COLUMN IF NOT EXISTS registry_favicon VARCHAR;",
        ]

        all_core_tables = [
            "g2p_intake_form_submissions",
            "g2p_intake_form_individuals", "g2p_register_individuals", "g2p_register_history_individuals",
            "g2p_intake_form_individual_disabilities", "g2p_register_individual_disabilities", "g2p_register_history_individual_disabilities",
            "g2p_intake_form_individual_land", "g2p_register_individual_land", "g2p_register_history_individual_land",
            "g2p_intake_form_individual_livelihoods", "g2p_register_individual_livelihoods", "g2p_register_history_individual_livelihoods",
            "g2p_intake_form_individual_livestock", "g2p_register_individual_livestock", "g2p_register_history_individual_livestock",
            "g2p_intake_form_individual_programs", "g2p_register_individual_programs", "g2p_register_history_individual_programs",
            "g2p_intake_form_individual_shocks", "g2p_register_individual_shocks", "g2p_register_history_individual_shocks",
            "g2p_intake_form_individual_vulnerability", "g2p_register_individual_vulnerability", "g2p_register_history_individual_vulnerability",
            "g2p_intake_form_households", "g2p_register_households", "g2p_register_history_households",
            "g2p_intake_form_household_assets", "g2p_register_household_assets", "g2p_register_history_household_assets",
            "g2p_intake_form_household_housing_and_services", "g2p_register_household_housing_and_services", "g2p_register_history_household_housing_and_services",
            "g2p_intake_form_household_pds", "g2p_register_household_pds", "g2p_register_history_household_pds",
            "g2p_intake_form_household_programs", "g2p_register_household_programs", "g2p_register_history_household_programs",
            "g2p_intake_form_farmers", "g2p_register_farmers", "g2p_register_history_farmers",
            "g2p_intake_form_farmer_lands", "g2p_register_farmer_lands", "g2p_register_history_farmer_lands",
            "g2p_intake_form_farmer_crops", "g2p_register_farmer_crops", "g2p_register_history_farmer_crops",
            "g2p_intake_form_lands", "g2p_register_lands", "g2p_register_history_lands",
            "g2p_intake_form_crops", "g2p_register_crops", "g2p_register_history_crops",
        ]
        for tbl in all_core_tables:
            direct_sqls.append(
                f"DO $$ BEGIN IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = '{tbl}') THEN "
                f"ALTER TABLE {tbl} ADD COLUMN IF NOT EXISTS application_reference VARCHAR; "
                f"ALTER TABLE {tbl} ADD COLUMN IF NOT EXISTS record_image_document_id TEXT; "
                f"ALTER TABLE {tbl} ADD COLUMN IF NOT EXISTS record_image_storage_id TEXT; "
                f"ALTER TABLE {tbl} ADD COLUMN IF NOT EXISTS link_foundational_id VARCHAR; "
                f"END IF; END $$;"
            )

        household_cols = [
            "household_head_person_id VARCHAR",
            "household_head_internal_record_id VARCHAR",
            "household_head_name VARCHAR",
            "headship_type VARCHAR",
            "husband_dead BOOLEAN DEFAULT FALSE",
            "husband_dead_date DATE",
            "size_total INTEGER",
            "size_adults INTEGER",
            "size_children_u5 INTEGER",
            "size_school_age INTEGER",
            "size_elderly INTEGER",
            "number_of_female_members INTEGER",
            "number_of_male_members INTEGER",
            "elderly_member_present BOOLEAN",
            "dwelling_type VARCHAR",
            "roof_material VARCHAR",
            "wall_material VARCHAR",
            "floor_material VARCHAR",
            "tenure_status VARCHAR",
            "rooms_count INTEGER",
            "overcrowding_indicator NUMERIC",
            "water_source_type VARCHAR",
            "water_distance_minutes INTEGER",
            "sanitation_type VARCHAR",
            "lighting_source VARCHAR",
            "cooking_fuel_type VARCHAR",
            "mobile_phone_type VARCHAR",
            "region_code VARCHAR",
            "zone_subcity_code VARCHAR",
            "woreda_code VARCHAR",
            "locality_ea_code VARCHAR",
            "kebele_code VARCHAR",
            "address_descriptor VARCHAR",
        ]
        for tbl in ["g2p_intake_form_households", "g2p_register_households", "g2p_register_history_households"]:
            for col in household_cols:
                direct_sqls.append(f"ALTER TABLE {tbl} ADD COLUMN IF NOT EXISTS {col};")

        household_asset_cols = [
            "asset_type VARCHAR", "asset_category VARCHAR", "quantity INTEGER", "size_value NUMERIC",
            "size_unit VARCHAR", "size_band VARCHAR", "details JSON",
            "jamabandi_number VARCHAR", "khata_number VARCHAR", "khesra_numbers VARCHAR",
            "rayat_name VARCHAR", "rakba_area NUMERIC(12, 2)", "land_type VARCHAR",
            "mauza VARCHAR", "anchal VARCHAR", "district VARCHAR",
            "mutation_status VARCHAR", "last_mutation_date DATE", "lpc_status VARCHAR",
            "lpc_certificate_number VARCHAR", "encumbrance_status VARCHAR",
            "bhu_lagan_paid_status BOOLEAN", "registration_deed_number VARCHAR",
        ]
        for tbl in ["g2p_intake_form_household_assets", "g2p_register_household_assets", "g2p_register_history_household_assets"]:
            for col in household_asset_cols:
                direct_sqls.append(
                    f"DO $$ BEGIN IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = '{tbl}') THEN "
                    f"ALTER TABLE {tbl} ADD COLUMN IF NOT EXISTS {col}; END IF; END $$;"
                )

        household_program_cols = [
            "program_name VARCHAR", "program_start_date DATE", "program_exit_date DATE",
            "ration_card_number VARCHAR", "ration_card_type VARCHAR", "head_of_household_name VARCHAR",
            "family_member_count INTEGER", "fps_shop_code VARCHAR", "dealer_name VARCHAR",
            "e_kyc_status VARCHAR", "last_transaction_date DATE", "monthly_entitlement_kg NUMERIC(12, 2)",
            "district VARCHAR", "block VARCHAR", "shg_id VARCHAR", "shg_name VARCHAR",
            "vo_id VARCHAR", "vo_name VARCHAR", "clf_id VARCHAR", "clf_name VARCHAR",
            "member_id VARCHAR", "member_name VARCHAR", "shg_role VARCHAR", "shg_grading VARCHAR",
            "monthly_savings_amount NUMERIC(12, 2)", "internal_loan_outstanding NUMERIC(12, 2)",
            "ccl_limit NUMERIC(12, 2)", "ccl_utilised NUMERIC(12, 2)", "bank_account_no VARCHAR",
            "ifsc VARCHAR", "shg_join_date DATE", "gp VARCHAR", "village VARCHAR",
        ]
        for tbl in ["g2p_intake_form_household_programs", "g2p_register_household_programs", "g2p_register_history_household_programs"]:
            for col in household_program_cols:
                direct_sqls.append(
                    f"DO $$ BEGIN IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = '{tbl}') THEN "
                    f"ALTER TABLE {tbl} ADD COLUMN IF NOT EXISTS {col}; END IF; END $$;"
                )

        household_pds_cols = [
            "program_name VARCHAR", "ration_card_number VARCHAR", "ration_card_type VARCHAR",
            "head_of_household_name VARCHAR", "family_member_count INTEGER", "fps_shop_code VARCHAR",
            "dealer_name VARCHAR", "e_kyc_status VARCHAR", "last_transaction_date VARCHAR",
            "monthly_entitlement_kg NUMERIC(12, 2)", "district VARCHAR", "block VARCHAR",
        ]
        for tbl in ["g2p_intake_form_household_pds", "g2p_register_household_pds", "g2p_register_history_household_pds"]:
            for col in household_pds_cols:
                direct_sqls.append(
                    f"DO $$ BEGIN IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = '{tbl}') THEN "
                    f"ALTER TABLE {tbl} ADD COLUMN IF NOT EXISTS {col}; END IF; END $$;"
                )

        # Fix g2p_registry_documents columns expected by base image model
        direct_sqls.extend([
            "ALTER TABLE g2p_registry_documents ADD COLUMN IF NOT EXISTS source_filename VARCHAR;",
            "ALTER TABLE g2p_registry_documents ADD COLUMN IF NOT EXISTS bucket VARCHAR DEFAULT 'default';",
            "ALTER TABLE g2p_registry_documents ADD COLUMN IF NOT EXISTS created_by VARCHAR;",
            "ALTER TABLE g2p_registry_documents ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT now();",
        ])

        # Ensure g2p_intake_section_documents table exists
        direct_sqls.append(
            "CREATE TABLE IF NOT EXISTS g2p_intake_section_documents ("
            "submission_id UUID NOT NULL, "
            "document_id VARCHAR NOT NULL, "
            "section_id VARCHAR NOT NULL, "
            "label VARCHAR NOT NULL, "
            "PRIMARY KEY (submission_id, document_id));"
        )

        # Ensure g2p_register_section_documents has label column
        direct_sqls.append(
            "ALTER TABLE g2p_register_section_documents ADD COLUMN IF NOT EXISTS label VARCHAR;"
        )

        try:
            async with dbengine.get().connect() as conn:
                raw_conn = await conn.get_raw_connection()
                for query in direct_sqls:
                    try:
                        await raw_conn.driver_connection.execute(query)
                    except Exception as e:
                        _logger.debug(f"Direct SQL notice: {e}")
        except Exception as e:
            _logger.error(f"Error applying core platform column fixes: {e}")

        # 2. Execute GramStack SQL scripts (columns + 7 clean UI sections)
        scripts = [
            "g2p_individual_gramstack_columns.sql",
            "g2p_individual_ui_columns_supplement.sql",
            "g2p_individual_ui_sections.sql",
            "g2p_farmer_registry.sql",
        ]
        for script_name in scripts:
            candidates = [
                os.path.join(os.path.dirname(__file__), f"meta_data/register-metadata/{script_name}"),
                f"/app/nsr-extension/src/openg2p_registry_nsr_extension/meta_data/register-metadata/{script_name}",
            ]
            for sql_file in candidates:
                if os.path.exists(sql_file):
                    try:
                        _logger.info(f"Applying startup SQL migration: {sql_file}")
                        with open(sql_file, "r") as f:
                            sql_content = f.read()
                        async with dbengine.get().connect() as conn:
                            raw_conn = await conn.get_raw_connection()
                            await raw_conn.driver_connection.execute(sql_content)
                        _logger.info(f"Successfully applied {script_name}")
                        break
                    except Exception as e:
                        _logger.error(f"Error applying {script_name}: {e}", exc_info=True)

        # 3. Start background deduplication worker
        from .deduplication_worker import start_deduplication_worker
        start_deduplication_worker()

    def migrate_database(self, args):

        async def migrate():
            _logger.info("Migrating extensions database")

            await G2PRegisterHousehold.create_migrate()
            await G2PRegisterHistoryHousehold.create_migrate()
            await G2PIntakeFormHousehold.create_migrate()

            await G2PRegisterIndividual.create_migrate()
            await G2PRegisterHistoryIndividual.create_migrate()
            await G2PIntakeFormIndividual.create_migrate()

            await G2PRegisterIndividualDisability.create_migrate()
            await G2PRegisterHistoryIndividualDisability.create_migrate()
            await G2PIntakeFormIndividualDisability.create_migrate()

            await G2PRegisterIndividualProgram.create_migrate()
            await G2PRegisterHistoryIndividualProgram.create_migrate()
            await G2PIntakeFormIndividualProgram.create_migrate()

            await G2PRegisterHouseholdProgram.create_migrate()
            await G2PRegisterHistoryHouseholdProgram.create_migrate()
            await G2PIntakeFormHouseholdProgram.create_migrate()

            await G2PRegisterHouseholdAsset.create_migrate()
            await G2PRegisterHistoryHouseholdAsset.create_migrate()
            await G2PIntakeFormHouseholdAsset.create_migrate()

            await G2PRegisterIndividualShock.create_migrate()
            await G2PRegisterHistoryIndividualShock.create_migrate()
            await G2PIntakeFormIndividualShock.create_migrate()

            await G2PRegisterHouseholdHousingAndServices.create_migrate()
            await G2PRegisterHistoryHouseholdHousingAndServices.create_migrate()
            await G2PIntakeFormHouseholdHousingAndServices.create_migrate()

            await G2PRegisterIndividualLand.create_migrate()
            await G2PRegisterHistoryIndividualLand.create_migrate()
            await G2PIntakeFormIndividualLand.create_migrate()

            await G2PRegisterIndividualLivelihood.create_migrate()
            await G2PRegisterHistoryIndividualLivelihood.create_migrate()
            await G2PIntakeFormIndividualLivelihood.create_migrate()

            await G2PRegisterIndividualLivestock.create_migrate()
            await G2PRegisterHistoryIndividualLivestock.create_migrate()
            await G2PIntakeFormIndividualLivestock.create_migrate()

            await G2PRegisterIndividualVulnerability.create_migrate()
            await G2PRegisterHistoryIndividualVulnerability.create_migrate()
            await G2PIntakeFormIndividualVulnerability.create_migrate()

            await G2PRegisterHouseholdPds.create_migrate()
            await G2PRegisterHistoryHouseholdPds.create_migrate()
            await G2PIntakeFormHouseholdPds.create_migrate()

            import os
            from sqlalchemy import text
            from openg2p_fastapi_common.context import dbengine

            scripts = [
                "g2p_individual_gramstack_columns.sql",
                "g2p_individual_ui_columns_supplement.sql",
                "g2p_individual_ui_sections.sql",
                "g2p_farmer_registry.sql",
            ]
            for script_name in scripts:
                sql_file = os.path.join(
                    os.path.dirname(__file__),
                    f"meta_data/register-metadata/{script_name}",
                )
                if os.path.exists(sql_file):
                    try:
                        with open(sql_file, "r") as f:
                            sql_content = f.read()
                        async with dbengine.get().begin() as conn:
                            await conn.execute(text(sql_content))
                        _logger.info(f"Executed {script_name} successfully")
                    except Exception as e:
                        _logger.error(f"Error executing {script_name}: {e}")

        asyncio.run(migrate())

