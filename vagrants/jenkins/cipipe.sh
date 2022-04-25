#!/bin/bash
yum update -y

#JVM install (for Jenkins & Gradle)
yum install java-11-openjdk-devel -y

#Jenkins install
echo "=========JENKINS============================"
curl --location http://pkg.jenkins.io/redhat-stable/jenkins.repo | tee /etc/yum.repos.d/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum update -y
yum install jenkins -y
systemctl start jenkins
systemctl enable jenkins
usermod --shell /bin/bash jenkins
# firewall-cmd --permanent --zone=public --add-port=8080/tcp
# firewall-cmd --reload
test -e /var/lib/jenkins/secrets/initialAdminPassword && cat /var/lib/jenkins/secrets/initialAdminPassword
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

#Gradle install
echo "=========GRADLE============================"
yum install unzip -y
test -e gradle-7.4.2-bin.zip || curl https://downloads.gradle-dn.com/distributions/gradle-7.4.2-bin.zip -O
test -d /opt/gradle || mkdir /opt/gradle
unzip -d /opt/gradle gradle-7.4.2-bin.zip
echo "GRADLE_HOME=/opt/gradle/gradle-7.4.2" >> /etc/.bashrc
echo "export GRADLE_HOME" >> /etc/.bashrc
echo "PATH=$PATH:$GRADLE_HOME/bin" >> /etc/.bashrc
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

#Git install
echo "=========GIT============================"
yum install git -y
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

#Docker install
echo "=========DOCKER============================"
curl --location https://download.docker.com/linux/centos/docker-ce.repo | tee /etc/yum.repos.d/docker.repo
yum update -y
yum install docker-ce docker-ce-cli containerd.io -y
systemctl start docker
systemctl enable docker
usermod -aG docker jenkins
usermod -aG docker vagrant
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

#Helm install
echo "=========HELM============================"
test -e get_helm.sh || curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
echo "PATH=$PATH:/usr/local/bin" >> /etc/.bashrc
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"

yum upgrade
source /etc/.bashrc
