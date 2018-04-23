data "ignition_user" "core" {
  name = "core"
  ssh_authorized_keys = ["${var.management_ssh_keys}"]
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
    content = "${aws_instance.manager.*.tags.Name[count.index]}"
  }
}

data "ignition_file" "worker_hostname" {
  count = "${var.worker_count}"
  filesystem = "root"
  path = "/etc/hostname"
  content {
    content = "${aws_instance.worker.*.tags.Name[count.index]}"
  }
}

data "ignition_file" "docker_swarm_dropin" {
  filesystem = "root"
  path = "/etc/systemd/system/docker.service.d/50-swarm.conf"
  content {
    content = <<EOF
[Service]
Environment='DOCKER_OPTS=--insecure-registry="10.81.0.0/16" --bip="172.17.43.1/16"'
EOF
  }
}

data "ignition_file" "sysctl_inotify_dropin" {
  filesystem = "root"
  path = "/etc/sysctl.d/99-inotify.conf"
  content {
    content = "fs.inotify.max_user_instances = 8192"
  }
}

data "ignition_networkd_unit" "default" {
  name = "zz-default.network"
}

data "ignition_networkd_unit" "empty" {
  name = "00-.network"
}

data "ignition_config" "manager_ignition_config" {
  count    = "${var.manager_count}"
  files    = [
    "${data.ignition_file.manager_hostname.*.id[count.index]}",
    "${data.ignition_file.sysctl_inotify_dropin.id}"
  ]

  users = [
    "${data.ignition_user.core.*.id[count.index]}"
  ]
}

data "ignition_config" "worker_ignition_config" {
  count    = "${var.worker_count}"
  files    = [
    "${data.ignition_file.manager_hostname.*.id[count.index]}",
    "${data.ignition_file.sysctl_inotify_dropin.id}"
  ]

  users = [
    "${data.ignition_user.core.*.id[count.index]}"
  ]
}
