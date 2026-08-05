---
layout: post
title: Creating Multiple Nested Directories In The Terminal
date: 2026-08-04 21:24:07 +0300
categories:
    - Terminal
    - Bash	
    - PowerShell
---

In our previous post, "[Creating Multiple Directories In The Terminal]({% post_url 2026-08-03-creating-multiple-directories-in-the-terminal %})", we looked at how to **create multiple directories** in the terminal in **one command**.

But what if we have a more **exotic** requirement?

We want to create this structure:

![tree](../images/2026/08/tree.png)

This is `3` directories, each with a **child** directory.

- One
    - Two
- Three
    - Four
- Five
    - Six

Doing this the **hard way** would require a lot of **command-line kung fu** - `mkdir`, `cd`, `mkdir`, `cd ..`

Mercifully, it is possible to create this structure in a **single** `mkdir` command using the [-p](https://linux.die.net/man/1/mkdir) flag, which **creates parents as needed**.

We can thus run the following command:

```bash
mkdir -p one/two three/four five/six
```

If you are wondering how I got the **tree** displayed above, that is courtesy of [eza](https://eza.rocks/).

The actual command is:

```c#
eza -T
```

![ezaTree](../images/2026/08/ezaTree.png)

### TLDR

**You can create nested directories using the `mkdir` command with the `-p` flag.**

Happy hacking!
