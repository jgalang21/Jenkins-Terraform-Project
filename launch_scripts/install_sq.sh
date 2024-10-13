#!/bin/bash

# Update packages
sudo yum update -y

# Install Java 17
sudo dnf install java-17-amazon-corretto -y

# Change to ec2-user's home directory
cd /home/ec2-user

# Download SonarQube
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip

# Unzip SonarQube
sudo unzip sonarqube-9.9.0.65466.zip

# Change ownership
sudo chown -R ec2-user:ec2-user /home/ec2-user/sonarqube-9.9.0.65466

# Change to SonarQube's bin directory
cd /home/ec2-user/sonarqube-9.9.0.65466/bin/linux-x86-64/

# Start SonarQube in the background
sudo ./sonar.sh start &
