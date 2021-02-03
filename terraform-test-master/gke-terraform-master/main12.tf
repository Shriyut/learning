provider "google" {
  credentials = "${file("credentials.json")}"
  project     = var.gcp_project_id
  region      = var.provider_region
}

provider "google-beta" {
  credentials = "${file("credentials.json")}"
  project = var.gcp_project_id
  region = var.provider_region
} 

resource "google_container_cluster" "test" {
provider = "google-beta"  
name = var.cluster_name
  location = var.cluster_location
  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count = var.initial_node_count
  enable_shielded_nodes = var.shielded_nodes

  enable_binary_authorization = var.binary_authorization
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = var.client_certificate
    }
  }
  network = var.network_name
  subnetwork = var.subnetwork_name

  default_max_pods_per_node = var.max_pods_per_node

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_start_time
    }
  }

  node_config {
      shielded_instance_config {
        enable_secure_boot = var.secure_boot
        enable_integrity_monitoring = var.integrity_monitoring
      }
      }

  lifecycle {
      ignore_changes = [
          node_config,
           ]
  }
  

  ip_allocation_policy {

  }

  private_cluster_config {
    enable_private_endpoint = var.private_endpoint
    enable_private_nodes = var.private_nodes
    master_ipv4_cidr_block = var.master_ipv4_cidr_block
  }
 master_authorized_networks_config {
       cidr_blocks {
               cidr_block = var.example_cidr_block
               display_name = var.example_display_name
           }
     }
 

 authenticator_groups_config {
    security_group = var.security_group
  } 
}
resource "google_container_node_pool" "ci_node_pool" {
  provider = "google-beta" 
  name = var.node_pool_name
  location = var.node_pool_location
  cluster = var.cluster_name
  initial_node_count = var.initial_node_count
  
  autoscaling {
    min_node_count = var.autoscale_min_node
    max_node_count = var.autoscale_max_node
  }

  management {
    auto_repair = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }

  node_config {
    preemptible = var.preemptible
    machine_type = var.node_machine_type
    metadata = var.metadata
    
    disk_size_gb = var.disk_gb_size
    disk_type = var.node_disk_type
    image_type = var.node_image_type
    oauth_scopes = var.oauth_scopes
  
  tags = var.node_tags

  labels = var.node_labels
  
  shielded_instance_config {
    enable_secure_boot = var.secure_boot
    enable_integrity_monitoring = var.integrity_monitoring
  }
  }

  max_pods_per_node = var.max_pods_per_node

  timeouts {
      create = "30m"
      update = "30m"
      delete = "30m"
  }
  depends_on = ["google_container_cluster.test"]

  provisioner "local-exec" {
      command = "gcloud container clusters update platform-storesys-ci --enable-network-egress-metering --enable-resource-consumption-metering --resource-usage-bigquery-dataset gke_usage_dataset --region us-central1"
  }

  provisioner "local-exec" {
      command = "gcloud container node-pools update ci-default --cluster platform-storesys-ci --max-surge-upgrade=1 --max-unavailable-upgrade=0 --region=us-central1" 
  }
}

