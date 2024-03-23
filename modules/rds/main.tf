resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "example"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.system}-${var.env}-db-subnet-group"
  }
}

resource "aws_rds_cluster_parameter_group" "rds_cluster_parameters" {
  name   = "${var.system}-${var.env}-rds-cluster-parameters"
  family = "aurora-mysql8.0"

  #mysql character set ----
  parameter {
    name         = "character_set_client"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_connection"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_database"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_filesystem"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_results"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "character_set_server"
    value        = "utf8mb4"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_connection"
    value        = "utf8mb4_0900_ai_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "collation_server"
    value        = "utf8mb4_0900_ai_ci"
    apply_method = "immediate"
  }

  parameter {
    name         = "long_query_time"
    value        = "3"
    apply_method = "immediate"
  }

  parameter {
    name         = "slow_query_log"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "time_zone"
    value        = "Asia/Tokyo"
    apply_method = "immediate"
  }
}

# aurora db cluster ------------------------
resource "aws_rds_cluster" "aurora_db_cluster" {
  cluster_identifier              = var.rds_cluster_settings.cluster_identifier
  database_name                   = var.rds_cluster_settings.database_name
  master_username                 = jsondecode(data.aws_secretsmanager_secret_version.aurora_connection.secret_string)["USERNAME"]
  master_password                 = jsondecode(data.aws_secretsmanager_secret_version.aurora_connection.secret_string)["PASSWORD"]
  engine                          = var.rds_cluster_settings.engine
  engine_mode                     = var.rds_cluster_settings.engine_mode
  engine_version                  = var.rds_cluster_settings.engine_version
  db_subnet_group_name            = aws_db_subnet_group.rds_subnet_group.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.rds_cluster_parameters.name
  vpc_security_group_ids          = [var.security_group_id]
  backup_retention_period         = var.rds_cluster_settings.backup_retention_period
  preferred_backup_window         = var.rds_cluster_settings.preferred_backup_window
  preferred_maintenance_window    = var.rds_cluster_settings.preferred_maintenance_window
  storage_encrypted               = true
  deletion_protection             = true
  final_snapshot_identifier       = "cluster-snapshot"
  enabled_cloudwatch_logs_exports = ["error", "slowquery"]
  tags = {
    Name = "${var.system}-${var.env}-rds-for-mysql"
  }
  skip_final_snapshot = true
  lifecycle {
    ignore_changes = [
      master_username,
      master_password,
    ]
  }
}

# aurora db cluster instance ------------------------
resource "aws_rds_cluster_instance" "aurora_db_cluster_instances" {
  for_each = toset(local.az_zone_names)

  identifier                   = "cluster-instance-${each.key}"
  cluster_identifier           = aws_rds_cluster.aurora_db_cluster.id
  engine                       = aws_rds_cluster.aurora_db_cluster.engine
  engine_version               = aws_rds_cluster.aurora_db_cluster.engine_version
  instance_class               = var.rds_cluster_instance_settings.instance_class
  copy_tags_to_snapshot        = true
  performance_insights_enabled = false
  publicly_accessible          = false
  availability_zone            = each.value
  db_subnet_group_name         = aws_db_subnet_group.rds_subnet_group.name
  tags = {
    Name = "${var.system}-${var.env}-rds-for-mysql"
  }
  lifecycle {
    ignore_changes = [
      instance_class,
      db_subnet_group_name,
    ]
  }
}
