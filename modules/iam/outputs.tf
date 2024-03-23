output "bastion_iam_instance_profile_name" {
  value = aws_iam_instance_profile.session_manager_instance_profile.name
}

output "ecs_iam_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}
