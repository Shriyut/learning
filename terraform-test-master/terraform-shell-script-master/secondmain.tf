provider "google" {
 credentials = "${file("credentials.json")}"
 project     = "practice-project-248415"
 region      = "us-central1"
}
resource "google_compute_address" "static" {
        name = "abc"
}
resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  tags = ["foo", "bar"]
  boot_disk {
    initialize_params {
      image = "centos-7-v20190905"
    }
  }
  // Local SSD disk
  scratch_disk {
  }
  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
        nat_ip = "${google_compute_address.static.address}"
        network_tier = "PREMIUM"
    }
  }
  
  metadata = {
    foo = "bar"
  }
  metadata_startup_script = " sudo yum install git -y; sudo yum install wget -y; cd /; cd /home/authentick9; sudo systemctl stop firewalld; sudo systemctl disable firewalld; sudo git clone https://github.com/Shriyut/terraform-shell-script.g
it ; cd terraform-shell-script/; sudo chmod 777 harbor.sh; sudo  ./harbor.sh; "
}
//data "google_compute_address" "terraform-ip" {
  //name = "terraform-ip"
//}
