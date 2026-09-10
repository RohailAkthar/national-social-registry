from typing import Optional

from openg2p_registry_core.schemas import (
    G2PRegisterBaseSchema,
    G2PRegisterHistorySchema,
    G2PIntakeFormSchemaBase,
)


class G2PSchemaFarmerLand:
    """Schema mixin for Farmer Land Parcels."""

    land_ownership_type: Optional[str] = None
    certificate_storage_id: Optional[str] = None
    land_size: Optional[str] = None
    unit: Optional[str] = None
    soil_fertility: Optional[str] = None
    current_land_use: Optional[str] = None
    farming_type: Optional[str] = None
    year_of_acquisition: Optional[int] = None
    means_of_acquisition: Optional[str] = None
    khata_number: Optional[str] = None
    khesra_numbers: Optional[str] = None
    jamabandi_number: Optional[str] = None
    mauza: Optional[str] = None
    anchal: Optional[str] = None
    district: Optional[str] = None
    rakba_area: Optional[float] = None


class G2PRegisterSchemaFarmerLand(G2PRegisterBaseSchema, G2PSchemaFarmerLand):
    """Schema for FarmerLand register."""
    pass


class G2PRegisterHistorySchemaFarmerLand(G2PRegisterHistorySchema):
    """Schema for FarmerLand history."""
    pass


class G2PIntakeFormSchemaFarmerLand(
    G2PIntakeFormSchemaBase, G2PRegisterBaseSchema, G2PSchemaFarmerLand
):
    """Schema for FarmerLand intake form."""
    pass
