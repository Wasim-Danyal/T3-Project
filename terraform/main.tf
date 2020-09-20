# Provider 
provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "ProjectVPC" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "Project VPC"
  }
}

#Internet Gateway for VPC

resource "aws_internet_gateway" "ProjectIG" {
  vpc_id = aws_vpc.ProjectVPC.id
  tags = {
    Name = "Project Internet Gateway"
  }
}

resource "aws_subnet" "ProjectSubnet" {
  vpc_id                  = aws_vpc.ProjectVPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Project Subnet"
  }
}

resource "aws_route_table" "ProjectRT" {
  vpc_id = aws_vpc.ProjectVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ProjectIG.id
  }
  tags = {
    Name = "Project Routes Table"
  }
}

resource "aws_route_table_association" "ProjectRTA" {
  subnet_id      = aws_subnet.ProjectSubnet.id
  route_table_id = aws_route_table.ProjectRT.id
}

resource "aws_security_group" "ProjectSG" {
  name        = "ProjectSG"
  description = "Allow SSH"
  vpc_id      = aws_vpc.ProjectVPC.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow"
  }
}
