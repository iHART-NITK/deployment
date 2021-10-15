# Create the K8s secret to store the GitHub personal access token
resource "kubernetes_secret" "github_pat_secret" {
  metadata {
    name = "github-pat-secret"
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "ghcr.io": {
      "auth": "${base64encode("${var.registry_username}:${var.registry_password}")}"
    }
  }
}
DOCKER
  }

  type = "kubernetes.io/dockerconfigjson"
}

# Create the K8s deployment
resource "kubernetes_deployment" "django_k8s_deployment" {
  metadata {
    name = "django-deployment"
    labels = {
      "app" = "iHART"
    }
  }

  spec {
    replicas = 8
    selector {
      match_labels = {
        "app" = "iHART"
      }
    }

    template {
      metadata {
        labels = {
          "app" = "iHART"
        }
      }

      spec {
        container {
          image = var.container_location
          name  = "ihart-container"
          port {
            container_port = 80
          }

          env {
            name  = "PROJECT_SECRET"
            value = var.django_secret_key
          }
          env {
            name  = "DATABASE_HOST"
            value = azurerm_mysql_server.ihart_mysql_server.fqdn
          }
          env {
            name  = "DATABASE_USER"
            value = "${var.mysql_username}@${azurerm_mysql_server.ihart_mysql_server.name}"
          }
          env {
            name  = "DATABASE_PASS"
            value = var.mysql_password
          }
          env {
            name  = "DATABASE_NAME"
            value = var.mysql_db_name
          }
          env {
            name  = "DATABASE_PORT"
            value = var.mysql_db_port
          }
        }

        image_pull_secrets {
          name = kubernetes_secret.github_pat_secret.metadata.0.name
        }

      }
    }
  }
}

# Create the load balancer
resource "kubernetes_service" "django_load_balancer" {
  metadata {
    name = "django-load-balancer"
  }
  spec {
    selector = {
      "app" = kubernetes_deployment.django_k8s_deployment.metadata.0.labels.app
    }
    port {
      port = 80
    }
    type = "LoadBalancer"
  }
}
