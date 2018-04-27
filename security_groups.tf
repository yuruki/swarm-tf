resource "aws_security_group" "swarm" {
  name = "swarm"
  description = "Allow only swarm specific inbound traffic"
  vpc_id = "${aws_vpc.swarm.id}"
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }
  ingress {
    from_port = 2376
    protocol = "tcp"
    to_port = 2376
    cidr_blocks = ["0.0.0.0/0"]
    description = "TLS Docker daemon port"
  }
  ingress {
    from_port = 2377
    protocol = "tcp"
    to_port = 2377
    self = true
    description = "Cluster management"
  }
  ingress {
    from_port = 4789
    protocol = "udp"
    to_port = 4789
    self = true
    description = "Overlay network traffic"
  }
  ingress {
    from_port = 7946
    protocol = "udp"
    to_port = 7946
    self = true
    description = "Inter-node communication"
  }
  ingress {
    from_port = 7946
    protocol = "tcp"
    to_port = 7946
    self = true
    description = "Inter-node communication"
  }
  ingress {
    from_port = 0
    protocol = "50"
    to_port = 0
    self = true
    description = "Encrypted traffic (--opt encrypted)"
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outgoing traffic"
  }
  tags {
    Name = "swarm"
  }
}

resource "aws_security_group" "efs" {
  name = "efs"
  description = "Allow only swarm nodes to mount EFS volumes"
  vpc_id = "${aws_vpc.swarm.id}"
  ingress {
    from_port = 2049
    protocol = "tcp"
    to_port = 2049
    security_groups = ["${aws_security_group.swarm.id}"]
    description = "EFS mounts"
  }
//  lifecycle {
//    prevent_destroy = true
//  }
  tags {
    Name = "efs"
  }
}
