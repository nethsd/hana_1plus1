project_id                 = "eco-muse-260215"
region                     = "us-east4"
zone                       = "us-east4-a"

hana_db_vpc                = "dc101-hana-db-nw"
hana_db_bizx_subnet        = "dc101-hana-db-bizx-sbn"
hana_db_bizx_cidr          = "10.10.1.0/24"
hana_db_lms_subnet         = "dc101-hana-db-lms-sbn"
hana_db_lms_cidr           = "10.10.2.0/24"

hana_backup_vpc            = "dc101-hana-backup-nw"
hana_backup_subnet         = "dc101-hana-backup-sbn"
hana_backup_cidr           = "10.10.11.0/24"

hana_heartbeat_vpc         = "dc101-hana-heartbeat-nw"
hana_heartbeat_bizx_subnet = "dc101-hana-heartbeat-bizx-sbn"
hana_heartbeat_bizx_cidr   = "10.10.21.0/24"
hana_heartbeat_lms_subnet  = "dc101-hana-heartbeat-lms-sbn"
hana_heartbeat_lms_cidr    = "10.10.22.0/24"