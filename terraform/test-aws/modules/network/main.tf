# Create a VPC with DNS support and hostnames enabled
resource "aws_vpc" "Terraform_VPC" {
    cidr_block           = "10.0.0.0/16"
    instance_tenancy     = "default"
    enable_dns_support   = "true"
    enable_dns_hostnames = "true"
    tags = {
        Name = "Terraform_VPC"
        Project = var.project
    }
}

# Internet Gateway for the VPC
resource "aws_internet_gateway" "Terraform_VPC-IGW" {
    vpc_id = aws_vpc.Terraform_VPC.id
    tags = {
        Name = "Terraform_VPC-IGW"
        Project = var.project
    }
}

# Public Subnet
resource "aws_subnet" "Terraform_VPC-pub" {
    vpc_id                  = aws_vpc.Terraform_VPC.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone       = var.zone
}

# Private Subnet
resource "aws_subnet" "Terraform_VPC-priv" {
    vpc_id                  = aws_vpc.Terraform_VPC.id
    cidr_block              = "10.0.4.0/24"
    map_public_ip_on_launch = "true"
    availability_zone       = var.zone
}

# NAT Gateway elastic ip
resource "aws_eip" "nat" {
    domain = "vpc"
    tags = {
        Name = "nat-eip"
    }
}

# NAT Gateway itself
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.Terraform_VPC-pub.id
    tags = {
        Name = "nat-gw"
    }
    depends_on = [aws_internet_gateway.Terraform_VPC-IGW]
}

# Security group for Tailscale client in public subnet for direct connections
# resource "aws_security_group" "main" {
#     vpc_id      = aws_vpc.Terraform_VPC.id
#     description = "Tailscale required traffic"

#     ingress {
#         from_port   = 41641
#         to_port     = 41641
#         protocol    = "udp"
#         cidr_blocks = ["0.0.0.0/0"]
#         description = "Tailscale UDP port"
#     }

#     egress {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#         description = "Allow all outbound traffic"
#     }
# }