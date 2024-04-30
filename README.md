# devops-playground-may2024

## Building and deploying a secure, highly available, low-cost blogging platform

Welcome to the DevOps Playground for May 2024!

This month we're going to be building a secure, highly available, low-cost blogging platform. We'll use Terraform to build the infrastructure in AWS. 

Then we'll show you how to use [Hugo](https://gohugo.io/) to create a static website, and deploy it to the infrastructure we've built.

Thanks to GlobalLogic UK&I for sponsoring the DevOps Playground, and to the AWS Community Builder program for providing a surprise we'll share at the end of the workshop.

Walking you through today's workshop is [Simon Hanmer](https://www.linkedin.com/in/simonhanmer/), a Senior Consultant at GlobalLogic UK&I. 

## Pre-requisites
1. Laptop with internet access
2. For those joining us live, we'll provide you with 
    * a Panda identity to use for the workshop.
    * a remote shell session with the following installed
        * Terraform
        * AWS CLI along with access to an AWS account
        * Hugo
4. If you're following along later, you'll need
    * An AWS account
    * A domain name, preferably with the DNS hosted in AWS Route 53.
    * The following installed on your machine
        * A bash session (or your favourite command line that can handle the below)
        * Terraform
        * AWS CLI and configuration to allow authentication
        * Hugo - see the [Hugo website](https://gohugo.io/installation/) for installation instructions




If you're joining us live, please proceed to [step 1a](./step_1a/README.md), otherwise [step 1b](./step_1b/README.md).