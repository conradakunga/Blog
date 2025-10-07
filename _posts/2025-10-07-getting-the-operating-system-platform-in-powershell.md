---
layout: post
title: Getting the Operating System Platform in PowerShell
date: 2025-10-07 23:18:55 +0300
categories:
    - PowerShell
---

A [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.5) script I am working on requires **different behavior across operating system platforms**.

Which is to say:

- Windows
- Unix

For this, we turn to the static property [OSVersion](https://learn.microsoft.com/en-us/dotnet/api/system.environment.osversion?view=net-9.0) of the [Environment](https://learn.microsoft.com/en-us/dotnet/api/system.environment?view=net-9.0) object, where we retrieve the [Platform](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.platform?view=net-9.0) property

The script will look like this:

```powershell
$platform = [System.Environment]::OSVersion.Platform 
```

This will return the following across 3 operating systems.

| Operating System   | Value   |
| ------------------ | ------- |
| Windows 11         | Win32NT |
| macOS 15 (Sequoia) | Unix    |
| Ubuntu 24.04       | Unix    |

Of interest is that Ubuntu, a [Linux](https://en.wikipedia.org/wiki/Linux) distribution, reports [Unix](https://en.wikipedia.org/wiki/Unix).

We'll look into why that is the case in the next post.

### TLDR

**`PowerShell` can use the `Environment` object to retrieve the OS `Platform`.**

Happy hacking!
