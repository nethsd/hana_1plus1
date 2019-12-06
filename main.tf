#Define local variables
locals {
  name                           = "${var.dc_prefix}${var.dc}-${var.source_env}"
  component_name_with_env        = "${replace(local.name, "/-$/", "")}-${var.component_name}"
  db_vpc_name                    = "${var.db_vpc_name}"
  db_subnet_name                 = "${var.db_subnet_name}"
  backup_vpc_name                = "${var.backup_vpc_name}"
  backup_subnet_name             = "${var.backup_subnet_name}"
  heartbeat_vpc_name             = "${var.heartbeat_vpc_name}"
  heartbeat_subnet_name          = "${var.heartbeat_subnet_name}"
  bootstrap_config               = "${merge(var.bootstrap_config, map("dc", var.dc))}"
}

module "hana_1plus1_VM" {
  source                     = "./modules/gcp/virtual-machine-hana"
  name                       = "${var.source_env}${var.hostname_prefix}hdb${lower(lookup(var.hana_1plus1_clusters["hana_1plus1"], "sid"))}"
  db_vpc_name                = "${var.db_vpc_name}"
  backup_vpc_name            = "${var.backup_vpc_name}"
  heartbeat_vpc_name         = "${var.heartbeat_vpc_name}"
  db_subnet_name             = "${var.db_subnet_name}"
  use_backened_pool          = true
  num                 = "${var.num}"
  vm_size             = "${lookup(var.hana_1plus1_clusters["hana_1plus1"], "vm_size")}"
  osdisk_size_gb      = "${lookup(var.hana_1plus1_clusters["hana_1plus1"], "osdisk_size_gb")}"
  admin_username      = "${var.admin_username}"
  admin_password      = "${var.admin_password}"
  bootstrap_config    = "${local.bootstrap_config}"
  zone                = "${var.zone}"
  flavor              = "${var.flavor}"
  image               = "${var.image}"
  backup_subnet_name    = "${var.backup_subnet_name}"
  heartbeat_subnet_name    = "${var.heartbeat_subnet_name}"
  cluster_disks       = "${var.disks}"
  tags                = "${var.vm_tags}"
}

# Get details of instance
#data $module.hana_1plus1_VM.google_compute_instance.instance[1]
