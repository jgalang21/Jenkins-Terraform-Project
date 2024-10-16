terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

# Security group to allow inbound traffic on port 22 (SSH), 80 (HTTP), and 443 (HTTPS)
resource "aws_security_group" "app_sg" {
  name        = "app_security_group"
  description = "Allow SSH, HTTP, and HTTPS inbound traffic"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Jenkins Web UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  tags = {
    Name = "Jenkins SGs"
  }
}

resource "aws_security_group" "sonarqube" {
  name        = "app_security_group_sonarqube"
  description = "SonarQube SGs"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  ingress {
    description = "Allow SonarQube"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  tags = {
    Name = "SonarQube SGs"
  }
}


resource "aws_instance" "app_server" {
  ami                    = "ami-0d081196e3df05f4d"
  instance_type          = "t2.medium"
  key_name               = "ec2"  
  vpc_security_group_ids = [aws_security_group.app_sg.id] 
  count = 1
  tags = {
    Name = "Jenkins"
  }

  user_data = file("${path.module}/launch_scripts/install.sh")
  associate_public_ip_address = true
}

resource "aws_instance" "sonarqube_host" {
  ami                    = "ami-0d081196e3df05f4d"
  instance_type          = "t2.medium"
  key_name               = "ec2"  
  vpc_security_group_ids = [aws_security_group.sonarqube.id] 
  count                  = 1
  associate_public_ip_address = true

  
  user_data = file("${path.module}/launch_scripts/install_sq.sh")


  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/ec2.pem")  
      host        = self.public_ip          
    }

    inline = [
      "while [ ! -f /home/ec2-user/sonarqube-9.9.0.65466/bin/linux-x86-64/sonar.sh ]; do echo 'Waiting for SonarQube installation...'; sleep 10; done",
      "sudo yum update -y",
      "cd /home/ec2-user/sonarqube-9.9.0.65466/bin/linux-x86-64/",
      "sudo chown -R ec2-user:ec2-user /home/ec2-user/sonarqube-9.9.0.65466",
      "sudo chmod -R 755 /home/ec2-user/sonarqube-9.9.0.65466",
      "./sonar.sh start"
    ]
  }

  tags = {
    Name = "SonarQube"
  }
}
