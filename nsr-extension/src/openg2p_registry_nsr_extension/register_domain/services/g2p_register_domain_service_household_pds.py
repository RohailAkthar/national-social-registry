import logging

from openg2p_registry_core.services import G2PRegisterDomainService

_logger = logging.getLogger("g2p-register-householdpds-service")


class G2PRegisterDomainServiceHouseholdPds(G2PRegisterDomainService):
    async def validate_domain_attributes(self, records: list[dict]):
        pass

    def construct_search_text(self, payload: dict, extra: list[str] = None) -> str:
        keys = ["ration_card_number", "head_of_household_name", "dealer_name", "fps_shop_code"]
        search_text = []
        if extra:
            search_text.extend(str(value).strip() for value in extra if str(value).strip())
        search_text.extend(
            str(payload.get(key) or "").strip()
            for key in keys
            if str(payload.get(key) or "").strip()
        )
        return " ".join(search_text).strip()

    def construct_record_name(self, payload: dict, extra: list[str] = None) -> str:
        rc = payload.get("ration_card_number") or "N/A"
        return f"PDS Ration Card ({rc})"
