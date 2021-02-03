provider "google" {
    credentials = "${file("credentials.json")}"
    project = var.project_id
    region = var.project_region
}

resource "google_project_service" "gcp_services" {
    count = length(var.gcp_service_list)
    service = var.gcp_service_list[count.index]
}

resource "google_compute_global_address" "private_sql_ip_address" {
    provider = google
    name = var.sql_ip_name
    purpose = var.sql_ip_purpose
    address_type = var.sql_ip_address_type
    prefix_length = var.sql_ip_prefix_length
    network = var.private_network
}

resource "google_service_networking_connection" "private_sql_vpc_connection" {
    provider = google
    network = var.private_network
    service = "servicenetworking.googleapis.com"
    reserved_peering_ranges = ["${google_compute_global_address.private_sql_ip_address.name}"]
    depends_on = [
        google_project_service.gcp_services,
        ]
}

resource "random_id" "db_name_suffix" {
    byte_length = 4
}

resource "google_sql_database_instance" "instance" {
    provider = google
    database_version = var.database_version
    name = "private-instance-${random_id.db_name_suffix.hex}"
    region = var.sql_instance_region
    depends_on = [google_service_networking_connection.private_sql_vpc_connection]
    settings {
        tier = var.sql_instance_tier
        activation_policy = var.activation_policy
        availability_type = var.availability_type
        disk_size = var.sql_disk_size
        disk_type = var.sql_disk_type
        ip_configuration {
            ipv4_enabled = var.ipv4_enabled
            private_network = var.private_network
            authorized_networks {
                value = var.authorized_network_value
                name = var.authorized_network_name
            }

        }
        backup_configuration {
                enabled = var.backup_configuration
                binary_log_enabled = var.binary_log
                start_time = var.backup_starttime
            }

        maintenance_window {
            day = var.maintenance_window_day
            hour = var.maintenance_window_hour
            update_track = var.update_track
        }

        user_labels = var.user_labels
    }
    
}
