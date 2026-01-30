terraform {
    required_version = ">= 1.0"
    required_providers {
        sops = {
            source = "carlpett/sops"
            version = "1.3.0"
        }
        aws = {
            source  = "hashicorp/aws"
            version = "6.28.0"
        }
        cloudinit = {
            source  = "hashicorp/cloudinit"
            version = "2.3.7"
        }
    }
}



### Auth ###

provider "aws" {
    assume_role {
        role_arn     = "arn:aws:iam::767398065040:role/dev-personal-website-20260126191403988000000001"
        session_name = "terraform-dev"
    }

    region = var.region

    // default_tags don't interact with api in same way
    // as tags at the resource block level so they are
    // nice for console filtering but not IAM condition filtering
    default_tags {
        tags = {
            Project-DefaultTag     = var.project
            Environment-DefaultTag = var.environment
        }
    }
}

data "sops_file" "sops-secret" {
    source_file = "../../../secrets/secrets.yaml"
}

module "network" {
    source  = "../../modules/aws/network"
    project = var.project
    zone    = "us-east-1a" 
}

module "server" {
    source             = "../../modules/aws/server"
    project            = var.project
    tailscale_auth_key = data.sops_file.sops-secret.data["aws_server_ts_auth_key"]
    aws_region         = "us-east-1"
    private_subnet_id  = module.network.private_subnet_id
    security_group_id  = module.network.minimal_security_group_id
}

