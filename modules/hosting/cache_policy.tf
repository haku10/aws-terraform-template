resource "aws_cloudfront_cache_policy" "cache_policy" {
  name        = "${var.system}-${var.env}-cache-policy"
  comment     = "cache policy"
  default_ttl = 1
  max_ttl     = 1
  min_ttl     = 0
  # TODO キャッシュの中身についてはあとから修正する
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    enable_accept_encoding_gzip = true
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = [
          "Authorization",
          "Origin",
          "Access-Control-Request-Headers",
          "Access-Control-Request-Method",
        ]
      }
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "origin_request_policy" {
  name    = "${var.system}-${var.env}-origin-request-policy"
  comment = "request policy"
  cookies_config {
    cookie_behavior = "all"
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = [
        "Accept", 
        "Accept-Language",
        "Origin",
        "Access-Control-Request-Headers",
        "Access-Control-Request-Method",
        "CloudFront-Viewer-Address",
      ]
    }
  }
  query_strings_config {
    query_string_behavior = "all"
  }
}
