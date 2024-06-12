# Working with themes

So now, we have a working site, but it's not exactly exciting visually.

However, one of the great things about Hugo is that we can concentrate on our content, 
and not have to manage it's visual aspect - but we can manage that through themes.
You can create your own theme, but there's also a catalog of themes already created at
https://themes.gohugo.io.

Let's grab a couple of themes and try switching between them to see how they change 
our site. In our bash session, let's make sure we're in the `hugo-blog` folder and run 
these commands 

```
git submodule add https://github.com/onweru/compose themes/compose
git submodule add https://github.com/coolapso/hugo-theme-hello-4s3ti themes/hello
git submodule add https://github.com/Vimux/Mainroad themes/mainroad
git submodule update
```

If we now edit the `hugo.toml` file, we can change the value in the `themes` field to
use the different themes, and if we have the local server running, you can see your
site change visually.

For some of these themes, they might add extra pages such as an `about-me` or `contact`. They
may also bring along additional functionality, or configuration options - look at the
theme documentation to find one that works for you.

Not only that, but some themes will bring new functionality such as image carousels, sidebars
and much more.

# Digging into a theme
Let's use the `mainroad` theme as an example - first make sure you edit your `hugo.toml` file and
change the theme to use `mainroad.

Let's start by adding a menu across the top of our pages. Add this text to the `hugo.toml`:

```
[menus]
  [[menu.main]]
    name = 'Home'
    pageRef = '/'
    weight = 10

  [[menu.main]]
    name = "Playground"
    weight = 20
    url = "https://devopsplayground.co.uk/"

  [[menu.main]]
    name = "About Me"
    weight = 30
    url = "/about-me/"  

```


The last item we added is pointing at a static page to show some content about us. Let's create
a page at `content/about-me/index.md`. You might see that this isn't under `content/posts` and so
it's treated as a static page.

In `content/about-me/index.md`, let's add this text:
```
+++
title = 'About Me'
date = 2024-05-16T10:00:01Z
draft = true
+++
This is my about me page
```

If we look at our page, we can see an `About Me` tab and we can access that.

Now let's add a custom logo. Let's grab a copy of the panda logo with this command
`wget -O static/logo.png https://avatars.githubusercontent.com/u/16601121?s=50`

Now we can modify our config to use the new logo by editing the `hugo.toml` file and adding
this text:

```
[Params.logo]
  image = "/logo.png"
  subtitle = "Just another site"
```

And if we view the site, we should see the new logo.

With `mainroad` we can also add a sidebar with widgets. Let's enable these to show on
the home page, and on our content pages. Add this text to the `hugo.toml`
file:

```
[Params.sidebar]
  home = "right"
  single = "right"
  widgets = ["recent", "social"]

[Params.widgets.social]
  # Enable parts of social widget
  facebook = "username"
  twitter = "username"
  instagram = "username"
  linkedin = "username"
  telegram = "username"
  github = "username"
  gitlab = "username"
  bitbucket = "username"
  email = "example@example.com"
```

---
Please proceed to [step_8](../step_8/README.md) where we'll look at deploying our site or
back to the main [README](../../README.md) file