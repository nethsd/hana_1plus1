locals {
  automation_username      = "${lookup(var.bootstrap_config, "automation_username", "")}"
  automation_user_id       = "${lookup(var.bootstrap_config, "automation_user_id", "")}"
  automation_environment   = "${lookup(var.bootstrap_config, "automation_environment", "")}"
  automation_template_path = "/automation/github/${lookup(var.bootstrap_config, "automation_environment", "")}/hcm-chef-automation/platform/rundeck-jobs/chef-full.erb"
  name_servers             = "${lookup(var.bootstrap_config, "name_servers", "")}"
  automation_mount         = "${lookup(var.bootstrap_config, "automation_mount", "")}"
  roaming_mount            = "${lookup(var.bootstrap_config, "roaming_mount", "")}"
  #public_key               = "${file("/home/${local.automation_username}/.ssh/id_rsa.pub")}"
  dc                       = "${lookup(var.bootstrap_config, "dc", "")}"
  suse_repo                = "${lookup(var.bootstrap_config, "suse_repo", "")}"
  role                     = "${lookup(var.bootstrap_config, "role", "hcm_platform_os_setup")}"
  disk_count               = "${var.hdd_disk_count * var.num}"
  ssd_disk_count           = "${var.ssd_disk_count * var.num}"
}


#resource "google_compute_address" "static" {
    #count = "${var.num}"
    #name = "ipv4-address-${var.name}${format("%02d", count.index + 1)}"
#}

resource "google_compute_instance" "instance" {
  count        = "${var.num}"
  name         = "${var.name}${format("%02d", count.index + 1)}"
  machine_type = "${var.flavor}"

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  metadata = {
      ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }
  metadata_startup_script = "sudo zypper -y up"

  network_interface {
    network = "${var.db_vpc_name}"

    access_config {
      // Setup for external IP
         # nat_ip = "${element(google_compute_address.static.*.address, count.index)}"
    }
  }

  network_interface {
    network = "${var.backup_vpc_name}"
    subnetwork = "${var.backup_subnet_name}"
  }

  #network_interface {
  #  network = "${var.heartbeat_vpc_name}"
  #  subnetwork = "${var.heartbeat_subnet_name}"  
  #}

  attached_disk {
      device_name = "${var.name}${format("%02d", count.index + 1)}-usrsap${lower(lookup(var.cluster_disks[count.index], "sid", ""))}-pd01"
      source = "${element(google_compute_disk.hana_usr_disks.*.name, count.index)}"
  }

  attached_disk {
      device_name = "${var.name}${format("%02d", count.index + 1)}-hanadata${lower(lookup(var.cluster_disks[count.index], "sid", ""))}-pd01"
      source = "${element(google_compute_disk.hana_data_disks.*.name, count.index)}"
  }

  attached_disk {
      device_name = "${var.name}${format("%02d", count.index + 1)}-hanalog${lower(lookup(var.cluster_disks[count.index], "sid", ""))}-pd01"
      source = "${element(google_compute_disk.hana_log_disks.*.name, count.index)}"
  }

  attached_disk {
      device_name = "${var.name}${format("%02d", count.index + 1)}-hanashared${lower(lookup(var.cluster_disks[count.index], "sid", ""))}-pd01"
      source = "${element(google_compute_disk.hana_shared_disks.*.name, count.index)}"
  }

  attached_disk {
      device_name = "${var.name}${format("%02d", count.index + 1)}-hanadatabkp${lower(lookup(var.cluster_disks[count.index], "sid", ""))}-pd01"
      source = "${element(google_compute_disk.hana_databkp_disks.*.name, count.index)}"
  }

  attached_disk {
      device_name = "${var.name}${format("%02d", count.index + 1)}-hanalogbkp${lower(lookup(var.cluster_disks[count.index], "sid", ""))}-pd01"
      source = "${element(google_compute_disk.hana_logbkp_disks.*.name, count.index)}"
  }

}

# Create HANA 1plus1 disks
# /usr/sap/<SID> disks
resource "google_compute_disk" "hana_usr_disks" {
  count = "${var.num}"
  name = "${var.name}${format("%02d", count.index + 1)}-usrsap${lower(lookup(var.cluster_disks[count.index], "sid", ""))}-pd01"
  zone = "${var.zone}"
  type = "${lookup(var.cluster_disks[count.index], "usr_type", "")}"
  size = "${lookup(var.cluster_disks[count.index], "usr_size", "")}"
}

