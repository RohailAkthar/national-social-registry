import logging
from openg2p_registry_core.services import G2PRegisterDomainService

_logger = logging.getLogger("g2p-register-domain-service-student")


class G2PRegisterDomainServiceStudent(G2PRegisterDomainService):
    async def validate_domain_attributes(self, records: list[dict]):
        pass

    def construct_search_text(self, payload: dict, extra: list[str] = None) -> str:
        _logger.info("Constructing search text for student")
        keys = [
            "first_name",
            "last_name",
            "foundational_id",
            "student_id",
            "udise_student_id",
            "apaar_id",
            "pen_number",
            "school_name",
            "school_udise_code",
            "class_grade",
            "stream",
            "roll_number",
            "district",
            "block",
            "village",
            "mobile_phone_number",
        ]
        search_text = []
        if extra:
            search_text.extend(str(value).strip() for value in extra if str(value).strip())
        search_text.extend(
            str(payload.get(key) or "").strip()
            for key in keys
            if str(payload.get(key) or "").strip()
        )
        return " ".join(search_text).strip()

    def construct_intake_record_name(self, payload: dict, extra: list[str] = None) -> str:
        _logger.info("Constructing intake record name for student")
        first_name = payload.get("first_name") or "Student"
        last_name = payload.get("last_name") or ""
        ref = payload.get("application_reference") or payload.get("udise_student_id") or payload.get("student_id") or ""
        name = f"{first_name} {last_name}".strip()
        if ref:
            return f"{name} ({ref})"
        return name

    def construct_record_name(self, payload: dict, extra: list[str] = None) -> str:
        _logger.info("Constructing record name for student")
        first_name = payload.get("first_name") or "Student"
        last_name = payload.get("last_name") or ""
        s_id = payload.get("udise_student_id") or payload.get("student_id") or payload.get("functional_record_id") or ""
        name = f"{first_name} {last_name}".strip()
        if s_id:
            return f"{name} ({s_id})"
        return name
