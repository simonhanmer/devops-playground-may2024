# Getting Started
Firstly, let's use Hugo to create an initial configuration. To do this, run the following commands in the provided wetty
terminal(if you're using our infrastructure, we suggest you do this in the `workdir` folder):

```bash
$ hugo new site hugo-blog
$ cd hugo-blog
$ git init
$ git submodule add https://github.com/Vimux/blank themes/blank
$ echo "theme = 'blank'" >> hugo.toml
$ echo 'uglyURLs = true' >> hugo.toml
```

Let's look at what we've done here.
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

---
Please proceed to [step_6](../step_6/README.md) where we'll create our first page or
back to the main [README](../../README.md) file

