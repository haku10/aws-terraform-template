terraform {
  # バージョンを常に最新にする TODO ある程度開発が進んだら固定も考える
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.24.1"
    }
  }

  backend "s3" {
    bucket = "" // TODO ft.stateを管理するバケット名をいれる
    key    = "test/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

locals {
  system = "example"
  env    = "test"
}

module "network" {
  source   = "../../modules/vpc"
  system   = local.system
  env      = local.env
  cidr_vpc = "10.0.0.0/16"
  cidr_subnet_public = [
    # "10.0.1.0/24",
    # "10.0.2.0/24",
  ] // TODO 設定したいパブリックサブネットのCIDRを入れる
  cidr_subnet_private = [
    # "10.0.101.0/24",
    # "10.0.102.0/24",
  ] // TODO 設定したいプライベートサブネットのCIDRを入れる
}

module "sg" {
  source = "../../modules/securitygroup"
  system = local.system
  env    = local.env
  vpc_id = module.network.vpc_id
}

module "alb" {
  source                                 = "../../modules/alb"
  system                                 = local.system
  env                                    = local.env
  vpc_id                                 = module.network.vpc_id
  subnet_ids                             = module.network.public_subnet_ids
  sg_id                                  = module.sg.sg_backend_alb_id
  backend_dns_name                 = local.web_backend_alb_domain_name
  frontend_dns_name                = local.web_frontend_alb_domain_name
}

module "iam" {
  source = "../../modules/iam"
  system = local.system
  env    = local.env
}

module "ecr" {
  source = "../../modules/ecr"
  system = local.system
  env    = local.env
}

module "ecs" {
  source = "../../modules/ecs"
  system = local.system
  env    = local.env
}

module "hosting" {
  source = "../../modules/hosting"

  providers = {
    aws      = aws
    aws.east = aws.east
  }
  system = local.system
  env    = local.env

  acm_certificate_arn     = local.acm_certificate_arn
  cloudfront_domain_name  = local.cloudfront_domain_name
  backend_dns_name  = local.web_backend_alb_domain_name
  frontend_dns_name = local.web_frontend_alb_domain_name
}

module "rds" {
  source                        = "../../modules/rds"
  system                        = local.system
  env                           = local.env
  availability_zone             = local.vpc_az
  subnet_ids                    = module.network.private_subnet_ids
  security_group_id             = module.sg.sg_rds_id
  rds_cluster_settings          = local.rds_cluster_settings
  rds_cluster_instance_settings = local.rds_cluster_instance_settings
  rds_proxy_settings            = local.rds_proxy_settings
  depends_on                    = [module.alb]
}

module "ssm" {
  source      = "../../modules/ssm"
  system      = local.system
  env         = local.env
  db_username = module.rds.db_cluster_username
  db_password = module.rds.db_cluster_password
  db_endpoint = module.rds.db_cluster_endpoint
  db_port     = module.rds.db_instance_port
  db_dbname   = module.rds.db_instance_dbname

  depends_on = [module.rds]
}

module "bation" {
  source               = "../../modules/bation"
  system               = local.system
  env                  = local.env
  subnet_ids           = module.network.private_subnet_ids
  sg_id                = module.sg.sg_bastion_id
  iam_instance_profile = module.iam.bastion_iam_instance_profile_name
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"
  system = local.system
  env    = local.env
}

module "storage" {
  source = "../../modules/storage"
  system = local.system
  env    = local.env
}
