from datetime import date
from typing import Optional

from openg2p_registry_core.schemas import (
    G2PRegisterBaseSchema,
    G2PRegisterHistorySchema,
    G2PIntakeFormSchemaBase,
)


class G2PSchemaFarmerCrop:
    """Schema mixin for Farmer Standing and Seasonal Crops."""

    commodity: Optional[str] = None
    planted_date: Optional[date] = None
    season: Optional[str] = None
    end_use: Optional[str] = None
    area_cultivated_acres: Optional[float] = None


class G2PRegisterSchemaFarmerCrop(G2PRegisterBaseSchema, G2PSchemaFarmerCrop):
    """Schema for FarmerCrop register."""
    pass


class G2PRegisterHistorySchemaFarmerCrop(G2PRegisterHistorySchema):
    """Schema for FarmerCrop history."""
    pass


class G2PIntakeFormSchemaFarmerCrop(
    G2PIntakeFormSchemaBase, G2PRegisterBaseSchema, G2PSchemaFarmerCrop
):
    """Schema for FarmerCrop intake form."""
    pass
