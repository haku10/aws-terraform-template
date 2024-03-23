output "db_cluster_username" {
  value = aws_rds_cluster.aurora_db_cluster.master_username
}

output "db_cluster_password" {
  value     = jsondecode(data.aws_secretsmanager_secret_version.aurora_connection.secret_string)["PASSWORD"]
  sensitive = true
}

output "db_cluster_endpoint" {
  value = aws_rds_cluster.aurora_db_cluster.endpoint
}

output "db_instance_port" {
  value = aws_rds_cluster.aurora_db_cluster.port
}

output "db_instance_dbname" {
  value = aws_rds_cluster.aurora_db_cluster.database_name
}
