from datetime import date
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


class G2PSchemaStudent:
    """Schema mixin for Student Register attributes."""

    student_id: Optional[str] = None
    udise_student_id: Optional[str] = None
    apaar_id: Optional[str] = None
    pen_number: Optional[str] = None
    guardian_aadhaar_number: Optional[str] = None
    father_name: Optional[str] = None
    mother_name: Optional[str] = None
    guardian_name: Optional[str] = None
    social_category: Optional[str] = None
    mobile_phone_number: Optional[str] = None
    email: Optional[str] = None

    school_name: Optional[str] = None
    school_udise_code: Optional[str] = None
    education_level: Optional[str] = None
    class_grade: Optional[str] = None
    stream: Optional[str] = None
    roll_number: Optional[str] = None
    enrollment_date: Optional[date] = None
    attendance_percentage: Optional[float] = None
    medium_of_instruction: Optional[str] = None

    scholarship_status: Optional[str] = None
    bank_account_no: Optional[str] = None
    bank_name: Optional[str] = None
    ifsc_code: Optional[str] = None

    village: Optional[str] = None
    block: Optional[str] = None
    district: Optional[str] = None
    state: Optional[str] = None


class G2PRegisterSchemaStudent(
    G2PRegisterBaseSchema, G2PPersonSchema, G2PGeoSchema, G2PSchemaStudent
):
    """Schema for Student register."""
    pass


class G2PRegisterHistorySchemaStudent(
    G2PRegisterHistorySchema, G2PPersonHistorySchema, G2PGeoHistorySchema
):
    """Schema for Student history."""
    pass


class G2PIntakeFormSchemaStudent(
    G2PIntakeFormSchemaBase,
    G2PRegisterBaseSchema,
    G2PPersonSchema,
    G2PGeoSchema,
    G2PSchemaStudent,
):
    """Schema for Student intake form."""
    pass
