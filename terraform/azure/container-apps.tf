# Container app environment
resource "azurerm_container_app_environment" "env" {
  name                       = "lab-project-env"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
}

# Container app for backend
resource "azurerm_container_app" "backend" {
  name                         = "lab-backend"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "backend"
      image  = "${azurerm_container_registry.acr.login_server}/backend:latest"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "MYSQL_ROOT_PASSWORD"
        value = var.mysql_password
      }
      env {
        name  = "MYSQL_HOST"
        value = azurerm_mysql_server.mysql.fqdn
      }
      env {
        name  = "MYSQL_USER"
        value = "mysqladmin"
      }
      env {
        name  = "MYSQL_DATABASE"
        value = "lab_db"
      }
    }
  }

  ingress {
    external_enabled = true
    target_port     = 3000
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

# Container app for prometheus
resource "azurerm_container_app" "prometheus" {
  name                         = "lab-prometheus"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "prometheus"
      image  = "prom/prometheus:latest"
      cpu    = 0.5
      memory = "1Gi"

      volume_mounts {
        name = "prometheus-config"
        path = "/etc/prometheus"
      }
    }

    volume {
      name         = "prometheus-config"
      storage_type = "EmptyDir"
    }
  }

  ingress {
    external_enabled = true
    target_port     = 9090
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

# Container app for grafana
resource "azurerm_container_app" "grafana" {
  name                         = "lab-grafana"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "grafana"
      image  = "grafana/grafana:latest"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "GF_SECURITY_ADMIN_PASSWORD"
        value = var.grafana_password
      }
    }
  }

  ingress {
    external_enabled = true
    target_port     = 3000
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

# Container app for frontend
resource "azurerm_container_app" "frontend" {
  name                         = "lab-frontend"
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "frontend"
      image  = "${azurerm_container_registry.acr.login_server}/frontend:latest"
      cpu    = 0.5
      memory = "1Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port     = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
} 