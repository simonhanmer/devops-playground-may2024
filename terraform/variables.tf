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
