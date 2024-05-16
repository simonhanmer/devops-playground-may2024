# Getting started with Hugo
Now we have our infrastructure ready and have somewhere to host a website, let's look at how
we can create our site.

We could of course, do it retro-style and hand-code our HTML, but that means knowing enough HTML to create something useful.
Alternatively, if you've ever worked with code in a Git repo, there's a good chance you've created a README file 
using [MarkDown](https://www.markdownguide.org/) which lets us create pages without having to remember how
to structure documents, and can concentrate on writing our content.

But before, we dig into the details, let's look at [Hugo](https://gohugo.io). Some big names use Hugo to host some of their 
sites such as:
* kubernetes.io
* docker.com
* Apache.org
* 1Password Support
* Let's Encrypt etc.

With Hugo, the content is created offline, converted to HTML and then uploaded to simple infrastructure. This means 
Hugo-based sites can run without the need for powerful servers, databases, loadbalancers, and so no need to maintain
all of those things. 

Since it's just HTML, it also tends to load very fast.

## Installing Hugo
Installing Hugo is fairly straightfoward, and it can run on Windows, OSX or Linux - more details can be found at 
the [installation page](https://gohugo.io/installation/).

For those using our workshop servers, to save time we've pre-installed hugo.


---
Please proceed to [step_6](../step_6/README.md) where we'll see Hugo in action or
back to the main [README](../../README.md) file