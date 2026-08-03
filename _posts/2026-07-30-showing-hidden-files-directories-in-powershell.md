---
layout: post
title: Showing Hidden Files & Directories in PowerShell
date: 2026-07-30 09:29:14 +0300
categories:
    - PowerShell
---

Generally, when you list files in [PowerShell](https://learn.microsoft.com/en-us/powershell/), you get, by default, only the **non-hidden** files.

The same applies to **directories**.

For example, if you run `ls` in a directory, you will get something like this:

![listResults](../images/2026/07/listResults.png)

If you want to see the **hidden** folders, pass the `-h` argument

```bash
ls -h
```

![listHidden](../images/2026/07/listHidden.png)

We can see here from the `Mode` column that the `.git` folder is actually a **hidden** folder.

Happy hacking!
