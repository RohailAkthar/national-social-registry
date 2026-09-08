import importlib
import logging
import threading
import time
from datetime import datetime
from .register_domain.factory import G2PRegisterDomainFactory
from .register_domain import models as model_module

from openg2p_fastapi_common.context import dbengine
from openg2p_registry_core.models import (
    ApprovalStatusEnum,
    DeduplicationIntakeFormIntakeFormResult,
    DeduplicationIntakeFormRegisterResult,
    DeduplicationStatusEnum,
    G2PIntakeFormSubmission,
    G2PRegisterDefinition,
    G2PRegisterSection,
    IntakeFormStatusEnum,
    RegisterPurposeEnum,
)
from sqlalchemy import create_engine, delete, inspect, select
from sqlalchemy.orm import Session

_logger = logging.getLogger("g2p-nsr-deduplication-worker")

_sync_engine = None


def get_sync_engine():
    global _sync_engine
    if _sync_engine is None:
        engine = dbengine.get()
        if engine is not None:
            sync_url = engine.url.set(drivername="postgresql+psycopg2")
            _sync_engine = create_engine(sync_url)
    return _sync_engine


def deduplicate_submission(submission_id: str, session: Session):
    submission = session.get(G2PIntakeFormSubmission, submission_id)
    if not submission:
        return

    sections = session.execute(
        select(G2PRegisterSection).where(
            G2PRegisterSection.register_id == str(submission.register_id)
        )
    ).scalars().all()

    seen_reg_ids = set()
    register_sections = []
    for section in sections:
        sec_reg_def = session.get(G2PRegisterDefinition, section.section_register_id)
        if sec_reg_def and sec_reg_def.register_purpose == RegisterPurposeEnum.REGISTER.value:
            if sec_reg_def.register_id not in seen_reg_ids:
                seen_reg_ids.add(sec_reg_def.register_id)
                register_sections.append((section, sec_reg_def))

    if not register_sections:
        submission.deduplication_status_vs_register = DeduplicationStatusEnum.COMPLETED.value
        submission.deduplication_status_vs_intake_forms = DeduplicationStatusEnum.COMPLETED.value
        session.commit()
        return

    # Delete existing results for idempotency
    session.execute(
        delete(DeduplicationIntakeFormRegisterResult).where(
            DeduplicationIntakeFormRegisterResult.submission_id == submission_id
        )
    )
    session.execute(
        delete(DeduplicationIntakeFormIntakeFormResult).where(
            DeduplicationIntakeFormIntakeFormResult.submission_id == submission_id
        )
    )
    session.flush()

    domain_factory = G2PRegisterDomainFactory.get_component() or G2PRegisterDomainFactory()

    other_submissions = session.execute(
        select(G2PIntakeFormSubmission).where(
            (G2PIntakeFormSubmission.register_id == submission.register_id) &
            (G2PIntakeFormSubmission.submission_id != submission_id) &
            (G2PIntakeFormSubmission.approval_status != ApprovalStatusEnum.APPROVED.value)
        )
    ).scalars().all()

    for section, sec_reg_def in register_sections:
        intake_class = getattr(
            model_module, f"G2PIntakeForm{sec_reg_def.register_mnemonic}", None
        )
        if intake_class is None:
            continue

        intake_records = session.execute(
            select(intake_class).where(intake_class.submission_id == submission_id)
        ).scalars().all()

        if not intake_records:
            continue

        domain_service = domain_factory.get_domain_service(sec_reg_def.register_mnemonic)
        if not domain_service:
            continue

        # 1. Register deduplication
        for intake_record in intake_records:
            record_dict = {
                col.name: getattr(intake_record, col.name)
                for col in inspect(intake_class).columns
                if col.name not in {"submission_id"}
            }
            reg_results = domain_service.compute_deduplication_score_for_register(
                submission_id,
                str(section.section_register_id),
                record_dict,
                session,
            )
            for result in reg_results:
                session.add(DeduplicationIntakeFormRegisterResult(
                    submission_id=submission_id,
                    section_register_id=str(section.section_register_id),
                    internal_record_id=result["candidate_id"],
                    match_score=result["score"],
                    field_matches=result.get("field_matches", {}),
                ))

        # 2. Intake vs Intake deduplication
        other_change_requests = []
        for other in other_submissions:
            other_records = session.execute(
                select(intake_class).where(
                    intake_class.submission_id == str(other.submission_id)
                )
            ).scalars().all()
            for other_record in other_records:
                other_change_requests.append({
                    "change_request_id": str(other.submission_id),
                    "change_payload": {
                        col.name: getattr(other_record, col.name)
                        for col in inspect(intake_class).columns
                        if col.name not in {"submission_id"}
                    },
                })

        for intake_record in intake_records:
            incoming_dict = {
                col.name: getattr(intake_record, col.name)
                for col in inspect(intake_class).columns
                if col.name not in {"submission_id"}
            }
            intake_results = domain_service.compute_deduplication_score_for_change_request(
                submission_id,
                str(section.section_register_id),
                incoming_dict,
                other_change_requests,
                session,
            )
            best = {}
            for result in intake_results:
                cid = result["candidate_id"]
                if cid not in best or result["score"] > best[cid]["score"]:
                    best[cid] = result

            for result in best.values():
                session.add(DeduplicationIntakeFormIntakeFormResult(
                    submission_id=submission_id,
                    section_register_id=str(section.section_register_id),
                    candidate_submission_id=result["candidate_id"],
                    match_score=result["score"],
                    field_matches=result.get("field_matches", {}),
                ))

    submission.deduplication_status_vs_register = DeduplicationStatusEnum.COMPLETED.value
    submission.deduplication_status_vs_intake_forms = DeduplicationStatusEnum.COMPLETED.value
    submission.deduplication_register_process_timestamp = datetime.utcnow()
    submission.deduplication_intake_forms_process_timestamp = datetime.utcnow()
    session.commit()
    _logger.info(f"Completed deduplication for submission {submission_id}")


def run_pending_deduplications():
    engine = get_sync_engine()
    if not engine:
        return
    with Session(engine) as session:
        pending_subs = session.execute(
            select(G2PIntakeFormSubmission).where(
                (G2PIntakeFormSubmission.draft_status == IntakeFormStatusEnum.FINAL.value) &
                (
                    (G2PIntakeFormSubmission.deduplication_status_vs_intake_forms == DeduplicationStatusEnum.PENDING.value) |
                    (G2PIntakeFormSubmission.deduplication_status_vs_register == DeduplicationStatusEnum.PENDING.value)
                )
            )
        ).scalars().all()

        for sub in pending_subs:
            try:
                _logger.info(f"Processing pending deduplication for submission {sub.submission_id}")
                deduplicate_submission(sub.submission_id, session)
            except Exception as e:
                _logger.error(f"Error deduplicating submission {sub.submission_id}: {e}", exc_info=True)


def _worker_loop():
    _logger.info("NSR deduplication background worker started.")
    while True:
        try:
            run_pending_deduplications()
        except Exception as e:
            _logger.error(f"Error in NSR deduplication worker loop: {e}")
        time.sleep(2)


_worker_started = False


def start_deduplication_worker():
    global _worker_started
    if not _worker_started:
        _worker_started = True
        t = threading.Thread(target=_worker_loop, daemon=True, name="nsr-dedup-worker")
        t.start()
