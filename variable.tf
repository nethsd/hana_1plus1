variable "project_id" {}
variable "region" {}
variable "zone" {}
#variable "vm_name" {}
variable "flavor" {}
variable "image" {}

variable "dc" {}
variable "dc_prefix" {}
variable "env" {}

variable "db_vpc_name" {}
variable "db_subnet_name" {}
variable "backup_vpc_name" {}
variable "backup_subnet_name" {}
variable "heartbeat_vpc_name" {}
variable "heartbeat_subnet_name" {}


variable "tags" {}

variable "component_name" {
  default = "bizx"
}

variable "bootstrap_config" {
  type = "map"
}

variable "vm_tags" {
  type = "map"
}


variable "source_env" {
  description = "Provide the source environment name. Such as hcm4 or hcm8, etc."
}

variable "hostname_prefix" {
  description = "Provide the hostname prefix for the servers. Such as pc4, pc8, sc17, etc."
}

variable "admin_username" {}
variable "admin_password" {}

variable "hana_1plus1_clusters" {
  type = "map"
}

variable "num" {
default = "0"
}

variable "disks" {
    type="list"
    default=[]
}
