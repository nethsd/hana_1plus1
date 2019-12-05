# Create HANA DB VPC network
resource "google_compute_network" "hana_db_network" {
  name                    = "${var.hana_db_vpc}"
  auto_create_subnetworks = false
}

# Create HANA Backup VPC network
resource "google_compute_network" "hana_backup_network" {
  name                    = "${var.hana_backup_vpc}"
  auto_create_subnetworks = false
}

# Create HANA Heartbeat VPC network
resource "google_compute_network" "hana_heartbeat_network" {
  name                    = "${var.hana_heartbeat_vpc}"
  auto_create_subnetworks = false
}

# Create HANA DB subnet
# HANA DB Bizx/WFA/ONB Subnet
resource "google_compute_subnetwork" "hana_db_bizx_subnetwork" {
  name  = "${var.hana_db_bizx_subnet}"
  ip_cidr_range = "${var.hana_db_bizx_cidr}"
  region        = "${var.region}"
  network       = "${google_compute_network.hana_db_network.self_link}"
}

# HANA DB LMS Subnet
resource "google_compute_subnetwork" "hana_db_lms_subnetwork" {
  name  = "${var.hana_db_lms_subnet}"
  ip_cidr_range = "${var.hana_db_lms_cidr}"
  region        = "${var.region}"
  network       = "${google_compute_network.hana_db_network.self_link}"
}

# Create HANA Backup subnet
# HANA Backup Subnet
resource "google_compute_subnetwork" "hana_backup_subnetwork" {
  name  = "${var.hana_backup_subnet}"
  ip_cidr_range = "${var.hana_backup_cidr}"
  region        = "${var.region}"
  network       = "${google_compute_network.hana_backup_network.self_link}"
}

# Create HANA Heartbeat subnet
# HANA Heartbeat BizX/WFA/ONB subnet
resource "google_compute_subnetwork" "hana_heartbeat_bizx_subnetwork" {
  name  = "${var.hana_heartbeat_bizx_subnet}"
  ip_cidr_range = "${var.hana_heartbeat_bizx_cidr}"
  region        = "${var.region}"
  network       = "${google_compute_network.hana_heartbeat_network.self_link}"
}

# HANA Heartbeat LMS subnet
resource "google_compute_subnetwork" "hana_heartbeat_lms_subnetwork" {
  name  = "${var.hana_heartbeat_lms_subnet}"
  ip_cidr_range = "${var.hana_heartbeat_lms_cidr}"
  region        = "${var.region}"
  network       = "${google_compute_network.hana_heartbeat_network.self_link}"
}

# Create Firewall rules for HANA DB VPC network
resource "google_compute_firewall" "hana_db_firewall_allow_tcp" {
  name    = "${var.hana_db_vpc}-fw-tcp"
  network = google_compute_network.hana_db_network.name
  source_ranges = [var.hana_db_fw_source_range]

  allow {
    protocol = "tcp"
    #ports    = ["22", "80", "443", "7630", "8001", "9100", "9002", "9090"]
    ports    = var.hana_db_fw_port_list
  }
}

resource "google_compute_firewall" "hana_db_firewall_allow_ssh" {
  name    = "${var.hana_db_vpc}-fw-ssh"
  network = google_compute_network.hana_db_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

# Create Firewall rules for HANA BACKUP VPC network
resource "google_compute_firewall" "hana_backup_firewall_allow_internal" {
  name          = "${var.hana_backup_vpc}-fw-internal"
  network       = google_compute_network.hana_backup_network.name
  source_ranges = [var.hana_backup_fw_source_range]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
}

# Create Firewall rules for HANA HEARTBEAT VPC network
resource "google_compute_firewall" "hana_heartbeat_firewall_allow_internal" {
  name          = "${var.hana_heartbeat_vpc}-fw-internal"
  network       = google_compute_network.hana_heartbeat_network.name
  source_ranges = [var.hana_heartbeat_fw_source_range]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
}