# Outputs for integration with other components
output "vpc_id" {
    description = "ID of the created VPC"
    value       = aws_vpc.Terraform_VPC.id
}

output "private_subnet_id" {
    description = "IDs of all private subnets"
    value       = aws_subnet.Terraform_VPC-priv.id
}

output "public_subnet_id" {
    description = "IDs of all public subnets"
    value       = aws_subnet.Terraform_VPC-pub.id
}

output "nat_gateway_ip" {
    description = "Public IP of the NAT Gateway"
    value       = aws_eip.nat.public_ip
}

# output "tailscale_security_group_id" {
#     description = "Security group used by VPC"
#     value       = aws_security_group.main.id
# }