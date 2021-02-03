cd /

sudo yum install wget -y


#cd /home/authentick9/
cd ~

cd projectdir
cd terraform-shell-script


sudo wget https://storage.googleapis.com/harbor-releases/release-1.8.0/harbor-online-installer-v1.8.2.tgz
sudo tar xvf harbor-online-installer-v1.8.2.tgz

sudo curl -fsSL https://get.docker.com -o get-docker.sh

sudo chmod 777 get-docker.sh

sudo ./get-docker.sh

sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

sudo usermod -aG docker root

sudo systemctl start docker

sudo systemctl enable docker

#adding external IP through terraform, 
#using target identifier to make changes to the places where exeternal IP is required

cd ~

echo 'export IP=`curl -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip`' >> ~/.bash_profile
source ~/.bash_profile


cat > /etc/docker/daemon.json << EOF
{
        "insecure-registries" : ["target"]
}

EOF
cd /
cd /etc/docker/
sudo sed -i 's/target/'$IP'/' daemon.json

cd /
cd ~
cd projectdir/terraform-shell-script

cd harbor

#sudo sed -i 's/reg.mydomain.com/35.209.67.188/' harbor.yml

sudo sed -i 's/reg.mydomain.com/'$IP'/' harbor.yml

sudo ./install.sh --with-clair

sudo docker-compose down

sudo systemctl restart docker

sudo ./install.sh --with-clair
