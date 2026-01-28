terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "6.28.0"
        }
    }
}

provider "aws" {
    assume_role {
        role_arn     = "arn:aws:iam::767398065040:role/Worker-Personal-Website"
        session_name = "terraform-personal-website-map"
    }

    region = var.region

    default_tags {
        tags = {
            Environment = "aws-dev"
            Project     = "Personal-Website"
        }
    }
}

data "aws_s3_bucket" "target_bucket" {
    bucket = var.s3_bucket_name
}

# Get all files from the sync directory
data "local_file" "sync_files" {
    for_each = fileset(var.sync_directory, "**")
    filename = "${var.sync_directory}/${each.value}"
}

# Upload each file to S3 bucket
resource "aws_s3_object" "synced-secrets" {
    for_each     = fileset(var.sync_directory, "**/*")

    bucket       = data.aws_s3_bucket.target_bucket.id
    key          = "secrets/${each.value}"
    source       = "${var.sync_directory}/${each.value}"
    content_type = "text/plain"
    source_hash = filemd5("${var.sync_directory}/${each.value}") # Ensure updates only for changed files
}