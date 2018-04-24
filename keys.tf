resource "tls_private_key" "provisioning" {
  algorithm = "RSA"
}

resource "tls_private_key" "manager" {
  algorithm = "RSA"
}

resource "tls_cert_request" "manager" {
  key_algorithm = "${tls_private_key.manager.algorithm}"
  private_key_pem = "${tls_private_key.manager.private_key_pem}"
  subject {
    common_name = "manager"
  }
  ip_addresses = ["${aws_eip.manager.*.public_ip}"]
}

resource "tls_locally_signed_cert" "manager" {
  cert_request_pem = "${tls_cert_request.manager.cert_request_pem}"
  ca_key_algorithm = "RSA"
  ca_private_key_pem = "${file("ca-key.pem")}"
  ca_cert_pem = "${file("ca.pem")}"
  validity_period_hours = 8
  early_renewal_hours = 2
  allowed_uses = [
    "server_auth"
  ]
}

resource "tls_private_key" "client" {
  algorithm = "RSA"
}

resource "tls_cert_request" "client" {
  key_algorithm = "${tls_private_key.client.algorithm}"
  private_key_pem = "${tls_private_key.client.private_key_pem}"
  subject {
    common_name = "client"
  }
}

resource "tls_locally_signed_cert" "client" {
  cert_request_pem = "${tls_cert_request.client.cert_request_pem}"
  ca_key_algorithm = "RSA"
  ca_private_key_pem = "${file("ca-key.pem")}"
  ca_cert_pem = "${file("ca.pem")}"
  validity_period_hours = 8
  early_renewal_hours = 2
  allowed_uses = [
    "client_auth"
  ]
}
