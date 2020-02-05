#!/usr/bin/env bash

DEST="$PWD/certs"
SERVER_PREFIX="server"
CLIENT_PREFIX="client"

test -d "${DEST}" || mkdir -p "${DEST}"

# Create CA, client cert/key
docker run --rm -v "${DEST}":/certs \
  -e SSL_CERT=/certs/"${CLIENT_PREFIX}"-cert.pem \
  -e SSL_KEY=/certs/"${CLIENT_PREFIX}".key \
  paulczar/omgwtfssl

# Create Server cert/key
if [[ ! -f "${DEST}"/"${SERVER_PREFIX}"-cert.pem ]]
then
  echo "Provide comma separated IPs to add to cert."
  read IPS
  echo "Provide comma separated Hostnames to add to cert."
  read HOSTNAMES
  docker run --rm -v "${DEST}":/certs \
    -e SSL_CERT=/certs/"${SERVER_PREFIX}"-cert.pem \
    -e SSL_KEY=/certs/"${SERVER_PREFIX}".key \
    -e SSL_IP="${IPS}" \
    -e SSL_DNS="${HOSTNAMES}" \
    paulczar/omgwtfssl
fi

