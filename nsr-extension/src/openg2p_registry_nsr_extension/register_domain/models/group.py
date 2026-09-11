from datetime import date
from openg2p_registry_core.models.g2p_intake_form import G2PIntakeForm
from sqlalchemy import Boolean, Date, Integer, Numeric, String
from sqlalchemy.orm import Mapped, mapped_column
from openg2p_registry_core.models import (
    G2PRegister,
    G2PRegisterHistory,
    G2PGeo,
    G2PGeoHistory,
)
from ..services import G2PRegisterDomainServiceGroup


class G2PGroup:
    """Domain mixin for Group / Self-Help Group (SHG) Register (JEEViKA LokOS)."""

    # Group Identification & Hierarchy
    group_name: Mapped[str | None] = mapped_column(String, nullable=True)
    group_type: Mapped[str | None] = mapped_column(String, nullable=True)
    shg_id: Mapped[str | None] = mapped_column(String, nullable=True, index=True)
    shg_code: Mapped[str | None] = mapped_column(String, nullable=True, index=True)
    lokos_id: Mapped[str | None] = mapped_column(String, nullable=True, index=True)
    vo_id: Mapped[str | None] = mapped_column(String, nullable=True)
    vo_name: Mapped[str | None] = mapped_column(String, nullable=True)
    clf_id: Mapped[str | None] = mapped_column(String, nullable=True)
    clf_name: Mapped[str | None] = mapped_column(String, nullable=True)

    # Key Representative / Office Bearer
    member_id: Mapped[str | None] = mapped_column(String, nullable=True, index=True)
    key_member_name: Mapped[str | None] = mapped_column(String, nullable=True)
    key_member_aadhaar: Mapped[str | None] = mapped_column(String, nullable=True)
    key_member_role: Mapped[str | None] = mapped_column(String, nullable=True)
    key_member_mobile: Mapped[str | None] = mapped_column(String, nullable=True)

    # Banking & Financial Metrics
    bank_name: Mapped[str | None] = mapped_column(String, nullable=True)
    bank_account_no: Mapped[str | None] = mapped_column(String, nullable=True)
    ifsc_code: Mapped[str | None] = mapped_column(String, nullable=True)
    monthly_savings_amount: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    internal_loan_outstanding: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    ccl_limit: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    ccl_utilised: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)

    # Governance & Operational Attributes
    shg_grading: Mapped[str | None] = mapped_column(String, nullable=True)
    formation_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    meeting_frequency: Mapped[str | None] = mapped_column(String, nullable=True)

    # Geographic Location
    district: Mapped[str | None] = mapped_column(String, nullable=True)
    block: Mapped[str | None] = mapped_column(String, nullable=True)
    gram_panchayat: Mapped[str | None] = mapped_column(String, nullable=True)
    village: Mapped[str | None] = mapped_column(String, nullable=True)
    pin_code: Mapped[str | None] = mapped_column(String, nullable=True)


class G2PRegisterGroup(G2PRegister, G2PGeo, G2PGroup):
    __tablename__ = "g2p_register_groups"
    __table_args__ = {"extend_existing": True}

    def get_search_text_fields(self) -> str:
        """Return group search text."""
        return G2PRegisterDomainServiceGroup().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        """Return group record name."""
        return G2PRegisterDomainServiceGroup().construct_record_name(self.to_dict())


class G2PRegisterHistoryGroup(G2PRegisterHistory, G2PGeoHistory, G2PGroup):
    __tablename__ = "g2p_register_history_groups"
    __table_args__ = {"extend_existing": True}


class G2PIntakeFormGroup(G2PIntakeForm, G2PRegister, G2PGeo, G2PGroup):
    __tablename__ = "g2p_intake_form_groups"
    __table_args__ = {"extend_existing": True}

    def get_search_text_fields(self) -> str:
        return G2PRegisterDomainServiceGroup().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        return G2PRegisterDomainServiceGroup().construct_intake_record_name(self.to_dict())
