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
from ..services import G2PRegisterDomainServiceFarmer


class G2PFarmer:
    """Domain mixin for Farmer Register (OpenG2P + AgriStack)."""

    # OpenG2P standard farmer fields
    estimated_age: Mapped[int | None] = mapped_column(Integer, nullable=True)
    has_personal_phone: Mapped[bool | None] = mapped_column(Boolean, nullable=True)
    disabled: Mapped[bool | None] = mapped_column(Boolean, nullable=True)
    disability_type: Mapped[str | None] = mapped_column(String, nullable=True)
    disability_severity: Mapped[str | None] = mapped_column(String, nullable=True)
    source_of_income: Mapped[str | None] = mapped_column(String, nullable=True)
    source_of_income_other: Mapped[str | None] = mapped_column(String, nullable=True)
    language_spoken: Mapped[str | None] = mapped_column(String, nullable=True)
    education_level: Mapped[str | None] = mapped_column(String, nullable=True)
    national_id_masked: Mapped[str | None] = mapped_column(String, nullable=True)

    # AgriStack & GramStack agricultural attributes
    farmer_id: Mapped[str | None] = mapped_column(String, nullable=True, index=True)
    farmer_name: Mapped[str | None] = mapped_column(String, nullable=True)
    relation_name: Mapped[str | None] = mapped_column(String, nullable=True)
    farmer_mobile_number: Mapped[str | None] = mapped_column(String, nullable=True)
    mobile_phone_number: Mapped[str | None] = mapped_column(String, nullable=True)
    crop_type: Mapped[str | None] = mapped_column(String, nullable=True)
    land_area_acres: Mapped[float | None] = mapped_column(Numeric(10, 2), nullable=True)
    land_ownership_type: Mapped[str | None] = mapped_column(String, nullable=True)
    khata_number: Mapped[str | None] = mapped_column(String, nullable=True)
    khesra_number: Mapped[str | None] = mapped_column(String, nullable=True)
    khatiyan_number: Mapped[str | None] = mapped_column(String, nullable=True)
    pm_kisan_enrolled: Mapped[bool | None] = mapped_column(Boolean, nullable=True)
    pmfby_enrolled: Mapped[bool | None] = mapped_column(Boolean, nullable=True)
    farmer_bank_account_no: Mapped[str | None] = mapped_column(String, nullable=True)
    bank_name: Mapped[str | None] = mapped_column(String, nullable=True)
    ifsc_code: Mapped[str | None] = mapped_column(String, nullable=True)
    village: Mapped[str | None] = mapped_column(String, nullable=True)
    block: Mapped[str | None] = mapped_column(String, nullable=True)
    district: Mapped[str | None] = mapped_column(String, nullable=True)


class G2PRegisterFarmer(G2PRegister, G2PGeo, G2PPerson, G2PFarmer):
    __tablename__ = "g2p_register_farmers"
    __table_args__ = {"extend_existing": True}

    def get_search_text_fields(self) -> str:
        """Return farmer search text."""
        return G2PRegisterDomainServiceFarmer().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        """Return farmer record name."""
        return G2PRegisterDomainServiceFarmer().construct_record_name(self.to_dict())


class G2PRegisterHistoryFarmer(G2PRegisterHistory, G2PGeoHistory, G2PPersonHistory, G2PFarmer):
    __tablename__ = "g2p_register_history_farmers"
    __table_args__ = {"extend_existing": True}


class G2PIntakeFormFarmer(G2PIntakeForm, G2PRegister, G2PGeo, G2PPerson, G2PFarmer):
    __tablename__ = "g2p_intake_form_farmers"
    __table_args__ = {"extend_existing": True}

    def get_search_text_fields(self) -> str:
        return G2PRegisterDomainServiceFarmer().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        return G2PRegisterDomainServiceFarmer().construct_intake_record_name(self.to_dict())
