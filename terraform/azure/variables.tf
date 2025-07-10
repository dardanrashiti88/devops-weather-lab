variable "mysql_password" {
  description = "Password for MySQL database"
  type        = string
  sensitive   = true
}

variable "grafana_password" {
  description = "Password for Grafana admin user"
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "lab-project-rg"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "labprojectacr"
} 