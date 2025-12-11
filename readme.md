[ Git push ]
      ↓
[ Jenkins webhook ]
      ↓
[ Pipeline start ]
      ↓
[ Docker build ]
      ↓
[ Docker push to DockerHub ]
      ↓
[ Terraform apply -> create app server ]
      ↓
[ Ansible deploy on app ]
      ↓
[ Done ]



-LINUX AMAZON 2023
-APP ROLES:
common
docker
postgres
flask_app
node_exporter
postgres_exporter
promtail
prometheus
grafana
cadvisor
loki
cadvisor

-CONTAINERS:
alertmanager_container_name: "alertmanager"
flask_container_name: "flask_app"
node_exporter_container_name: "node_exporter"
postgres_exporter_container_name: "postgres_exporter"
loki_container_name: "loki"
cadvisor_container_name: "cadvisor"
grafana_container_name: "grafana"
promtail_container_name: "promtail"
postgres_container_name: "postgres_db"
prometheus_container_name: "prometheus"

-IMAGES:
flask_image: "flask-app:v2"
alertmanager_image: "prom/alertmanager:v0.26.0"
cadvisor_image: "gcr.io/cadvisor/cadvisor:v0.47.0"
grafana_image: "grafana/grafana:10.2.2"
loki_image: "grafana/loki:2.9.0"
node_exporter_image: "prom/node-exporter:v1.7.0"
postgres_image: "postgres:14.10-alpine"
postgres_exporter_image: "prometheuscommunity/postgres-exporter:v0.15.0"
prometheus_image: "prom/prometheus:v2.48.0"
promtail_image: "grafana/promtail:2.9.0"

-PORTS:
flask_port: 5000
postgres_port: 5432
node_exporter_port: 9100
cadvisor_port: 8080
loki_port: 3100
prometheus_port: 9090
grafana_port: 3000
alertmanager_port: 9093
promtail_port: 9080
postgres_exporter_port: 9187
docker_metrics_port: 9323

-GRAFANA DASHBOARDS:
11098 (Prometheus Alertmanager) 
14055 (Loki & Promtail)
1860 (Node Exporter Full)
14282 (Cadvisor exporter)
13639 (Loki Dashboard Quick Search)
893 (Docker and system monitoring)
1229 (Docker Host Dashboard)
9628 (PostgreSQL Database)
3662 (Prometheus 2.0 Stats)

-WEB UI:
'Flask App:    http://3.123.2.206:5000'
'Prometheus:   http://3.123.2.206:9090'
'Grafana:      http://3.123.2.206:3000'
'Alertmanager: http://3.123.2.206:9093'
'Loki:         http://3.123.2.206:3100' (404)


  
