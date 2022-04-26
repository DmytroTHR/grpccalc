echo "==========MINIKUBE============="
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
dpkg -i minikube_latest_amd64.deb 

echo "==========DOCKER============="
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io -y
usermod -aG docker vagrant && newgrp docker

echo "==========KUBECTL==========="
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list > /dev/null
apt-get update
apt-get install kubectl -y

apt-get full-upgrade -y

echo ">>>>>>>>STARTING_MINIKUBE>>>>>>>>"
apt-get install conntrack -y
echo "#!/bin/bash" > /etc/rc.local
echo "minikube start --driver none --embed-certs --apiserver-ips 192.168.56.111 --delete-on-failure" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
chmod +x /etc/rc.local
./etc/rc.local