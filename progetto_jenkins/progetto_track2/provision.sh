#!/bin/bash

# Aggiorna il sistema
sudo dnf update -y

# 1. INSTALLAZIONE DOCKER
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Abilita e avvia Docker
sudo systemctl enable --now docker
sudo usermod -aG docker vagrant

# 2. INSTALLAZIONE KUBECTL v1.32.2 (allineato al server)
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.32/rpm/repodata/repomd.xml.key
EOF

sudo dnf install -y kubectl-1.32.2

# 3. INSTALLAZIONE HELM
echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash


# 4. CONFIGURAZIONI AGGIUNTIVE
# Crea la cartella .kube
mkdir -p /home/vagrant/.kube
sudo chown vagrant:vagrant /home/vagrant/.kube

# Configurazione shell
cat <<EOF >> /home/vagrant/.bashrc
# Kubernetes alias
alias k=kubectl
complete -F __start_kubectl k
source <(kubectl completion bash)
EOF

# Abilita i CGroup v2 (richiesto da Kubernetes)
sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=1"
