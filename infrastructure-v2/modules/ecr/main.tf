# ============================================================
# ECR Module: Elastic Container Registry
# ============================================================

resource "aws_ecr_repository" "vote" {
  name                 = "${var.environment}-vote-app"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.environment}-vote-app"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_ecr_repository" "result" {
  name                 = "${var.environment}-result-app"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.environment}-result-app"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_ecr_repository" "worker" {
  name                 = "${var.environment}-worker-app"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "${var.environment}-worker-app"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Lifecycle policy: Keep last 10 images
resource "aws_ecr_lifecycle_policy" "main" {
  for_each   = toset([aws_ecr_repository.vote.name, aws_ecr_repository.result.name, aws_ecr_repository.worker.name])
  repository = each.value

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
