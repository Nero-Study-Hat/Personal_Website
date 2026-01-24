# Output uploaded files for verification
output "uploaded_files" {
    value = aws_s3_object.synced-secrets[*].key
}