output "bucket_website_endpoint" {
  value = "http://${aws_s3_bucket.this.bucket_regional_domain_name}"
}

output "bucket_s3_name" {
  value = "s3://${aws_s3_bucket.this.bucket}"
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.this.id
}