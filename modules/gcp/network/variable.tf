variable "project_id" {}
variable "region" {}
variable "zone" {}

variable "hana_db_vpc" {}
variable "hana_backup_vpc" {}
variable "hana_heartbeat_vpc" {}

variable "hana_db_bizx_subnet" {}
variable "hana_db_bizx_cidr" {}

variable "hana_db_lms_subnet" {}
variable "hana_db_lms_cidr" {}

variable "hana_backup_subnet" {}
variable "hana_backup_cidr" {}

variable "hana_heartbeat_bizx_subnet" {}
variable "hana_heartbeat_bizx_cidr" {}

variable "hana_heartbeat_lms_subnet" {}
variable "hana_heartbeat_lms_cidr" {}

variable "hana_db_fw_port_list" {
    default = ["22"]
}

variable "hana_db_fw_source_range" {
    default = "10.0.0.0/8"
}

variable "hana_backup_fw_source_range" {
    default = "10.0.0.0/8"
}
variable "hana_heartbeat_fw_source_range" {
    default = "10.0.0.0/8"
}