# /hana/data/<SID> disks
resource "google_compute_disk" "hana_data_disks" {
  count = "${var.num}"
  name = "${var.name}${format("%02d", count.index + 1)}-hanadata${lower(lookup(var.cluster_disks[count.index], "sid", ""))}-pd01"
  zone = "${var.zone}"
  type = "${lookup(var.cluster_disks[count.index], "data_type", "")}"
  size = "${lookup(var.cluster_disks[count.index], "data_size", "")}"
}

# /hana/log/<SID> disks
resource "google_compute_disk" "hana_log_disks" {
  count = "${var.num}"
  name = "${var.name}${format("%02d", count.index + 1)}-hanalog${lower(lookup(var.cluster_disks[count.index], "sid", ""))}-pd01"
  zone = "${var.zone}"
  type = "${lookup(var.cluster_disks[count.index], "log_type", "")}"
  size = "${lookup(var.cluster_disks[count.index], "log_size", "")}"
}

# /hana/shared/<SID> disks
resource "google_compute_disk" "hana_shared_disks" {
  count = "${var.num}"
  name = "${var.name}${format("%02d", count.index + 1)}-hanashared${lower(lookup(var.cluster_disks[count.index], "sid", ""))}-pd01"
  zone = "${var.zone}"
  type = "${lookup(var.cluster_disks[count.index], "shared_type", "")}"
  size = "${lookup(var.cluster_disks[count.index], "shared_size", "")}"
}

# /hana_backup/<SID>/data disks
resource "google_compute_disk" "hana_databkp_disks" {
  count = "${var.num}"
  name = "${var.name}${format("%02d", count.index + 1)}-hanadatabackup${lower(lookup(var.cluster_disks[count.index], "sid", ""))}-pd01"
  zone = "${var.zone}"
  type = "${lookup(var.cluster_disks[count.index], "databkp_type", "")}"
  size = "${lookup(var.cluster_disks[count.index], "databkp_size", "")}"
}

# /hana_backup/<SID>/log disks
resource "google_compute_disk" "hana_logbkp_disks" {
  count = "${var.num}"
  name = "${var.name}${format("%02d", count.index + 1)}-hanalogbackup${lower(lookup(var.cluster_disks[count.index], "sid", ""))}-pd01"
  zone = "${var.zone}"
  type = "${lookup(var.cluster_disks[count.index], "logbkp_type", "")}"
  size = "${lookup(var.cluster_disks[count.index], "logbkp_size", "")}"
}

resource "null_resource" "hana_usr_disk_mount" {
  count = "${var.num}"

  connection {
    host = element(
      google_compute_instance.instance.*.network_interface.0.access_config.0.nat_ip,
      count.index,
    )
    type        = "ssh"
    user        = "${var.gce_ssh_user}"
    private_key = file(var.gce_ssh_private_key_file)
    timeout  = "1m"
  }

  provisioner "file" {
    source      = "/home/kfmaster7777/terraform/hana_tf/modules/gcp/virtual-machine-hana/disk_mount.sh"
    destination = "/tmp/disk_mount.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -x /tmp/disk_mount.sh ${lookup(var.cluster_disks[count.index], "usr_lun", "")} ${lookup(var.cluster_disks[count.index], "usr_vg", "")} ${lookup(var.cluster_disks[count.index], "usr_lv", "")} ${lookup(var.cluster_disks[count.index], "usr_mount", "")} || sudo -n true"
    ]
  }

  depends_on = ["google_compute_instance.instance"]
}

resource "null_resource" "hana_data_disk_mount" {
  count = "${var.num}"

  connection {
    host = element(
      google_compute_instance.instance.*.network_interface.0.access_config.0.nat_ip,
      count.index,
    )
    type        = "ssh"
    user        = "${var.gce_ssh_user}"
    private_key = file(var.gce_ssh_private_key_file)
    timeout  = "1m"
  }

  provisioner "file" {
    source      = "/home/kfmaster7777/terraform/hana_tf/modules/gcp/virtual-machine-hana/disk_mount.sh"
    destination = "/tmp/disk_mount.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -x /tmp/disk_mount.sh ${lookup(var.cluster_disks[count.index], "data_lun", "")} ${lookup(var.cluster_disks[count.index], "data_vg", "")} ${lookup(var.cluster_disks[count.index], "data_lv", "")} ${lookup(var.cluster_disks[count.index], "data_mount", "")} || sudo -n true"
    ]
  }

  depends_on = ["google_compute_instance.instance"]
}

