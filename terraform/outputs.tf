output "application_ip_address" {
  value = kubernetes_service.django_load_balancer.status[0].load_balancer[0].ingress.0.ip
}