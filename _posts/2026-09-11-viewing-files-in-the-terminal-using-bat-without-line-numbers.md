---
layout: post
title: Viewing Files In The Terminal Using Bat Without Line Numbers
date: 2026-09-11 12:11:54 +0300
categories:
    - Tools
    - Terminal
---

In a previous post, "[Viewing Files In The Terminal Using Bat]({% post_url 2026-09-08-viewing-files-in-the-terminal-using-bat %})", we looked at how to **view files** in the **terminal** using the utility [bat](https://github.com/sharkdp/bat), the **better** alternative to the [cat](https://www.akamai.com/docs/guides/linux-cat-command/) utility.

A sample file, `docker-compose.yaml`, looks like this:

![batDockerCompose](../images/2026/09/batDockerComposeDefault.png)

However, that colour coded view, with **line numbers**, can sometimes be **problematic** if you need to **copy** and **paste** from this view.

The solution to this is the `-p` parameter.

```bash
bat docker-compose.yaml -p
```

This presents the file without these **artifacts**:

![batComposeArtifacts](../images/2026/09/batComposeArtifacts.png)

It therefore now looks like this:

![batDockerComposePlain](../images/2026/09/batDockerComposePlain.png)

Here, we have the benefit that the display is colour coded but you can now freely copy the text.

### TLDR

The `bat` parameter `-p` allows you to view files without artifacts.
