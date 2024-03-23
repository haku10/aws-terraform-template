locals {
  az_zone_names = var.availability_zone == "2az" ? ["ap-northeast-1a", "ap-northeast-1c"] : ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}