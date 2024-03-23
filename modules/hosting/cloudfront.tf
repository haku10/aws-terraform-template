####################################################
# Distributions
####################################################
data "aws_cloudfront_response_headers_policy" "security_headers_policy" {
  name = "Managed-SecurityHeadersPolicy"
}

// 管理画面
resource "aws_cloudfront_distribution" "app_cloudfront" {
  aliases = [var.cloudfront_domain_name]
  enabled = true
  origin {
    # フロントエンド(ALBとの連携)
    domain_name = var.frontend_dns_name
    origin_id   = "web-front"
    origin_path = ""
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "match-viewer"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }

  origin {
    # バックエンド(ALBとの連携)
    domain_name = var.backend_dns_name
    origin_id   = "api-origin"
    origin_path = ""
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
    # TODO ALBのアクセスを制限する際に有効化する
    # custom_header {
    #   name  = "x-origin-key"
    #   value = jsondecode(data.aws_secretsmanager_secret_version.x_origin_key.secret_string)["X_ORIGIN_KEY"]
    # }
  }

  viewer_certificate {
    //案件ごとに修正ください
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.acm_certificate_arn
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  # フロントのキャッシュ戦略
  default_cache_behavior {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods             = ["GET", "HEAD"]
    target_origin_id           = "web-front"
    cache_policy_id            = aws_cloudfront_cache_policy.cache_policy.id
    origin_request_policy_id   = aws_cloudfront_origin_request_policy.origin_request_policy.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security_headers_policy.id

    viewer_protocol_policy = "https-only"
  }

  # backendのキャッシュ戦略
  ordered_cache_behavior {
    path_pattern               = "/exmaple/*" // TODO APIパスのプレフィックスなどを指定する
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods             = ["GET", "HEAD"]
    target_origin_id           = "api-origin"
    cache_policy_id            = aws_cloudfront_cache_policy.cache_policy.id
    origin_request_policy_id   = aws_cloudfront_origin_request_policy.origin_request_policy.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.security_headers_policy.id

    viewer_protocol_policy = "https-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}

