resource "aws_eip" "manager" {
  count = "${var.manager_count}"
  vpc = true
  depends_on = ["aws_internet_gateway.gw"]
  lifecycle {
    prevent_destroy = true
  }
  tags {
    Name = "${aws_instance.manager.*.tags.Name[count.index]}"
  }
}

resource "aws_eip_association" "manager" {
  count = "${var.manager_count}"
  instance_id = "${aws_instance.manager.*.id[count.index]}"
  allocation_id = "${aws_eip.manager.*.id[count.index]}"
}

resource "aws_instance" "manager" {
  count = "${var.manager_count}"
  ami = "${data.aws_ami.coreos.id}"
  availability_zone = "${element(aws_subnet.public.*.availability_zone, count.index)}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = [
    "${aws_security_group.efs.id}", // workaround for rexray driver behavior
    "${aws_security_group.swarm.id}"
  ]
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  user_data = "${data.ignition_config.manager_ignition_config.*.rendered[count.index]}"
  iam_instance_profile = "${aws_iam_instance_profile.rexray_efs_profile.id}"
  lifecycle {
    ignore_changes = [
      "user_data", // allow creating new nodes with configuration changes without removing existing ones
      "ami"
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "docker swarm init --advertised-address"
    ]
    connection {
      type = "ssh"
      user = "core"
      private_key = "${file("./swarm-private.rsa")}"
    }
  }
  tags {
    Name = "manager-${count.index}"
  }
}

resource "aws_instance" "worker" {
  count = "${var.worker_count}"
  ami = "${data.aws_ami.coreos.id}"
  availability_zone = "${element(aws_subnet.nat.*.availability_zone, count.index)}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = [
    "${aws_security_group.efs.id}", // workaround for rexray driver behavior
    "${aws_security_group.swarm.id}"
  ]
  subnet_id = "${element(aws_subnet.nat.*.id, count.index)}"
  user_data = "${data.ignition_config.worker_ignition_config.*.id[count.index]}"
  source_dest_check = false
  iam_instance_profile = "${aws_iam_instance_profile.rexray_efs_profile.id}"
  lifecycle {
    ignore_changes = [
      "user_data", // allow creating new nodes with configuration changes without removing existing ones
      "ami"
    ]
  }
  provisioner "remote-exec" {
    inline = [
      "docker plugin install --alias efs --grant-all-permissions rexray/efs EFS_SECURITYGROUPS='${aws_security_group.efs.id}'"
    ]
    connection {
      type = "ssh"
      user = "core"
      private_key = "${file("./swarm-private.rsa")}"
      bastion_host = "${aws_eip.manager.0.public_ip}"
    }
  }
  tags {
    Name = "worker-${count.index}"
  }
}
