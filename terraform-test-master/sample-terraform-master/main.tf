provider "google" {
 credentials = "${file("credentials.json")}"
 project     = "${var.gcp_project}"
 region      = "${var.region}"
}



resource "google_compute_instance" "vm" {
  name         = "${var.instance_name}"
  machine_type = "${var.instance_type}"
  zone         = "${var.instance_zone}"
  tags = ["foo", "bar"]
  boot_disk {
    initialize_params {
      image = "${var.instance_image}"
    }
  }
  // Local SSD disk
  scratch_disk {
  }
  network_interface {
    network = "${var.instance_vpc}"
  //  access_config {
      // Ephemeral IP
    //    nat_ip = "${google_compute_address.static.address}"
      //  network_tier = "PREMIUM"
  //  }
  }
  
  metadata = {
    foo = "bar"
  }
}

resource "google_sql_database" "database" {
    name = "${var.sql_db_name}"
    instance = "${google_sql_database_instance.instance.name}"
}

resource "google_sql_database_instance" "instance" {
    name = "${var.sql_db_instance_name}"
    region = "${var.sql_region}"
    settings {
        tier = "D0"
    }
}


resource "google_bigquery_dataset" "dataset" {
  dataset_id                  ="${var.bq_dataset_id}"
  friendly_name               = "${var.bq_dataset_friendly_name}"
  description                 = "Created via Terraform"
  location                    = "${var.bq_location}"
 // default_table_expiration_ms = 3600000

  labels = {
    env = "default"
  }

  access {
    role          = "OWNER"
    user_by_email = "shriyut.jha@cognizant.com"
  }
  access {
    role   = "READER"
    domain = "cognizant.com"
  }
}



resource "google_storage_bucket" "an-example-1112233343" {
  name     = "${var.bucket_name}"
  location = "${var.bucket_location}"
  storage_class = "${var.bucket_class}"
}
