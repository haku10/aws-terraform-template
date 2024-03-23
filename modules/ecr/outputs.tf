output "backend_repository_url" {
  value = aws_ecr_repository.admin_backend_repository.repository_url
}

output "frontend_repository_url" {
  value = aws_ecr_repository.admin_front_repository.repository_url
}
