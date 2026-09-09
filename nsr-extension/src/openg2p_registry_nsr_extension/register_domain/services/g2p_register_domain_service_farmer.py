import logging
from openg2p_registry_core.services import G2PRegisterDomainService

_logger = logging.getLogger("g2p-register-domain-service-farmer")


class G2PRegisterDomainServiceFarmer(G2PRegisterDomainService):
    async def validate_domain_attributes(self, records: list[dict]):
        # Domain validation for farmer records
        pass

    def construct_search_text(self, payload: dict, extra: list[str] = None) -> str:
        _logger.info("Constructing search text for farmer")
        keys = [
            "first_name",
            "last_name",
            "foundational_id",
            "farmer_id",
            "farmer_name",
            "relation_name",
            "crop_type",
            "khata_number",
            "khesra_number",
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
        _logger.info("Constructing intake record name for farmer")
        first_name = payload.get("first_name") or payload.get("farmer_name") or "Farmer"
        last_name = payload.get("last_name") or ""
        ref = payload.get("application_reference") or payload.get("farmer_id") or ""
        name = f"{first_name} {last_name}".strip()
        if ref:
            return f"{name} ({ref})"
        return name

    def construct_record_name(self, payload: dict, extra: list[str] = None) -> str:
        _logger.info("Constructing record name for farmer")
        first_name = payload.get("first_name") or payload.get("farmer_name") or "Farmer"
        last_name = payload.get("last_name") or ""
        f_id = payload.get("farmer_id") or payload.get("functional_record_id") or ""
        name = f"{first_name} {last_name}".strip()
        if f_id:
            return f"{name} ({f_id})"
        return name
