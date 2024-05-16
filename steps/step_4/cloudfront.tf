resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "oac for ${var.panda_name}"
  description                       = ""
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = "CDN for ${var.panda_name}"
  default_root_object = "index.html"

  aliases = [local.url]

  price_class = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.this.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id

    # custom_origin_config {
    #   http_port              = 80
    #   https_port             = 443
    #   origin_protocol_policy = "http-only"
    #   origin_ssl_protocols   = ["TLSv1.2"]
    # }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.this.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = aws_s3_bucket.this.bucket_regional_domain_name

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }

}


resource "aws_route53_record" "cloudfront_alias" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = local.url
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}