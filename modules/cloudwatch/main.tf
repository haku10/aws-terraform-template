resource "aws_cloudwatch_log_group" "backend_middleware" {
  name              = "/ecs/${var.system}/${var.env}/go"
  retention_in_days = 30
}
