variable "gcp_service_list" {
    description = "List of GCP service to be enabled for a project"
    type = list(string)
}

variable "project_id" {
    type = string
    default = "cloudglobaldelivery-100135575"
}

variable "project_region" {
    type = string
    default = "us-central1"
}

variable "sql_ip_name" {
    type = string
    description = "IP name"
    default = "setupprivateip"
}

variable "sql_ip_purpose" {
    type = string
    default = "VPC_PEERING"
}

variable "sql_ip_address_type" {
    type = string
    default = "INTERNAL"
}

variable "sql_ip_prefix_length" {
    type = number
    default = 16
}

variable "private_network" {
    type = string
    default = "projects/cloudglobaldelivery-1000135575/global/networks/a-a-sample-vpc"
}

variable "sql_instance_region" {
    type = string
    default = "us-central1"
}

variable "database_version" {
    type = string
    default = "MYSQL_5_6"
}

variable "sql_instance_tier" {
    type = string
    default = "db-f1-micro"
}

variable "activation_policy" {
    type = string
    default = "ALWAYS"
}

variable "availability_type" {
    type = string
    default = "ZONAL"
}

variable "sql_disk_size" {
    type = string
    default = "10"
}
variable "sql_disk_type" {
    type = string
    default = "PD_HDD"
}

variable "ipv4_enabled" {
    type = bool
    default = "true"
}

variable "authorized_network_value" {
    type = string
}

variable "authorized_network_name" {
    type = string
}

variable "backup_configuration" {
    type = bool
    default = false
}

variable "binary_log" {
    type = bool
    default = false
}

variable "backup_starttime" {
    type = string
}

variable "maintenance_window_day" {
    type = number
}

variable "maintenance_window_hour" {
    type = number
}

variable "update_track" {
    type = string
    default = "stable"
}

variable "user_labels" {
    type = map(string)
}
