variable "system" {}
variable "env" {}
variable "subnet_ids" {}
variable "security_group_id" {}

# Availability Zone attributes ---
variable "availability_zone" {
  description = "Select AZ structure( 2az or 3az )"
  type        = string
}

# RDS Cluster -------------
variable "rds_cluster_settings" {
  description = "RDS cluster settings"
  type = object({
    backup_retention_period      = number
    cluster_identifier           = string
    database_name                = string
    engine                       = string
    engine_mode                  = string
    engine_version               = string
    preferred_backup_window      = string
    preferred_maintenance_window = string
  })
}

# RDS Cluster Instance -------------
variable "rds_cluster_instance_settings" {
  description = "RDS cluster settings"
  type = object({
    instance_class = string
  })
}

# RDS Proxy -------------
variable "rds_proxy_settings" {
  description = "RDS cluster settings"
  type = object({
    engine_family                = string
    idle_client_timeout          = number
    connection_borrow_timeout    = number
    max_connections_percent      = number
    max_idle_connections_percent = number
  })
}