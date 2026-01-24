# Create a VPC with DNS support and hostnames enabled
resource "aws_vpc" "Terraform_VPC" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "Terraform_VPC"
  }
}

# Public Subnet
resource "aws_subnet" "Terraform_VPC-pub" {
  vpc_id                  = aws_vpc.Terraform_VPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.zone
  tags = {
    Name = "Terraform_VPC-pub-1"
  }
}

# Private Subnet
resource "aws_subnet" "Terraform_VPC-priv" {
  vpc_id                  = aws_vpc.Terraform_VPC.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.zone
  tags = {
    Name = "Terraform_VPC-priv-1"
  }
}

# Internet Gateway for the VPC
resource "aws_internet_gateway" "Terraform_VPC-IGW" {
  vpc_id = aws_vpc.Terraform_VPC.id
  tags = {
    Name = "Terraform_VPC-IGW"
  }
}

# Public Route Table with route to Internet Gateway
resource "aws_route_table" "Terraform_VPC-pub-RT" {
  vpc_id = aws_vpc.Terraform_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Terraform_VPC-IGW.id
  }

  tags = {
    Name = "Terraform_VPC-pub-RT"
  }
}

# Associate Public Subnet with the Public Route Table
resource "aws_route_table_association" "Terraform_VPC-pub-1-a" {
  subnet_id      = aws_subnet.Terraform_VPC-pub-1.id
  route_table_id = aws_route_table.Terraform_VPC-pub-RT.id
}