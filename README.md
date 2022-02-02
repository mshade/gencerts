# gencerts
Quick and dirty script to create client/server certs for TLS things. Reuse the key and CSR to generate certs from a vendor, or use the generated self-signed certs.

Uses [paulczar/omgwtfssl](https://github.com/superseb/omgwtfssl)'s docker image to generate a local CA, client certificate, and server certificates and keys.

## Usage

`gencerts.sh` will create a CA keypair and a server keypair without any options supplied. If a CA keypair already exists as `ca-key.pem` and `ca.pem`, they will be reused.

Set opions via cli or environmen variable:

```
Basic Usage: gencerts.sh [-s 'host.example.com' ] [-i 127.0.0.1,192.168.1.10] [-n host.example.com,host]

# Env Var Options
CA_EXPIRE=1000  # Expiry of CA cert
CA_SUBJECT=ExampleCA # Name of CA Issuer

CERTNAME=server  # Prefix for server certificate to generate

SSL_EXPIRE=3650  # Expiry of Server Cert
SSL_SIZE=4096    # Key size for generated certs (CA and Server)
SILENT=1 .       # Silence output - otherwise, cert data is printed to stdout
```

