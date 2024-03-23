provider "aws" {
  // リージョンの指定
  region = "ap-northeast-1"
}

module "s3" {
  source = "../../s3"
  system = "example"
  env    = "stg"
}
