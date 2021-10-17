/*
  All the Azure MySQL Resources are defined here.
  The MySQL Server, MySQL Database and the firewall rule to allow traffic from the Kubernetes Cluster is defined here.
*/

# Fetch the Public IP Address of the AKS Load Balancer (this fetches the Resource ID as a URL, example below)
# /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Network/publicIPAddresses/<resource-name>
locals {
  # Split the fetched URL on the delimiter character '/'
  urlList = split("/", one(azurerm_kubernetes_cluster.django_deployment_cluster.network_profile.0.load_balancer_profile.0.effective_outbound_ips))
}

# Fetch the Public IP Address from Azure
data "azurerm_public_ip" "k8s_lb_ip_address" {
  name                = element(local.urlList, length(local.urlList) - 1)
  resource_group_name = element(local.urlList, length(local.urlList) - 5)
}

# Resource to create a MySQL Server in Azure
resource "azurerm_mysql_server" "ihart_mysql_server" {
  name                = "ihart-mysql-server"
  location            = data.azurerm_resource_group.ihart_resource_group.location
  resource_group_name = data.azurerm_resource_group.ihart_resource_group.name

  # Provide administrator credentials for the server
  administrator_login          = var.mysql_username
  administrator_login_password = var.mysql_password

  # Define processor, storage size and MySQL Version for the server
  sku_name   = "B_Gen5_1"
  storage_mb = 5120
  version    = "8.0"

  # Enable SSL Enforcement to allow only authenticated clients to connect to the server
  ssl_enforcement_enabled = true
}

# Create a Database in the MySQL Server
resource "azurerm_mysql_database" "mysql_db" {
  name                = var.mysql_db_name
  resource_group_name = data.azurerm_resource_group.ihart_resource_group.name
  server_name         = azurerm_mysql_server.ihart_mysql_server.name

  # Define the character set using which data in the database will be stored
  charset   = "utf8"
  collation = "utf8_unicode_ci"
}

# Add a firewall rule to allow traffic from AKS to the MySQL Server
resource "azurerm_mysql_firewall_rule" "mysql_firewall_rule" {
  name                = "k8s-ip-firewall-rule"
  resource_group_name = data.azurerm_resource_group.ihart_resource_group.name
  server_name         = azurerm_mysql_server.ihart_mysql_server.name

  # Since the start and end IP Address is the same, only one IP Address (from AKS) will be allowed to access the server
  start_ip_address = data.azurerm_public_ip.k8s_lb_ip_address.ip_address
  end_ip_address   = data.azurerm_public_ip.k8s_lb_ip_address.ip_address
}
