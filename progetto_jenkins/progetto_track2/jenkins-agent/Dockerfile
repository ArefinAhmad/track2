FROM jenkins/inbound-agent:latest

USER root

#copio config sul container
COPY config /home/jenkins/.kube/config

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y docker.io && \
    apt-get clean

# Aggiungi il gruppo docker con GID corretto (modifica 998 se necessario)
RUN groupdel docker || true
RUN groupadd -for -g 988 docker
RUN usermod -aG docker jenkins

# Installa kubectl
RUN curl -LO "https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Installa helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

USER jenkins

