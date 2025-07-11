variable "tf_cloud_organization" {
  description = "Terraform Cloud organization name"
  type        = string
  default     = "LAB-2-terraform"
}

variable "tf_cloud_workspace" {
  description = "Terraform Cloud workspace name"
  type        = string
  default     = "lab-project-workspace"
}

variable "kubeconfig_path" {
  description = "Path to your kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "my-app"
}

variable "app_namespace" {
  description = "Kubernetes namespace for the app"
  type        = string
  default     = "my-app-ns"
}

variable "app_image" {
  description = "Container image for the app"
  type        = string
  default     = "nginx:latest"
}

variable "app_port" {
  description = "Port the app container exposes"
  type        = number
  default     = 80
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "database_url" {
  description = "Database connection URL (for secret)"
  type        = string
  sensitive   = true
  default     = "mysql://root:password@localhost:3306/mydb"
}

variable "api_key" {
  description = "API key (for secret)"
  type        = string
  sensitive   = true
  default     = "dummy-api-key"
}

variable "init_sql_content" {
  description = "Content for the init SQL file"
  type        = string
  default     = "-- SQL initialization script\nCREATE USER 'exporter'@'%' IDENTIFIED BY 'exporter_password';\nGRANT SELECT, PROCESS, REPLICATION CLIENT ON *.* TO 'exporter'@'%';\nFLUSH PRIVILEGES;"
} 