terraform {
    required_version = ">= 1.6.0"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "6.28.0"
        }
    }
}

### Auth ###

provider "aws" {
    assume_role {
        role_arn     = "arn:aws:iam::767398065040:role/bootstrap-terraform-iam"
        session_name = "terraform-personal-website-map"
    }

    region = var.region

    default_tags {
        tags = {
            Environment = "aws-dev"
            Project     = "personal-website"
        }
    }
}

# using
# https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest

module "iam_account" {
    source = "terraform-aws-modules/iam/aws//modules/iam-account"
    version = "6.4.0"

    account_alias = "wiresndreams-labs"

    max_password_age               = 90
    minimum_password_length        = 24
    require_uppercase_characters   = true
    require_lowercase_characters   = true
    require_numbers                = true
    require_symbols                = true
    password_reuse_prevention      = 24
    allow_users_to_change_password = true
}

