#!/bin/bash

$(which apt-get) -y docker docker-engine docker.io containerd runc

$(which apt-get) update

$(which apt-get) install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    openjdk-11-jdk

$(which curl) -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

$(which apt-key) fingerprint 0EBFCD88

$(which add-apt-repository) \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

$(which apt-get) update

$(which apt-get) install -y docker-ce docker-ce-cli containerd.io

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3",
    "labels": "production_status",
    "env": "os,customer"
  },
  "storage-driver": "overlay2"
}
EOF

$(which usermod) -aG docker vagrant

mkdir -p /etc/systemd/system/docker.service.d

$(which systemctl) daemon-reload

$(which systemctl) enable docker

$(which systemctl) restart docker

$(which curl) -L https://raw.githubusercontent.com/docker/compose/1.28.4/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose