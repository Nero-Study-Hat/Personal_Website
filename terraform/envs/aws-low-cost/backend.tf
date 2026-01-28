terraform {
  backend "s3" {
    bucket         = "terraform-state-backend-0iw5ulc1" # retrieving from initial creation output
    key            = "backends/envs/mvp.tfstate"
    region         = "us-east-1" # can't use tf var here
    encrypt        = true
    use_lockfile   = true
    assume_role = {
      role_arn = "arn:aws:iam::767398065040:role/dev-personal-website-20260126191403988000000001"
    }
  }
}