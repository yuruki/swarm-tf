output "client_cert" {
  value = "${tls_locally_signed_cert.client.cert_pem}"
  sensitive = true
}

output "client_key" {
  value = "${tls_private_key.client.private_key_pem}"
  sensitive = true
}