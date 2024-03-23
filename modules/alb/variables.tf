variable "system" {}
variable "env" {}
variable "vpc_id" {}
variable "subnet_ids" {}
variable "sg_id" {}
variable "backend_dns_name" {
  type = string
}

variable "frontend_dns_name" {
  type = string
}
