/*
  Variables are declared in this file. These variables are passed to different resource configurations using the `var` keyword.
  Values to these variables are defined in the Repository Secrets and passed to Terraform using GitHub Actions Secrets (using the `secrets` keyword).
  Link to Repository secrets: https://github.com/iHART-NITK/deployment/settings/secrets/actions
*/

### Azure Related Variables
# Name of the Resource Group to be fetched from Azure
variable "azure_rg_name" {
  type = string
}

### MySQL Related Variables
# Username to access the MySQL Server
variable "mysql_username" {
  type = string
}

# Password to access the MySQL Server
variable "mysql_password" {
  type = string
}

# Database name to store data in the MySQL Server
variable "mysql_db_name" {
  type = string
}

# Port number at which MySQL Server will listen to requests
variable "mysql_db_port" {
  type    = string
  default = "3306"
}

### AKS Related Variables
# AKS Cluster name in which the application will be deployed
variable "aks_cluster_name" {
  type = string
}

### Kubernetes Related Variables
# Secret key that is used in the Django Project
variable "django_secret_key" {
  type = string
}

# Username to access the GitHub Container Registry (GHCR) to fetch the Docker Container Image containing the Django Application
variable "registry_username" {
  type = string
}

# Password to access the GitHub Container Registry (GHCR) to fetch the Docker Container Image containing the Django Application
variable "registry_password" {
  type = string
}

# URL of the Docker Container Image containing the Django application
variable "container_location" {
  type = string
}
