# gencerts
Quick and dirty script to create client/server certs for docker TLS authentication and other purposes. Reuse the key and CSR to generate certs from a vendor, or use the generated self-signed certs.

Uses [superseb/omgwtfssl](https://github.com/superseb/omgwtfssl)'s docker image (forked from [paulczar/omgwtfssl](https://github.com/paulczar/omgwtfssl) to fix SAN fields) to generate a local CA, client
certificate, and server certificates and keys.

