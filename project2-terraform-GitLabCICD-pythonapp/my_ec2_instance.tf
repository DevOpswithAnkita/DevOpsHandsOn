# Provider
provider "aws" {
  region = "us-east-1"
}

# Default VPC
data "aws_vpc" "default" {
  default = true
}

# Pick first subnet in default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

locals {
  default_subnet_id = data.aws_subnets.default.ids[0]
}

# Security Group
resource "aws_security_group" "python_app_dev_sg" {
  name        = "python-app-dev-sg"
  description = "Allow SSH and Python app port"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Python app port"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "python_app_dev" {
  ami                    = "ami-043c397cbae890540" # Ubuntu AMI
  instance_type           = "t2.medium"
  key_name                = "DevOpswithAnkita"
  subnet_id               = local.default_subnet_id
  vpc_security_group_ids  = [aws_security_group.python_app_dev_sg.id]

  user_data = <<EOF
#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y software-properties-common
sudo apt-get install -y docker.io docker-compose
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu
EOF

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "python-app-dev"
  }
}

# Outputs
output "subnet_id" {
  value = local.default_subnet_id
}

output "instance_public_ip" {
  value = aws_instance.python_app_dev.public_ip
}

output "security_group_id" {
  value = aws_security_group.python_app_dev_sg.id
}
