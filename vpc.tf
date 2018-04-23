resource "aws_vpc" "swarm" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags {
    Name = "swarm"
  }
}

resource "aws_subnet" "public" {
  count = "${length(var.aws_availability_zones)}"
  vpc_id = "${aws_vpc.swarm.id}"
  cidr_block = "10.0.${count.index * 2}.0/24" // public subnets = even
  availability_zone = "${var.aws_availability_zones[count.index]}"
  map_public_ip_on_launch = true
  tags {
    Name = "public ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.swarm.id}"
  tags {
    Name = "internet"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.swarm.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

resource "aws_route_table_association" "public_subnet_association" {
  count = "${length(var.aws_availability_zones)}"
  subnet_id = "${aws_subnet.public.*.id[count.index]}"
  route_table_id = "${aws_vpc.swarm.main_route_table_id}"
}
