/*
resource "aws_subnet" "nat" {
  count = "${length(var.aws_availability_zones)}"
  vpc_id = "${aws_vpc.swarm.id}"
  cidr_block = "10.0.${count.index * 2 + 1}.0/24" // private subnets = odd
  availability_zone = "${var.aws_availability_zones[count.index]}"
  tags {
    Name = "private ${count.index + 1}"
  }
}

resource "aws_eip" "nat" {
  count = "${length(var.aws_availability_zones)}"
  vpc = true
  depends_on = ["aws_internet_gateway.gw"]
  lifecycle {
    prevent_destroy = true
  }
  tags {
    Name = "public nat ip ${count.index + 1}"
  }
}

resource "aws_nat_gateway" "nat" {
  count = "${length(var.aws_availability_zones)}"
  allocation_id = "${aws_eip.nat.*.id[count.index]}"
  subnet_id = "${aws_subnet.public.*.id[count.index]}"
  depends_on = ["aws_internet_gateway.gw"]
  tags {
    Name = "nat gateway ${count.index + 1}"
  }
}

resource "aws_route_table" "private_route_table" {
  count = "${length(var.aws_availability_zones)}"
  vpc_id = "${aws_vpc.swarm.id}"
  tags {
    Name = "private ${count.index + 1}"
  }
}

resource "aws_route" "private_route" {
  count = "${length(var.aws_availability_zones)}"
  route_table_id  = "${aws_route_table.private_route_table.*.id[count.index]}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat.*.id[count.index]}"
}


resource "aws_route_table_association" "private_subnet_association" {
  count = "${length(var.aws_availability_zones)}"
  subnet_id = "${aws_subnet.nat.*.id[count.index]}"
  route_table_id = "${aws_route_table.private_route_table.*.id[count.index]}"
}
*/