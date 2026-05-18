# Centralized tfvars

This directory keeps the shared environment variable files for `infrastructure-v2`.

- `dev.tfvars`
- `staging.tfvars`
- `prod.tfvars`
- `management.tfvars`

The management CIDR allocation is `10.3.0.0/16`, which avoids overlap with the dev VPC and allows the peering module to create bidirectional routes safely.
