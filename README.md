# devops-playground-may2024

## Building and deploying a secure, highly available, low-cost blogging platform

Welcome to the DevOps Playground for May 2024!

This month we're going to be building a secure, highly available, low-cost blogging platform. We'll use Terraform to build the infrastructure in AWS. 

![infrastructure diagram](/images/infra.png)

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




If you're joining us live, please proceed to [step 1a](./steps/step_1a/README.md), otherwise [step 1b](./steps/step_1b/README.md).

The workshop is split into three parts as below

* Setups

    1. [step_1a](./steps/step_1a/) - for those joining us live
    1. [step_1b](./steps/step_1b/) - for those trying this at their own pace
* Terraform

    3. [step_2](./steps/step_2/) - Create a Terraform project, and deploy storage for our site
    3. [step_3](./steps/step_3/) - Generating an SSL certificate to make our site secure
    3. [step_4](./steps/step_4/) - Create a CloudFront distribution to share our site with the world

* Hugo

    6. [step_5](./steps/step_5) - Getting started with Hugo
    6. [step_6](./steps/step_6) - Creating a site
    6. [step_7](./steps/step_7) - Creating our first pages
    6. [step_8](./steps/step_8) - Working with themes
    6. [step_9](./steps/step_9) - Bringing it all together



Each step contains a README.md file that will guide you through the process, along with the Terraform files you'll need to complete the step.
