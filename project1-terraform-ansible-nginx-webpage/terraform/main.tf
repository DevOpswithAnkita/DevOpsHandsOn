provider "aws" {
   region =  "us-east-1"
  
}
#create vpc
resource "aws_vpc" "DevOpswithAnkita-vpc" {
    cidr_block =  "10.0.0.0/16" 
    tags = {
    Name = "DevOpswithAnkita-vpc"
  }
}
# create subnet 
resource "aws_subnet" "DevOpswithAnkita-pub-subnet" {
    vpc_id = aws_vpc.DevOpswithAnkita-vpc.id
    cidr_block =  "10.0.1.0/24" 
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
    tags = {
    Name = "DevOpswithAnkita-pub-subnet"
  }
}

resource "aws_subnet" "DevOpswithAnkita-pri-subnet" {
    vpc_id = aws_vpc.DevOpswithAnkita-vpc.id
    cidr_block =  "10.0.2.0/24" 
    availability_zone = "us-east-1b"
    tags = {
    Name = "DevOpswithAnkita-pri-subnet"
  }
}
resource "aws_internet_gateway" "DevOpswithAnkita-igw" {
    vpc_id = aws_vpc.DevOpswithAnkita-vpc.id
    tags = {
    Name = "DevOpswithAnkita-igw"
  }
  
}
resource "aws_route_table" "DevOpswithAnkita-rt" {
    vpc_id =  aws_vpc.DevOpswithAnkita-vpc.id
    route{
        cidr_block =  "0.0.0.0/0"         
        gateway_id = aws_internet_gateway.DevOpswithAnkita-igw.id
    }
    tags = {
    Name = "DevOpswithAnkita-rt"
  }
    
  
}
# Associate Public Route Table with Public Subnet
resource "aws_route_table_association" "DevOpswithAnkita-pub-rt" {
    subnet_id = aws_subnet.DevOpswithAnkita-pub-subnet.id
    route_table_id = aws_route_table.DevOpswithAnkita-rt.id
}
# NAT Gateway for Private Subnet
resource "aws_eip" "DevOpswithAnkita-eip" {
    domain =  "vpc"
  
}
resource "aws_nat_gateway" "DevOpswithAnkita-ng" {
    allocation_id =  aws_eip.DevOpswithAnkita-eip.id
    subnet_id = aws_subnet.DevOpswithAnkita-pub-subnet.id
    tags = {
    Name = "DevOpswithAnkita-ng"
  }
}
resource "aws_route_table" "DevOpswithAnkita-pvt-rt" {
    vpc_id =  aws_vpc.DevOpswithAnkita-vpc.id
    route {
        cidr_block =  "0.0.0.0/0" 
        nat_gateway_id =  aws_nat_gateway.DevOpswithAnkita-ng.id
    }
}
# Associate Private Route Table with Private Subnet
resource "aws_route_table_association" "DevOpswithAnkita-pri-rt" {
    subnet_id = aws_subnet.DevOpswithAnkita-pri-subnet.id
    route_table_id = aws_route_table.DevOpswithAnkita-pvt-rt.id
}

# Security Group 
resource "aws_security_group" "DevOpswithAnkita-sg" {
    vpc_id = aws_vpc.DevOpswithAnkita-vpc.id
    name =  "DevOpswithAnkita-sg"
    description =  "Create sg for our projects"
    ingress {
        from_port =  80
        to_port =  80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]       
        description = "Allow http access"

    }
    ingress {
        from_port =  22
        to_port =  22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]    
        description = "Allow ssh"

    }
    egress {
        from_port = 0
        to_port =  0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]        
        description = "Allow incomming trafic"

    }
    tags = {
    Name = "DevOpswithAnkita-sg"
  }

}
resource "aws_key_pair" "DevOpswithAnkita_key" {
    key_name =  "DevOpswithAnkita_key"
    public_key = file("${path.module}/devops-key.pub")
    tags = {
    Name = "DevOpswithAnkita_key"
  }
}
# AMI ID (Ubuntu in us-east-1)
variable "ami" {
  default = "ami-0360c520857e3138f"
}

# Instance type
variable "instance_type" {
  default = "t2.micro"
}
#storage variable
variable "ebs_size" {
    default = 20
  
}
variable "ebs_type"{
    default = "gp3"
}
#create master instnace 
resource "aws_instance" "Ansible-master" {
    ami = var.ami
    instance_type = var.instance_type
    key_name = aws_key_pair.DevOpswithAnkita_key.key_name
    subnet_id = aws_subnet.DevOpswithAnkita-pub-subnet.id
    vpc_security_group_ids =  [aws_security_group.DevOpswithAnkita-sg.id]
    associate_public_ip_address = true
    user_data = <<-EOF
      #!/bin/bash
      sudo apt-get update -y 
      sudo apt-get install software-property-common
      sudo add-apt-repository --yes --update ppa:/ansible/ansible
      sudo apt-get install ansible -y
      EOF
    tags = {
        Name = "Ansible-master"
    }
    root_block_device {
      volume_size = var.ebs_size
      volume_type = var.ebs_type
    }
  
}
#create ec2 instance with two worker nodes
resource "aws_instance" "Ansible-user" {
    ami = var.ami
    count = 2
    instance_type = var.instance_type
    subnet_id = aws_subnet.DevOpswithAnkita-pub-subnet.id
    vpc_security_group_ids = [aws_security_group.DevOpswithAnkita-sg.id]
    key_name = aws_key_pair.DevOpswithAnkita_key.key_name
    root_block_device {
      volume_size = var.ebs_size
      volume_type = var.ebs_type
    }
    tags = {
      Name = "Ansible-user-${count.index + 1}"
}
}
