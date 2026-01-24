variable "project" {
    type        = string
    description = "Project name for tags"
    default     = "Personal-Website"
}

variable "tailscale_auth_key" {
    description = "Node authorization key; if it begins with 'file:', then it's a path to a file containing the authkey"
    type        = string
    sensitive   = true
}

variable "aws_region" {
    description = "AWS region"
    type        = string
    default     = "us-east-1"
}

variable "private_subnet_id" {
    description = "ID of the subnet the server will be placed in"
    type        = string
    default     = ""
}

# variable "security_group_id" {
#     description = "Security group used by VPC the server will be placed in"
#     type        = string
#     default     = ""
# }