# Securing our Bucket

Technically, we now have all of the infrastructure configuration we need to deliver our website via
a custom domain. However, there is one more thing we should do to secure our S3 bucket - often a must
if you're working in a professional environment.

Currently we can bypass the CloudFront distribution and access the S3 bucket directly. This is not
ideal, as it means that we're not taking advantage of the security features that CloudFront provides.
To fix this, we're going to update the bucket policy to only allow access from the CloudFront
distribution.

Let's update our `s3.tf` file and modify the bucket policy to one that restricts access to the CloudFront
distribution:

Find this text in the `s3.tf` file:

```hcl
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.this]
}
```

and replace it with this:

```hcl
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
            "Service": "cloudfront.amazonaws.com"
        },
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.this.arn}/*",
        Condition = {
            "StringLike": {
                "AWS:SourceARN": aws_cloudfront_distribution.this.arn
            }
        }
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.this]
}
```

This policy allows the CloudFront distribution to access the bucket, but denies access to anyone else.

Finally, we want to remove the settings that made the S3 bucket public. Find this text in the `s3.tf` file:

```hcl
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
```

and change it to this:

```hcl
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

Next, we're going to change the CloudFront distribution to use Origin Access Control (OAC) to restrict
access to the S3 bucket. This will ensure that only the CloudFront distribution can access the bucket.

First, add this to the `cloudfront.tf` file to create the OAC identity:

```hcl
resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "oac for ${var.panda_name}"
  description                       = ""
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
```

Next find each occurence of `aws_s3_bucket_website_configuration.this.website_endpoint` and change it to `aws_s3_bucket.this.bucket_regional_domain_name`.

Then, remove or comment out these lines from the `cloudfront.tf` file:

```hcl
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
```

and finally tell CloudFront to use the OAC we created earlier by adding this to the `cloudfront.tf` file under the `origin_id` definition:

```hcl
    origin_access_identity = aws_cloudfront_origin_access_control.this.iam_arn
```

With these changes in place, only CloudFront can now access the S3 bucket.
