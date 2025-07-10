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

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "lab-project"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
} 