data "helm_repository" "vm" {
  name = "vm"
  url  = "https://victoriametrics.github.io/helm-charts/"
}

data "helm_repository" "loki" {
  name = "loki"
  url  = "https://grafana.github.io/loki/charts"
}

resource "helm_release" "metrics-server" {
  name      = "metrics-server"
  chart     = "stable/metrics-server"
  namespace = "kube-system"
  wait      = true

  values = [file("${path.module}/files/helm-metrics-server.yaml")]
}

resource "helm_release" "kube-state-metrics" {
  name      = "kube-state-metrics"
  chart     = "stable/kube-state-metrics"
  namespace = "kube-system"
  wait      = true

  values = [file("${path.module}/files/helm-kube-state-metrics.yaml")]
}

resource "kubernetes_secret" "grafana-credentials" {
  depends_on = [var.monitor_depends_on]

  metadata {
    name      = "grafana-credentials"
    namespace = var.namespace
  }

  data = {
    username = var.grafana_user
    password = var.grafana_password
  }
}

resource "kubernetes_secret" "grafana-datasources" {
  count      = length(fileset(path.module, "files/grafana/datasources/*.yaml"))
  depends_on = [var.monitor_depends_on]

  metadata {
    name      = "grafana-datasource-${replace(replace(basename(sort(fileset(path.module, "files/grafana/datasources/*.yaml"))[count.index]), ".yaml", ""), "_", "-")}"
    namespace = var.namespace

    labels = {
      grafana_datasource = 1
    }
  }

  data = {
    basename(sort(fileset(path.module, "files/grafana/datasources/*.yaml"))[count.index]) = file("${path.module}/${sort(fileset(path.module, "files/grafana/datasources/*.yaml"))[count.index]}")
  }
}

resource "kubernetes_config_map" "grafana-dashboards" {
  count      = length(fileset(path.module, "files/grafana/dashboards/*.json"))
  depends_on = [var.monitor_depends_on]

  metadata {
    name      = "grafana-dashboard-${replace(replace(basename(sort(fileset(path.module, "files/grafana/dashboards/*.json"))[count.index]), ".json", ""), "_", "-")}"
    namespace = var.namespace

    labels = {
      grafana_dashboard = 1
    }
  }

  data = {
    basename(sort(fileset(path.module, "files/grafana/dashboards/*.json"))[count.index]) = file("${path.module}/${sort(fileset(path.module, "files/grafana/dashboards/*.json"))[count.index]}")
  }
}

resource "helm_release" "grafana-ingress" {
  depends_on = [var.monitor_depends_on]
  name       = "grafana-ingress"
  chart      = "${path.module}/files/grafana-ingress"
  namespace  = var.namespace
  wait       = true

  values = [templatefile("${path.module}/templates/grafana/helm-grafana-ingress.tpl", {
    host     = var.grafana_host,
    endpoint = var.grafana_endpoint
    }
    )
  ]
}

resource "helm_release" "grafana" {
  depends_on = [
    kubernetes_secret.grafana-credentials,
    kubernetes_config_map.grafana-dashboards,
    kubernetes_secret.grafana-datasources
  ]

  name         = "grafana"
  chart        = "grafana"
  repository   = "stable"
  namespace    = var.namespace
  wait         = true
  force_update = true

  values = [
    templatefile("${path.module}/templates/grafana/helm-grafana.tpl", {}),
    jsonencode(lookup(var.helm_configuration_overrides, "grafana", {}))
  ]
}

resource "helm_release" "prometheus" {
  depends_on   = [var.monitor_depends_on]
  name         = "prometheus"
  chart        = "prometheus"
  repository   = "stable"
  namespace    = var.namespace
  wait         = true
  force_update = true

  values = [
    #templatefile("${path.module}/templates/helm-prometheus.tpl", {}),
    file("${path.module}/files/helm-prometheus.yaml"),
    jsonencode(lookup(var.helm_configuration_overrides, "prometheus", {}))
  ]
}

resource "helm_release" "loki" {
  depends_on   = [var.monitor_depends_on]
  name         = "loki"
  chart        = "loki"
  repository   = data.helm_repository.loki.metadata.0.name
  namespace    = var.namespace
  wait         = true
  force_update = true

  values = [file("${path.module}/files/helm-loki.yaml")]
}

resource "helm_release" "victoria-metrics" {
  depends_on   = [var.monitor_depends_on]
  name         = "victoria-metrics"
  chart        = "victoria-metrics-cluster"
  repository   = data.helm_repository.vm.metadata.0.name
  namespace    = var.namespace
  wait         = true
  force_update = true

  values = [templatefile("${path.module}/templates/helm-victoria-metrics.tpl", {})]

}

