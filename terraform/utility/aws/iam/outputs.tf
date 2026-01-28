output "neostudyhat-password" {
    description = "Default sassword for neostudyhat user: they are required to change and setup MFA on login"
    value       = module.iam_user-neostudyhat.login_profile_password
    sensitive   = true
}

output "role-arn-dev-personal-website" {
    description = "ARN of the deve-personal-website role used for Terraform work."
    value = module.iam_role-dev-personal-website.arn
}