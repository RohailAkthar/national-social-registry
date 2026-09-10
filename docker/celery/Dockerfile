# National Social Registry — Celery image (workers + beat).
#
# Thin extension of the registry-platform celery base image (see
# docker/staff-api/Dockerfile for the full rationale). Adds only the NSR domain
# model; both celery packages, the run_celery.py wrapper, the CELERY_* ENV
# defaults and the CMD are inherited from the base. A single image runs as
# worker or beat, selected at runtime via CELERY_APP.
#
# Build context = repo root (so nsr-extension/ is reachable).
ARG RP_VERSION=0.0.0-develop.296
FROM openg2p/openg2p-registry-celery:${RP_VERSION}

# Option C: select NSR's domain model (coexists with the base image's reference
# extension; env picks NSR, no uninstall needed).
ENV REGISTRY_EXTENSION_MODULE=openg2p_registry_nsr_extension

COPY nsr-extension/ /app/nsr-extension/
RUN pip install --no-cache-dir /app/nsr-extension

# Option C aliasing for Celery:
# Celery worker processes hardcode imports of `openg2p_registry_extensions.register_domain.*`.
# We symlink openg2p_registry_extensions to openg2p_registry_nsr_extension and set up sitecustomize
# so that all worker prefork processes load NSR's models.
RUN python3 -c 'import site; print(site.getsitepackages()[0])' > /tmp/site_pkg && \
    SITE_PKG=$(cat /tmp/site_pkg) && \
    rm -rf ${SITE_PKG}/openg2p_registry_extensions && \
    ln -s ${SITE_PKG}/openg2p_registry_nsr_extension ${SITE_PKG}/openg2p_registry_extensions && \
    printf 'import os, sys, importlib\next = os.environ.get("REGISTRY_EXTENSION_MODULE", "openg2p_registry_nsr_extension")\nif ext != "openg2p_registry_extensions":\n    try:\n        nsr = importlib.import_module(ext)\n        orig = importlib.import_module("openg2p_registry_extensions")\n        orig.__path__ = nsr.__path__\n        sys.modules["openg2p_registry_extensions"] = nsr\n    except Exception:\n        pass\n' > ${SITE_PKG}/sitecustomize.py && \
    rm /tmp/site_pkg

