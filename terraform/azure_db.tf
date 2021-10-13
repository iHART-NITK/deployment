# Fetch the Public IP Address of the AKS Load Balancer (this fetches the Resource ID)
locals {
  urlList = split("/", one(azurerm_kubernetes_cluster.django_deployment_cluster.network_profile.0.load_balancer_profile.0.effective_outbound_ips))
}

# Fetch the Public ID Address
data "azurerm_public_ip" "k8s_lb_ip_address" {
  name                = element(local.urlList, length(local.urlList) - 1)
  resource_group_name = element(local.urlList, length(local.urlList) - 5)
}

# Resource to create a MySQL Server in Azure
resource "azurerm_mysql_server" "ihart_mysql_server" {
  name                = "ihart-mysql-server"
  location            = azurerm_resource_group.ihart_resource_group.location
  resource_group_name = azurerm_resource_group.ihart_resource_group.name

  administrator_login          = var.mysql_username
  administrator_login_password = var.mysql_password

  sku_name   = "B_Gen5_1"
  storage_mb = 5120
  version    = "8.0"

  ssl_enforcement_enabled = true
}

# Create a Database in the MySQL Server
resource "azurerm_mysql_database" "mysql_db" {
  name                = var.mysql_db_name
  resource_group_name = azurerm_resource_group.ihart_resource_group.name
  server_name         = azurerm_mysql_server.ihart_mysql_server.name

  charset   = "utf8"
  collation = "utf8_unicode_ci"
}

# Add a firewall rule to allow traffic from AKS to the MySQL Server
resource "azurerm_mysql_firewall_rule" "mysql_firewall_rule" {
  name                = "k8s-ip-firewall-rule"
  resource_group_name = azurerm_resource_group.ihart_resource_group.name
  server_name         = azurerm_mysql_server.ihart_mysql_server.name

  start_ip_address = data.azurerm_public_ip.k8s_lb_ip_address.ip_address
  end_ip_address   = data.azurerm_public_ip.k8s_lb_ip_address.ip_address
}
