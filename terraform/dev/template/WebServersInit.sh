#!/bin/bash
sudo yum -y update
sudo yum -y install yum-utils device-mapper-persistent-data lvm2 mc
sudo yum -y update
sudo yum -y install docker
sudo amazon-linux-extras -y install docker 
sudo usermod -aG docker $USER
sudo cat <<EOF > /etc/docker/daemon.json
{ 
    "insecure-registries": ["ip-10-0-0-179.eu-central-1.compute.internal:8085", "10.0.0.179:8085", "ec2-3-70-136-183.eu-central-1.compute.amazonaws.com:8085", "3.70.136.183:8085"]
}
EOF
sudo systemctl start docker
sudo systemctl enable docker
sudo docker login -u ${docker_login} -p ${docker_pass} ec2-3-70-136-183.eu-central-1.compute.amazonaws.com:8085
sudo docker run -d -p 8080:8080 ec2-3-70-136-183.eu-central-1.compute.amazonaws.com:8085/${imageName}