cd /
cd ~

mkdir projectdir

sudo yum install git -y

sudo systemctl stop firewalld
sudo systemctl disable firewalld

cd projectdir

sudo git clone https://github.com/Shriyut/terraform-shell-script.git
cd terraform-shell-script/
sudo chmod 777 *

sudo ./harbor.sh

#cd ..
#sudo ./get-docker.sh

#sudo usermod -aG docker root
#sudo usermod -aG docker authentick9

#sudo systemctl start docker
#sudo systemctl enable docker
#cd harbor
#sudo sed -i 's/reg.mydomain.com/35.209.67.188/' harbor.yml
#sudo ./install.sh --with-clair
#sudo docker-compose down
#sudo systemctl restart docker
#sudo ./install.sh --with-clair
