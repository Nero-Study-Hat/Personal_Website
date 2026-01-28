variable "region" {
    description = "AWS region"
    type        = string
    default     = "us-east-1"
}

variable "environment" {
    description = "Deployment environment used for"
    type        = string
    default     = "mvp"
}

variable "project" {
    type        = string
    description = "Project name for tags"
    default     = "Personal-Website"
}

variable "account_id" {
    type        = string
    description = "Used for ARN values."
    default     = "767398065040"
}