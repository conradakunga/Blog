---
layout: post
title: Temporarily Overriding An Alias In macOS, Linux & Unix
date: 2026-06-13 05:15:11 +0300
categories:
    - Terminal
    - Command Line
    - Tooling
    - Linux
    - Unix
    - macOS
---

In a previous post, "[Using Aliases To Improve Command Line Experience]({% post_url 2026-06-09-using-aliases-to-improve-command-line-experience %})", we looked at how to use [aliases](https://en.wikipedia.org/wiki/Alias_(command)) to **improve our command line workflow** and experience.

This **generally** works pretty well.

But there are times when you want to **temporarily** override your **alias**.

In our post, we aliased `ls` to `eza`, such that a default **file listing** yields this:

![lsAliasList](../images/2026/06/lsAliasList.png)

This is because my **alias** is set up as follows:

```bash
ls='eza -l --icons'
```

Suppose you wanted to **temporarily override this.**

You can achieve this by prefixing our alias with `command`.

```bash
command ls
```

![lsAliasOverride](../images/2026/06/lsAliasOverride.png)

Of course, this only works if the alias has a **pre-existing definition**.

### TLDR

**You can *temporarily* override an alias to an existing command definition by prefixing it with `command`.**

Happy hacking!
