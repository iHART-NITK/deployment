/*
  All Kubernetes resources are defined here.
  The Kubernetes deployment, Kubernetes Load Balancer service and the Kubernetes Secret (GitHub Personal Access Token to fetch private Docker Image) are defined.
  All the Kubernetes resources will be deployed on to the Azure Kubernetes Service cluster, defined in `azure_aks.tf`
*/

# Create the K8s secret to store the GitHub personal access token
resource "kubernetes_secret" "github_pat_secret" {
  metadata {
    name = "github-pat-secret"
  }

  # The secret has to be stored in a file called .dockerconfigjson, so we pipe the string into the .dockerconfigjson file
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
  # Deployment metadata
  metadata {
    name = "django-deployment"
    labels = {
      "app" = "iHART"
    }
  }

  # Deployment specifications
  spec {
    # Number of replicas in total, these will be equally divided in the node pool
    replicas = 2

    # Selector is used to match Pod labels to manage
    selector {
      match_labels = {
        "app" = "iHART"
      }
    }

    # Template for each pod
    template {
      # Pod metadata, used by spec selector for identification
      metadata {
        labels = {
          "app" = "iHART"
        }
      }

      # Pod specifications
      spec {
        # Docker container image to run in each pod
        container {
          image = var.container_location
          name  = "ihart-container"
          port {
            container_port = 80
          }

          # Environment variables within the container
          env {
            name  = "PROJECT_SECRET"
            value = var.django_secret_key
          }
          env {
            name = "DJANGO_SUPERUSER_PASSWORD"
            value = var.django_superuser_password
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

        # Kubernetes secret required to pull the private Docker image
        image_pull_secrets {
          name = kubernetes_secret.github_pat_secret.metadata.0.name
        }

      }
    }
  }
}

# Create the load balancer
resource "kubernetes_service" "django_load_balancer" {
  # Service metadata
  metadata {
    name = "django-load-balancer"
  }

  # Service specifications
  spec {
    # This service will select all Pods with the label "iHART"
    selector = {
      "app" = kubernetes_deployment.django_k8s_deployment.metadata.0.labels.app
    }

    # This service will target port 80 on all selected pods
    port {
      port = 80
    }

    # This service is a load balancer service
    type = "LoadBalancer"
  }
}
