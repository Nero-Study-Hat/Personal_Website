# Create a security group for terraform-ec2-setup
resource "aws_security_group" "terraform-ec2-setup-sg" {
  name        = "terraform-ec2-setup-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.Terraform_VPC.id #REPLACE WITH YOUR VPC ID IF NEEDED

  tags = {
    Name = "terraform-ec2-setup-sg"
  }
}

# Allow SSH access from a specific IP address
resource "aws_vpc_security_group_ingress_rule" "ssh_from_my_ip" {
  security_group_id = aws_security_group.terraform-ec2-setup-sg.id
  cidr_ipv4         = "REPLACE YOUR IP/32" # Replace with your actual IP address
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Allow HTTP access from My IP address
resource "aws_vpc_security_group_ingress_rule" "allow_http_from_my_ip" {
  security_group_id = aws_security_group.terraform-ec2-setup-sg.id
  cidr_ipv4         = "REPLACE YOUR IP/32" # Replace with your actual IP address
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Allow all outbound IPv4 traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.terraform-ec2-setup-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Allow all outbound IPv6 traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.terraform-ec2-setup-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}