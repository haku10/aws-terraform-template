# This sample, non-production-ready template describes AWS IaC.
# © 2021 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement
# available at http://aws.amazon.com/agreement or other written agreement
# between Customer and either Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  vpc_az = "2az" // 2AZ構成VPCの場合: "2az"、3AZ構成VPCの場合: "3az"
  //RDS設定
  rds_cluster_settings = {
    backup_retention_period      = 7
    cluster_identifier           = "example-cluster"
    database_name                = "example" // 好きな前をつける
    engine                       = "aurora-mysql" //aurora, aurora-mysql, aurora-postgresql, mysql, postgres
    engine_mode                  = "provisioned"  //multimaster, parallelquery, provisioned, serverless
    engine_version               = "8.0.mysql_aurora.3.04.0"
    preferred_backup_window      = "02:24-02:54"
    preferred_maintenance_window = "sat:00:15-sat:01:45"
  }

  rds_proxy_settings = {
    engine_family                = "MYSQL"
    idle_client_timeout          = 120 //案件ごとに修正ください
    connection_borrow_timeout    = 120 //案件ごとに修正ください
    max_connections_percent      = 100 //案件ごとに修正ください
    max_idle_connections_percent = 50  //案件ごとに修正ください
  }

  rds_cluster_instance_settings = {
    instance_class = "db.t3.medium" // 予算に応じてインスタンスタイプは調整 ※Auroraは高い。。
  }

  // -------------------------------------
  // 管理画面用
  // -------------------------------------

  // CloudFrontのドメイン名 TODO 取得したドメイン名をつけてください
  cloudfront_domain_name = ""

  // CLoudFrontのACMのARN TODO 取得したACMのARNをつけてください
  acm_certificate_arn = ""

  // ELBバックエンドのドメイン名 TODO バックエンドのドメイン名をつけてください(証明済みドメイン)
  web_backend_alb_domain_name = ""

  // ELBフロントエンドのドメイン名 TODO バックエンドのドメイン名をつけてください(証明済みドメイン)
  web_frontend_alb_domain_name = ""

}
