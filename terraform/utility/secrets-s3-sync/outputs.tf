# Output uploaded files for verification
output "uploaded_files" {
    value = [for obj in aws_s3_object.synced-secrets : obj.key]
}