vmselect:
  fullnameOverride: vmselect
  replicaCount: 1
  image:
    tag: v1.29.1-cluster
    pullPolicy: Always
  resources:
    limits:
      cpu: 1
      memory: 1Gi
    requests:
      cpu: 300m
      memory: 512Mi
vminsert:
  fullnameOverride: vminsert
  replicaCount: 1
  image:
    tag: v1.29.1-cluster
    pullPolicy: Always
  resources:
    limits:
      cpu: 1
      memory: 1Gi
    requests:
      cpu: 300m
      memory: 512Mi
vmstorage:
  fullnameOverride: vmstorage
  replicaCount: 1
  image:
    tag: v1.29.1-cluster
    pullPolicy: Always
  persistentVolume:
    size: 50Gi
  resources:
    limits:
      cpu: 1
      memory: 4Gi
    requests:
      cpu: 300m
      memory: 2Gi
