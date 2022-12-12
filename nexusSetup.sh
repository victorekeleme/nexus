#!/bin/bash

NEXUSURL="http://download.sonatype.com/nexus/3/nexus-3.15.2-01-unix.tar.gz"


#Set hostname to nexus
sudo hostnamectl set-hostname nexus

#intalling neccessary packages
sudo yum install wget git vim unzip -y

#add system user for nexus
sudo useradd -m -U -d /opt/nexus_home/ -s /bin/bash nexus

#Grant sudo access to nexus user
sudo echo "nexus ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nexus

#change directory
cd /opt/nexus_home

#checking for java
java -version

if [ $? -eq 0 ]
then
        echo "Java already installed"
else
        echo "Installing Java"
        sudo yum install java-11-openjdk-devel java-1.8.0-openjdk-devel -y
fi

#downloading, extracting nexus package
sudo wget $NEXUSURL

sudo tar -zxvf nexus-3.15.2-01-unix.tar.gz

#cleaning nexus zippped package
sudo rm -rf nexus-3.15.2-01-unix.tar.gz

# change the owner and group permissions to /opt/nexus and /opt/sonatype-work directories.
sudo chown -R nexus:nexus /opt/nexus_home

sudo chmod -R 775 /opt/nexus_home

sudo mv /opt/nexus_home/nexus-3.15.2-01 /opt/nexus_home/nexus

#update nexus run_as_user=""
sudo echo  'run_as_user="nexus"' > /opt/nexus_home/nexus/bin/nexus.rc

#configuring nexus to run as a service
sudo ln -s /opt/nexus_home/nexus/bin/nexus /etc/init.d/nexus

#enable and start the nexus services
sudo systemctl enable nexus
sudo systemctl start nexus
sudo systemctl status nexus
