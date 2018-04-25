// AWS
variable "aws_access_key" {}
variable "aws_secret_key" {}

// Regions
variable "aws_region" {
  description = "EC2 Region for the VPC"
  default = "eu-central-1"
}

// Availability zones
variable "aws_availability_zones" {
  description = "List of used availability zones"
  type = "list"
  default = [
    "eu-central-1a"
//    ,"eu-central-1b"
//    ,"eu-central-1c"
  ]
}

// Node counts
variable "manager_count" {
  description = "Number of manager nodes"
  default = 1
}

variable "worker_count" {
  description = "Number of private (NAT) worker nodes"
  default = 1
}

// Instance type
variable "instance_type" {
  description = "Instance type for nodes"
  default = "t2.micro"
}

// AMI
data "aws_ami" "coreos" {
  most_recent = true
  filter {
    name = "name"
    values = ["CoreOS-stable-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["595879546273"] // CoreOS
}

// Keys
variable "management_keys" {
  type = "list"
  default = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDczjL/whCDN1vXZ+rUanOTA3ul/4/iQaJwQfRr4b9Oh97m01+zeqB/9uDzYGxY+eSGFSaXdIrXVHWNUYSq/Ync9b4L0JK7vMY+H6VeBueuLGKP8xA4qyFAHAHo/FpDgfGlCXBCM4Nennt4YxC+iPTHTm8Ujfeg9YCpUcbojvHUtpESFvbE+HO+WFm+T7l0bhEJCaLYKyUocb4ClnUFfbRUhtHMJVVxhjEnfFWe2gF6p4dyUOFqtP/00A+BWb4xNYVkkKrnmqSHdfOWEor+BJZFd8vf1irDnK3Pjynz9CaC2MoqEy9mFGS1ra3KBorEr0g9Z7ZS2RTAI5I7d5226HVH2UR+mVtUVpd7zvfLE9XX3jPupnjv9EpoRVKbRkYB4t0HkN8eGxuMttYk51Oa0hqydqvYc1Kl5+TDV+wQqzeV779dAdD1oHXWGzaJIsZ7ZsDerA+swNEZD8cm0h8muLOP9Ylxom670F+yxVoIdTlpHJ2OKA5CW1q+h9Xiv5hqxIeYtdnltgyfPvKiW76c3Trv/ACas1KwpbHTOkz1pzczoXWbyj3tbNMyJlpptFn85XObf9Ow8NbpaOJM7BfmW9u81Y+xHQZgbX2zrIivZJ5wfDgAbLdMBb4C0WvFJqjTv8MEHUwWwNf/i/DatVehiS9UQlMc2hOrHXdF7y1wkUpysw== swarm-public.rsa"
  ]
}
