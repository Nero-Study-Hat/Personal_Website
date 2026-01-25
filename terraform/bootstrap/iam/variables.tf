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