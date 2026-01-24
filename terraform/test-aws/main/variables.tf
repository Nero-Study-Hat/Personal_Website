# AWS region where resources will be created.
variable "region" {
    default = "us-east-1" # Default AWS region
}

variable "zone" {
  default = "us-east-1a" # Default availability zone
}

variable "vpc_cidr" {
    description = "Primary CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16" # Overall VPC address space
}