terraform {
  backend "s3" {
    region         = "us-east-1" # can't use tf var here
    bucket         = "terraform-state-backend-0iw5ulc1" # retrieving from initial creation output
    encrypt        = true
    use_lockfile   = true
    # config file nested vars not supported so role_arn needs to be defined here 2/4/26
    assume_role = {
      role_arn = "arn:aws:iam::767398065040:role/dev-personal-website-20260126191403988000000001"
    }
    # Loaded from environment .config file via CLI
    # key          = ""  
  }
}