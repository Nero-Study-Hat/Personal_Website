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

data "sops_file" "sops-secret" {
    source_file = "../../../secrets/secrets.yaml"
}

module "network" {
    source  = "../../modules/network"
    project = "Personal-Website"
    zone    = "us-east-1a" 
}

module "server" {
    source             = "../../modules/server"
    project            = "Personal-Website"
    tailscale_auth_key = data.sops_file.sops-secret.data["aws_server_ts_auth_key"]
    aws_region         = "us-east-1"
    private_subnet_id  = module.network.private_subnet_id
}

