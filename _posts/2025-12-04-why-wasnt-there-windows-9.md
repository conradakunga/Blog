---
layout: post
title: Why wasn't there Windows 9
date: 2025-12-04 10:22:52 +0300
categories:
    - Windows
---

The progression of [Microsoft Windows](https://en.wikipedia.org/wiki/Microsoft_Windows), at least the mainstream consumer version (i.e. NOT [Windows NT](https://en.wikipedia.org/wiki/Windows_NT)), is as follows:

- Windows 1.0
- Windows 2.0
- Windows 3.0
- Windows 3.1 / 3.11
- Windows 95
- Windows 98
- Windows ME
- Windows XP
- Windows Vista
- Windows 7
- Windows 8
- Windows 8.1
- Windows 10
- Windows 11

You will notice there is no Windows `9` after 8.1.

Ever wonder why?

***I don't work for Microsoft, nor have I ever asked anyone directly why, so this is my speculation!***

## To Make A Clean Break

A lot of experiments and risks were taken in Windows `8`. 

These included:

1. New UI design language.
2. Attempt to target tablets.
3. Attempt to use touch.
4. Many, many others.

History will ultimately tell if many of these were outright bad ideas or ideas ahead of their time.

What is definitely known is that the reception to users was mostly **negative**.

From a marketing and brand perspective, it might have been better to overtly break the link to the new operating system, such that it became clear that Windows `10` was completely different from Windows `8`.

## Legacy OS Checks

Legacy code would typically check the operating system like this:

```c#
if (version.StartsWith("Windows 9")) {
    // This is Windows 98 or Windos 95
}
```

This would break if there were, in fact, a Windows `9`.

Keep in mind that one of Windows' strengths is backward compatibility - the ability to run older software.

Such a change would, naturally, introduce many problems.

**Happy hacking!**
