// AWS
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_name" {
  default = "swarm-public.rsa"
}

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
  default = "t2.nano"
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

variable "management_ssh_keys" {
  type = "list"
  default = [
    "ssh-rsa XXX"
  ]
}
