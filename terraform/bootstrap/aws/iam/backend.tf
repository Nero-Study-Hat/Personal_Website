terraform {
  backend "s3" {
    bucket         = "terraform-state-backend-0iw5ulc1" # retrieving from initial creation output
    key            = "backends/bootstrap/iam.tfstate"
    region         = "us-east-1" # can't use tf var here
    encrypt        = true
    use_lockfile   = true
    assume_role = {
      role_arn = "arn:aws:iam::767398065040:role/iam-controller-20260126191404497000000006"
    }
  }
}