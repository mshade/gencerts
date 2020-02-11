#!/usr/bin/env bash

DEST="$PWD/certs"
SERVER_PREFIX="server"
CLIENT_PREFIX="client"

usage() {
  echo "Usage: gencerts.sh [-s 'host.example.com' ] [-i 127.0.0.1,192.168.1.10] [-n host.example.com,host]"
}

while getopts "s:i:n:" opt; do
  case ${opt} in
    s )
      SUBJECT=${OPTARG}
      ;;
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

echo "Hostnames: $HOSTNAMES"
echo "Subject: $SUBJECT"
echo "IPs: $IPS"

test -d "${DEST}" || mkdir -p "${DEST}"

COMMON_OPTS="-e CA_EXPIRE=10000 -e SSL_EXPIRE=10000 -e SSL_SIZE=4096"

# Create CA, client cert/key
if [[ ! -f "${DEST}"/"${CLIENT_PREFIX}"-cert.pem ]]
then
  docker run --rm -v "${DEST}":/certs \
    ${COMMON_OPTS} \
    -e SSL_CERT=/certs/"${CLIENT_PREFIX}"-cert.pem \
    -e SSL_KEY=/certs/"${CLIENT_PREFIX}".key \
    superseb/omgwtfssl
fi

# Create Server cert/key
if [[ ! -f "${DEST}"/"${SERVER_PREFIX}"-cert.pem ]]
then
  test -z "${SUBJECT}" && \
    read -rp "Provide Primary hostname / Subject to add to cert." SUBJECT
  test -z "${IPS}" && \
    read -rp "Provide comma separated IPs to add to cert." IPS
  test -z "${HOSTNAMES}" && \
    read -rp "Provide comma separated SAN Hostnames to add to cert." HOSTNAMES
  docker run --rm -v "${DEST}":/certs \
    ${COMMON_OPTS} \
    -e SSL_SUBJECT="${SUBJECT}" \
    -e SSL_CERT=/certs/"${SERVER_PREFIX}"-cert.pem \
    -e SSL_KEY=/certs/"${SERVER_PREFIX}".key \
    -e SSL_DNS="${HOSTNAMES}" \
    superseb/omgwtfssl
fi

