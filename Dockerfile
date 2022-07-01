FROM docker.io/alpine:3.11
LABEL maintainer="Ross Hendry <rhendry@gmail.com>"

ENV UID=1337 \
  GID=1337

ARG DEHYDRATED_VERSION="0.7.0"

RUN apk add --update --no-cache gcc build-base python3-dev py3-pip libffi-dev libressl-dev curl openssl openssl-dev musl-dev rust cargo bash && \
  curl -L https://github.com/dehydrated-io/dehydrated/archive/v${DEHYDRATED_VERSION}.tar.gz | tar -xz -C / && \
  mv /dehydrated-${DEHYDRATED_VERSION} /dehydrated && \
  mkdir -p /dehydrated/hooks /dehydrated/certs /dehydrated/accounts && \
  pip install --no-cache-dir dns-lexicon && \
  rm -rf /var/cache/apk/* ~/.cache /root/.cargo && \
  apk del --no-cache gcc build-base python3-dev libffi-dev libressl-dev openssl-dev musl-dev rust cargo

ENV \
  DEHYDRATED_CA="https://acme-staging-v02.api.letsencrypt.org/directory" \
  DEHYDRATED_CHALLENGE="http-01" \
  DEHYDRATED_KEYSIZE="4096" \
  DEHYDRATED_KEY_ALGO="rsa" \
  DEHYDRATED_HOOK="" \
  DEHYDRATED_RENEW_DAYS="30" \
  DEHYDRATED_KEY_RENEW="yes" \
  DEHYDRATED_ACCEPT_TERMS="no" \
  DEHYDRATED_EMAIL="user@example.org" \
  DEHYDRATED_GENERATE_CONFIG="yes"

ADD root /

VOLUME /data

CMD ["/bin/s6-svscan", "/etc/s6.d"]
