terraform {
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
    for_each     = data.local_file.sync_files
    bucket       = data.aws_s3_bucket.target_bucket.id
    key          = "secrets/${each.key}"
    source       = data.local_file.sync_files[each.key].filename
    content_type = "text/plain"
    etag         = filemd5(data.local_file.sync_files[each.key].filename) # Ensure updates only for changed files
}