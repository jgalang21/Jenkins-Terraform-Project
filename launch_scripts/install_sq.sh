#!/bin/bash


# Add a short sleep to ensure all services are up
sleep 60


# Update packages
sudo yum update -y

# Install Java 17
sudo dnf install java-17-amazon-corretto -y

# Change to ec2-user's home directory
cd /home/ec2-user

# Download SonarQube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip

# Unzip SonarQube
unzip sonarqube-9.9.0.65466.zip


sudo chown -R ec2-user:ec2-user /home/ec2-user/sonarqube-9.9.0.65466

# Change to SonarQube's bin directory
cd /home/ec2-user/sonarqube-9.9.0.65466/bin/linux-x86-64/

sudo chmod -R 755 /home/ec2-user/sonarqube-9.9.0.65466

echo 'got to 31' > 31.txt
./sonar.sh start
echo 'got to 33' > 33.txt 
