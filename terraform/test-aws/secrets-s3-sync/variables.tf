variable "region" {
    description = "AWS region"
    type        = string
    default     = "us-east-1"
}

variable "s3_bucket_name" {
    description = "Name of state backend bucket where secrets are also stored"
    type        = string
    default = "terraform-state-backend-0iw5ulc1"
}

variable "sync_directory" {
    description = "Local directory where your files are located"
    type        = string
    default = "../../../secrets"
}