---
layout: post
title: You Cannot Search For Bullet Numbers In Chrome & Edge
date: 2026-05-27 06:59:49 +0300
categories:
    - Chrome
    - Edge
    - HTML
    - Firefox
---

The archives for this blog look like this:

![blogArchives](../images/2026/05/blogArchives.png)

You can see that **every wee**k the blog entries are numbered from `1` to 7, in [Roman numerals](https://en.wikipedia.org/wiki/Roman_numerals).

This is actually an [ordered list](https://www.w3schools.com/hTml/html_lists_ordered.asp) , as you can tell from the source.

![numericList](../images/2026/05/numericList.png)

The blog itself is generated using [Jekyll](https://jekyllrb.com/), and the **source code** and **posts** of this blog, as a reminder, is available [here](https://github.com/conradakunga/Blog).

I wanted to check whether I had ever accidentally posted **more** than `7` times in a week.

A quick way to do so is to search for the text `viii`.

![searchBlogInit](../images/2026/05/searchBlogInit.png)

This found **nothing**, to my satisfaction.

But, on a whim, I searched for what **I know exists** - `vii`.

**This still found nothing!**

![searchNotFound](../images/2026/05/searchNotFound.png)

Which, technically, is **accurate** - that `viii` text **does not actually exist on the page** and, it is the **browser responsible** for **computing** and **presenting** it.

The same happens for [Safari](https://www.apple.com/safari/), [Microsoft Edge](https://www.microsoft.com/en-us/edge), as well as [Vivaldi](https://vivaldi.com/).

As far as I can tell, all [Chromium](https://www.chromium.org/) based browsers probably have this **issue**.

[Firefox](https://www.firefox.com/en-US/), however, does not!

![firefoxBulletSearch](../images/2026/05/firefoxBulletSearch.png)

### TLDR

**You cannot search for bullet numbers on *Chrome*, *Edge*, *Safari* and most *Chromium* based browsers. However, you can on *Firefox*.**

Happy hacking!
