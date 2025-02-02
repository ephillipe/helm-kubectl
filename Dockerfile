FROM alpine:3

ARG VCS_REF
ARG BUILD_DATE
ARG KUBE_VERSION
ARG HELM_VERSION

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="helm-kubectl" \
      org.label-schema.url="https://hub.docker.com/r/dtzar/helm-kubectl/" \
      org.label-schema.vcs-url="https://github.com/dtzar/helm-kubectl" \
      org.label-schema.build-date=$BUILD_DATE

RUN apk add --no-cache ca-certificates bash git openssh curl gettext jq bind-tools && \
    ARCH=`uname -m` && \
    echo "ARCH: $ARCH"; \
    if [ "aarch64 arm64" == *"$ARCH"* ]; then \
       ARCH="arm64"; \
    else \
       ARCH="amd64"; \
    fi \
    && echo "ARCH: $ARCH" \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/$ARCH/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-v${HELM_VERSION}-linux-$ARCH.tar.gz -O - | tar -xzO linux-$ARCH/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && chmod g+rwx /root \
    && mkdir /config \
    && chmod g+rwx /config \
    && helm repo add "stable" "https://charts.helm.sh/stable" --force-update

WORKDIR /config

CMD bash
