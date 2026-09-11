from datetime import date
from typing import Optional

from openg2p_registry_core.schemas import (
    G2PRegisterBaseSchema,
    G2PGeoSchema,
    G2PRegisterHistorySchema,
    G2PGeoHistorySchema,
    G2PIntakeFormSchemaBase,
)


class G2PSchemaGroup:
    """Schema mixin for Group / Self-Help Group (SHG) Register (JEEViKA LokOS)."""

    # Group Identification & Hierarchy
    group_name: Optional[str] = None
    group_type: Optional[str] = None
    shg_id: Optional[str] = None
    shg_code: Optional[str] = None
    lokos_id: Optional[str] = None
    vo_id: Optional[str] = None
    vo_name: Optional[str] = None
    clf_id: Optional[str] = None
    clf_name: Optional[str] = None

    # Key Representative / Office Bearer
    member_id: Optional[str] = None
    key_member_name: Optional[str] = None
    key_member_aadhaar: Optional[str] = None
    key_member_role: Optional[str] = None
    key_member_mobile: Optional[str] = None

    # Banking & Financial Metrics
    bank_name: Optional[str] = None
    bank_account_no: Optional[str] = None
    ifsc_code: Optional[str] = None
    monthly_savings_amount: Optional[float] = None
    internal_loan_outstanding: Optional[float] = None
    ccl_limit: Optional[float] = None
    ccl_utilised: Optional[float] = None

    # Governance & Operational Attributes
    shg_grading: Optional[str] = None
    formation_date: Optional[date] = None
    meeting_frequency: Optional[str] = None

    # Geographic Location
    district: Optional[str] = None
    block: Optional[str] = None
    gram_panchayat: Optional[str] = None
    village: Optional[str] = None
    pin_code: Optional[str] = None


class G2PRegisterSchemaGroup(G2PRegisterBaseSchema, G2PGeoSchema, G2PSchemaGroup):
    """Schema for Group register."""
    pass


class G2PRegisterHistorySchemaGroup(G2PRegisterHistorySchema, G2PGeoHistorySchema):
    """Schema for Group history."""
    pass


class G2PIntakeFormSchemaGroup(
    G2PIntakeFormSchemaBase, G2PRegisterBaseSchema, G2PGeoSchema, G2PSchemaGroup
):
    """Schema for Group intake form."""
    pass
