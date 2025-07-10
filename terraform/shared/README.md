# Multi-Cloud Terraform Infrastructure

This directory contains Terraform configurations for deploying your application across different cloud providers.

## Structure

```
terraform/
├── aws/                    # AWS-specific infrastructure
├── azure/                  # Azure-specific infrastructure  
├── terraform-cloud/        # Terraform Cloud configuration
└── shared/                 # Shared modules and documentation
    ├── modules/
    │   ├── kubernetes/     # K8s modules
    │   ├── database/       # Database modules
    │   └── monitoring/     # Monitoring modules
    └── README.md
```

## Quick Start

### AWS Deployment
```bash
cd terraform/aws
terraform init
terraform plan
terraform apply
```

### Azure Deployment
```bash
cd terraform/azure
terraform init
terraform plan
terraform apply
```

### Terraform Cloud Deployment
```bash
cd terraform/terraform-cloud
terraform init
terraform plan
terraform apply
```

## Prerequisites

### AWS
- AWS CLI configured
- Appropriate AWS permissions
- Terraform installed

### Azure
- Azure CLI configured
- Appropriate Azure permissions
- Terraform installed

### Terraform Cloud
- Terraform Cloud account
- Organization and workspace created
- API token configured

## Variables

Each provider has its own `variables.tf` file. Common variables include:
- `project_name`: Name of your project
- `environment`: Environment (dev, staging, prod)
- `region`: Cloud provider region

## Security Notes

- Never commit `.tfstate` files
- Use Terraform Cloud for remote state management
- Store sensitive variables in Terraform Cloud or use environment variables
- Add `*.tfvars` files to `.gitignore` (except examples)

## Best Practices

1. **Use Terraform Cloud** for team collaboration and remote state
2. **Test in dev/staging** before production
3. **Use consistent naming** across providers
4. **Document changes** in commit messages
5. **Review plans** before applying

## Support

- AWS: Uses EKS for Kubernetes
- Azure: Uses AKS for Kubernetes  
- Terraform Cloud: Works with any cloud provider 