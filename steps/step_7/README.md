# Let's create our first page

Making sure we're in the `hugo-blog` folder, run the command `hugo new content posts/my-first-post.md`. 
This will create the a dummy page called `my-first-post.md`, which we can see if we run the command `ls content/posts`.

Rather than expecting people to understand HTML, hugo relies on pages being written in 
[Markdown](https://www.markdownguide.org/). If you're written documentation for a modern repository, 
there's a good change you've already used Markdown, and even the README's for this workshop are written using Markdown.

As an example of how Markdown, here's some of the formatting codes you can use

| Format&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Description
|--|--|
|\# text | heading level 1
| \#\# text | heading level 2
| \#\#\# text | heading level 3
| \*test\* | italic (*note that you can't have a space between the asterisks and the text*)
| \*\*test\*\* | bold
| \*\*\*test\*\*\* | bold and italic
| \`text\` | inline code
|\`\`\`<br />``` | code block - you can also add a language type after the first \`\`\` to add syntax 
highlighting (see [here](https://gohugo.io/content-management/syntax-highlighting/) for a list of supported languages)
| \> | blockquote
| \[text](link) | hyperlink

There's a number of cheatsheats for Markdown, such as https://www.markdownguide.org/cheat-sheet/.

## Editing the page
If you open the page we've created in an editor (those in the live session can use 
the provided coder session), you should see a page that looks like:

```
+++
title = 'My First Post'
date = 2024-05-16T10:00:01Z
draft = true
+++
```
This section is known as `front matter` and is used to describe the page and how it will appear 
on the site. A standard set of options is available at https://gohugo.io/content-management/front-matter/, 
and these can be augmented depending on the theme in use.

Let's add some additional Markdown text below the bottom set of pluses; you 
can use your own, or here's some example text:

```
# This is my first page
Hello world, this is my first [Hugo](https://gohugo.io) page.

```

## Running Hugo as a local server
Hugo can provide a local server which allows you to review content as you're working on it - for a full
list of the options, run `hugo server -h`.

For now, let's start the server - if you're running the workshop independently, you could use `hugo server`,
but since we're in a hosted environment, we need a few more options, so use 
`hugo server --bind '0.0.0.0' --baseURL 'http://panda-simon.devopsplayground.org'`, remembering to update
the url with your personal panda name. This tells hugo to share content on a public ip via our hosted environment
url. This will output something similar to 
```
Watching for changes in /home/playground/workdir/hugo-blog/{archetypes,assets,content,data,i18n,layouts,static,themes}
Watching for config changes in /home/playground/workdir/hugo-blog/hugo.toml
Start building sites … 
hugo v0.125.4-cc3574ef4f41fccbe88d9443ed066eb10867ada2+extended linux/amd64 BuildDate=2024-04-25T13:27:26Z VendorInfo=gohugoio


                   | EN  
-------------------+-----
  Pages            |  9  
  Paginator pages  |  0  
  Non-page files   |  0  
  Static files     |  1  
  Processed images |  0  
  Aliases          |  4  
  Cleaned          |  0  

Built in 30 ms
Environment: "development"
Serving pages from disk
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at http://panda-simon.devopsplayground.org:1313/ (bind address 0.0.0.0) 
Press Ctrl+C to stop
```

If you edit your first page `content/posts//my-first-post.md` and save it, you should see something
similar to 
```
Change detected, rebuilding site (#1).
2024-05-16 10:33:29.501 +0000
Source changed /posts/my-first-post.md
Web Server is available at http://panda-simon.devopsplayground.org:1313/ (bind address 0.0.0.0)
Total in 0 ms
```
This is because the server monitors the files for changes and shares the latest version.

If you now visit either `http://localhost:1313`, or `http://panda-simon.devopsplayground.org:1313`

When you do this, you should see something like 

![screenshot](/images/sshot_08_01.png)

You should notice that there's no reference to the page you created here. That's because if you
look at the front matter in the page, there is a flag `draft = true`. This allows us to work
on content and not worry about accidentally deploying it; to see it, stop the `hugo server` command
and add a `-D` flag to show draft posts. If you now visit the local URL, you should see something
similar to:

![screenshot](/images/sshot_08_02.png)

and we can click on the title of the link to see the page.

![screenshot](/images/sshot_08_03.png)

---
Please proceed to [step_8](../step_8/README.md) where we'll look at themes or
back to the main [README](../../README.md) file