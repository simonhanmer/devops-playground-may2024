# Let's look at Hugo

## What is Hugo?
Hugo is a static site generator written in Go. It is optimized for speed, easy use, and flexibility. 
Hugo takes a directory with content and templates and renders them into a full HTML website.

While Hugo is a great tool for creating static websites, it is not the only one. Other popular static site 
generators include Jekyll, Gatsby, and Next.js.

# Installing Hugo
For this workshop, we've pre-installed Hugo to save some time - however installation is straightforward.
If you need to install this yourself, you can find instructions on the [Hugo website](https://gohugo.io/installation/).

# Getting Started
Firstly, let's use Hugo to create an initial configuration. To do this, run the following commands in the provided wetty
terminal:

```bash
$ cd
$ hugo new site hugo-blog
$ cd hugo-blog
$ git init
$ git submodule add https://github.com/Vimux/blank themes/blank
$ echo "theme = 'blank'" >> hugo.toml
```

Let's look at what we've done here.
1. make sure we're in our home folder
1. asked hugo to create a new, empty site for us in a folder called `hugo-blog`
1. changed into the new folder and initialised it as a git repository
1. Added a hugo theme called `blank` as a git sub-module
1. Told hugo to use the theme `blank` by default

When hugo created the site, it will have created a number of folders such as
* assets - this will be used to hold any static content we might want, such as css, or maybe a banner image.
* content - this is where our blog content will go. It will be sub-divided into posts, videos etc.
* layout - we can use this to modify how our content is viewed, any shortcuts we might want to add
* static - this is where our blog code will live as it's generated
* themes - a set of folders holding different visual themes - by default we've installed one called `blank`

### Let's create our first page

Making sure we're in the `hugo-blog` folder, run the command `hugo new content posts/my-first-post.md`. This will create the a dummy page called `my-first-post.md`, which we can see if we run the command `ls content/posts`.