resource "null_resource" "hana_log_disk_mount" {
  count = "${var.num}"

  connection {
    host = element(
      google_compute_instance.instance.*.network_interface.0.access_config.0.nat_ip,
      count.index,
    )
    type        = "ssh"
    user        = "${var.gce_ssh_user}"
    private_key = file(var.gce_ssh_private_key_file)
    timeout  = "1m"
  }

  provisioner "file" {
    source      = "/home/kfmaster7777/terraform/hana_tf/modules/gcp/virtual-machine-hana/disk_mount.sh"
    destination = "/tmp/disk_mount.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -x /tmp/disk_mount.sh ${lookup(var.cluster_disks[count.index], "log_lun", "")} ${lookup(var.cluster_disks[count.index], "log_vg", "")} ${lookup(var.cluster_disks[count.index], "log_lv", "")} ${lookup(var.cluster_disks[count.index], "log_mount", "")} || sudo -n true"
    ]
  }

  depends_on = ["google_compute_instance.instance"]
}

resource "null_resource" "hana_shared_disk_mount" {
  count = "${var.num}"

  connection {
    host = element(
      google_compute_instance.instance.*.network_interface.0.access_config.0.nat_ip,
      count.index,
    )
    type        = "ssh"
    user        = "${var.gce_ssh_user}"
    private_key = file(var.gce_ssh_private_key_file)
    timeout  = "1m"
  }

  provisioner "file" {
    source      = "/home/kfmaster7777/terraform/hana_tf/modules/gcp/virtual-machine-hana/disk_mount.sh"
    destination = "/tmp/disk_mount.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -x /tmp/disk_mount.sh ${lookup(var.cluster_disks[count.index], "shared_lun", "")} ${lookup(var.cluster_disks[count.index], "shared_vg", "")} ${lookup(var.cluster_disks[count.index], "shared_lv", "")} ${lookup(var.cluster_disks[count.index], "shared_mount", "")} || sudo -n true"
    ]
  }

  depends_on = ["google_compute_instance.instance"]
}

resource "null_resource" "hana_databkp_disk_mount" {
  count = "${var.num}"

  connection {
    host = element(
      google_compute_instance.instance.*.network_interface.0.access_config.0.nat_ip,
      count.index,
    )
    type        = "ssh"
    user        = "${var.gce_ssh_user}"
    private_key = file(var.gce_ssh_private_key_file)
    timeout  = "1m"
  }

  provisioner "file" {
    source      = "/home/kfmaster7777/terraform/hana_tf/modules/gcp/virtual-machine-hana/disk_mount.sh"
    destination = "/tmp/disk_mount.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -x /tmp/disk_mount.sh ${lookup(var.cluster_disks[count.index], "databkp_lun", "")} ${lookup(var.cluster_disks[count.index], "databkp_vg", "")} ${lookup(var.cluster_disks[count.index], "databkp_lv", "")} ${lookup(var.cluster_disks[count.index], "databkp_mount", "")} || sudo -n true"
    ]
  }

  depends_on = ["google_compute_instance.instance"]
}

resource "null_resource" "hana_logbkp_disk_mount" {
  count = "${var.num}"

  connection {
    host = element(
      google_compute_instance.instance.*.network_interface.0.access_config.0.nat_ip,
      count.index,
    )
    type        = "ssh"
    user        = "${var.gce_ssh_user}"
    private_key = file(var.gce_ssh_private_key_file)
    timeout  = "1m"
  }

  provisioner "file" {
    source      = "/home/kfmaster7777/terraform/hana_tf/modules/gcp/virtual-machine-hana/disk_mount.sh"
    destination = "/tmp/disk_mount.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -x /tmp/disk_mount.sh ${lookup(var.cluster_disks[count.index], "logbkp_lun", "")} ${lookup(var.cluster_disks[count.index], "logbkp_vg", "")} ${lookup(var.cluster_disks[count.index], "logbkp_lv", "")} ${lookup(var.cluster_disks[count.index], "logbkp_mount", "")} || sudo -n true"
    ]
  }

  depends_on = ["google_compute_instance.instance"]
}