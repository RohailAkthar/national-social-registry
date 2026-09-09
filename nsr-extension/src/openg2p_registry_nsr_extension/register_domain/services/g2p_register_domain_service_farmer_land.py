import logging
from openg2p_registry_core.services import G2PRegisterDomainService

_logger = logging.getLogger("g2p-register-domain-service-farmer-land")


class G2PRegisterDomainServiceFarmerLand(G2PRegisterDomainService):
    async def validate_domain_attributes(self, records: list[dict]):
        _logger.info("Validating farmer land domain attributes")
        return

    def construct_search_text(self, payload: dict, extra: list[str] = None) -> str:
        _logger.info("Constructing search text for farmer land")
        keys = [
            "functional_record_id",
            "khata_number",
            "khesra_numbers",
            "jamabandi_number",
            "mauza",
            "anchal",
            "district",
            "land_ownership_type",
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
        _logger.info("Constructing record name for farmer land")
        khata = payload.get("khata_number")
        khesra = payload.get("khesra_numbers")
        mauza = payload.get("mauza")
        parts = []
        if khesra:
            parts.append(f"Plot {khesra}")
        if khata:
            parts.append(f"Khata {khata}")
        if mauza:
            parts.append(mauza)
        if parts:
            return " - ".join(parts)
        return payload.get("record_name") or "Land Parcel"
