terraform {
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
resource "azurerm_resource_group" "ihart_resource_group" {
  name     = var.azure_rg_name
  location = var.azure_rg_location
}
