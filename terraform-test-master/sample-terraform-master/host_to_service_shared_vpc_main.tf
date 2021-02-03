provider "google" {
 credentials = "${file("credentials.json")}"
 project     = "${var.gcp_project_id}"
 region      = "${var.provider_region}"
}
resource "google_compute_network" "private_service_sql_network" {
  provider = "google"
  name       = "${var.vpc_name}"
  auto_create_subnetworks = "false"
}
resource "google_compute_subnetwork" "subnet1" {
  name          = "${var.vpc_subnet_name}-1"
  ip_cidr_range = "10.1.1.0/24"
  network       = "${var.vpc_name}"
  depends_on    = ["google_compute_network.private_service_sql_network"]
  region        = "${var.subnet_region}"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnet2" {
  name          = "${var.vpc_subnet_name}-2"
  ip_cidr_range = "10.2.1.0/24"
  network       = "${var.vpc_name}"
  depends_on    = ["google_compute_network.private_service_sql_network"]
  region        = "${var.subnet_region}"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnet3" {
  name          = "${var.vpc_subnet_name}-3"
  ip_cidr_range = "10.3.1.0/24"
  network       = "${var.vpc_name}"
  depends_on    = ["google_compute_network.private_service_sql_network"]
  region        = "${var.subnet_region}"
  private_ip_google_access = true
}


resource "google_compute_global_address" "private_service_sql_ip_address" {
  provider = "google"
  name          = "${var.ip_name}"
  purpose       = "VPC_PEERING"
  address_type = "INTERNAL"
  prefix_length = 16
  network       = "${google_compute_network.private_service_sql_network.self_link}"
}

resource "google_service_networking_connection" "private_sql_vpc_connection" {
  provider = "google"
  network       = "${google_compute_network.private_service_sql_network.self_link}"
  service       = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["${google_compute_global_address.private_service_sql_ip_address.name}"]
}
resource "random_id" "db_name_suffix" {
  byte_length = 4
}


resource "google_sql_database_instance" "instance" {
  provider = "google"
  name = "private-instance-${random_id.db_name_suffix.hex}"
  region = "${var.subnet_region}"
  depends_on = [
    "google_service_networking_connection.private_sql_vpc_connection"
  ]
  settings {
    tier = "${var.sql_machine_type}"
    ip_configuration {
      ipv4_enabled = false
      private_network = "${google_compute_network.private_service_sql_network.self_link}"
       authorized_networks {
        value = "${google_compute_address.reserveip.address}/32"
        name  = "${var.vpc_name}"
      }
     authorized_networks {
         value = "${google_compute_address.reserveipt.address}/32"
                  }
      
    authorized_networks {
          value = "${google_compute_address.reserveipo.address}/32"
      }
    }
  }
}

resource "google_compute_address" "reserveip" {
  name   = "reserveip"
  region = "${var.compute_region}"
}
resource "google_compute_instance" "default" {
  name         = "${var.first_instance}"
  machine_type = "${var.compute_machine_type}"
  zone         = "${var.compute_zone}"
  tags         = ["foo", "bar"]
  boot_disk {
    initialize_params {
      image = "${var.compute_image}"
    }
  }

  network_interface {

    //network    = "${google_compute_network.private_service_sql_network.self_link}"
    subnetwork = "${var.shared_subnet}"
    subnetwork_project = "${var.host_project}"
    access_config {
      nat_ip       = "${google_compute_address.reserveip.address}"
      network_tier = "PREMIUM"
    }
  }

  metadata = {
    foo = "bar"
  }
}

resource "google_compute_address" "reserveipt" {
  name   = "reserveipt"
  region = "${var.compute_region}"
}
resource "google_compute_instance" "defaultt" {
  name         = "${var.second_instance}"
  machine_type = "${var.compute_machine_type}"
  zone         = "${var.compute_zone}"
  tags         = ["foo", "bar"]
  boot_disk {
    initialize_params {
      image = "${var.compute_image}"
    }
  }

  network_interface {

    //network    = "${google_compute_network.private_service_sql_network.self_link}"
    subnetwork = "${var.shared_subnet}"
    subnetwork_project = "${var.host_project}"
    access_config {
      nat_ip       = "${google_compute_address.reserveipt.address}"
      network_tier = "PREMIUM"
    }
  }

  metadata = {
    foo = "bar"
  }
}

