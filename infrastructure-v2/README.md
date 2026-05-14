# Infrastructure-V2: Minimal EKS Setup

## 📋 Kiến trúc

- **1 VPC** duy nhất: `10.0.0.0/16`
- **1 Private Subnet**: `10.0.10.0/24` (Nodes + Pods)
- **EKS Cluster**: Minimal configuration
- **Node Group**: 1-2 nodes (t3.small) - Auto-scaling
- **ALB Controller**: Để expose services ra ngoài
- **Terraform State**: S3 + DynamoDB (lock)

## 🚀 Cách deploy

### Step 1: Bootstrap (tạo S3 + DynamoDB)
```bash
cd infrastructure-v2/bootstrap/backend
terraform init
terraform apply
```

### Step 2: Deploy Dev Environment
```bash
cd infrastructure-v2/environments/dev
terraform init
terraform plan
terraform apply
```

### Step 3: Deploy Staging (optional)
```bash
cd infrastructure-v2/environments/staging
terraform init
terraform apply
```

### Step 4: Deploy Prod (optional)
```bash
cd infrastructure-v2/environments/prod
terraform init
terraform apply
```

## 💰 Chi phí dự kiến

| Dịch vụ | Chi phí/tháng |
|---------|---------------|
| EKS Cluster | $73 |
| EC2 (t3.small x1-2) | $15-30 |
| NAT Gateway | $35 |
| VPC Endpoints | ~$7 |
| ALB (optional) | $16 |
| **TỔNG** | **~$146-161/tháng** |

## 📝 Notes

- Terraform state lưu trên S3 + DynamoDB lock
- Mỗi environment (dev/staging/prod) có state riêng
- Auto-scaling: Min 1 node, Max 3 nodes
- Instance type: `t3.small` (rẻ, đủ cho dev/staging)
- Staging/Prod có thể thay đổi instance type trong `terraform.tfvars`

## 🔗 Mối quan hệ modules

```
main.tf
├── vpc (tạo VPC + Subnet)
├── security-group (tạo SG cho EKS)
├── iam (tạo IAM roles)
├── eks (tạo EKS cluster)
├── node-group (tạo Node Group)
├── alb-controller (Helm chart)
├── ecr (tạo ECR repos)
└── argocd (Helm chart - optional)
```

## ⚠️ Requirements

- Terraform >= 1.0
- AWS CLI configured
- `kubectl` installed
- `helm` installed (for ArgoCD + ALB Controller)
