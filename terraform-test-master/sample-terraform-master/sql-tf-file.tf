provider "google" {
 credentials = "${file("credentials.json")}"
 project     = "cloudglobaldelivery-1000135575"
 region      = "us-central1"
}

resource "google_compute_network" "private_network" {
  provider = "google"

  name       = "private-network"
}
resource "google_compute_global_address" "private_ip_address" {
  provider = "google"
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type = "INTERNAL"
  prefix_length = 16
  network       = "${google_compute_network.private_network.self_link}"
}
resource "google_service_networking_connection" "private_vpc_connection" {
  provider = "google"
  network       = "${google_compute_network.private_network.self_link}"
  service       = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["${google_compute_global_address.private_ip_address.name}"]
}
resource "random_id" "db_name_suffix" {
  byte_length = 4
}
resource "google_sql_database_instance" "instance" {
  provider = "google"
  name = "private-instance-${random_id.db_name_suffix.hex}"
  region = "us-central1"
  depends_on = [
    "google_service_networking_connection.private_vpc_connection"
  ]
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = false
      private_network = "${google_compute_network.private_network.self_link}"
    }
  }
}
