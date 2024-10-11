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
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from all IPs (best to restrict this to your IP)
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from all IPs
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS from all IPs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allow all outbound traffic
  }

  tags = {
    Name = "AppSecurityGroup"
  }
}

resource "aws_instance" "app_server" {
  ami                    = "ami-0d081196e3df05f4d"
  instance_type          = "t2.micro"
  key_name               = "ec2"  
  vpc_security_group_ids = [aws_security_group.app_sg.id] 

  tags = {
    Name = "ExampleAppServerInstance"
  }

  user_data = file("${path.module}/launch_scripts/install.sh")
  associate_public_ip_address = true
}
