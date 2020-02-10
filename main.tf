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
  count      = length(fileset(local.datasources_path, "*.yaml"))
  depends_on = [var.monitor_depends_on]

  metadata {
    name      = "grafana-datasource-${replace(replace(sort(fileset(local.datasources_path, "*.yaml"))[count.index], ".yaml", ""), "_", "-")}"
    namespace = var.namespace

    labels = {
      grafana_datasource = 1
    }
  }

  data = {
    sort(fileset(local.datasources_path, "*.yaml"))[count.index] = file("${local.datasources_path}/${sort(fileset(local.datasources_path, "*.yaml"))[count.index]}")
  }
}

resource "kubernetes_config_map" "grafana-dashboards-kubernetes" {
  count      = length(fileset(local.dashboards_path, "kubernetes/*.json"))
  depends_on = [var.monitor_depends_on]

  metadata {
    name      = "grafana-dashboard-${replace(replace(basename(sort(fileset(local.dashboards_path, "kubernetes/*.json"))[count.index]), ".json", ""), "_", "-")}"
    namespace = var.namespace

    labels = {
      grafana_dashboard = 1
    }

    annotations = {
      k8s-sidecar-target-directory: "/var/lib/grafana/dashboards/kubernetes"
    }
  }

  data = {
    basename(sort(fileset(local.dashboards_path, "kubernetes/*.json"))[count.index]) = file("${local.dashboards_path}/${sort(fileset(local.dashboards_path, "kubernetes/*.json"))[count.index]}")
  }
}

resource "kubernetes_config_map" "grafana-dashboards-aws" {
  count      = length(fileset(local.dashboards_path, "aws/*.json"))
  depends_on = [var.monitor_depends_on]

  metadata {
    name      = "grafana-dashboard-${replace(replace(basename(sort(fileset(local.dashboards_path, "aws/*.json"))[count.index]), ".json", ""), "_", "-")}"
    namespace = var.namespace

    labels = {
      grafana_dashboard = 1
    }

    annotations = {
      k8s-sidecar-target-directory: "/var/lib/grafana/dashboards/aws"
    }
  }

  data = {
    basename(sort(fileset(local.dashboards_path, "aws/*.json"))[count.index]) = file("${local.dashboards_path}/${sort(fileset(local.dashboards_path, "aws/*.json"))[count.index]}")
  }
}

resource "kubernetes_config_map" "grafana-dashboards-logs" {
  count      = length(fileset(local.dashboards_path, "logs/*.json"))
  depends_on = [var.monitor_depends_on]

  metadata {
    name      = "grafana-dashboard-${replace(replace(basename(sort(fileset(local.dashboards_path, "logs/*.json"))[count.index]), ".json", ""), "_", "-")}"
    namespace = var.namespace

    labels = {
      grafana_dashboard = 1
    }

    annotations = {
      k8s-sidecar-target-directory: "/var/lib/grafana/dashboards/logs"
    }
  }

  data = {
    basename(sort(fileset(local.dashboards_path, "logs/*.json"))[count.index]) = file("${local.dashboards_path}/${sort(fileset(local.dashboards_path, "logs/*.json"))[count.index]}")
  }
}

resource "kubernetes_config_map" "grafana-dashboards-rails" {
  count      = length(fileset(local.dashboards_path, "rails/*.json"))
  depends_on = [var.monitor_depends_on]

  metadata {
    name      = "grafana-dashboard-${replace(replace(basename(sort(fileset(local.dashboards_path, "rails/*.json"))[count.index]), ".json", ""), "_", "-")}"
    namespace = var.namespace

    labels = {
      grafana_dashboard = 1
    }

    annotations = {
      k8s-sidecar-target-directory: "/var/lib/grafana/dashboards/rails"
    }
  }

  data = {
    basename(sort(fileset(local.dashboards_path, "rails/*.json"))[count.index]) = file("${local.dashboards_path}/${sort(fileset(local.dashboards_path, "rails/*.json"))[count.index]}")
  }
}

resource "kubernetes_config_map" "grafana-dashboards-vm" {
  count      = length(fileset(local.dashboards_path, "vm/*.json"))
  depends_on = [var.monitor_depends_on]

  metadata {
    name      = "grafana-dashboard-${replace(replace(basename(sort(fileset(local.dashboards_path, "vm/*.json"))[count.index]), ".json", ""), "_", "-")}"
    namespace = var.namespace

    labels = {
      grafana_dashboard = 1
    }

    annotations = {
      k8s-sidecar-target-directory: "/var/lib/grafana/dashboards/vm"
    }
  }

  data = {
    basename(sort(fileset(local.dashboards_path, "vm/*.json"))[count.index]) = file("${local.dashboards_path}/${sort(fileset(local.dashboards_path, "vm/*.json"))[count.index]}")
  }
}

resource "kubernetes_config_map" "grafana-dashboards-istio" {
  count      = length(fileset(local.dashboards_path, "istio/*.json"))
  depends_on = [var.monitor_depends_on]

  metadata {
    name      = "grafana-dashboard-${replace(replace(basename(sort(fileset(local.dashboards_path, "istio/*.json"))[count.index]), ".json", ""), "_", "-")}"
    namespace = var.namespace

    labels = {
      grafana_dashboard = 1
    }

    annotations = {
      k8s-sidecar-target-directory: "/tmp/dashboards/1"
    }
  }

  data = {
    basename(sort(fileset(local.dashboards_path, "istio/*.json"))[count.index]) = file("${local.dashboards_path}/${sort(fileset(local.dashboards_path, "istio/*.json"))[count.index]}")
  }
}

resource "helm_release" "grafana-ingress" {
  depends_on = [var.monitor_depends_on]
  name       = "grafana-ingress"
  chart      = "${path.module}/files/grafana-ingress"
  namespace  = var.namespace
  wait       = true

  values = [templatefile("${path.module}/templates/grafana-ingress.tpl", {
    host     = var.grafana_host,
    endpoint = var.grafana_endpoint
    }
    )
  ]
}

resource "helm_release" "grafana" {
  depends_on = [
    kubernetes_secret.grafana-credentials,
    kubernetes_secret.grafana-datasources
  ]

  name         = "grafana"
  #chart        = "grafana"
  chart        = "/Users/perx/Desktop/Repositories/test_grafana_chart/charts/stable/grafana"
  #repository   = "stable"
  namespace    = var.namespace
  wait         = true
  force_update = true

  values = [
    templatefile("${path.module}/templates/grafana.tpl", {
      tag = var.grafana_version
      # # AWS
      # aws-elasticache-redis      = indent(8, file("${local.dashboards_path}/aws/aws-elasticache-redis.json"))
      # # K8s
      # cluster-usage-overview     = indent(8, file("${local.dashboards_path}/kubernetes/cluster-usage-overview.json"))
      # containter-resource-usage  = indent(8, file("${local.dashboards_path}/kubernetes/containter-resource-usage.json"))
      # pod-resource-usage-by-node = indent(8, file("${local.dashboards_path}/kubernetes/pod-resource-usage-by-node.json"))
      # resource-utilisation       = indent(8, file("${local.dashboards_path}/kubernetes/resource-utilisation.json"))
      # jobs-monitoring            = indent(8, file("${local.dashboards_path}/kubernetes/jobs-monitoring.json"))
      # # Loki Logs
      # loki-application-logs      = indent(8, file("${local.dashboards_path}/logs/loki-application-logs.json"))
      # loki-job-logs              = indent(8, file("${local.dashboards_path}/logs/loki-job-logs.json"))
      # # Rails App
      # rails-app-overview         = indent(8, file("${local.dashboards_path}/rails/rails-app-overview.json"))
      # worker-jobs                = indent(8, file("${local.dashboards_path}/rails/worker-jobs.json"))
      # # Victoria Metrics
      # victoria-metrics-dashboard = indent(8, file("${local.dashboards_path}/vm/victoria-metrics-dashboard.json"))
      # # Istio
      # istio-performance          = indent(8, file("${local.dashboards_path}/istio/istio-performance.json"))
      # istio-workload             = indent(8, file("${local.dashboards_path}/istio/istio-workload.json"))
    }
    ),
    file("${path.module}/files/grafana/helm-grafana.yaml"),
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
    templatefile("${path.module}/templates/prometheus.tpl", {
      tag = var.prometheus_version
    }
    ),
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

  values = [
    templatefile("${path.module}/templates/loki.tpl", {
      tag = var.loki_version
    }
    ),
    file("${path.module}/files/helm-loki.yaml"),
    jsonencode(lookup(var.helm_configuration_overrides, "loki", {}))
  ]
}

resource "helm_release" "victoria-metrics" {
  depends_on   = [var.monitor_depends_on]
  name         = "victoria-metrics"
  chart        = "victoria-metrics-cluster"
  repository   = data.helm_repository.vm.metadata.0.name
  namespace    = var.namespace
  wait         = true
  force_update = true

  values = [
    templatefile("${path.module}/templates/victoria.tpl", {
      tag = var.vm_version
    }
    ),
    file("${path.module}/files/helm-victoria-metrics.yaml"),
    jsonencode(lookup(var.helm_configuration_overrides, "victoria-metrics", {}))
  ]

}

