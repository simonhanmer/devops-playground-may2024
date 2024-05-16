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
You can find this code in (cloudfront.tf)[./cloudfront.tf].

Let's walk through this CloudFront configuration.
1. First, we'll enabled the distribution, add a comment to make it clearer to identift and define the default root object that will be returned if a user requests the root of the site.
2. We'll add an alias to the distribution, which is the URL we want to use to access the site.
3. We'll set the price class to `PriceClass_100`, which is the cheapest option. Price Classes are used to define which AWS
regions will be used to cache informations. If a user is in a different geographic region, the CDN will fetch the content from the nearest region.
4. We'll define the origin of the distribution, which is the S3 bucket we created earlier. We'll set the origin protocol policy to `http-only`, which means that the CDN will only fetch content from the S3 bucket using HTTP.
5. We'll define the viewer certificate, which is the certificate we created in (step 3)[../step_3/README.md]. We'll set the SSL support method to `sni-only`, which means that the CDN will only support HTTPS using Server Name Indication (SNI).
6. We'll define the restrictions for the distribution. In this case, we're not restricting access to any geographic regions.
7. We'll define the default cache behavior for the distribution. We'll allow `GET`, `HEAD`, and `OPTIONS` methods, and we'll cache `GET` and `HEAD` methods. We'll set the viewer protocol policy to `redirect-to-https`, which means that the CDN will redirect users to HTTPS if they try to access the site using HTTP.

If we deployed this alone, we'd have a cloudfront distribution but it would be served from a URL in the `cloudfront.net` domain. However, we want to serve our site from our own domain, so we'll need to add a DNS record to point our domain to the CloudFront distribution.

Add the following to your `cloudfront.tf` file:
  
  ```hcl
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
```

This code creates a Route 53 record that points our domain to the CloudFront distribution. The `alias` block is used to create an alias record, which is a Route 53 feature that allows us to point a domain to a CloudFront distribution.



At this point, if we deploy our terraform, we'll have a CloudFront distribution that serves our site from our own domain - please be aware it might take a short while for the DNS to propagate, but you should be able to access your site via the domain you've defined. If you try to access via a `http` connection, you should be redirected to `https`.

Finally, let's add two entries to our `outputs.tf` file to output the website url, and the CloudFront distribution id as we'll need this later. Add these following lines:

```hcl

output "website_url" {
  value = "https://${local.url}"
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.this.id
}

```hcl

---
If you want to secure our S3 bucket, please proceed to [step 5](../step_5/README.md), 
head to [step_6](../step_6/README.md) to start learning about Hugo or
back to the main [README](../../README.md) file