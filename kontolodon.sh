#!/bin/bash -x

COMPOSE_VERSION="2.23.3"
COMPOSE_URL="https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-$(uname -s)-$(uname -m)"

# Opendax bootstrap script
install_core() {
  sudo apt-get update
  sudo apt-get install -y git tmux gnupg2 dirmngr dbus htop curl libmariadbclient-dev build-essential
}

log_rotation() {
  sudo mkdir -p /etc/docker
  sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "10"
  }
}
EOF
}

# Docker installation
install_docker() {
  curl -fsSL https://get.docker.com/ | sudo bash
  sudo usermod -aG docker $USER
  mkdir -p ~/.docker/cli-plugins
  curl -SL "$COMPOSE_URL" -o ~/.docker/cli-plugins/docker-compose
  chmod +x ~/.docker/cli-plugins/docker-compose
}

install_ruby() {
  gpg2 --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  curl -sSL https://get.rvm.io | bash -s stable --ruby=3.0.1
  source /home/$USER/.rvm/scripts/rvm
  rvm use 3.0.1
}

install_core
log_rotation
install_docker
install_ruby
