#!/bin/bash

VAULT_VERSION=${VAULT_VERSION:-1.11.0}
VAULT_GPGKEY=${VAULT_GPGKEY:-C874011F0AB405110D02105534365D9472D7468F}
HASHICORP_RELEASES=${HASHICORP_RELEASES:-https://releases.hashicorp.com}

VAULT_USER=${VAULT_USER:-vault}
VAULT_GROUP=${VAULT_GROUP:-vault}

addgroup ${VAULT_GROUP}
adduser -S -G ${VAULT_GROUP} ${VAULT_USER}

apkArch="$(apk --print-arch)"; \
case "$apkArch" in \
  armhf) ARCH='arm' ;; \
  aarch64) ARCH='arm64' ;; \
  x86_64) ARCH='amd64' ;; \
  x86) ARCH='386' ;; \
  *) echo >&2 "error: unsupported architecture: $apkArch"; exit 1 ;; \
esac && \
found=''; \
for server in \
    hkps://keys.openpgp.org \
    hkps://keyserver.ubuntu.com \
    hkps://pgp.mit.edu \
; do \
    echo "Fetching GPG key $VAULT_GPGKEY from $server"; \
    gpg --batch --keyserver "$server" --recv-keys "$VAULT_GPGKEY" && found=yes && break; \
done; \
test -z "$found" && echo >&2 "error: failed to fetch GPG key $VAULT_GPGKEY" && exit 1; \
mkdir -p /tmp/build && \
cd /tmp/build && \
wget -q ${HASHICORP_RELEASES}/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${ARCH}.zip && \
wget -q ${HASHICORP_RELEASES}/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS && \
wget -q ${HASHICORP_RELEASES}/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig && \
gpg --batch --verify vault_${VAULT_VERSION}_SHA256SUMS.sig vault_${VAULT_VERSION}_SHA256SUMS && \
grep vault_${VAULT_VERSION}_linux_${ARCH}.zip vault_${VAULT_VERSION}_SHA256SUMS | sha256sum -c && \
unzip -d /tmp/build vault_${VAULT_VERSION}_linux_${ARCH}.zip && \
cp /tmp/build/vault /bin/vault && \
if [ -f /tmp/build/EULA.txt ]; then mkdir -p /usr/share/doc/vault; mv /tmp/build/EULA.txt /usr/share/doc/vault/EULA.txt; fi && \
if [ -f /tmp/build/TermsOfEvaluation.txt ]; then mkdir -p /usr/share/doc/vault; mv /tmp/build/TermsOfEvaluation.txt /usr/share/doc/vault/TermsOfEvaluation.txt; fi && \
cd /tmp && \
rm -rf /tmp/build && \
gpgconf --kill dirmngr && \
gpgconf --kill gpg-agent && \
apk del gnupg openssl && \
rm -rf /root/.gnupg

mkdir -p /vault/logs && \
  mkdir -p /vault/file && \
  mkdir -p /vault/config && \
  chown -R ${VAULT_USER}:${VAULT_GROUP} /vault
