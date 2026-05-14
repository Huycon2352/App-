output "vote_repository_url" {
  description = "Vote app ECR repository URL"
  value       = aws_ecr_repository.vote.repository_url
}

output "result_repository_url" {
  description = "Result app ECR repository URL"
  value       = aws_ecr_repository.result.repository_url
}

output "worker_repository_url" {
  description = "Worker app ECR repository URL"
  value       = aws_ecr_repository.worker.repository_url
}
