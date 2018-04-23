data "ignition_user" "root" {
  name = "root"
  ssh_authorized_keys = ["${tls_private_key.provisioning_key.public_key_openssh}"]
}

data "ignition_user" "core" {
  name = "core"
  ssh_authorized_keys = ["${var.management_keys}"]
  groups = [
    "sudo",
    "docker"
  ]
}

data "ignition_file" "manager_hostname" {
  count = "${var.manager_count}"
  filesystem = "root"
  path = "/etc/hostname"
  content {
    content = "manager-${count.index}"
  }
}

data "ignition_file" "worker_hostname" {
  count = "${var.worker_count}"
  filesystem = "root"
  path = "/etc/hostname"
  content {
    content = "worker-${count.index}"
  }
}

data "ignition_file" "docker_swarm_dropin" {
  filesystem = "root"
  path = "/etc/systemd/system/docker.service.d/50-swarm.conf"
  content {
    content = <<EOF
[Service]
Environment='DOCKER_OPTS=-H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375'
EOF
  }
}

data "ignition_config" "manager_ignition_config" {
  count    = "${var.manager_count}"
  files    = [
    "${data.ignition_file.manager_hostname.*.id[count.index]}",
    "${data.ignition_file.docker_swarm_dropin.id}",
  ]

  users = [
    "${data.ignition_user.core.id}",
    "${data.ignition_user.root.id}"
  ]
}

data "ignition_config" "worker_ignition_config" {
  count    = "${var.worker_count}"
  files    = [
    "${data.ignition_file.worker_hostname.*.id[count.index]}",
  ]

  users = [
    "${data.ignition_user.core.id}",
    "${data.ignition_user.root.id}"
  ]
}
