variable "aws_region" {
  type        = string
  description = "The AWS region to deploy to"
  default     = "eu-west-2"
}


variable "create_hosted_zone" {
  type        = bool
  description = "Whether to create a hosted zone for the domain"
  default     = false
}


variable "domain" {
  type        = string
  description = "The domain name to use for the application"
  default     = "devopsplayground.co.uk"
}


variable "panda_name" {
  type        = string
  description = "The name of your panda"
}


# ----------------------------------------------------------------------------
# Locals below are used to create the URL for the application
locals {
  url       = "${var.panda_name}.${var.domain}"
}

data "aws_route53_zone" "this" {
  name = "${var.domain}."
}