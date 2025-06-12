resource "kubernetes_service" "service" {
  metadata {
    name      = "${var.project_name}-service"
    namespace = kubernetes_namespace.n.metadata[0].name
  }
  spec {
    selector = {
      App = kubernetes_deployment.deployment.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = var.app_target_port
    }

    type = "LoadBalancer"
  }
}