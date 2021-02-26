apiVersion: v1
data:
  prometheus.yml: |-
    global:
      evaluation_interval: 1m
      scrape_interval: 1m
      scrape_timeout: 10s
      external_labels:
        prometheus01: nodeCluster
        prometheus02: jenkinsCluster
        prometheus03: appCluster
    scrape_configs:
    - job_name: 'federate'
      scrape_interval: 5s
      honor_labels: true
      metrics_path: '/federate'
      params:
        'match[]':
          - '{job=~"monitoring.*"}'
          - '{job="kubelet"}'
          - '{job="kube-state-metrics"}'
          - '{job=~"prometheus.*"}'
          - '{job=~"alertmanager.*"}'
          - '{job=~"grafana.*"}'
          - '{__name__=~"job:.*"}'
          - '{__name__=~"node.*"}'
          - '{__name__=~"kube.*"}'
          - '{__name__=~"grafana.*"}'
          - '{__name__=~"cluster:.*"}'
          - '{__name__=~"alertmanager.*"}'
          - '{job="apiserver"}'
      static_configs:
        - targets:
          - "192.168.80.32:32418"
          labels:
            instance: nodeCluster
            __hostname__: nodeCluster
        - targets:
          - "192.168.80.80:30289"
          labels:
            instance: jenkinsCluster
            __hostname__: jenkinsCluster
        - targets:
          - "192.168.80.84:30760"
          labels:
            instance: appCluster
            __hostname__: appCluster
      relabel_configs:
      - source_labels:
        - "__hostname__"
        regex: "(.*)"
        target_label: "origin_prometheus"
        action: replace
        replacement: "$1"
kind: ConfigMap