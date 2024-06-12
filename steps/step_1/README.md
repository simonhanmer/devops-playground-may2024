# Step 2 - starting to build our infrastructure

The first thing we need to use to host our website, is storage to hold the pages that we will be serving. In this step, we will create an S3 bucket to hold our website.

We'll suggest names you could use for each file, but since it's Terraform you could place it all in a single file, or use your own naming convention. Just remember,
Terraform expects your files to end with a `.tf`. Likewise, we suggest placing the files in a folder called `terraform`; if you're using the live
workshop infrastructure do this in the workdir folder, but you can place them wherever you like.

## Create a variables file
We'll start by creating a file to hold our variables. We'll call this file `variables.tf`. This file will contain the following:

```hcl
variable "aws_region" {
  type        = string
  description = "The AWS region to deploy to"
  default     = "eu-west-2"
}


variable "domain" {
  type        = string
  description = "The domain name to use for the application"
  default     = "devopsplayground.org"
}


variable "panda_name" {
  type        = string
  description = "The name of your panda"
}


# ----------------------------------------------------------------------------
# Locals below are used to create the URL for the application
locals {
  url = "${var.panda_name}-blog.${var.domain}"
}

```
We'll provide a copy of each file in the appropriate step folder, in this case [variables.tf](./variables.tf). This file tells Terraform about some values that
we'll be using in our infrastructure. We've defined the region we'll be deploying to, the domain name we'll be using, and the name of our panda. We've also
defined a local variable to build the URL of our application based on the domain and panda name.


## Create a provider file
We need to tell Terraform that we're going to be deploying to AWS. We do this by creating a provider file -- `providers.tf`. This file will contain the following:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31"
    }
  }

  required_version = "~> 1.2"
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      project = "devops-playground-may-2024"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      project = "devops-playground-may-2024"
    }
  }

  alias = "us-east-1"
}

```
We'll provide a copy of each file in the appropriate step folder, in this case [providers.tf](./providers.tf). This file tells Terraform that we'll be
deploying to AWS, specifies our version and region preferences, and sets a default tag for all resources we create. We'll also need to deploy to
an additional region in a later step, so we've created an alias to allow us to do that.

## Create a bucket file
Next, we need to create a file to hold our S3 bucket. We'll call this file `s3.tf`. First, let's create the bucket:
```hcl
resource "aws_s3_bucket" "this" {
  bucket        = local.url
  force_destroy = true
}
```
We're going to set the bucket name to the URL of our application. We're also setting `force_destroy` to `true`. This means that Terraform will allow us to
destroy the bucket even if it's not empty. This is useful for our purposes, but be careful when using this in production.


Next, we're going to setup some permissions around the bucket. We'll use these to ensure our bucket is secure:
```hcl
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

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
      }
    ]
  })
  depends_on = [aws_s3_bucket_public_access_block.this]
}
```

Finallly, let's tell AWS that we want this to be a website bucket:
```hcl
resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

```
You can find a copy of this file in the appropriate step folder, in this case [s3.tf](./s3.tf).

## Outputting some configuration
To make it easier to see what's going on, we're going to output some information about our infrastructure. We'll create a file called `outputs.tf` to hold this information:
```hcl
output "bucket_website_endpoint" {
  value = "http://${aws_s3_bucket_website_configuration.this.website_endpoint}"
}

output "bucket_s3_name" {
  value = "s3://${aws_s3_bucket.this.bucket}"
}
```
This file will output the website endpoint and the S3 bucket name.

---
Now, please proceed to [step 3](../step_3/README.md), or
back to the main [README](../../README.md) file
