from datetime import date
from openg2p_registry_core.models.g2p_intake_form import G2PIntakeForm
from sqlalchemy import Date, Numeric, String, select
from sqlalchemy.orm import Mapped, mapped_column, Session
from openg2p_registry_core.models import G2PRegister, G2PRegisterHistory
from ..services import G2PRegisterDomainServiceFarmerCrop


class G2PFarmerCrop:
    """Domain mixin for Farmer Standing and Seasonal Crops."""

    commodity: Mapped[str | None] = mapped_column(String, nullable=True)
    planted_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    season: Mapped[str | None] = mapped_column(String, nullable=True)
    end_use: Mapped[str | None] = mapped_column(String, nullable=True)
    area_cultivated_acres: Mapped[float | None] = mapped_column(Numeric, nullable=True)


class G2PRegisterFarmerCrop(G2PRegister, G2PFarmerCrop):
    __tablename__ = "g2p_register_crops"

    def get_search_text_fields(self) -> str:
        return G2PRegisterDomainServiceFarmerCrop().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        return G2PRegisterDomainServiceFarmerCrop().construct_record_name(self.to_dict())


class G2PRegisterHistoryFarmerCrop(G2PRegisterHistory, G2PFarmerCrop):
    __tablename__ = "g2p_register_history_crops"


class G2PIntakeFormFarmerCrop(G2PIntakeForm, G2PRegister, G2PFarmerCrop):
    __tablename__ = "g2p_intake_form_crops"

    async def get_link_internal_record_id(self, session: Session):
        from .farmer import G2PIntakeFormFarmer

        result = await session.execute(
            select(G2PIntakeFormFarmer).where(
                G2PIntakeFormFarmer.submission_id == self.submission_id
            )
        )
        farmer = result.scalars().first()
        if farmer:
            self.link_internal_record_id = farmer.internal_record_id

    def get_search_text_fields(self) -> str:
        return G2PRegisterDomainServiceFarmerCrop().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        return G2PRegisterDomainServiceFarmerCrop().construct_intake_record_name(self.to_dict())
