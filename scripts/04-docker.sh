#!/usr/bin/env bash
source tools.sh
step_info "Setup docker"

sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common > $verbose_path 2>&1 || exit_on_error "CANNOT INSTALL DOCKER DEPS"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - > $verbose_path 2>&1
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt-get update > $verbose_path 2>&1
sudo apt-get install -y docker-ce docker-ce-cli containerd.io > $verbose_path 2>&1 || exit_on_error "CANNOT INSTALL DOCKER"
sudo service docker stop

sudo bash -c 'cat << EOF > /etc/docker/daemon.json
{
   "graph": "/docker"
}
EOF'

DOWNLOAD_URL=$( curl -s -q https://api.github.com/repos/docker/compose/releases/latest | grep "browser_download_url.*docker-compose-$(uname -s)-$(uname -m)\"" | cut -d : -f 2,3 | tr -d \")
sudo curl -q -L "$DOWNLOAD_URL" -o /usr/local/bin/docker-compose > $verbose_path 2>&1
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version || exit_on_error "DOCKER-COMPOSE INSTALLATION FAILED"
sudo service docker start || exit_on_error "CANNOT START DOCKER"
sudo usermod -a -G docker "$USER"
docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /data/portainer:/data portainer/portainer
caveat "Please access http://$PUBLIC_IP:9000 to setup credentials and avoid stealing of your machine !"
success
