#!/bin/bash

sudo yum update -y

sudo dnf install java-17-amazon-corretto -y

cd /home/ec2-user

wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip

unzip sonarqube-9.9.0.65466.zip


