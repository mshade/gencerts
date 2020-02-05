#!/usr/bin/env bash

DEST="$PWD/certs"
SERVER_PREFIX="server"
CLIENT_PREFIX="client"

usage() {
  echo "Usage: gencerts.sh [-i 127.0.0.1,192.168.1.10] [-n host.example.com,host]"
}

while getopts "i:n:" opt; do
  case ${opt} in
    i ) 
      IPS=${OPTARG}
      ;;
    n )
      HOSTNAMES=${OPTARG}
      ;;
    \? )
      usage
      exit 1
      ;;
  esac
done

test -d "${DEST}" || mkdir -p "${DEST}"

# Create CA, client cert/key
if [[ ! -f "${DEST}"/"${CLIENT_PREFIX}"-cert.pem ]]
then
  docker run --rm -v "${DEST}":/certs \
    -e SSL_CERT=/certs/"${CLIENT_PREFIX}"-cert.pem \
    -e SSL_KEY=/certs/"${CLIENT_PREFIX}".key \
    paulczar/omgwtfssl
fi

# Create Server cert/key
if [[ ! -f "${DEST}"/"${SERVER_PREFIX}"-cert.pem ]]
then
  test -z "${IPS}" && \
    read -rp "Provide comma separated IPs to add to cert." IPS
  test -z "${HOSTNAMES}" && \
    read -rp "Provide comma separated Hostnames to add to cert." HOSTNAMES
  docker run --rm -v "${DEST}":/certs \
    -e SSL_CERT=/certs/"${SERVER_PREFIX}"-cert.pem \
    -e SSL_KEY=/certs/"${SERVER_PREFIX}".key \
    -e SSL_IP="${IPS}" \
    -e SSL_DNS="${HOSTNAMES}" \
    paulczar/omgwtfssl
fi

