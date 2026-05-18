# Cross-stack outputs

Use these Terraform outputs for cross-stack wiring:

- `dev.route_table_ids`: route tables consumed by the management peering stack
- `management.dev_management_peering_connection_id`: dev ↔ management peering connection
- `management.prometheus_remote_write_url`: canonical remote_write endpoint for agents
- `management.prometheus_agent_environment_variables`: environment variables to export before rendering `monitoring/k8s-manifests/prometheus-agent-configmap.yml`
- `management.prometheus_agent_environment_file`: shell-compatible env file content for `envsubst`

Example:

```bash
cd infrastructure-v2/environments/management
terraform output -raw prometheus_agent_environment_file > /tmp/prometheus-agent.env
set -a
source /tmp/prometheus-agent.env
set +a
envsubst < ../../../monitoring/k8s-manifests/prometheus-agent-configmap.yml | kubectl apply -f -
```
