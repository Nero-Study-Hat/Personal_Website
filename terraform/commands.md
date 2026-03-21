## Dev
```bash
terraform init -reconfigure -backend-config=environments/backend.dev.config

terraform plan -var-file=environments/dev.tfvars --out tfplan-dev.binary
terraform show -json tfplan-dev.binary > tfplan-dev.json
conftest test ./tfplan-dev.json ./policy

terraform apply "tfplan-dev.binary"
rm tfplan-dev.binary tfplan-dev.json
```

## Prod
```bash
terraform init -reconfigure -backend-config=environments/backend.prod.config

terraform plan -var-file=environments/prod.tfvars --out tfplan-prod.binary
terraform show -json tfplan-prod.binary > tfplan-prod.json
conftest test ./tfplan-prod.json ./policy

terraform apply -var-file=environments/prod.tfvars

rm tfplan-prod.binary tfplan-prod.json
```