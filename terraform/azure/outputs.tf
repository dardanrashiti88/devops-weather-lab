output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "container_registry_login_server" {
  description = "Container Registry login server"
  value       = azurerm_container_registry.acr.login_server
}

output "mysql_server_fqdn" {
  description = "MySQL server FQDN"
  value       = azurerm_mysql_server.mysql.fqdn
}

output "backend_url" {
  description = "Backend application URL"
  value       = azurerm_container_app.backend.latest_revision_fqdn
}

output "prometheus_url" {
  description = "Prometheus monitoring URL"
  value       = azurerm_container_app.prometheus.latest_revision_fqdn
}

output "grafana_url" {
  description = "Grafana dashboard URL"
  value       = azurerm_container_app.grafana.latest_revision_fqdn
}

output "mysql_connection_string" {
  description = "MySQL connection string"
  value       = "mysql://mysqladmin:${var.mysql_password}@${azurerm_mysql_server.mysql.fqdn}:3306/lab_db"
  sensitive   = true
}

output "key_vault_name" {
  description = "Azure Key Vault name"
  value       = azurerm_key_vault.main.name
}

output "mysql_password_secret_uri" {
  description = "Key Vault Secret URI for MySQL password"
  value       = azurerm_key_vault_secret.mysql_password.id
}

output "grafana_password_secret_uri" {
  description = "Key Vault Secret URI for Grafana password"
  value       = azurerm_key_vault_secret.grafana_password.id
}

output "storage_account_name" {
  description = "Storage account name for assets/backups"
  value       = azurerm_storage_account.sa.name
}

output "assets_container_name" {
  description = "Blob container name for assets/backups"
  value       = azurerm_storage_container.assets.name
} 