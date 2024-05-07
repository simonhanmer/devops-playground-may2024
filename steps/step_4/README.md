# Delivering our website via a Content Delivery Network (CDN)

So far, we've setup an S3 bucket ready to host our content, and a certificate to secure the site. 
Now we're going to add a CloudFront distribution to deliver our content via a Content Delivery Network (CDN).
Using a CDN has several advantages:

1. **Speed** - CDNs cache content at edge locations around the world, so users get content from a location closer to them.
2. **Security** - If we were using a server to host our site, CDNs can provide DDoS protection, and can help protect against other attacks. 
In our scenario, we'll use the CDN to provide HTTPS, which is more secure than HTTP.
3. **Cost** - CDNs can cache our content, which means that not all requests go to our S3 bucket, which can reduce costs.

## Create a CloudFront distribution
Let's get started creating a CloudFront distribution to deliver our content. We'll create a file called `cloudfront.tf` to hold the configuration:

```hcl
resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = "CDN for ${var.panda_name}"
  default_root_object = "index.html"

  aliases = [local.url]

  price_class = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket_website_configuration.this.website_endpoint
    origin_id   = aws_s3_bucket_website_configuration.this.website_endpoint

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
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
    target_origin_id       = aws_s3_bucket_website_configuration.this.website_endpoint

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }

}
    ```

---
Now, please proceed to [step 5](../step_5/README.md), or
back to the main [README](../../README.md) file