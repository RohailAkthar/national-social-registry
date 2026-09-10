from datetime import date

from openg2p_registry_core.models.g2p_intake_form import G2PIntakeForm
from sqlalchemy import Boolean, Date, Integer, Numeric, String, text
from sqlalchemy.orm import Mapped, mapped_column
from openg2p_registry_core.models import (
    G2PRegister,
    G2PRegisterHistory,
    G2PGeo,
    G2PGeoHistory,
)
from ..services import G2PRegisterDomainServiceHousehold
from .enums import (
    CookingFuelEnum,
    DwellingTypeEnum,
    HeadshipTypeEnum,
    LightingSourceEnum,
    MobilePhoneTypeEnum,
    SanitationTypeEnum,
    TenureStatusEnum,
    WaterSourceTypeEnum,
)


class G2PHousehold:

    household_head_person_id: Mapped[str | None] = mapped_column(String, nullable=True)
    household_head_internal_record_id: Mapped[str | None] = mapped_column(
        String, nullable=True, index=True
    )
    household_head_name: Mapped[str | None] = mapped_column(String, nullable=True)
    headship_type: Mapped[HeadshipTypeEnum] = mapped_column(String, nullable=True)

    husband_dead: Mapped[bool] = mapped_column(
        Boolean, nullable=True, server_default=text("false")
    )
    husband_dead_date: Mapped[date | None] = mapped_column(Date, nullable=True)

    size_total: Mapped[int] = mapped_column(Integer, nullable=True)
    size_adults: Mapped[int] = mapped_column(Integer, nullable=True)
    size_children_u5: Mapped[int] = mapped_column(Integer, nullable=True)
    size_school_age: Mapped[int] = mapped_column(Integer, nullable=True)
    size_elderly: Mapped[int] = mapped_column(Integer, nullable=True)
    number_of_female_members: Mapped[int] = mapped_column(Integer, nullable=True)
    number_of_male_members: Mapped[int] = mapped_column(Integer, nullable=True)
    elderly_member_present: Mapped[bool] = mapped_column(Boolean, nullable=True)

    dwelling_type: Mapped[DwellingTypeEnum] = mapped_column(String, nullable=True)
    roof_material: Mapped[str] = mapped_column(String, nullable=True)
    wall_material: Mapped[str] = mapped_column(String, nullable=True)
    floor_material: Mapped[str] = mapped_column(String, nullable=True)
    tenure_status: Mapped[TenureStatusEnum] = mapped_column(String, nullable=True)
    rooms_count: Mapped[int] = mapped_column(Integer, nullable=True)
    overcrowding_indicator: Mapped[float] = mapped_column(Numeric, nullable=True)

    water_source_type: Mapped[WaterSourceTypeEnum] = mapped_column(String, nullable=True)
    water_distance_minutes: Mapped[int] = mapped_column(Integer, nullable=True)
    sanitation_type: Mapped[SanitationTypeEnum] = mapped_column(String, nullable=True)
    lighting_source: Mapped[LightingSourceEnum] = mapped_column(String, nullable=True)
    cooking_fuel_type: Mapped[CookingFuelEnum] = mapped_column(String, nullable=True)
    mobile_phone_type: Mapped[MobilePhoneTypeEnum] = mapped_column(String, nullable=True)

    # Location Details (Bihar / NSR hierarchy)
    region_code: Mapped[str | None] = mapped_column(String, nullable=True)
    zone_subcity_code: Mapped[str | None] = mapped_column(String, nullable=True)
    woreda_code: Mapped[str | None] = mapped_column(String, nullable=True)
    locality_ea_code: Mapped[str | None] = mapped_column(String, nullable=True)
    kebele_code: Mapped[str | None] = mapped_column(String, nullable=True)
    address_descriptor: Mapped[str | None] = mapped_column(String, nullable=True)

    # PDS Food Security (Ration Card)
    ration_card_number: Mapped[str | None] = mapped_column(String, nullable=True)
    ration_card_type: Mapped[str | None] = mapped_column(String, nullable=True)
    fps_shop_code: Mapped[str | None] = mapped_column(String, nullable=True)
    dealer_name: Mapped[str | None] = mapped_column(String, nullable=True)
    monthly_entitlement_kg: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    e_kyc_status: Mapped[str | None] = mapped_column(String, nullable=True)



class G2PRegisterHousehold(G2PRegister, G2PGeo, G2PHousehold):
    __tablename__ = "g2p_register_households"
    __table_args__ = {"extend_existing": True}

    def get_search_text_fields(self) -> str:
        """Return household fields used to build search_text."""
        return G2PRegisterDomainServiceHousehold().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        """Return household record_name from domain service implementation."""
        return G2PRegisterDomainServiceHousehold().construct_record_name(self.to_dict())


class G2PRegisterHistoryHousehold(G2PRegisterHistory, G2PGeoHistory, G2PHousehold):
    __tablename__ = "g2p_register_history_households"
    __table_args__ = {"extend_existing": True}


class G2PIntakeFormHousehold(G2PIntakeForm, G2PRegister, G2PGeo, G2PHousehold):
    __tablename__ = "g2p_intake_form_households"
    __table_args__ = {"extend_existing": True}

    def get_search_text_fields(self) -> str:
        """Return household fields used to build search_text."""
        return G2PRegisterDomainServiceHousehold().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        """Return household intake record_name from domain service implementation."""
        return G2PRegisterDomainServiceHousehold().construct_intake_record_name(self.to_dict())
