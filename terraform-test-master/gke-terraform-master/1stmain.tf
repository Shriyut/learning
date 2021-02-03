provider "google" {
  credentials = "${file("credentials.json")}"
  project     = "cloudglobaldelivery-1000135575"
  region      = "us-central1"
}

provider "google-beta" {
        credentials = "${file("credentials.json")}"
        project = "cloudglobaldelivery-1000135575"
        region = "us-central1"
} 

resource "google_container_cluster" "test" {
provider = "google-beta"  
name = "platform-storesys-ci"
  location = "us-central1"
  remove_default_node_pool = true
  initial_node_count = 1
 enable_shielded_nodes = true

  enable_binary_authorization = true
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
        enable_secure_boot = true  
        enable_integrity_monitoring = true
      }
      }

  lifecycle {
      ignore_changes = [
          "node_config"
      ]
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
       ]
     },
 ]
 authenticator_groups_config {
            security_group = "gke-security-groups@cognizant.com"
  } 
}
resource "google_container_node_pool" "ci_node_pool" {
        provider = "google-beta" 
 name = "ci-default"
  location = "us-central1"
  cluster = "platform-storesys-ci"
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
    }
    
    
    disk_size_gb = "100"
    disk_type = "pd-standard"
    image_type = "COS"
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  
  tags = ["gke-platform-storesys-ci", "gke-platform-storesys-ci-ci-default", "gke", "healthchecks"]

  labels {
    cluster_name = "platform-storesys-ci"
    node_pool    = "ci-default"
  }
  
  shielded_instance_config {
        enable_secure_boot = true
    enable_integrity_monitoring = true
  }
  }


  max_pods_per_node = 110

  

  timeouts {
      create = "30m"
      update = "30m"
      delete = "30m"
  }
  
}
