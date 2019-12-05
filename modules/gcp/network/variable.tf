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