# Step 2 - starting to build our infrastructure

The first thing we need to use to host our website, is storage to hold the pages that we will be serving. In this step, we will create an S3 bucket to hold our website.

We'll suggest names you could use for each file, but since it's Terraform you could place it all in a single file, or use your own naming convention. Just remember,
Terraform expects your files to end with a `.tf`. Likewise, we suggest placing the files in a folder called `terraform`, but you can place them wherever you like.

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
  default     = "strange-panda"
}


# ----------------------------------------------------------------------------
# Locals below are used to create the URL for the application
locals {
  url = "${var.panda_name}.${var.domain}"
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
```
We'll provide a copy of each file in the appropriate step folder, in this case [providers.tf](./providers.tf). This file tells Terraform that we'll be
deploying to AWS, specifies our version and region preferences, and sets a default tag for all resources we create.

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


Next, we're going to setup some permissions around the bucket. Note that we'll tie these down shortly, but for now we'll just allow all access to the bucket:
```hcl
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

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
We're setting up a public access block to allow public access to the bucket. We're also setting up a bucket policy to allow anyone to read objects from the bucket.

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

## Deploying our terraform
We've now got our starting terraform files, so we can get ready to deploy them.

First, let's initialise our project - this will download the required providers, that will let Terraform deploy to AWS.
The command we will need is `terraform init`. For those who know Terraform, we're going to store our state file
locally, although in a real-world scenario you'd want to store this remotely.

The output should look something like this:

```
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 5.31"...
- Installing hashicorp/aws v5.48.0...
- Installed hashicorp/aws v5.48.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

:warning: If this or any following commands doesn't work, and you're in the live session, please ask for help. If you're doing this at home, please check the Terraform documentation.


Now that we've initialised our project, we can check our code is valid Terraform. We can do this by running `terraform validate`. This should output `Success! The configuration is valid`. 

Finally, we can deploy our infrastructure by running `terraform apply`. If you just run `terraform apply`, it is going to ask you to enter the name of your panda 
role - this is because while we have a variable for it, we haven't set a default value. You can either enter a name, or you can set a default value in your 
`variables.tf` file.
```hcl
panda_name = "your-panda-name"
```

When we run `terraform apply`, Terraform will show us a plan of what it's going to do. If you're happy with the plan, you can type `yes` and Terraform will deploy your infrastructure. As the end of the deployment, it will show us the outputs we defined in the `outputs.tf` file, specifically the website endpoint and the S3 bucket name.


## Create an example web page
Now that we've deployed our infrastructure, we can create a simple web page to test it. Create a file called `index.html` with the following content:
```html
<!DOCTYPE html>
<html>
  <head>
    <title>DevOps Playground</title>
  </head>
  <body>
    <h1>Welcome to the DevOps Playground</h1>
    <p>This is a test page for our DevOps Playground</p>
  </body>
</html>
  ```

  Let's copy that to our S3 bucket. We can do this by running the following command:
  `aws s3 cp index.html s3://your-panda-name-blog.devopsplayground.org/index.html`, replacing the s3 value with the value output by Terraform.

  You can now open the website endpoint listed in the outputs in your browser, and you should see the web page you just created.

---
Now, please proceed to [step 3](../step_3/README.md), or
back to the main [README](../../README.md) file