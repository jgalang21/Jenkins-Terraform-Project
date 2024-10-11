#!bin/bash
sudo yum update -y
sudo amazon-linux-extras enable nginx1
sudo yum install nginx -y

# Start and enable NGINX service 
sudo systemctl start nginx
sudo systemctl enable nginx