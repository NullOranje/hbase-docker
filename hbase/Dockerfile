FROM openjdk:8-jre
LABEL site="https://hbase.apache.org"

ARG UID=1000
ARG GID=1000
ARG HBASE_VERSION=2.1.2
ARG BASE_URL=https://archive.apache.org/dist

ENV HBASE_URL https://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz
ENV HBASE_PREFIX=/opt/hbase-${HBASE_VERSION}
ENV HBASE_CONFIG_DIR=${HBASE_PREFIX}/conf
ENV HBASE_PID_DIR=${HBASE_PREFIX}/pid
ENV HBASE_LOG_DIR=${HBASE_PREFIX}/log
ENV HBASE_DATA_DIR=${HBASE_PREFIX}/data

# Setup HBase user and create necessary directories
RUN groupadd -g ${GID} hbase || groupmod -n hbase `getent group ${GID} | cut -d: -f1` \
    && useradd --shell /bin/bash -u ${UID} -g ${GID} -m hbase \
    && mkdir -p ${HBASE_PREFIX} \
    && mkdir -p ${HBASE_PID_DIR} \
    && mkdir -p ${HBASE_CONFIG_DIR} \
    && mkdir -p ${HBASE_LOG_DIR} \
    && mkdir -p ${HBASE_DATA_DIR} \
    && apt-get update \
    && apt-get install -y jq xmlstarlet procps net-tools curl

# Download, validate, and expand Apache HBase binary.
RUN curl -fSL "${HBASE_URL}" -o /tmp/hbase.tar.gz \
    # && echo "$(curl ${BASE_URL}/${HBASE_BINARY_PATH}.sha512) *${HBASE_BASE_DIR}/hbase-${HBASE_VERSION}-bin.tar.gz" | sha512sum -c - \. ## FIX THIS ~NDM~
    && tar -xvf /tmp/hbase.tar.gz -C /opt/ \
    && rm /tmp/hbase.tar.gz \
    && rm -Rf ${HBASE_PREFIX}/docs \
    && chown -R hbase:hbase ${HBASE_PREFIX}

ENV HBASE_PREFIX=/opt/hbase-${HBASE_VERSION}
ENV HBASE_CONFIG_DIR=${HBASE_PREFIX}/conf

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

WORKDIR ${HBASE_PREFIX}

ENTRYPOINT ["/entrypoint.sh"]