resource "google_compute_address" "reserveipo" {
  name   = "reserveipo"
  region = "${var.compute_region}"
}
resource "google_compute_instance" "defaulto" {
  name         = "${var.third_instance}"
  machine_type = "${var.compute_machine_type}"
  zone         = "${var.compute_zone}"
  tags         = ["foo", "bar"]
  boot_disk {
    initialize_params {
      image = "${var.compute_image}"
    }
  }

  network_interface {

    //network    = "${google_compute_network.private_service_sql_network.self_link}"
    subnetwork = "${var.shared_subnet}"
    subnetwork_project = "${var.host_project}"
    access_config {
      nat_ip       = "${google_compute_address.reserveipo.address}"
      network_tier = "PREMIUM"
    }
  }

  metadata = {
    foo = "bar"
  }
}

resource "google_bigquery_dataset" "dataset" {
  project                     = "project-1-256305"  
  dataset_id                  ="${var.dataset_id}"
  friendly_name               = "${var.bq_friendly_name}"
  description                 = "Created via Terraform"
  location                    = "${var.bq_location}"
 // default_table_expiration_ms = 3600000

  labels = {
    env = "default"
  }

  access {
    role          = "OWNER"
    user_by_email = "${var.bq_owner_email}"
  }
  access {
    role   = "READER"
    domain = "cognizant.com"
  }
}



resource "google_storage_bucket" "storage_bucket" {
  project  = "project-1-256305" 
  name     = "${var.bucket_name}"
  location = "${var.bucket_location}"
  storage_class = "${var.bucket_class}"
}





resource "google_compute_firewall" "default" {
  name    = "${var.first_firewall}"
  network = "${var.shared_vpc_name}"
  project = "${var.host_project}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
      protocol = "udp"
      ports    = ["0-65535"]
  }

  //source_tags = ["web"]

  source_ranges = ["10.250.230.0/24"]
  
  priority = "1000"
}
  

resource "google_compute_firewall" "defaulta" {
  name    = "${var.second_firewall}"
  network = "${var.shared_vpc_name}"
  project = "${var.host_project}"

  target_service_accounts = "${var.target_second_sa}"

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  
  source_service_accounts = "${var.source_second_sa}" 
  
  priority = "1000"
}

resource "google_compute_firewall" "defaultb" {
  name    = "${var.third_firewall}"
  network = "${var.shared_vpc_name}"
  project = "${var.host_project}"

  target_tags = "${var.third_network_tag}"

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  
  source_ranges = ["10.250.230.0/24"]
  
  priority = "1000"
}

resource "google_compute_firewall" "defaultc" {
  name    = "${var.fourth_firewall}"
  network = "${var.shared_vpc_name}"
  project = "${var.host_project}"

  target_service_accounts = "${var.target_fourth_firewall_sa}"

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  
  source_service_accounts = "${var.source_fourth_firewall_sa}" 
  
  priority = "1000"
}

resource "google_compute_firewall" "defaultd" {
  name    = "${var.fifth_firewall}"
  network = "${var.shared_vpc_name}"
  project = "${var.host_project}"

  target_tags = "${var.fifth_firewall_tag}"

  allow {
    protocol = "tcp"
    ports    = ["88", "135", "445", "464", "389", "636", "3268", "3269", "49152-65535"]
  }

  allow {
      protocol = "udp"
      ports    = ["88", "123", "389", "464"]
  }

  allow {
      protocol = "icmp"
  }
  
  source_ranges = ["10.250.230.0/24", "10.250.240.0/24"]
  
  priority = "1000"
}

resource "google_compute_firewall" "defaulte" {
  name    = "${var.sixth_firewall}"
  network = "${var.shared_vpc_name}"
  project = "${var.host_project}"

  target_tags = "${var.sixth_firewall_tag}"

  allow {
    protocol = "tcp"
    ports    = ["53"]
  }

  allow {
      protocol = "udp"
      ports    = ["53"]
  }
  
  source_ranges = ["10.250.230.0/24", "10.250.240.0/24"]
  
  priority = "1000"
}

resource "google_compute_firewall" "defaultf" {
  name    = "${var.seventh_firewall}"
  network = "${var.shared_vpc_name}"
  project = "${var.host_project}"

  target_tags = "${var.target_seventh_firewall_tag}"

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  
  source_tags = "${var.source_seventh_firewall_tag}"
  
  priority = "1000"
}

resource "google_compute_firewall" "defaultg" {
  name    = "${var.eight_firewall}"
  network = "${var.shared_vpc_name}"
  project = "${var.host_project}"

  target_tags = "${var.target_seventh_firewall_tag}"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  
  source_ranges = ["195.157.67.82/32"]
  
  priority = "1000"
}
