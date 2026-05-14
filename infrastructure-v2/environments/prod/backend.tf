terraform {
  backend "s3" {
    bucket         = "voting-app-terraform-state-123456789"  # Change this to your bucket name
    key            = "environments/prod/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "voting-app-terraform-lock"
    encrypt        = true
  }
}
