import logging
from openg2p_registry_core.services import G2PRegisterDomainService

_logger = logging.getLogger("g2p-register-domain-service-student-academic")


class G2PRegisterDomainServiceStudentAcademic(G2PRegisterDomainService):
    async def validate_domain_attributes(self, records: list[dict]):
        return

    def construct_search_text(self, payload: dict, extra: list[str] = None) -> str:
        _logger.info("Constructing search text for student academic record")
        keys = [
            "functional_record_id",
            "exam_name",
            "board_or_university",
            "passing_year",
            "division_or_grade",
        ]
        search_text = []
        if extra:
            search_text.extend(str(v).strip() for v in extra if str(v).strip())
        search_text.extend(
            str(payload.get(key) or "").strip()
            for key in keys
            if str(payload.get(key) or "").strip()
        )
        return " ".join(search_text).strip()

    def construct_record_name(self, payload: dict, extra: list[str] = None) -> str:
        _logger.info("Constructing record name for student academic record")
        exam = payload.get("exam_name") or "Examination"
        year = payload.get("passing_year")
        board = payload.get("board_or_university")
        parts = [exam]
        if year:
            parts.append(str(year))
        if board:
            parts.append(board)
        return " - ".join(parts)

    def construct_intake_record_name(self, payload: dict, extra: list[str] = None) -> str:
        return self.construct_record_name(payload, extra)
