from openg2p_registry_core.models.g2p_intake_form import G2PIntakeForm
from sqlalchemy import JSON, Boolean, Date, Integer, BigInteger, Numeric, String, select
from sqlalchemy.orm import Mapped, mapped_column
from openg2p_registry_core.models import (
    G2PRegister,
    G2PRegisterHistory,
    G2PGeo,
    G2PPerson,
    G2PPersonHistory,
    G2PGeoHistory,
)
from ..services import G2PRegisterDomainServiceIndividual
from .enums import (
    AgeMethodEnum,
    CitizenshipCategoryEnum,
    DisabilityStatusEnum,
    DisplacementStatusEnum,
    EmploymentStatusEnum,
    IdentityEvidenceTypeEnum,
    PastoralistClassificationEnum,
    PreferredContactMethodEnum,
    RelationshipToHeadEnum,
    ResidencyStatusEnum,
    VerificationStatusEnum,
)


class G2PIndividual:

    foundational_id_masked: Mapped[str] = mapped_column(String, nullable=True)
    foundational_id_verification_status: Mapped[VerificationStatusEnum] = mapped_column(
        String, nullable=True
    )
    identity_evidence_type: Mapped[IdentityEvidenceTypeEnum] = mapped_column(String, nullable=True)
    legacy_program_ids: Mapped[dict] = mapped_column(JSON, nullable=True)

    full_name: Mapped[str] = mapped_column(String, nullable=True, index=True)
    alias_names: Mapped[list] = mapped_column(JSON, nullable=True)

    estimated_age: Mapped[int] = mapped_column(Integer, nullable=True)
    age_method: Mapped[AgeMethodEnum] = mapped_column(String, nullable=True)
    citizenship_category: Mapped[CitizenshipCategoryEnum] = mapped_column(String, nullable=True)

    relationship_to_head: Mapped[RelationshipToHeadEnum] = mapped_column(String, nullable=True)
    residency_status: Mapped[ResidencyStatusEnum] = mapped_column(String, nullable=True)
    dependency_indicator: Mapped[bool] = mapped_column(Boolean, nullable=True)

    preferred_contact_method: Mapped[PreferredContactMethodEnum] = mapped_column(String, nullable=True)
    contact_person_name: Mapped[str] = mapped_column(String, nullable=True)

    disability_status: Mapped[DisabilityStatusEnum] = mapped_column(String, nullable=True)
    plw_status: Mapped[bool] = mapped_column(Boolean, nullable=True)
    plw_status_date: Mapped[Date] = mapped_column(Date, nullable=True)
    orphanhood_flag: Mapped[bool] = mapped_column(Boolean, nullable=True)
    chronic_illness_flag: Mapped[bool] = mapped_column(Boolean, nullable=True)
    displacement_status: Mapped[DisplacementStatusEnum] = mapped_column(String, nullable=True)
    pastoralist_classification: Mapped[PastoralistClassificationEnum] = mapped_column(String, nullable=True)
    high_mobility_indicator: Mapped[bool] = mapped_column(Boolean, nullable=True)

    primary_livelihood: Mapped[str] = mapped_column(String, nullable=True)
    secondary_livelihood: Mapped[str] = mapped_column(String, nullable=True)
    employment_status: Mapped[EmploymentStatusEnum] = mapped_column(String, nullable=True)
    coping_strategies_index: Mapped[int] = mapped_column(Integer, nullable=True)

    # =========================================================================
    # GramStack Federated Registry Columns (from GramStack-Mock-Data.xlsx)
    # =========================================================================

    # Common Location, Personal & Financial Identifiers
    household_id: Mapped[str | None] = mapped_column(String, nullable=True, index=True)
    mobile_number: Mapped[str | None] = mapped_column(String, nullable=True)
    bank_account_no: Mapped[str | None] = mapped_column(String, nullable=True)
    district: Mapped[str | None] = mapped_column(String, nullable=True)
    block: Mapped[str | None] = mapped_column(String, nullable=True)
    village: Mapped[str | None] = mapped_column(String, nullable=True)
    gp: Mapped[str | None] = mapped_column(String, nullable=True)
    aadhaar_number: Mapped[str | None] = mapped_column(String, nullable=True)
    dob: Mapped[str | None] = mapped_column(String, nullable=True)

    # 1. JEEViKA SHG LokOS
    member_id: Mapped[str | None] = mapped_column(String, nullable=True)
    shg_id: Mapped[str | None] = mapped_column(String, nullable=True)
    shg_name: Mapped[str | None] = mapped_column(String, nullable=True)
    vo_id: Mapped[str | None] = mapped_column(String, nullable=True)
    vo_name: Mapped[str | None] = mapped_column(String, nullable=True)
    clf_id: Mapped[str | None] = mapped_column(String, nullable=True)
    clf_name: Mapped[str | None] = mapped_column(String, nullable=True)
    member_name: Mapped[str | None] = mapped_column(String, nullable=True)
    relationship_to_hoh: Mapped[str | None] = mapped_column(String, nullable=True)
    shg_role: Mapped[str | None] = mapped_column(String, nullable=True)
    shg_join_date: Mapped[str | None] = mapped_column(String, nullable=True)
    shg_grading: Mapped[str | None] = mapped_column(String, nullable=True)
    monthly_savings_amount: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    internal_loan_outstanding: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    ccl_limit: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    ccl_utilised: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    ifsc: Mapped[str | None] = mapped_column(String, nullable=True)

    # 2. BiharBhumi Land Records
    jamabandi_number: Mapped[str | None] = mapped_column(String, nullable=True)
    khata_number: Mapped[str | None] = mapped_column(String, nullable=True)
    khesra_numbers: Mapped[str | None] = mapped_column(String, nullable=True)
    rayat_name: Mapped[str | None] = mapped_column(String, nullable=True)
    rakba_area: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    land_type: Mapped[str | None] = mapped_column(String, nullable=True)
    mauza: Mapped[str | None] = mapped_column(String, nullable=True)
    anchal: Mapped[str | None] = mapped_column(String, nullable=True)
    mutation_status: Mapped[str | None] = mapped_column(String, nullable=True)
    last_mutation_date: Mapped[str | None] = mapped_column(String, nullable=True)
    lpc_status: Mapped[str | None] = mapped_column(String, nullable=True)
    lpc_certificate_number: Mapped[str | None] = mapped_column(String, nullable=True)
    encumbrance_status: Mapped[str | None] = mapped_column(String, nullable=True)
    bhu_lagan_paid_status: Mapped[bool | None] = mapped_column(Boolean, nullable=True)
    registration_deed_number: Mapped[str | None] = mapped_column(String, nullable=True)

    # 3. Farmer AgriStack
    farmer_id: Mapped[str | None] = mapped_column(String, nullable=True)
    farmer_name: Mapped[str | None] = mapped_column(String, nullable=True)
    relation_name: Mapped[str | None] = mapped_column(String, nullable=True)
    khatiyan_number: Mapped[str | None] = mapped_column(String, nullable=True)
    khesra_number: Mapped[str | None] = mapped_column(String, nullable=True)
    land_area_acres: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    land_ownership_type: Mapped[str | None] = mapped_column(String, nullable=True)
    crop_type: Mapped[str | None] = mapped_column(String, nullable=True)
    pm_kisan_enrolled: Mapped[bool | None] = mapped_column(Boolean, nullable=True)
    pmfby_enrolled: Mapped[bool | None] = mapped_column(Boolean, nullable=True)

    # 4. PDS Food Security (Ration Card)
    ration_card_number: Mapped[str | None] = mapped_column(String, nullable=True)
    ration_card_type: Mapped[str | None] = mapped_column(String, nullable=True)
    head_of_household_name: Mapped[str | None] = mapped_column(String, nullable=True)
    family_member_count: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    fps_shop_code: Mapped[str | None] = mapped_column(String, nullable=True)
    dealer_name: Mapped[str | None] = mapped_column(String, nullable=True)
    e_kyc_status: Mapped[str | None] = mapped_column(String, nullable=True)
    last_transaction_date: Mapped[str | None] = mapped_column(String, nullable=True)
    monthly_entitlement_kg: Mapped[int | None] = mapped_column(BigInteger, nullable=True)

    # 5. Student (UDISE+)
    student_aadhaar_number: Mapped[str | None] = mapped_column(String, nullable=True)
    guardian_aadhaar_number: Mapped[str | None] = mapped_column(String, nullable=True)
    udise_student_id: Mapped[str | None] = mapped_column(String, nullable=True)
    student_name: Mapped[str | None] = mapped_column(String, nullable=True)
    school_udise_code: Mapped[str | None] = mapped_column(String, nullable=True)
    school_name: Mapped[str | None] = mapped_column(String, nullable=True)
    class_grade: Mapped[str | None] = mapped_column(String, nullable=True)
    enrollment_date: Mapped[str | None] = mapped_column(String, nullable=True)
    attendance_percentage: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    scholarship_status: Mapped[str | None] = mapped_column(String, nullable=True)

    # 6. Social Pension
    beneficiary_id: Mapped[str | None] = mapped_column(String, nullable=True)
    scheme_name: Mapped[str | None] = mapped_column(String, nullable=True)
    sanction_date: Mapped[str | None] = mapped_column(String, nullable=True)
    pension_amount_monthly: Mapped[int | None] = mapped_column(BigInteger, nullable=True)
    payment_status: Mapped[str | None] = mapped_column(String, nullable=True)

    # 7. UI Widget Mappings & Supplemental Attributes
    religion: Mapped[str | None] = mapped_column(String, nullable=True)
    caste: Mapped[str | None] = mapped_column(String, nullable=True)
    aadhaar_no: Mapped[str | None] = mapped_column(String, nullable=True)
    primary_phone_number: Mapped[str | None] = mapped_column(String, nullable=True)
    gram_panchayat: Mapped[str | None] = mapped_column(String, nullable=True)
    pin_code: Mapped[str | None] = mapped_column(String, nullable=True)
    bank_name: Mapped[str | None] = mapped_column(String, nullable=True)
    ifsc_code: Mapped[str | None] = mapped_column(String, nullable=True)

    shg_member_name: Mapped[str | None] = mapped_column(String, nullable=True)
    shg_bank_account_no: Mapped[str | None] = mapped_column(String, nullable=True)
    shg_ifsc: Mapped[str | None] = mapped_column(String, nullable=True)

    khatian_number: Mapped[str | None] = mapped_column(String, nullable=True)
    plot_number: Mapped[str | None] = mapped_column(String, nullable=True)
    total_land_area_acres: Mapped[float | None] = mapped_column(Numeric(10, 2), nullable=True)
    irrigated_land_area_acres: Mapped[float | None] = mapped_column(Numeric(10, 2), nullable=True)
    unirrigated_land_area_acres: Mapped[float | None] = mapped_column(Numeric(10, 2), nullable=True)
    land_classification: Mapped[str | None] = mapped_column(String, nullable=True)
    soil_type: Mapped[str | None] = mapped_column(String, nullable=True)

    pm_kisan_id: Mapped[str | None] = mapped_column(String, nullable=True)
    pm_kisan_status: Mapped[str | None] = mapped_column(String, nullable=True)
    pm_kisan_installment_count: Mapped[int | None] = mapped_column(Integer, nullable=True)
    primary_crop: Mapped[str | None] = mapped_column(String, nullable=True)
    secondary_crop: Mapped[str | None] = mapped_column(String, nullable=True)
    kcc_sanctioned_amount: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    kcc_outstanding_amount: Mapped[float | None] = mapped_column(Numeric(12, 2), nullable=True)
    soil_health_card_issued: Mapped[bool | None] = mapped_column(Boolean, nullable=True)
    crop_insurance_enrolled: Mapped[bool | None] = mapped_column(Boolean, nullable=True)

    pds_ration_card_number: Mapped[str | None] = mapped_column(String, nullable=True)
    pds_card_type: Mapped[str | None] = mapped_column(String, nullable=True)
    fps_dealer_name: Mapped[str | None] = mapped_column(String, nullable=True)
    pds_family_member_count: Mapped[int | None] = mapped_column(Integer, nullable=True)
    last_pds_transaction_date: Mapped[str | None] = mapped_column(String, nullable=True)
    pds_ekyc_status: Mapped[str | None] = mapped_column(String, nullable=True)

    pension_scheme_name: Mapped[str | None] = mapped_column(String, nullable=True)
    pensioner_id: Mapped[str | None] = mapped_column(String, nullable=True)
    sanction_order_number: Mapped[str | None] = mapped_column(String, nullable=True)
    monthly_pension_amount: Mapped[float | None] = mapped_column(Numeric(10, 2), nullable=True)
    pension_disbursement_mode: Mapped[str | None] = mapped_column(String, nullable=True)
    pension_account_number: Mapped[str | None] = mapped_column(String, nullable=True)
    pension_status: Mapped[str | None] = mapped_column(String, nullable=True)
    last_disbursement_date: Mapped[str | None] = mapped_column(String, nullable=True)

    student_id: Mapped[str | None] = mapped_column(String, nullable=True)
    current_grade: Mapped[str | None] = mapped_column(String, nullable=True)
    scholarship_received: Mapped[str | None] = mapped_column(String, nullable=True)
    midday_meal_beneficiary: Mapped[bool | None] = mapped_column(Boolean, nullable=True)



