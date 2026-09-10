from datetime import date
from openg2p_registry_core.models.g2p_intake_form import G2PIntakeForm
from sqlalchemy import Boolean, Date, Integer, Numeric, String
from sqlalchemy.orm import Mapped, mapped_column
from openg2p_registry_core.models import (
    G2PRegister,
    G2PRegisterHistory,
    G2PGeo,
    G2PGeoHistory,
    G2PPerson,
    G2PPersonHistory,
)
from ..services import G2PRegisterDomainServiceStudent


class G2PStudent:
    """Domain mixin for Student Registry."""

    # Student Identification & Demographics
    student_id: Mapped[str | None] = mapped_column(String, nullable=True, index=True)
    udise_student_id: Mapped[str | None] = mapped_column(String, nullable=True, index=True)
    apaar_id: Mapped[str | None] = mapped_column(String, nullable=True, index=True)
    pen_number: Mapped[str | None] = mapped_column(String, nullable=True, index=True)
    guardian_aadhaar_number: Mapped[str | None] = mapped_column(String, nullable=True)
    father_name: Mapped[str | None] = mapped_column(String, nullable=True)
    mother_name: Mapped[str | None] = mapped_column(String, nullable=True)
    guardian_name: Mapped[str | None] = mapped_column(String, nullable=True)
    social_category: Mapped[str | None] = mapped_column(String, nullable=True)
    mobile_phone_number: Mapped[str | None] = mapped_column(String, nullable=True)
    email: Mapped[str | None] = mapped_column(String, nullable=True)

    # School & Institutional Affiliation
    school_name: Mapped[str | None] = mapped_column(String, nullable=True)
    school_udise_code: Mapped[str | None] = mapped_column(String, nullable=True, index=True)
    education_level: Mapped[str | None] = mapped_column(String, nullable=True)
    class_grade: Mapped[str | None] = mapped_column(String, nullable=True)
    stream: Mapped[str | None] = mapped_column(String, nullable=True)
    roll_number: Mapped[str | None] = mapped_column(String, nullable=True)
    enrollment_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    attendance_percentage: Mapped[float | None] = mapped_column(Numeric(5, 2), nullable=True)
    medium_of_instruction: Mapped[str | None] = mapped_column(String, nullable=True)

    # Entitlements & Banking
    scholarship_status: Mapped[str | None] = mapped_column(String, nullable=True)
    bank_account_no: Mapped[str | None] = mapped_column(String, nullable=True)
    bank_name: Mapped[str | None] = mapped_column(String, nullable=True)
    ifsc_code: Mapped[str | None] = mapped_column(String, nullable=True)

    # Location / Address Details
    village: Mapped[str | None] = mapped_column(String, nullable=True)
    block: Mapped[str | None] = mapped_column(String, nullable=True)
    district: Mapped[str | None] = mapped_column(String, nullable=True)
    state: Mapped[str | None] = mapped_column(String, nullable=True)


class G2PRegisterStudent(G2PRegister, G2PGeo, G2PPerson, G2PStudent):
    __tablename__ = "g2p_register_students"

    def get_search_text_fields(self) -> str:
        """Return student search text."""
        return G2PRegisterDomainServiceStudent().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        """Return student record name."""
        return G2PRegisterDomainServiceStudent().construct_record_name(self.to_dict())


class G2PRegisterHistoryStudent(G2PRegisterHistory, G2PGeoHistory, G2PPersonHistory, G2PStudent):
    __tablename__ = "g2p_register_history_students"


class G2PIntakeFormStudent(G2PIntakeForm, G2PRegister, G2PGeo, G2PPerson, G2PStudent):
    __tablename__ = "g2p_intake_form_students"

    def get_search_text_fields(self) -> str:
        return G2PRegisterDomainServiceStudent().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        return G2PRegisterDomainServiceStudent().construct_intake_record_name(self.to_dict())
