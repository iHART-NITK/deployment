/*
  All output values from the Terraform Deployment are defined here. Once the `terraform apply` succeeds, the output values are displayed to console.
  These values can then be accessed using the `terraform output` command.
*/

# Output the Public IP Address of the application
output "application_ip_address" {
  value = kubernetes_service.django_load_balancer.status[0].load_balancer[0].ingress.0.ip
}
