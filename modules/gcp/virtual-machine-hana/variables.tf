variable "tags" {
  default = {}
}

variable "dc" {
  default = ""
}
variable "db_vpc_name" {}
variable "backup_vpc_name" {}
variable "heartbeat_vpc_name" {}

variable "db_subnet_name" {}

variable "gce_ssh_user" {
    default = "kfmaster7777"
}

variable "gce_ssh_pub_key_file" {
    default = "/home/kfmaster7777/.ssh/google_compute_engine.pub"
}

variable "name" {}

variable "flavor" {}

#Bootstraping Config
variable "bootstrap_config" {
  default = {}
}

variable "num" {
  default = 1
}

variable "vm_size" {}

variable "admin_username" {}

variable "admin_password" {}

variable "osdisk_size_gb" {
  default = ""
}

variable "hdd_disk_size_gb" {
  default = ""
}

variable "hdd_disk_count" {
  default = 0
}

variable "ssd_lun_start" {
  default = "21"
}

variable "hdd_lun_start" {
  default = "10"
}

variable "ssd_disk_size_gb" {
  default = ""
}

variable "ssd_disk_count" {
  default = 0
}

variable "backup_subnet_name" {
  default = ""
}

variable "heartbeat_subnet_name" {
  default = ""
}

variable "image" {
}

variable "backend_pool_ids" {
  type    = "list"
  default = []
}

variable "use_backened_pool" {
  default = false
}
variable "is_cluster" {
  default = true
}
variable "chef_tags" {
  default = ""
}

variable "zone" {
}


variable "init_config" {
  default = {}
}

variable "is_multi_clusters" {
  default = false
}

variable "num_of_node_per_cluster" {
  default = "1"
}

variable "cluster_disks" {
  type = "list"
}

