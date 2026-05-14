output "s3_bucket_name" {
  description = "S3 bucket name for Terraform state"
  value       = aws_s3_bucket.terraform_state.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_table_name" {
  description = "DynamoDB table name for Terraform lock"
  value       = aws_dynamodb_table.terraform_lock.id
}

output "terraform_backend_config" {
  description = "Terraform backend configuration"
  value = {
    bucket         = aws_s3_bucket.terraform_state.id
    key            = "environments/{env}/terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = aws_dynamodb_table.terraform_lock.id
    encrypt        = true
  }
}
