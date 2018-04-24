#!/usr/bin/env bash

# Create CA private key
openssl genrsa -aes256 -out ca-key.pem 4096
# Remove passphrase
openssl rsa -in ca-key.pem -out ca-key.pem
# Create CA certificate
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
# Create manager private key
openssl genrsa -out manager-key.pem 4096
# Create manager csr
openssl req -subj "/CN=manager" -sha256 -new -key manager-key.pem -out manager.csr
# Create manager certificate
echo subjectAltName = IP:52.28.228.65 > manager.cnf
echo extendedKeyUsage = serverAuth >> manager.cnf
openssl x509 -req -days 365 -sha256 -in manager.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out manager-cert.pem -extfile manager.cnf
# Create client private key
openssl genrsa -out client-key.pem 4096
# Create client csr
openssl req -subj "/CN=client" -sha256 -new -key client-key.pem -out client.csr
# Create client certificate
echo extendedKeyUsage = clientAuth > client.cnf
openssl x509 -req -days 365 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out client-cert.pem -extfile client.cnf
# Clean up
rm -v client.cnf manager.cnf client.csr manager.csr
