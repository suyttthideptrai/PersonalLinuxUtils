echo "stopping docker"
sudo systemctl stop docker
echo "stopping docker.socket"
sudo systemctl stop docker.socket
sudo systemctl disable docker
echo "purging docker stuffs"
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
echo "removing data"
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo rm -rf /etc/docker
sudo rm -rf /etc/systemd/system/docker.service
sudo rm -rf /etc/systemd/system/docker.socket
sudo rm -rf /usr/local/bin/docker-compose
echo "auto removing"
sudo groupdel docker
sudo apt-get autoremove -y
sudo apt-get autoclean
echo "verifying docker existence"
docker --version
docker compose
