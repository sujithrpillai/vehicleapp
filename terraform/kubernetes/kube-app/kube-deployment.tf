resource "kubernetes_deployment" "deployment" {
  metadata {
    name = "${var.project_name}-deployment"
    labels = {
      App = var.project_name
    }
    namespace = kubernetes_namespace.n.metadata[0].name
  }

  spec {
    replicas                  = 1
    progress_deadline_seconds = 300
    selector {
      match_labels = {
        App = var.project_name
      }
    }
    template {
      metadata {
        labels = {
          App = var.project_name
        }
      }
      spec {
        container {
          image = var.frontend_image
          name  = var.project_name

          port {
            container_port = var.app_target_port
          }

          resources {
            limits = {
              cpu    = "0.2"
              memory = "2562Mi"
            }
            requests = {
              cpu    = "0.1"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}