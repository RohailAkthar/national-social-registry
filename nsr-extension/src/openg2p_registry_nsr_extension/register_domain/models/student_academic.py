from openg2p_registry_core.models.g2p_intake_form import G2PIntakeForm
from sqlalchemy import Integer, Numeric, String, select
from sqlalchemy.orm import Mapped, mapped_column, Session
from openg2p_registry_core.models import G2PRegister, G2PRegisterHistory
from ..services import G2PRegisterDomainServiceStudentAcademic


class G2PStudentAcademic:
    """Domain mixin for Student Academic & Examination Records."""

    exam_name: Mapped[str | None] = mapped_column(String, nullable=True)
    board_or_university: Mapped[str | None] = mapped_column(String, nullable=True)
    passing_year: Mapped[int | None] = mapped_column(Integer, nullable=True)
    marks_obtained: Mapped[float | None] = mapped_column(Numeric(6, 2), nullable=True)
    total_marks: Mapped[float | None] = mapped_column(Numeric(6, 2), nullable=True)
    percentage_or_cgpa: Mapped[float | None] = mapped_column(Numeric(5, 2), nullable=True)
    division_or_grade: Mapped[str | None] = mapped_column(String, nullable=True)


class G2PRegisterStudentAcademic(G2PRegister, G2PStudentAcademic):
    __tablename__ = "g2p_register_student_academics"

    def get_search_text_fields(self) -> str:
        return G2PRegisterDomainServiceStudentAcademic().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        return G2PRegisterDomainServiceStudentAcademic().construct_record_name(self.to_dict())


class G2PRegisterHistoryStudentAcademic(G2PRegisterHistory, G2PStudentAcademic):
    __tablename__ = "g2p_register_history_student_academics"


class G2PIntakeFormStudentAcademic(G2PIntakeForm, G2PRegister, G2PStudentAcademic):
    __tablename__ = "g2p_intake_form_student_academics"

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
        return G2PRegisterDomainServiceStudentAcademic().construct_search_text(self.to_dict())

    def get_record_name_fields(self) -> str:
        return G2PRegisterDomainServiceStudentAcademic().construct_intake_record_name(self.to_dict())
