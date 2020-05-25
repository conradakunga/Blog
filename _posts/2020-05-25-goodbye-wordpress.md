---
title: Goodbye Wordpress
date: 2020-05-25T10:40:26+30:00
author: Conrad Akunga
layout: post
categories:
  - Epiphanies
---
I have been running this blog on [WordPress](https://wordpress.org/) since inception, and using WordPress in general for many years (since 2005).

While uploading my last post I got a cryptic error and the effort aborted.

I tried several times before giving up.

At which point I realized that my content was at the mercy of somebody else's platform.

My words are stored in a database somewhere, mixed with markup and formatting that only WordPress can render correctly.

So I have just completed migrating from WordPress to [Jekyll](https://jekyllrb.com/), a static site generator.

This gives me a number of benefits
1. The content and its formatting is 100% controlled by me
2. The content and its rendering are different. So I can write my posts in markup without worrying about mixing concerns
3. Given the content and presentation are separate I can do interesting things like re-purpose the markdown content for other uses - perhaps on an intranet, or as a PDF
4. I don't have to worry about server software (runtimes, blog platform updates, etc) - all the server requires is a HTTP server
5. If WordPress is discontinued there is nothing to worry about. Markdown is just plain text
6. It is cheap to quickly publish and view the site as it will appear to end users.
7. WordPress gave me a lot of problems when it came to formatting source code. Jekykll handles that brilliantly
8. A Jekyll site is **FAST**
9. I always have my content with me
10. It is very easy to correct and update posts

Here's to the future.

Happy hacking!