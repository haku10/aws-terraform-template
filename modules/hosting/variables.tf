variable "system" {}
variable "env" {}

variable "backend_dns_name" {
  type = string
}

variable "frontend_dns_name" {
  type = string
}

variable "cloudfront_domain_name" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}
