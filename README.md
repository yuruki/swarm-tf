## Terraform + AWS + CoreOS + Docker Swarm Mode /w TLS

#### Prerequisites:

1. AWS API user for Terraform (SystemAdministrator, AmazonVPNFullAccess, IAMFullAccess).
1. AWS access key.
1. AWS secret key.
1. CA certificate and private key in PEM format for creating manager and client certificates. These can be generated with `ca.sh`.
1. One or more SSH key pairs for later management.

#### Configuration

Regions, availability zones, management public keys and node counts are configured in `variables.tf`.

#### Usage

Bootstrap terraform with `terraform init`. Create the whole infrastructure and later apply changes with `terraform apply`.

#### Security

*Terraform state file contains client and manager certificates and private keys in plain text. Client keys grant access to your swarm docker daemon from anywhere. Use short expiry time on client certs and make sure state file is securely stored!*

Client certificates, CA certificate and private keys are stored on every swarm host in /opt/docker-tls. Manager certificates and private keys are stored on manager hosts.

Manager hosts are accessible through SSH with the management keys you have defined and through secure docker daemon port with the client certificate and private key.

Worker hosts are not accessible from the outside world.

#### Todos for production

1. Use a dedicated and secure host for running Terraform. It can even be left disconnected from the network during normal operations.
1. Add OpenVPN client-to-site access point for management, particularly for the management of the worker hosts.
1. Use secure certificate management to create and manage certificates and private keys for clients/CI/CD/ChatOps.