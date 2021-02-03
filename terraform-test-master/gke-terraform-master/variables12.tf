variable "gcp_project_id" {}
variable "provider_region" {}
variable "cluster_name" {}
variable "initial_node_count" {}
variable "cluster_location" {}
variable "remove_default_node_pool" {}
variable "shielded_nodes" {}
variable "binary_authorization" {}
variable "client_certificate" {}
variable "max_pods_per_node" {}
variable "maintenance_start_time" {}
variable "private_endpoint" {}
variable "private_nodes" {}
variable "example_cidr_block" {}
variable "example_display_name" {}
variable "autoscale_min_node" {}
variable "autoscale_max_node" {}
variable "auto_repair" {}
variable "auto_upgrade" {}
variable "preemptible" {}
variable "metadata" {
    type = map(string)
    default = {
        disable-legacy-endpoint = "true"
    }
}
variable "disk_gb_size" {}
variable "network_name" {}
variable "subnetwork_name" {}
variable "master_ipv4_cidr_block" {}
variable "security_group" {}
variable "node_pool_name" {}
variable "node_pool_location" {}
variable "node_machine_type" {}
variable "node_disk_type" {}
variable "node_image_type" {}
variable "oauth_scopes" {
    type = list(string)
    default = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
}
variable "node_tags" {
    type = list(string)
    default = ["gke-node"]
}
variable "node_labels" {
    type = map(string)
}
variable "secure_boot" {}
variable "integrity_monitoring" {}
