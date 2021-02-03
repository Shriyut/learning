gcp_service_list = [
    "servicenetworking.googleapis.com"
]
project_id = "cloudglobaldelivery-1000135575"
project_region = "us-central1"
sql_ip_name = "sqlipaddress"
sql_ip_purpose = "VPC_PEERING"
sql_ip_address_type = "INTERNAL"
sql_ip_prefix_length = 16
private_network = "projects/cloudglobaldelivery-1000135575/global/networks/a-a-sample-vpc"
sql_instance_region = "us-central1"
database_version = "MYSQL_5_7"
sql_instance_tier = "db-f1-micro"
activation_policy = "ALWAYS"
availability_type = "REGIONAL"
sql_disk_size = "10"
sql_disk_type = "PD_HDD"
ipv4_enabled = false
authorized_network_value = "34.69.40.22/32"
authorized_network_name = "example"
backup_configuration  = true
binary_log = true
backup_starttime = "00:00"
maintenance_window_day = 7
maintenance_window_hour = 0
update_track = "stable"
user_labels = {
    "environment" = "test"
    "team" = "gcp"
}
