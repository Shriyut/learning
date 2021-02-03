provider "google" {
  credentials = "${file("credentials.json")}"
  project     = "cloudglobaldelivery-1000135575"
  region      = "us-central1"
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                  ="bq_metering_dataset"
  friendly_name               = "bqfriendlyname"
  description                 = "Created via Terraform"
  location                    = "US"
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

resource "google_container_cluster" "test" {
  name = "platform-storesys-ci"
  location = "us-central1"
  remove_default_node_pool = true
  initial_node_count = 1
  enable_shielded_nodes = true

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
  network = "a-a-sample-vpc"
  subnetwork = "sample-us-central1"

  default_max_pods_per_node = 110

  maintenance_policy {
    daily_maintenance_window {
      start_time = "10:30"
      #end_time   = "14:00"
    }
  }

  node_config {
      shielded_instance_config {
          enable_integrity_monitoring = true
      }

       upgrade_settings {
         max_surge = 1
        max_unavailable = 0
  }
       
  }

  lifecycle {
      ignore_changes = [
          node_config, upgrade_settings,
      ]
      }
  
  resource_usage_export_config {
    enable_network_egress_metering = true

    bigquery_destination = {
      dataset_id = "bq_metering_dataset"
    }
  }
  
  authenticator_groups_config {
        security_group = "gke-security-groups@cognizant.com"
  }

  ip_allocation_policy {

  }

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes = true
    master_ipv4_cidr_block = "172.16.0.0/28"
  }
 master_authorized_networks_config = [
     {
       cidr_blocks = [
           {
               cidr_block = "34.66.82.14/32"
               display_name = "bastion"
           },
       ]
     },
 ]
  
  depends_on = ["google_bigquery_dataset.dataset"]
}
resource "google_container_node_pool" "ci_node_pool" {
  name = "ci-default"
  location = "us-central1"
  cluster = "google_container_cluster.test.name"
  initial_node_count = 1
  
  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  management {
    auto_repair = "true"
    auto_upgrade = "false"
  }

  node_config {
    preemptible = false
    machine_type = "n1-standard-1"
    metadata = {
      disable-legacy-endpoint = "true"
      node_pool               = "ci-default"
      cluster_name            = "platform-storesys-ci"
    }
    disk_size_gb = "100"
    disk_type = "pd-standard"
    image_type = "coreos-stable-2345-3-0-v20200302"
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  
  tags = ["gke-platform-storesys-ci", "gke-platform-storesys-ci-ci-default", "gke", "healthchecks"]

  labels = {
    cluster_name = "platform-storesys-ci"
    node_pool    = "ci-default"
  }
  
  shielded_instance_config {
    enable_integrity_monitoring = true
  }
  }

 

  max_pods_per_node = 110

  

  timeouts {
      create = "30m"
      update = "30m"
      delete = "30m"
  }
  
  depends_on = ["google_bigquery_dataset.dataset"]
}
