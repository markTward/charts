FROM alpine:3.2

MAINTAINER Lachlan Evenson <lachlan@deis.com>

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/kubernetes/charts" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

ENV VAULT_VERSION 0.6.1
ENV VAULT_HTTP_PORT 8080
ENV VAULT_HTTPS_PORT 8443

COPY config.json /etc/vault/config.json

RUN apk --update add openssl zip\
&& mkdir -p /etc/vault/ssl \
&& wget http://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip \
&& unzip vault_${VAULT_VERSION}_linux_amd64.zip \
&& mv vault /usr/local/bin/ \
&& rm -f vault_${VAULT_VERSION}_linux_amd64.zip

EXPOSE ${VAULT_HTTP_PORT}
EXPOSE ${VAULT_HTTPS_PORT}

COPY /run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

ENTRYPOINT ["/usr/bin/run.sh"]
CMD []
