from typing import Optional

from openg2p_registry_core.schemas import (
    G2PRegisterBaseSchema,
    G2PRegisterHistorySchema,
    G2PIntakeFormSchemaBase,
)


class G2PSchemaStudentAcademic:
    """Schema mixin for Student Academic Performance & Exams."""

    exam_name: Optional[str] = None
    board_or_university: Optional[str] = None
    passing_year: Optional[int] = None
    marks_obtained: Optional[float] = None
    total_marks: Optional[float] = None
    percentage_or_cgpa: Optional[float] = None
    division_or_grade: Optional[str] = None


class G2PRegisterSchemaStudentAcademic(G2PRegisterBaseSchema, G2PSchemaStudentAcademic):
    """Schema for StudentAcademic register."""
    pass


class G2PRegisterHistorySchemaStudentAcademic(G2PRegisterHistorySchema):
    """Schema for StudentAcademic history."""
    pass


class G2PIntakeFormSchemaStudentAcademic(
    G2PIntakeFormSchemaBase, G2PRegisterBaseSchema, G2PSchemaStudentAcademic
):
    """Schema for StudentAcademic intake form."""
    pass
