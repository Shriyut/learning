provider "google" {
	credentials = "credentials.json"
	project = "cloudglobaldelivery-1000135575"
	region = "us-central1"
}

data "google_compute_address" "vmip" {
	name = "testingip"
	project = "cloudglobaldelivery-1000135575"
}

resource "google_compute_instance" "vm" {
	name = "testvm"
	machine_type = "n1-standard-1"
	zone = "us-central1-a"

	boot_disk {
		initialize_params {
			image = "centos-7-v20190905"
		}
	}

	network_interface {
		network = "default"

		access_config {
			nat_ip = data.google_compute_address.vmip.address
			network_tier = "PREMIUM"

		}
	}
}
