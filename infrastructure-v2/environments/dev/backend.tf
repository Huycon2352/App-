# ============================================================
# Terraform Backend: S3 + DynamoDB (Remote State)
# ============================================================

terraform {
  backend "s3" {
    # Thay đổi sau khi bootstrap
    bucket         = "voting-app-terraform-state-123456789"  # Change this to your bucket name
    key            = "environments/dev/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "voting-app-terraform-lock"
    encrypt        = true
  }
}
