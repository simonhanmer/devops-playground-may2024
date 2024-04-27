# devops-playground-may2024

## Building and deploying a secure, highly available, low-cost blogging platform

Welcome to the DevOps Playground for May 2024!

This month we're going to be building a secure, highly available, low-cost blogging platform. We'll use Terraform to build the infrastructure in AWS. 

Then we'll show you how to use [Hugo](https://gohugo.io/) to create a static website, and deploy it to the infrastructure we've built.

Thank you to GlobalLogic UK&I for hosting the DevOps Playground, and to the AWS Community Builder program for providing a surprise we'll share at the end of the workshop.

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
    * A domain name
    * The following installed on your machine
        * A bash session (or your favourite command line that can handle the below)
        * Terraform
        * AWS CLI and configuration to allow authentication
        * Hugo - see the [Hugo website](https://gohugo.io/installation/) for installation instructions

         to have an AWS account and a domain name you can use for the workshop.
3. For those in the workshop, we'll also provide access to a shell session on a remote session which you can use to follow along. If you're following along later, you'll need to have the AWS CLI and terraform installed on your laptop.
4. We'll also use the remote shell to run Hugo - we've preinstalled that in the remote server, but if you're working on your own, follow the installation instructions on the Hugo website at 

Structure
---
1. Build infrastructure with Terraform
    1. S3 bucket for static website hosting
    1. ACM cert
    1. Cloudfront distribution
1. Hugo
    1. Download
    1. Run locally
    1. Structure
    1. Content
    1. Themes
    1. Build
    1. Sync to S3



Notes
---
https://gohugo.io/





Questions
---
* Should we try to do CI/CD - codecatalyst, github actions, etc.?
* Editor - vscode website (coder)
* Certs - should already exist, but good to include terraform for verification
* Can we run hugo locally and connect for development process