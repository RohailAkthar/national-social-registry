from typing import Optional

from openg2p_registry_core.schemas import (
    G2PRegisterBaseSchema,
    G2PPersonSchema,
    G2PGeoSchema,
    G2PRegisterHistorySchema,
    G2PPersonHistorySchema,
    G2PGeoHistorySchema,
    G2PIntakeFormSchemaBase,
)


class G2PSchemaFarmer:
    """Schema mixin for Farmer Register attributes."""

    # Standard farmer demographics & attributes
    estimated_age: Optional[int] = None
    has_personal_phone: Optional[bool] = None
    disabled: Optional[bool] = None
    disability_type: Optional[str] = None
    disability_severity: Optional[str] = None
    source_of_income: Optional[str] = None
    source_of_income_other: Optional[str] = None
    language_spoken: Optional[str] = None
    education_level: Optional[str] = None
    national_id_masked: Optional[str] = None

    # AgriStack & agricultural profile
    farmer_id: Optional[str] = None
    farmer_name: Optional[str] = None
    relation_name: Optional[str] = None
    farmer_mobile_number: Optional[str] = None
    mobile_phone_number: Optional[str] = None
    crop_type: Optional[str] = None
    land_area_acres: Optional[float] = None
    land_ownership_type: Optional[str] = None
    khata_number: Optional[str] = None
    khesra_number: Optional[str] = None
    khatiyan_number: Optional[str] = None
    pm_kisan_enrolled: Optional[bool] = None
    pmfby_enrolled: Optional[bool] = None
    farmer_bank_account_no: Optional[str] = None
    bank_name: Optional[str] = None
    ifsc_code: Optional[str] = None
    village: Optional[str] = None
    block: Optional[str] = None
    district: Optional[str] = None


class G2PRegisterSchemaFarmer(
    G2PRegisterBaseSchema, G2PPersonSchema, G2PGeoSchema, G2PSchemaFarmer
):
    """Schema for Farmer register."""
    pass


class G2PRegisterHistorySchemaFarmer(
    G2PRegisterHistorySchema, G2PPersonHistorySchema, G2PGeoHistorySchema
):
    """Schema for Farmer history."""
    pass


class G2PIntakeFormSchemaFarmer(
    G2PIntakeFormSchemaBase,
    G2PRegisterBaseSchema,
    G2PPersonSchema,
    G2PGeoSchema,
    G2PSchemaFarmer,
):
    """Schema for Farmer intake form."""
    pass
