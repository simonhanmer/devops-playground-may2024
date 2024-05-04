# Step 2 - starting to build our infrastructure

The first thing we need to use to host our website, is storage to hold the pages that we will be serving. In this step, we will create an S3 bucket to hold our website.

We'll suggest names you could use for each file, but since it's Terraform you could place it all in a single file, or use your own naming convention. Just remember,
Terraform expects your files to end with a `.tf`. Likewise, we suggest placing the files in a folder called `terraform`, but you can place them wherever you like.

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
Next, we need to create a file to hold our S3 bucket. We'll call this file `s3.tf`. This file will contain the following:
```hcl
```

```hcl

---
Now, please proceed to [step 3](../step3/README.md), or
Back to the main [README](../../README.md) file