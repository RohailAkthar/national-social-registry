import logging
from openg2p_registry_core.services import G2PRegisterDomainService

_logger = logging.getLogger("g2p-register-domain-service-student-scholarship")


class G2PRegisterDomainServiceStudentScholarship(G2PRegisterDomainService):
    async def validate_domain_attributes(self, records: list[dict]):
        return

    def construct_search_text(self, payload: dict, extra: list[str] = None) -> str:
        _logger.info("Constructing search text for student scholarship")
        keys = [
            "functional_record_id",
            "scheme_name",
            "academic_year",
            "disbursement_status",
            "transaction_reference",
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
        _logger.info("Constructing record name for student scholarship")
        scheme = payload.get("scheme_name") or "Scholarship"
        year = payload.get("academic_year")
        status = payload.get("disbursement_status")
        parts = [scheme]
        if year:
            parts.append(str(year))
        if status:
            parts.append(f"({status})")
        return " - ".join(parts)

    def construct_intake_record_name(self, payload: dict, extra: list[str] = None) -> str:
        return self.construct_record_name(payload, extra)
