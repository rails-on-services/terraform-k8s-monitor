image:
  tag: 6.4.4
persistence:
  enabled: true
  size: 20Gi
  accessModes:
  - ReadWriteOnce
deploymentStrategy:
  type: Recreate
service:
  type: ClusterIP
resources:
  limits:
    cpu: 200m
    memory: 512Mi
  requests:
    cpu: 100m
    memory: 256Mi
admin:
  existingSecret: grafana-credentials
  userKey: username
  passwordKey: password
sidecar:
  dashboards:
    enabled: true
    label: grafana_dashboard
  datasources:
    enabled: true
    label: grafana_datasource
plugins:
  - grafana-piechart-panel
env:
  GODEBUG: netdns=go

