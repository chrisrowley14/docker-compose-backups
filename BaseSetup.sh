#do not run this script as sudo!

sudo apt update
sudo apt upgrade -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common gnupg-agent -y


#webmin
sudo wget -q http://www.webmin.com/jcameron-key.asc -O- | sudo apt-key add -
#sudo add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository sarge contrib"
sudo add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository $(lsb_release -cs) contrib"
sudo apt install webmin -y
sudo apt install lm-sensors -y
sudo apt install smartmontools -y

#zfs
sudo apt install zfsutils-linux

#docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt install docker-ce docker-ce-cli containerd.io -y
sudo apt install docker-compose -y
sudo usermod -aG docker ${USER}

#move docker data
cp /lib/systemd/system/docker.service /lib/systemd/system/docker.service.bak
nano /lib/systemd/system/docker.service
#change line starting with ExecStart to ExecStart=/usr/bin/dockerd -g /DISK_1T/docker -H fd:// --containerd=/run/containerd/containerd.sock
/etc/init.d/docker restart
systemctl daemon-reload
/etc/init.d/docker restart

#Portainer
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
