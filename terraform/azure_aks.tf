/*
  The Azure Kubernetes Cluster is defined here.
*/

# Creates a Kubernetes Cluster in Azure
resource "azurerm_kubernetes_cluster" "django_deployment_cluster" {
  name                = var.aks_cluster_name
  location            = data.azurerm_resource_group.ihart_resource_group.location
  resource_group_name = data.azurerm_resource_group.ihart_resource_group.name

  dns_prefix                = "djangoaks1"
  automatic_channel_upgrade = "stable"

  # Define the default node pool, along with the processor and number of such nodes
  default_node_pool {
    name                = "default"
    vm_size             = "Standard_DS2_v2"
    enable_auto_scaling = false
    # min_count = 1
    # max_count = 32
    node_count = 1
  }

  # Define the type of Service Account that will manage the cluster
  identity {
    type = "SystemAssigned"
  }

  # When the number of nodes in the node pool are set to auto-scale, Terraform will not attempt to constantly store these changes to state
  lifecycle {
    ignore_changes = [
      default_node_pool["node_count"]
    ]
  }
}
