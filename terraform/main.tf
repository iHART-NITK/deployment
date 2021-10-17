/*
  Main module of the Terraform Deployment. The backend, provides and modules are defined here.
*/

# Terraform block, defines the required providers and the backend to use to store state
terraform {
  # Use the remote backend, provided by Terraform Cloud
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "iHART-NITK"
    workspaces {
      name = "prod"
    }
  }

  # Define the required providers, Azure and Kubernetes
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

# Define the Azure Resource Manager (AzureRM) provider
provider "azurerm" {
  features {}
}

# Define the Kubernetes provider, and pass the details from the AKS Cluster Resource to Kubernetes
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.django_deployment_cluster.kube_config.0.host
  username               = azurerm_kubernetes_cluster.django_deployment_cluster.kube_config.0.username
  password               = azurerm_kubernetes_cluster.django_deployment_cluster.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.django_deployment_cluster.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.django_deployment_cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.django_deployment_cluster.kube_config.0.cluster_ca_certificate)
}

# Fetch the Resource Group to house all Azure Resources
data "azurerm_resource_group" "ihart_resource_group" {
  name = var.azure_rg_name
}
