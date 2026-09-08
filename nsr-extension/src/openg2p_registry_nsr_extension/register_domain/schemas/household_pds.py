from typing import Optional
from openg2p_registry_core.schemas import (
    G2PRegisterBaseSchema,
    G2PRegisterHistorySchema,
    G2PIntakeFormSchemaBase,
)


class G2PRegisterSchemaHouseholdPds(G2PRegisterBaseSchema):
    program_name: Optional[str] = "PDS_FOOD_SECURITY"
    ration_card_number: Optional[str] = None
    ration_card_type: Optional[str] = None
    head_of_household_name: Optional[str] = None
    family_member_count: Optional[int] = None
    fps_shop_code: Optional[str] = None
    dealer_name: Optional[str] = None
    e_kyc_status: Optional[str] = None
    last_transaction_date: Optional[str] = None
    monthly_entitlement_kg: Optional[float] = None
    district: Optional[str] = None
    block: Optional[str] = None


class G2PIntakeFormSchemaHouseholdPds(G2PIntakeFormSchemaBase, G2PRegisterSchemaHouseholdPds):
    pass


class G2PRegisterHistorySchemaHouseholdPds(G2PRegisterHistorySchema):
    program_name: Optional[str] = "PDS_FOOD_SECURITY"
    ration_card_number: Optional[str] = None
    ration_card_type: Optional[str] = None
    head_of_household_name: Optional[str] = None
    family_member_count: Optional[int] = None
    fps_shop_code: Optional[str] = None
    dealer_name: Optional[str] = None
    e_kyc_status: Optional[str] = None
    last_transaction_date: Optional[str] = None
    monthly_entitlement_kg: Optional[float] = None
    district: Optional[str] = None
    block: Optional[str] = None
