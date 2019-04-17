FROM jenkins/jnlp-slave:alpine

LABEL MAINTAINER mathieu@gaubert.eu

ARG HELM_VERSION
ARG KUBE_VERSION

ENV HELM_VERSION ${HELM_VERSION:-2.13.0}
ENV KUBE_VERSION ${KUBE_VERSION:-1.13.0}

ENV HELM_BASE_URL="https://storage.googleapis.com/kubernetes-helm"
ENV HELM_TAR_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"

ENV KCTL_BASE_URL="https://storage.googleapis.com/kubernetes-release/release"
ENV KCTL_FILE="kubectl"

ENV HELM_HOST=localhost:44134

USER root

RUN apk add --update --no-cache ca-certificates wget gettext && \
    wget -q ${HELM_BASE_URL}/${HELM_TAR_FILE} && \
    wget -q ${HELM_BASE_URL}/${HELM_TAR_FILE}.sha256 && \
    wget -q ${KCTL_BASE_URL}/v${KUBE_VERSION}/bin/linux/amd64/${KCTL_FILE} -O /usr/local/bin/${KCTL_FILE} && \
    chmod +x /usr/local/bin/${KCTL_FILE} && \
    echo "$(cat ${HELM_TAR_FILE}.sha256)  ${HELM_TAR_FILE}" > SHASUMS && \
    sha256sum -c SHASUMS && \
    tar -xzvf ${HELM_TAR_FILE} linux-amd64/helm --strip-components=1 -C /usr/local/bin && \
    rm ${HELM_TAR_FILE}* SHASUMS

USER jenkins
