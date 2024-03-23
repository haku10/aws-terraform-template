//DBでのユーザー名・パスワードは、事前に手動でSecrets Managerに登録しておく必要があります。
data "aws_secretsmanager_secret" "aurora_connection" {
  name = "${var.system}-${var.env}/aurora-connection"
}

data "aws_secretsmanager_secret_version" "aurora_connection" {
  secret_id = data.aws_secretsmanager_secret.aurora_connection.id
}
