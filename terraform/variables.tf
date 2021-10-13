# Azure Related Variables
variable "azure_rg_name" {
  type = string
}

variable "azure_rg_location" {
  type    = string
  default = "Central India"
}

# MySQL Related Variables
variable "mysql_username" {
  type = string
}

variable "mysql_password" {
  type = string
}

variable "mysql_db_name" {
  type = string
}

# AKS Related Variables
variable "aks_cluster_name" {
  type = string
}

# Kubernetes Related Variables
variable "django_secret_key" {
  type = string
}

variable "registry_username" {
  type = string
}

variable "registry_password" {
  type = string
}

variable "container_location" {
  type = string
}

variable "mysql_db_port" {
  type = string
  default = "3306"
}