provider "aws" {
  assume_role {
    role_arn     = "arn:aws:iam::767398065040:role/Worker-Personal-Website"
    session_name = "terraform-dev"
  }

  region = var.region

  default_tags {
    tags = {
      Environment = "aws-dev"
      Project     = "personal-website"
    }
  }
}

terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "6.28.0"
   }
 }
}

module "terraform_state_backend" {
  source = "cloudposse/tfstate-backend/aws"
  version     = "1.8.0"

  namespace  = "personal-website"
  stage      = "shared"
  name       = "terraform"
  attributes = ["tfstate-backend"]

  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy                      = false
}

# Your Terraform configuration
module "another_module" {
  source = "....."
}