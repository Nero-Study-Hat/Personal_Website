output "neostudyhat-password" {
    description = "Default sassword for neostudyhat user: they are required to change and setup MFA on login"
    value       = module.iam_user-neostudyhat.login_profile_password
    sensitive   = true
}