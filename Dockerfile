ARG IGNITION_VERSION="8.1.39"
FROM inductiveautomation/ignition:${IGNITION_VERSION:-latest}
LABEL org.opencontainers.image.source https://github.com/ia-eknorr/ignition

USER root

ENV WORKING_DIRECTORY ${WORKING_DIRECTORY:-/workdir}
ENV ACCEPT_IGNITION_EULA "Y"
ENV GATEWAY_ADMIN_USERNAME ${GATEWAY_ADMIN_USERNAME:-admin}
ENV GATEWAY_ADMIN_PASSWORD ${GATEWAY_ADMIN_PASSWORD:-seteamdevserver}
ENV IGNITION_EDITION ${IGNITION_EDITION:-standard}
ENV GATEWAY_MODULES_ENABLED ${GATEWAY_MODULES_ENABLED:-alarm-notification,opc-ua,perspective,reporting,tag-historian,web-developer}
ENV IGNITION_UID ${IGNITION_UID:-2003}
ENV IGNITION_GID ${IGNITION_GID:-2003}
ENV ENABLE_LOCALTEST_ADDRESS ${ENABLE_LOCALTEST_ADDRESS:-Y}
ENV TRAEFIK_SERVICE_NAME ${TRAEFIK_SERVICE_NAME}
ENV DISABLE_QUICKSTART ${DISABLE_QUICKSTART:-true}

ENV SYMLINK_PROJECTS ${SYMLINK_PROJECTS:-true}

# Setup dedicated user
RUN groupmod -g ${IGNITION_GID} ignition && \
    usermod -u ${IGNITION_UID} ignition && \
    chown -R ${IGNITION_UID}:${IGNITION_GID} /usr/local/bin/

# Copy gitignore into the working
COPY --chmod=0755 --chown=${IGNITION_UID}:${IGNITION_GID} ./entrypoint-shim.sh /usr/local/bin/

USER ${IGNITION_UID}:${IGNITION_GID}

ENTRYPOINT [ "entrypoint-shim.sh" ]