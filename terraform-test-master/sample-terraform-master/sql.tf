provider "google" {
    credentials = "${file("credentials.json")}"
    project = "cloudglobaldelivery-1000135575"
    region = "us-central1"
}

resource "google_compute_global_address" "private_sql_ip_address" {
    provider = "google"
    name = "setupprivateip"
    purpose = "VPC_PEERING"
    address_type = "INTERNAL"
    prefix_length = 16
    network = "a-a-sample-vpc"
}

resource "google_service_networking_connection" "private_sql_vpc_connection" {
    provider = "google"
    network = "a-a-sample-vpc"
    service = "servicenetworking.googleapis.com"
    reserved_peering_ranges = ["${google_compute_global_address.private_sql_ip_address.name}"]

}

resource "random_id" "db_name_suffix" {
    byte_length = 4
}

resource "google_sql_database_instance" "instance" {
    provider = "google"
    name = "private-instance-${random_id.db_name_suffix.hex}"
    region = "us-central1"
    depends_on = [google_service_networking_connection.private_sql_vpc_connection]
    settings {
        tier = "db-f1-micro"
        ip_configuration {
            ipv4_enabled = false
            private_network = "projects/cloudglobaldelivery-1000135575/global/networks/a-a-sample-vpc"
            authorized_networks {
                value = "34.69.40.22/32"
                name = "example"
            }
        }
    }
}
