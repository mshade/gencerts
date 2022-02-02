#!/usr/bin/env bash

DEST="$PWD/certs"

# Set default values for expiry and ssl key size
export CA_EXPIRE="${CA_EXPIRE:-10000}"
export CA_SUBJECT="${CA_SUBJECT:-Test CA}"

export CERTNAME="${CERTNAME:-server}"

export SSL_EXPIRE="${SSL_EXPIRE:-3650}"
export SSL_SIZE="${SSL_SIZE:-4096}"
export SILENT="${SILENT:-}"

usage () {
  echo "Usage: gencerts.sh [-s 'host.example.com' ] [-i 127.0.0.1,192.168.1.10] [-n host.example.com,host]"
  echo "May also set one or more of SSL_SUBJECT, SSL_IP, or SSL_DNS env vars"
  echo "Set CERTNAME to override the default server.pem cert name, and generate multiples for example."
  echo "Optional: CA_EXPIRE, CA_SUBJECT, SSL_EXPIRE, SSL_SIZE, SILENT"
}

while getopts "s:i:n:" opt; do
  case ${opt} in
    s )
      export SSL_SUBJECT=${OPTARG}
      ;;
    i ) 
      export SSL_IP=${OPTARG}
      ;;
    n )
      export SSL_DNS=${OPTARG}
      ;;
    \? )
      usage
      exit 1
      ;;
  esac
done

if [ -z "$SSL_SUBJECT" ] && [ -z "$SSL_IP" ] && [ -z "$SSL_DNS" ]; then
  usage
  exit 1
fi

env |grep "^CA_"
env | grep "^SSL_"
echo 

test -d "${DEST}" || mkdir -p "${DEST}"


# Create CA, client cert/key
if [[ ! -f "${DEST}"/ca-key.pem ]]
then
  docker run --rm -v "${DEST}":/certs \
    -e SILENT \
    -e SSL_SIZE \
    -e CA_EXPIRE \
    -e CA_SUBJECT \
    paulczar/omgwtfssl
fi

# Create Server cert/key
if [[ ! -f "${DEST}"/"${CERTNAME}".pem ]]
then
  docker run --rm -v "${DEST}":/certs \
    -e SILENT \
    -e SSL_SIZE \
    -e SSL_EXPIRE \
    -e SSL_CERT=/certs/"${CERTNAME}".pem \
    -e SSL_KEY=/certs/"${CERTNAME}".key \
    -e SSL_IP \
    -e SSL_DNS \
    -e SSL_SUBJECT \
    paulczar/omgwtfssl
fi
