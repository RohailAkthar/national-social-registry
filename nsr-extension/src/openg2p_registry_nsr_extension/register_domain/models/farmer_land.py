from openg2p_registry_core.models.g2p_intake_form import G2PIntakeForm
from sqlalchemy import Integer, Numeric, String, Text, select
from sqlalchemy.orm import Mapped, mapped_column, Session
from openg2p_registry_core.models import G2PRegister, G2PRegisterHistory
from ..services import G2PRegisterDomainServiceFarmerLand


class G2PFarmerLand:
    """Domain mixin for Farmer Land Parcels."""

    land_ownership_type: Mapped[str | None] = mapped_column(String, nullable=True)
    certificate_storage_id: Mapped[str | None] = mapped_column(Text, nullable=True)
    land_size: Mapped[str | None] = mapped_column(String, nullable=True)
    unit: Mapped[str | None] = mapped_column(String, nullable=True)
    soil_fertility: Mapped[str | None] = mapped_column(String, nullable=True)
    current_land_use: Mapped[str | None] = mapped_column(String, nullable=True)
    farming_type: Mapped[str | None] = mapped_column(String, nullable=True)
    year_of_acquisition: Mapped[int | None] = mapped_column(Integer, nullable=True)
    means_of_acquisition: Mapped[str | None] = mapped_column(String, nullable=True)
    khata_number: Mapped[str | None] = mapped_column(String, nullable=True)
    khesra_numbers: Mapped[str | None] = mapped_column(String, nullable=True)
    jamabandi_number: Mapped[str | None] = mapped_column(String, nullable=True)
    mauza: Mapped[str | None] = mapped_column(String, nullable=True)
    anchal: Mapped[str | None] = mapped_column(String, nullable=True)
    district: Mapped[str | None] = mapped_column(String, nullable=True)
    rakba_area: Mapped[float | None] = mapped_column(Numeric(10, 2), nullable=True)


class G2PRegisterFarmerLand(G2PRegister, G2PFarmerLand):
    __tablename__ = "g2p_register_lands"

    def get_search_text_fields(self) -> str:
        return G2PRegisterDomainServiceFarmerLand().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        return G2PRegisterDomainServiceFarmerLand().construct_record_name(self.to_dict())


class G2PRegisterHistoryFarmerLand(G2PRegisterHistory, G2PFarmerLand):
    __tablename__ = "g2p_register_history_lands"


class G2PIntakeFormFarmerLand(G2PIntakeForm, G2PRegister, G2PFarmerLand):
    __tablename__ = "g2p_intake_form_lands"

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
        return G2PRegisterDomainServiceFarmerLand().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        return G2PRegisterDomainServiceFarmerLand().construct_intake_record_name(self.to_dict())
