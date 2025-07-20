resource "azurerm_key_vault" "main" {
  name                        = "labprojectkv"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  soft_delete_enabled         = true
}

resource "azurerm_key_vault_secret" "mysql_password" {
  name         = "mysql-password"
  value        = var.mysql_password
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "grafana_password" {
  name         = "grafana-password"
  value        = var.grafana_password
  key_vault_id = azurerm_key_vault.main.id
}

data "azurerm_client_config" "current" {} 