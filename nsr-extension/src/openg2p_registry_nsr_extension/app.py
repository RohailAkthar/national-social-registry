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
)

_logger = logging.getLogger(_config.logging_default_logger_name)


class Initializer(BaseInitializer):
    def initialize(self, **kwargs):
        super().initialize()
        CoreInitializer().initialize()

        G2PRegisterDomainFactory()
        G2PRegisterDomainServiceIndividual()
        G2PRegisterDomainServiceHousehold()

    async def fastapi_app_startup(self, app):
        await super().fastapi_app_startup(app)

        # 1. Execute GramStack database migrations and core fixes first
        import os
        from openg2p_fastapi_common.context import dbengine

        direct_sqls = [
            "ALTER TABLE g2p_intake_form_submissions ADD COLUMN IF NOT EXISTS application_reference VARCHAR;",
            "ALTER TABLE g2p_intake_form_individuals ADD COLUMN IF NOT EXISTS application_reference VARCHAR;",
            "ALTER TABLE g2p_register_individuals ADD COLUMN IF NOT EXISTS application_reference VARCHAR;",
            "ALTER TABLE g2p_register_history_individuals ADD COLUMN IF NOT EXISTS application_reference VARCHAR;",
            "ALTER TABLE g2p_intake_form_households ADD COLUMN IF NOT EXISTS application_reference VARCHAR;",
            "ALTER TABLE g2p_register_households ADD COLUMN IF NOT EXISTS application_reference VARCHAR;",
            "ALTER TABLE g2p_register_history_households ADD COLUMN IF NOT EXISTS application_reference VARCHAR;",
            "ALTER TABLE g2p_registry_configuration ADD COLUMN IF NOT EXISTS registry_favicon VARCHAR;",
        ]

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

