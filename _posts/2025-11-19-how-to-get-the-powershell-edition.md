---
layout: post
title: How To Get The PowerShell Edition
date: 2025-11-19 20:42:17 +0300
categories:
    - PowerShell
---

Yesterday's post, "[How To Get The PowerShell Version]({% post_url 2025-11-18-how-to-get-the-powershell-version %})", discussed how to get the [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.5) **version** that you are running under.

In this post, we will look at a **simpler** challenge - how to get the **edition**.

As a reminder, there are two editions of PowerShell:

1. [PowerShell For Windows](https://learn.microsoft.com/en-us/powershell/scripting/what-is-windows-powershell?view=powershell-7.5) (version `5` and below)
2. [PowerShell Core](https://learn.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.5) (Version `6` and above, `7` being the current)

One way would be to ride on what we learned yesterday.

We can use this invocation:

```powershell
$PSVersionTable.PSVersion
```

From this, we can extract the property `MajorVersion`.

If it is `5`, then that is **PowerShell for Windows**.

If it is larger than `5`, then that is cross-platform **PowerShell Core**.

There is another, **simpler** way to obtain this information..

We can use the following invocation:

```powershell
$PSVersionTable.PSEdition
```

If we run it under **PowerShell for Windows**, we get the following result:

![PowerShellWindowsEdition](../images/2025/11/PowerShellWindowsEdition.png)

It returns a `string` value, `Desktop`

We can also run it under **PowerShell Core** on Windows.

![PowerShellCoreWindowsEdition](../images/2025/11/PowerShellCoreWindowsEdition.png)

It returns a string `value`, `Core`

On **macOS**, which can run **PowerShell Core**,  it returns the same:

![PowerShellmacOSEdition](../images/2025/11/PowerShellmacOSEdition.png)

### TLDR

**You can obtain the PowerShell edition from the `$PSVersionTable.PSEdition` invocation.**

Happy hacking!
