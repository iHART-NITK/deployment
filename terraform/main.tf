terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "iHART-NITK"
    workspaces {
      name = "prod"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.80.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.5.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.django_deployment_cluster.kube_config.0.host
  username               = azurerm_kubernetes_cluster.django_deployment_cluster.kube_config.0.username
  password               = azurerm_kubernetes_cluster.django_deployment_cluster.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.django_deployment_cluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.django_deployment_cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.django_deployment_cluster.kube_config.0.cluster_ca_certificate)
}

# Resource Group to house all Azure Resources
data "azurerm_resource_group" "ihart_resource_group" {
  name     = var.azure_rg_name
}
