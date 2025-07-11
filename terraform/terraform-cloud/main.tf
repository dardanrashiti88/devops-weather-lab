terraform {
  required_version = ">= 1.0"
  cloud {
    organization = "LAB-2-terraform"
    workspaces {
      name = "lab-project-workspace"
    }
  }
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

resource "kubernetes_namespace" "app" {
  metadata {
    name = var.app_namespace
  }
}

resource "kubernetes_config_map" "app_config2" {
  metadata {
    name      = "my-app2-config"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  data = {
    ENVIRONMENT = var.environment
    APP_NAME    = "my-app2"
  }
}

resource "kubernetes_secret" "app_secret2" {
  metadata {
    name      = "my-app2-secret"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  data = {
    DATABASE_URL = var.database_url
    API_KEY      = var.api_key
  }
  type = "Opaque"
}

resource "kubernetes_deployment" "app2" {
  metadata {
    name      = "my-app2"
    namespace = kubernetes_namespace.app.metadata[0].name
    labels = {
      app = "my-app2"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "my-app2"
      }
    }
    template {
      metadata {
        labels = {
          app = "my-app2"
        }
      }
      spec {
        container {
          name  = "my-app2"
          image = var.app_image
          env_from {
            config_map_ref {
              name = kubernetes_config_map.app_config2.metadata[0].name
            }
          }
          env_from {
            secret_ref {
              name = kubernetes_secret.app_secret2.metadata[0].name
            }
          }
          port {
            container_port = var.app_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app2" {
  metadata {
    name      = "my-app2-svc"
    namespace = kubernetes_namespace.app.metadata[0].name
  }
  spec {
    selector = {
      app = "my-app2"
    }
    port {
      port        = var.app_port
      target_port = var.app_port
    }
    type = "ClusterIP"
  }
}

resource "local_file" "init_sql" {
  content  = var.init_sql_content
  filename = "${path.module}/init-exporter-user.sql"
}

output "namespace" {
  value = kubernetes_namespace.app.metadata[0].name
}

output "service_name2" {
  value = kubernetes_service.app2.metadata[0].name
}

output "deployment_name2" {
  value = kubernetes_deployment.app2.metadata[0].name
}

output "init_sql_path" {
  value = local_file.init_sql.filename
} 