project_id = "eco-muse-260215"
region     = "us-east4"
zone       = "us-east4-a"
#vm_name    = "tf-test01"
flavor     = "f1-micro"
image      = "sles-15-sp1-v20191113"

db_vpc_name        = "default"
backup_vpc_name    = "dc101-hana-backup-nw"
heartbeat_vpc_name = "dc101-hana-heartbeat-nw"

db_subnet_name        = "default"
backup_subnet_name    = "dc101-hana-backup-sbn"
heartbeat_subnet_name = "dc101-hana-heartbeat-bizx-sbn"

dc        = 101
dc_prefix = "pc"
env = "production"
component_name = "hana"
#location = "Canada Central"
tags = "DC47 BIZX HANA NON PROD"
source_env = ""
hostname_prefix = "pc101"
num = 2

vm_tags = {
  Owner = "Seshadri Chandragiri"
  Application = "Bizx Non Prod HANA 1plus1"
  "VM Expiration date" = "NA"
}

bootstrap_config = {
  automation_username      = "deployer"
  automation_user_id       = "4001"
  automation_environment   = "dc101_hana_prod"
  automation_template_path = "/automation/github/dc101_hana_prod/hcm-chef-automation/platform/rundeck-jobs/chef-full.erb"
  name_servers             = "10.169.165.68,10.169.165.69"
  automation_mount         = "10.169.165.202,vol1_automation_vol01"
  roaming_mount            = "10.169.165.202,vol1_home_roaming_vol01"
  suse_repo                = "10.169.164.138"
  role = "hcm_db_hana_os_setup"
}


hana_1plus1_clusters = {
   hana_1plus1 = {
    vm_size = "f1-micro"
    sid = "BP9"
    osdisk_size_gb = "100"
    hdd_disk_different_size_gb = "100,100,30"
    lb_private_ip = "10.169.208.50"
    lb_frontend_port = "30815,1128,1129,22"
    lb_backend_port = "30815,1128,1129,22"
    lb_probe_port = "62503,62503,62503,62503"
  }
}

disks = [ {name="cluster-node1", sid="BP9", usr_mount="/usr/sap/BP9", usr_size="1", usr_type="pd-standard", usr_lun=2, usr_vg="vgsharedsap", usr_lv="BP9_usr_sap_node1", data_mount="/hana/data/BP9", data_size="2", data_type="pd-standard", data_lun=3,  data_vg="vgdata", data_lv="BP9_data_mnt00001", log_mount="/hana/log/BP9", log_size="3", log_type="pd-standard", log_lun=4,  log_vg="vglog", log_lv="BP9_log_mnt00001", shared_mount="/hana/shared/BP9", shared_size="4", shared_type="pd-standard", shared_lun=5,  shared_vg="vgshared", shared_lv="BP9_shared", databkp_mount="/hana_backup/BP9/data", databkp_size="5", databkp_type="pd-standard", databkp_lun=6,  databkp_vg="vgbkpdata", databkp_lv="BP9_data_backup", logbkp_mount="/hana_backup/BP9/log", logbkp_size="6", logbkp_type="pd-standard", logbkp_lun=7, logbkp_vg="vgbkplog", logbkp_lv="BP9_log_backup"}, {name="cluster-node2", sid="BP9", usr_mount="/usr/sap/BP9", usr_size="1", usr_type="pd-standard", usr_lun=2, usr_vg="vgsharedsap", usr_lv="BP9_usr_sap_node2", data_mount="/hana/data/BP9", data_size="2", data_type="pd-standard", data_lun=3, data_vg="vgdata", data_lv="BP9_data_mnt00002", log_mount="/hana/log/BP9", log_size="3", log_type="pd-standard", log_lun=4, log_vg="vglog", log_lv="BP9_log_mnt00002", shared_mount="/hana/shared/BP9", shared_size="4", shared_type="pd-standard", shared_lun=5, shared_vg="vgshared", shared_lv="BP9_shared", databkp_mount="/hana_backup/BP9/data", databkp_size="5", databkp_type="pd-standard", databkp_lun=6, databkp_vg="vgbkpdata", databkp_lv="BP9_data_backup", logbkp_mount="/hana_backup/BP9/log", logbkp_size="6", logbkp_type="pd-standard", logbkp_lun=7, logbkp_vg="vgbkplog", logbkp_lv="BP9_log_backup"} ]
#disks = [ {name="cluster-node1" sid="BP9" usr_mount="/usr/sap/BP9" usr_size="64" usr_type="Premium_LRS" usr_lun=21 usr_vg="vgsharedsap" usr_lg="BP9_usr_sap_node1" data_mount= "/hana/data/BP9" data_size="1024" data_disk_count=3 data_type="Premium_LRS" data_lun="51,52,53" data_vg="vgdata" data_lg="BP9_data_mnt00001" shared_mount= "/hana/shared/BP9" shared_size="512" shared_type="Premium_LRS" shared_lun=25 shared_vg="vgshared" shared_lg="BP9_shared" log_mount= "/hana/log/BP9" log_size="512" log_disk_count=2 log_type="Premium_LRS" log_lun="54,55" log_vg="vglog" log_lg="BP9_log_mnt00001" databkp_mount= "/hana_backup/BP9/data" databkp_size="1024" databkp_type="Premium_LRS" databkp_lun=29 databkp_vg="vgbkpdata" databkp_lg="BP9_data_backup" logbkp_mount= "/hana_backup/BP9/log" logbkp_size="512" logbkp_type="Premium_LRS" logbkp_lun=31 logbkp_vg="vgbkplog" logbkp_lg="BP9_log_backup" }, {name="cluster-node2" sid="BP9" usr_mount="/usr/sap/BP9" usr_size="64" usr_type="Premium_LRS" usr_lun=22 usr_vg="vgsharedsap" usr_lg="BP9_usr_sap_node2" data_mount= "/hana/data/BP9" data_size="1024" data_disk_count=3 data_type="Premium_LRS" data_lun="51,52,53" data_vg="vgdata" data_lg="BP9_data_mnt00002" shared_mount= "/hana/shared/BP9" shared_size="512" shared_type="Premium_LRS" shared_lun=25 shared_vg="vgshared" shared_lg="BP9_shared" log_mount= "/hana/log/BP9" log_size="512" log_disk_count=2 log_type="Premium_LRS" log_lun="54,55" log_vg="vglog" log_lg="BP9_log_mnt00002" databkp_mount= "/hana_backup/BP9/data" databkp_size="1024" databkp_type="Premium_LRS" databkp_lun=29 databkp_vg="vgbkpdata" databkp_lg="BP9_data_backup" logbkp_mount= "/hana_backup/BP9/log" logbkp_size="512" logbkp_type="Premium_LRS" logbkp_lun=31 logbkp_vg="vgbkplog" logbkp_lg="BP9_log_backup" } ]

admin_username = "kfmaster7777"
admin_password = "test"
