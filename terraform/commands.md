## Dev
```bash
terraform init -reconfigure -backend-config=environments/backend.dev.config
terraform plan -var-file=environments/dev.tfvars
terraform apply -var-file=environments/dev.tfvars
```

## Prod
```bash
terraform init -reconfigure -backend-config=environments/backend.prod.config
terraform apply -var-file=environments/prod.tfvars
```