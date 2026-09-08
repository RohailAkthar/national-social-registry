from datetime import date

from sqlalchemy import Date, Integer, Numeric, String, select
from sqlalchemy.orm import Mapped, mapped_column, Session

from openg2p_registry_core.models import G2PRegister, G2PRegisterHistory
from openg2p_registry_core.models.g2p_intake_form import G2PIntakeForm

from ..services import G2PRegisterDomainServiceHouseholdProgram
from .enums import ProgramEnum
from .household import G2PIntakeFormHousehold


class G2PHouseholdProgram:
    program_name: Mapped[ProgramEnum] = mapped_column(String, nullable=True)
    program_start_date: Mapped[date] = mapped_column(Date, nullable=True)
    program_exit_date: Mapped[date] = mapped_column(Date, nullable=True)

    # PDS Food Security (Ration Card) fields
    ration_card_number: Mapped[str | None] = mapped_column(String, nullable=True)
    ration_card_type: Mapped[str | None] = mapped_column(String, nullable=True)
    head_of_household_name: Mapped[str | None] = mapped_column(String, nullable=True)
    family_member_count: Mapped[int | None] = mapped_column(Integer, nullable=True)
    fps_shop_code: Mapped[str | None] = mapped_column(String, nullable=True)
    dealer_name: Mapped[str | None] = mapped_column(String, nullable=True)
    e_kyc_status: Mapped[str | None] = mapped_column(String, nullable=True)
    last_transaction_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    monthly_entitlement_kg: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    district: Mapped[str | None] = mapped_column(String, nullable=True)
    block: Mapped[str | None] = mapped_column(String, nullable=True)

    # JEEViKA Self-Help Group (SHG LokOS) fields
    shg_id: Mapped[str | None] = mapped_column(String, nullable=True)
    shg_name: Mapped[str | None] = mapped_column(String, nullable=True)
    vo_id: Mapped[str | None] = mapped_column(String, nullable=True)
    vo_name: Mapped[str | None] = mapped_column(String, nullable=True)
    clf_id: Mapped[str | None] = mapped_column(String, nullable=True)
    clf_name: Mapped[str | None] = mapped_column(String, nullable=True)
    member_name: Mapped[str | None] = mapped_column(String, nullable=True)
    shg_role: Mapped[str | None] = mapped_column(String, nullable=True)
    shg_grading: Mapped[str | None] = mapped_column(String, nullable=True)
    monthly_savings_amount: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    internal_loan_outstanding: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    ccl_limit: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    ccl_utilised: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    bank_account_no: Mapped[str | None] = mapped_column(String, nullable=True)
    ifsc: Mapped[str | None] = mapped_column(String, nullable=True)
    shg_join_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    gp: Mapped[str | None] = mapped_column(String, nullable=True)
    village: Mapped[str | None] = mapped_column(String, nullable=True)


class G2PRegisterHouseholdProgram(G2PRegister, G2PHouseholdProgram):
    __tablename__ = "g2p_register_household_programs"

    def get_record_name_fields(self) -> str:
        """Return household programs fields used to build record_name."""
        return G2PRegisterDomainServiceHouseholdProgram().construct_record_name(self.to_dict())

    def get_search_text_fields(self) -> str:
        """Return household programs fields used to build search_text."""
        return G2PRegisterDomainServiceHouseholdProgram().construct_search_text(self.to_dict())


# All Intake Form classes should have the prefix G2PIntakeForm
class G2PIntakeFormHouseholdProgram(G2PIntakeForm, G2PRegister, G2PHouseholdProgram):
    __tablename__ = "g2p_intake_form_household_programs"

    def get_record_name_fields(self) -> str:
        """Return household programs fields used to build record_name."""
        return G2PRegisterDomainServiceHouseholdProgram().construct_intake_record_name(self.to_dict())

    def get_search_text_fields(self) -> str:
        """Return household programs fields used to build search_text."""
        return G2PRegisterDomainServiceHouseholdProgram().construct_search_text(self.to_dict())

    async def get_link_internal_record_id(self, session: Session):
        result = await session.execute(
            select(G2PIntakeFormHousehold).where(
                G2PIntakeFormHousehold.submission_id == self.submission_id
            )
        )
        household = result.scalars().first()
        if household:
            self.link_internal_record_id = household.internal_record_id


class G2PRegisterHistoryHouseholdProgram(G2PRegisterHistory, G2PHouseholdProgram):
    __tablename__ = "g2p_register_history_household_programs"
