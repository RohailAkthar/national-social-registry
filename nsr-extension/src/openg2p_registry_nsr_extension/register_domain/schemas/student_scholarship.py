from datetime import date
from typing import Optional

from openg2p_registry_core.schemas import (
    G2PRegisterBaseSchema,
    G2PRegisterHistorySchema,
    G2PIntakeFormSchemaBase,
)


class G2PSchemaStudentScholarship:
    """Schema mixin for Student Scholarships & Entitlements."""

    scheme_name: Optional[str] = None
    academic_year: Optional[str] = None
    sanctioned_amount: Optional[float] = None
    disbursement_status: Optional[str] = None
    disbursement_date: Optional[date] = None
    transaction_reference: Optional[str] = None


class G2PRegisterSchemaStudentScholarship(G2PRegisterBaseSchema, G2PSchemaStudentScholarship):
    """Schema for StudentScholarship register."""
    pass


class G2PRegisterHistorySchemaStudentScholarship(G2PRegisterHistorySchema):
    """Schema for StudentScholarship history."""
    pass


class G2PIntakeFormSchemaStudentScholarship(
    G2PIntakeFormSchemaBase, G2PRegisterBaseSchema, G2PSchemaStudentScholarship
):
    """Schema for StudentScholarship intake form."""
    pass
