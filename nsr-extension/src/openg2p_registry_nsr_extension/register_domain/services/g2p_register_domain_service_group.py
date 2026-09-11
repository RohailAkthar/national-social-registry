import logging
from openg2p_registry_core.services import G2PRegisterDomainService

_logger = logging.getLogger("g2p-register-domain-service-group")


class G2PRegisterDomainServiceGroup(G2PRegisterDomainService):
    async def validate_domain_attributes(self, records: list[dict]):
        # Domain validation for group/SHG records
        pass

    def construct_search_text(self, payload: dict, extra: list[str] = None) -> str:
        _logger.info("Constructing search text for group")
        keys = [
            "group_name",
            "shg_id",
            "shg_code",
            "vo_name",
            "clf_name",
            "key_member_name",
            "key_member_aadhaar",
            "key_member_mobile",
            "bank_name",
            "bank_account_no",
            "district",
            "block",
            "gram_panchayat",
            "village",
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
        _logger.info("Constructing intake record name for group")
        group_name = payload.get("group_name") or "Self Help Group"
        ref = payload.get("application_reference") or payload.get("shg_id") or ""
        if ref:
            return f"{group_name} ({ref})"
        return group_name

    def construct_record_name(self, payload: dict, extra: list[str] = None) -> str:
        _logger.info("Constructing record name for group")
        group_name = payload.get("group_name") or "Self Help Group"
        f_id = payload.get("shg_id") or payload.get("functional_record_id") or ""
        if f_id:
            return f"{group_name} ({f_id})"
        return group_name
