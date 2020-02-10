image:
  tag: ${tag}
sidecar:
  dashboards:
    provider:
      provider.yaml:
        apiVersion: 1
        providers:
        - name: 'kubernetes'
          orgId: 1
          folder: 'Kubernetes'
          type: file
          disableDeletion: true
          editable: true
          options:
            path: /var/lib/grafana/dashboards/kubernetes
        - name: 'aws'
          orgId: 1
          folder: 'AWS'
          type: file
          disableDeletion: true
          editable: true
          options:
            path: /var/lib/grafana/dashboards/aws
        - name: 'logs'
          orgId: 1
          folder: 'Logs'
          type: file
          disableDeletion: true
          editable: true
          options:
            path: /var/lib/grafana/dashboards/logs
        - name: 'rails'
          orgId: 1
          folder: 'Rails Application'
          type: file
          disableDeletion: true
          editable: true
          options:
            path: /var/lib/grafana/dashboards/rails
        - name: 'vm'
          orgId: 1
          folder: 'Victoria Metrics'
          type: file
          disableDeletion: true
          editable: true
          options:
            path: /var/lib/grafana/dashboards/vm
        - name: 'istio'
          orgId: 1
          folder: 'Istio'
          type: file
          disableDeletion: true
          editable: true
          options:
            path: /var/lib/grafana/dashboards/istio
# dashboards:
#   kubernetes:
#     cluster-usage-overview:
#       json: |
#         ${cluster-usage-overview}
#     containter-resource-usage:
#       json: |
#         ${containter-resource-usage}
#     pod-resource-usage-by-node:
#       json: |
#         ${pod-resource-usage-by-node}
#     resource-utilisation:
#       json: |
#         ${resource-utilisation}
#     jobs-monitoring:
#       json: |
#         ${jobs-monitoring}
#   aws:
#     aws-elasticache-redis:
#       json: |
#         ${aws-elasticache-redis}
#   logs:
#     loki-application-logs:
#       json: |
#         ${loki-application-logs}
#     loki-job-logs:
#       json: |
#         ${loki-job-logs}
#   rails:
#     rails-app-overview:
#       json: |
#         ${rails-app-overview}
#     worker-jobs:
#       json: |
#         ${worker-jobs}
#   vm:
#     victoria-metrics-dashboard:
#       json: |
#         ${victoria-metrics-dashboard}
#   istio:
#     istio-performance:
#       json: |
#         ${istio-performance}
#     istio-workload:
#       json: |
#         ${istio-workload}