# Generating an SSL certificate to make our site secure

Now that we've created our terraform project, and deployed an S3 bucket we can use to store our site, 
we need to ensure that our site can use https which marks our site as secure in a browser.

To do this, we'll use Amazon Certificate Manager (ACM) to create a certificate for our domain. Not
only will ACM allow us to create and manage a certificate, even renewing automatically when needed, 
but it's also free!

## How does ACM verify our certificate.
Certificates are used to validate the identity of our side, and to ensure that the data we send and
receive is encrypted. ACM will verify that we own the domain we're requesting a certificate for.

Whilst it is possible to configure ACM to send an email to the domain owner, we're going to use DNS. ACM
does this by generating a CNAME record to the DNS zone for our domain.

With DNS verification, we have 3 scenarios to consider.

1. We have registered our domain name via Amazon Route 53. This is the easiest scenarion, as it will
create and configure a hosted zone for us in Route 53, and configure the name servers to point to that zone.

    Route53 Hosted zones are used to hold the DNS entries for a specific domain, and because all of this is
    handled inside Amazon, we can configure our certificate request to automatically validate itself via DNS.

2. We have registered our domain name via another registrar, but we want to use Route53 to manage our DNS. With
this approach, we will need to create a hosted zone in Route53, and update the name servers at our registrar to
point to the Route53 hosted zone. 

    Once, this is configured, as per option 1, we can automatically verify our certificate via DNS.
3. We have registered our domain name via another registrar, and we want to continue to manage our DNS there.
Unless you've chosen a DNS registrar that has a Terraform provider, we'll need to manually add the required
CNAME details to our DNS zone.

## Our approach
For simplicity, we're going to use option 1 - we've already registered our domain `devopsplayground.org` in Route53,
which created a hosted zone for us. We'll use this hosted zone to automatically verify our certificate.

## Creating a certificate in ACM
To create a certificate in ACM, we need to provide the url we want to secure. Create a file called `acm.tf` 
in your terraform folder, and add the following code:
```hcl
resource "aws_acm_certificate" "this" {
  domain_name       = local.url
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}
```
this code can be found in [acm.tf](./acm.tf).

This will return a terraform set containing the details of the certificate. We can use this to identify the 
CNAME record we need to add to our DNS zone as we'll see below.

When we deploy this code, it will create a certificate in ACM for our domain, and set the validation method to DNS. 
It will also return the name and value of the CNAME record we need to add to our DNS zone in a set using the attribute `domain_validation_options`.

## Identify the hosted zone
As mentioned above, we're using option 1, so our hosted zone is already created. But we'll need to know the host id, as
we'll need that when we want to create our DNS record for validation.

To do this, we'll query Route53 and find our hosted zone. To do this, add this code to the `acm.tf` file:
```hcl
data "aws_route53_zone" "this" {
  name = local.url
}
```

## Add the CNAME needed for verification
Finally, we need to add the CNAME record to our hosted zone. Add the following code to the `acm.tf` file:
```hcl
resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_type
  records = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_value
  ttl     = 60
}
```
It's worthwhile understanding the syntax above - we're using the `tolist` function to convert the set of validation
options from the certificate we created into a list. We then use the first item in the list to get the name, type and value
for the DNS entry we need to create.

However the records attribute in the route53 record resource expects a list, so we convert the value to a list.

---
Now, please proceed to [step 4](../step_4/README.md), or
back to the main [README](../../README.md) file