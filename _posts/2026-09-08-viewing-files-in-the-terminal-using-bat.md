---
layout: post
title: Viewing Files In The Terminal Using Bat
date: 2026-09-08 22:25:34 +0300
categories:
    - Tools
    - Terminal
---

**Viewing file contents** while in the terminal is something that you will probably do quite often.

And the goto for this is usually the [cat](https://www.akamai.com/cloud/guides/linux-cat-command) command.

For example in the terminal, if you wanted to view the **contents** of the file `docker-compose.yaml`, you would do it like this:

```bash
cat docker-compose.yaml
```

Which would yield the following:

![catDockerCompose](../images/2026/09/catDockerCompose.png)

A better tool for this is the cross-platform [bat](https://github.com/sharkdp/bat).

[Install](https://github.com/sharkdp/bat#installation) it using whichever option is appropriate. 

Once it is installed, it is a drop-in replacement for cat.

```bash
cat docker-compose.yaml
```

This will yield the following:

![batDockerCompose](../images/2026/09/batDockerCompose.png)

The differences are:

1. The viewer is **file-type aware** and can **colour** the contents appropriately
2. **Line numbers** are visible.

This is much easier to view and interact with.

### TLDR

**Use `bat`, a replacement for `cat`, for viewing files in the terminal.**

Happy hacking!
