# Bringing it all together
Up to this point, we've been looking at using Hugo locally. But we've built
out our infrastructure so let's look at how we can generate our site and upload
it so it's visible to everyone.

To generate our site, rather than running `hugo server`, we can run `hugo`
and that will generate a static version of our site in the `public` folder.

With this content generated, we can copy it to the S3 bucket we created earlier. First,
let's remind ourselves of the outputs from the terraform we ran. We can do this by
running the command `terraform output` in the folder where we deployed terraform. In my
case, this looks something like:

```
bucket_s3_name = "s3://funny-panda-blog.devopsplayground.org"
bucket_website_endpoint = "http://funny-panda-blog.devopsplayground.org.s3.eu-west-2.amazonaws.com"
cloudfront_distribution_id = "E2JDXT7NL7E5Q7"
website_url = "https://funny-panda-blog.devopsplayground.org"
```

We want to copy all of the content from our `public` folder to the s3 bucket shown in `bucket_s3_name`
output parameter. To do this, we need to run the command `aws s3 sync public s3://funny-panda-blog.devopsplayground.org`.

However, when we do this, we should see something like

![Screenshot](/images/sshot_10_01.png) with the message
> You don't have any posts yet

This is because, as you might remember, the pages we created so far all had a variable in the
respective frontmatter `draft = true`. We need to remove this on the pages we've created and
re-generate the contents, then copy this to the s3 bucket again.

## Cloudfront Caching
As we mentioned earlier, CloudFront can perform caching on content. This might mean that
when you make a change to content and upload it, the change might not appear.

If this occurs, we can clear the cache by checking the outputs from terraform, that
include a distribution id for CloudFront. We can then use that to clear the cache by
running the command `aws cloudfront create-invalidation --distribution-id _dist_id_ --paths '/*'`,
replacing `_dist_id_` with the value from the terraform outputs.
