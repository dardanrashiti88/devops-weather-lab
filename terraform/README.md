# Lab Project - Azure Deployment

This project contains Terraform configuration to deploy the lab project to Azure using best practices with organized, modular files.

## 📁 File Structure

The Terraform configuration is organized into separate files for better maintainability:

```
terraform/
├── providers.tf              # Terraform provider configuration
├── variables.tf              # Input variables
├── outputs.tf                # Output values
├── resource-group.tf         # Azure Resource Group
├── container-registry.tf     # Azure Container Registry (ACR)
├── mysql.tf                  # MySQL Database Server, Database, and Firewall Rules
├── container-apps.tf         # Container App Environment and all Container Apps
├── terraform.tfvars.example  # Example variable values
└── README.md                 # This file
```

## Prerequisites

1. **Azure CLI** installed and authenticated
2. **Terraform** installed (version >= 1.0)
3. **Docker** installed (for building images)

## 🚀 Deployment Steps

### 1. Navigate to Terraform Directory
```bash
cd terraform
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Configure Variables
Copy the example variables file and update with your values:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and set:
- `mysql_password`: Secure password for MySQL database
- `grafana_password`: Secure password for Grafana admin user

### 4. Review Deployment Plan
```bash
terraform plan
```

This will show you all resources that will be created across all `.tf` files.

### 5. Deploy Infrastructure
```bash
terraform apply
```

### 6. Build and Push Docker Images
After the infrastructure is deployed, build and push your backend image:

```bash
# Get the ACR login server from outputs
terraform output acr_login_server

# Login to Azure Container Registry
az acr login --name labprojectacr

# Build backend image
docker build -t labprojectacr.azurecr.io/backend:latest ../backend

# Push to registry
docker push labprojectacr.azurecr.io/backend:latest
```

### 7. Initialize Database
After deployment, run the SQL scripts to initialize the database:

```bash
# Get MySQL server details from outputs
terraform output mysql_server_fqdn

# Connect to MySQL and run the initialization scripts
mysql -h <mysql-server-fqdn> -u mysqladmin -p lab_db < ../db/01-create-table.sql
mysql -h <mysql-server-fqdn> -u mysqladmin -p lab_db < ../db/02-seed-data.sql
```

## 🌐 Accessing Applications

After successful deployment, you can access:

- **Backend**: `https://<backend-url>` (from terraform output)
- **Prometheus**: `https://<prometheus-url>` (from terraform output)
- **Grafana**: `https://<grafana-url>` (admin/your-grafana-password)

Get the URLs using:
```bash
terraform output
```

## 🏗️ Architecture

The deployment includes:

### **Core Infrastructure:**
- **Resource Group** (`resource-group.tf`) - Organizes all resources
- **Container Registry** (`container-registry.tf`) - Stores Docker images

### **Database Layer:**
- **MySQL Server** (`mysql.tf`) - Managed MySQL database
- **Database** (`mysql.tf`) - Application database
- **Firewall Rules** (`mysql.tf`) - Network access configuration

### **Application Layer:**
- **Container App Environment** (`container-apps.tf`) - Runtime environment
- **Backend Container App** (`container-apps.tf`) - Node.js application
- **Prometheus Container App** (`container-apps.tf`) - Monitoring
- **Grafana Container App** (`container-apps.tf`) - Dashboards

## 🔧 Management Commands

### View Current State
```bash
terraform show
```

### View Outputs
```bash
terraform output
```

### Plan Changes (after modifying any .tf file)
```bash
terraform plan
```

### Apply Changes
```bash
terraform apply
```

### Destroy All Resources
```bash
terraform destroy
```

## 📝 Notes

- **Modular Design**: Each resource type is in its own file for easy maintenance
- **Automatic Dependencies**: Terraform handles resource creation order automatically
- **State Management**: All resources are tracked in a single state file
- **Security**: MySQL server has public access for simplicity (use private endpoints in production)
- **Scaling**: Container Apps provide automatic scaling and HTTPS endpoints
- **Passwords**: All sensitive data is stored as Terraform variables

## 🛠️ Troubleshooting

### Common Issues:

1. **Authentication Error**: Run `az login` to authenticate with Azure
2. **Resource Name Conflicts**: Change resource names in the `.tf` files
3. **Permission Errors**: Ensure your Azure account has proper permissions
4. **Network Issues**: Check firewall rules and network connectivity

### Useful Commands:
```bash
# Validate Terraform configuration
terraform validate

# Format Terraform files
terraform fmt

# Check what resources exist
terraform state list
``` 