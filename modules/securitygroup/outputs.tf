output "sg_backend_alb_id" {
  description = "ALB security group id"
  value       = aws_security_group.backend_alb.id
}

output "sg_ecs_id" {
  description = "ECS security group id"
  value       = aws_security_group.backend_ecs.id
}

output "sg_rds_id" {
  description = "RDS for MySQL security group id"
  value       = aws_security_group.rds.id
}

output "sg_bastion_id" {
  description = "bastion security group id"
  value       = aws_security_group.bastion.id
}