class G2PRegisterIndividual(G2PRegister, G2PPerson, G2PGeo, G2PIndividual):
    __tablename__ = "g2p_register_individuals"

    def get_record_name_fields(self) -> str:
        """Return individual fields used to build record_name."""
        return G2PRegisterDomainServiceIndividual().construct_record_name(self.to_dict())

    def get_search_text_fields(self) -> str:
        """Return individual fields used to build search_text."""
        return G2PRegisterDomainServiceIndividual().construct_search_text(self.to_dict())


class G2PRegisterHistoryIndividual(
    G2PRegisterHistory, G2PPersonHistory, G2PGeoHistory, G2PIndividual
):
    __tablename__ = "g2p_register_history_individuals"


class G2PIntakeFormIndividual(G2PIntakeForm, G2PRegister, G2PPerson, G2PGeo, G2PIndividual):
    __tablename__ = "g2p_intake_form_individuals"

    async def get_link_internal_record_id(self, session):
        from .household import G2PIntakeFormHousehold

        result = await session.execute(
            select(G2PIntakeFormHousehold).where(
                G2PIntakeFormHousehold.submission_id == self.submission_id
            )
        )
        household = result.scalars().first()
        if household:
            self.link_internal_record_id = household.internal_record_id

    def get_record_name_fields(self) -> str:
        """Return individual fields used to build record_name."""
        return G2PRegisterDomainServiceIndividual().construct_intake_record_name(self.to_dict())

    def get_search_text_fields(self) -> str:
        """Return individual fields used to build search_text."""
        return G2PRegisterDomainServiceIndividual().construct_search_text(self.to_dict())
