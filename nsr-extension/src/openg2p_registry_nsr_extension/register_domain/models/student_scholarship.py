from datetime import date
from openg2p_registry_core.models.g2p_intake_form import G2PIntakeForm
from sqlalchemy import Date, Numeric, String, select
from sqlalchemy.orm import Mapped, mapped_column, Session
from openg2p_registry_core.models import G2PRegister, G2PRegisterHistory
from ..services import G2PRegisterDomainServiceStudentScholarship


class G2PStudentScholarship:
    """Domain mixin for Student Scholarships & Entitlements."""

    scheme_name: Mapped[str | None] = mapped_column(String, nullable=True)
    academic_year: Mapped[str | None] = mapped_column(String, nullable=True)
    sanctioned_amount: Mapped[float | None] = mapped_column(Numeric(10, 2), nullable=True)
    disbursement_status: Mapped[str | None] = mapped_column(String, nullable=True)
    disbursement_date: Mapped[date | None] = mapped_column(Date, nullable=True)
    transaction_reference: Mapped[str | None] = mapped_column(String, nullable=True)


class G2PRegisterStudentScholarship(G2PRegister, G2PStudentScholarship):
    __tablename__ = "g2p_register_student_scholarships"

    def get_search_text_fields(self) -> str:
        return G2PRegisterDomainServiceStudentScholarship().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        return G2PRegisterDomainServiceStudentScholarship().construct_record_name(self.to_dict())


class G2PRegisterHistoryStudentScholarship(G2PRegisterHistory, G2PStudentScholarship):
    __tablename__ = "g2p_register_history_student_scholarships"


class G2PIntakeFormStudentScholarship(G2PIntakeForm, G2PRegister, G2PStudentScholarship):
    __tablename__ = "g2p_intake_form_student_scholarships"

    async def get_link_internal_record_id(self, session: Session):
        from .student import G2PIntakeFormStudent

        result = await session.execute(
            select(G2PIntakeFormStudent).where(
                G2PIntakeFormStudent.submission_id == self.submission_id
            )
        )
        student = result.scalars().first()
        if student:
            self.link_internal_record_id = student.internal_record_id

    def get_search_text_fields(self) -> str:
        return G2PRegisterDomainServiceStudentScholarship().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        return G2PRegisterDomainServiceStudentScholarship().construct_intake_record_name(self.to_dict())
