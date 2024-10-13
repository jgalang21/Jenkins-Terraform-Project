#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras enable nginx1
sudo yum install nginx -y

# Start and enable NGINX service 
sudo systemctl start nginx
sudo systemctl enable nginx

#create jenkins 

sudo hostnamectl set-hostname jenkins
sudo yum update -y
# sudo amazon-linux-extras install java-openjdk11 -y
# sudo yum install openjdk-11-jdk -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo dnf install java-17-amazon-corretto -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

#install git
sudo yum install git -y
