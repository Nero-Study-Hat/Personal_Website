# AWS region where resources will be created.
variable "region" {
  default = "us-east-1" # Default AWS region
}

# AWS availability zone within the region.
variable "zone" {
  default = "us-east-1a" # Default availability zone
}

variable "webuser" {
  default = "ansible" # Default user
}

# Map of AMI IDs for different AWS regions.
# Update these values to match the AMI you want to use in your chosen region.
variable "amiID" {
    default = "ami-0f9c27b471bdcd702" # AMI ID for Debian 13 (HVM)
}