resource "aws_ssm_parameter" "db_username" {
  name  = "/${var.system}/${var.env}/rds/username"
  type  = "String"
  value = var.db_username
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.system}/${var.env}/rds/password"
  type  = "String"
  value = var.db_password
}

resource "aws_ssm_parameter" "db_endpoint" {
  name  = "/${var.system}/${var.env}/rds/host"
  type  = "String"
  value = var.db_endpoint
}

resource "aws_ssm_parameter" "db_port" {
  name  = "/${var.system}/${var.env}/rds/port"
  type  = "String"
  value = var.db_port
}

resource "aws_ssm_parameter" "db_dbname" {
  name  = "/${var.system}/${var.env}/rds/dbname"
  type  = "String"
  value = var.db_dbname
}

resource "aws_ssm_document" "port_forwarding_connection_to_rds" {
  name          = "${var.system}-${var.env}-StartPortForwardingSessionToRDS"
  document_type = "Session"

  content = jsonencode({
    "schemaVersion" : "1.0",
    "description" : "Session Manager経由でRDSへのポートフォワーディングを開始するためのSSM Document",
    "sessionType" : "Port",
    "parameters" : {
      "localPortNumber" : {
        "type" : "String",
        "description" : "(任意) ローカルマシンのポート番号。デフォルトは13307",
        "allowedPattern" : "^([0-9]|[1-9][0-9]{1,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$",
        "default" : "13307"
      },
    },
    "properties" : {
      "portNumber" : "3306",
      "type" : "LocalPortForwarding",
      "localPortNumber" : "{{ localPortNumber }}",
      "host" : "${var.db_endpoint}"
    }
  })
}
