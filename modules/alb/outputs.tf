output "alb_backend_arn" {
  value = aws_lb.alb_backend.arn
}

output "alb_backend_target_group_arn" {
  value = aws_lb_target_group.target_group_backend.arn
}

output "alb_backend_dns_name" {
  value = aws_lb.alb_backend.dns_name
}

output "alb_frontend_dns_name" {
  value = aws_lb.alb_frontend.dns_name
}
