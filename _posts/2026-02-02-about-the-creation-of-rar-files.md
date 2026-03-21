---
layout: post
title: About the Creation of RAR Files
date: 2026-02-02 14:46:21 +0300
categories:
    - C#
    - .NET
    - Compression
---

Over the past series of posts, we have been looking at how to create and extract files of various archive types - [Zip](https://en.wikipedia.org/wiki/ZIP_(file_format)), [Gzip](https://en.wikipedia.org/wiki/Gzip), and [7z](https://en.wikipedia.org/wiki/7z), as well as a general method of creating archives of various types in the post "[Creating Other Archive Types Using 7-Zip Command Line In C# & .NET]({% post_url 2026-02-01-creating-other-archive-types-using-7-zip-command-line-in-c-net %})".

You may have noticed there haven't been any posts about **creating** [RAR](https://en.wikipedia.org/wiki/RAR_(file_format)) files, a format that was fairly popular for some time, succeeding the [Zip](https://en.wikipedia.org/wiki/ZIP_(file_format)) format.

The reason for this is as follows:

1. `RAR` is a **proprietary** format, fully **developed**, **owned**, and **controlled** by [Eugene Roshal](https://en.wikipedia.org/wiki/Eugene_Roshal) and [RAR Labs](https://www.rarlab.com/).
2. There are **no free tools for creating** RAR files (except for the Android version). All the tools available are [trial versions by RAR Labs](https://www.rarlab.com/download.htm)

Thus, it does not seem like a good investment to **produce** RAR files (unless you have **purchased** the software).

You can still **extract** `RAR` files, however, as outlined in [this post]({% post_url 2026-02-01-creating-other-archive-types-using-7-zip-command-line-in-c-net %}).

Happy hacking!
