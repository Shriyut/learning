#script doesnt work

provider "google" {
        credentials = "credentials.json"
        region = "us-central1"
        project = "cloudglobaldelivery-1000135575"
}

resource "google_compute_address" "first" {
        name = "firstip"
        region = "us-central1"

}

resource "google_compute_instance" "firstvm" {
        name = "firstvm"
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
                nat_ip = google_compute_address.first.address
        }
        }


}

resource "google_compute_address" "second" {
        name = "secondip"
        region = "us-central1"

}

resource "google_compute_instance" "secondvm" {
        name = "secondvm"
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
                nat_ip = google_compute_address.second.address
                network_tier = "PREMIUM"
        }


        }

        #metadata = {
    #ssh-keys = "USERNAME:${file("~/.ssh/id_rsa.pub")}"
  #}

        metadata_startup_script = "cd /; touch makefile.txt; sudo echo \"string xyz bgv\" >>./makefile.txt"

        provisioner "remote-exec" {

        inline = [
                "sudo sed -i 's/xyz/google_compute_address.first.address/gI' /makefile.txt"
        ]

        connection {
                type = "ssh"
                #port = 22
                host = self.network_interface[0].access_config[0].nat_ip
                user = "shriyut_jha"
                timeout = "120s"
                #agent = false
                private_key = file("~/.ssh/google_compute_engine")
                #host_key = file("~/.ssh/google_compute_engine.pub")
                host_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDFKvDTgGk6b5bEHt4y6IVmMRUgcR+tXFiPwzcMJyjiOhLf5RzHdRFi1DRKVh9vbSDl8gmj5xH1emibLE+L3Y+2bcdcKMZwmX8YLeqAWKgt4Tc3jzDuVXLDHfy2uND9KT9Pns1CIcSA0C6y1M5JPlmCbSPS6WPG6VyNm4nW3TZfZ2iNXABtcSl/QVSo5XbIcro0Z8Bj9pLHB6Lt/JarPihfAabdTVyeRUTJm6ZCIaGsP9WEHSOE4rEETc/Hm3DohkcWYF8fjM6WwsfvzPNBRSnXxbYAW3FUc9HgIsiwN6VQjcuTGq1YS2zARu1ceOT8p5jgzmagtYX8uI6yxDGIYNRz shriyut_jha@cs-6000-devshell-vm-4c381571-5cc7-43a5-bbb7-a73a7c2157ec"
        }
	}

        depends_on = [google_compute_address.second]
}

output "firstvm_ip" {
        value = google_compute_instance.firstvm.network_interface.0.access_config.0.nat_ip
}
