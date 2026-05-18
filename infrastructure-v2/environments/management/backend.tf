# ============================================================
# Terraform Backend: S3 + DynamoDB (Remote State)
# ============================================================

terraform {
  backend "s3" {
    bucket         = "voting-app-terraform-state-248195880649"
    key            = "environments/management/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "voting-app-terraform-lock-248195880649"
    encrypt        = true
  }
}
