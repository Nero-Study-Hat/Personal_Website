terraform {
  backend "s3" {
    bucket         = "terraform-state-backend-0iw5ulc1" # retrieving from initial creation output
    key            = "backends/utility/secrets-s3-sync.tfstate"
    region         = "us-east-1" # can't use tf var here
    encrypt        = true
    use_lockfile   = true
    token = ""
  }
}