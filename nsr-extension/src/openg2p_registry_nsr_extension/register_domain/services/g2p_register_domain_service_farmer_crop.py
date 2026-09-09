import logging
from openg2p_registry_core.services import G2PRegisterDomainService

_logger = logging.getLogger("g2p-register-domain-service-farmer-crop")


class G2PRegisterDomainServiceFarmerCrop(G2PRegisterDomainService):
    async def validate_domain_attributes(self, records: list[dict]):
        _logger.info("Validating farmer crop domain attributes")
        return

    def construct_search_text(self, payload: dict, extra: list[str] = None) -> str:
        _logger.info("Constructing search text for farmer crop")
        keys = [
            "functional_record_id",
            "commodity",
            "season",
            "end_use",
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
        _logger.info("Constructing record name for farmer crop")
        commodity = payload.get("commodity")
        season = payload.get("season")
        if commodity and season:
            return f"{commodity} ({season})"
        elif commodity:
            return commodity
        return payload.get("record_name") or "Crop"
