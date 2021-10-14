# Creates a Kubernetes Cluster in Azure
resource "azurerm_kubernetes_cluster" "django_deployment_cluster" {
  name                      = var.aks_cluster_name
  location                  = data.azurerm_resource_group.ihart_resource_group.location
  resource_group_name       = data.azurerm_resource_group.ihart_resource_group.name
  dns_prefix                = "djangoaks1"
  automatic_channel_upgrade = "stable"

  default_node_pool {
    name                = "default"
    vm_size             = "Standard_DS2_v2"
    enable_auto_scaling = false
    # min_count = 1
    # max_count = 32
    node_count = 1
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      default_node_pool["node_count"]
    ]
  }
}
