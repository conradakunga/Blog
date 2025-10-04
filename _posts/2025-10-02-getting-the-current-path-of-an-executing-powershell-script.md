---
layout: post
title: Getting The Current Path Of An Executing PowerShell Script
date: 2025-10-02 10:26:20 +0300
categories:
    - PowerShell
    -.NET
---

[PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.5) is an excellent, [cross-platform](https://en.wikipedia.org/wiki/Cross-platform_software) scripting solution that you can use to automate various tasks in Windows, Linux, and Unix environments. The fact that it has full access to the entire .[NET ecosystem](https://dotnet.microsoft.com/en-us/) is the icing on the cake.

I use it for a bunch of quick scripts and utilities across the various devices I work on.

Recently, from **within a script**, I needed to know the exact location from which the script was running.

Before going any further, I need to point out a few things

1. There are multiple versions of `PowerShell`
    1. The original (`Windows PowerShell`), v1.0 to 5.1
    2. The successor (cross-platform) `PowerShell`, v7 - 7.6
2. `Windows PowerShell` is installed by default with Windows.
3. You **cannot assume PowerShell 7 is installed**, given that it is not installed by default.

Therefore, if you have no visibility or control of the target machine, you cannot assume the presence of `PowerShell 7`.

My scenario is the latter - I have no control or visibility of the target machine under which the script will be run.

With that out of the way, the way to get the path of the current script is to use the [MyInvocation](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables?view=powershell-7.5#myinvocation) automatic variable.

This returns an [InvocationInfo](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.invocationinfo?view=powershellsdk-1.1.0) object class, and the property we are interested in is [MyCommand](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.invocationinfo.mycommand?view=powershellsdk-1.1.0#system-management-automation-invocationinfo-mycommand), which is an object of type [CommandInfo](https://learn.microsoft.com/en-us/dotnet/api/system.management.automation.commandinfo?view=powershellsdk-1.1.0)

From this, we can retrieve the `Path` property.

```powershell
# Get the current path
$currentPath = $MyInvocation.MyCommand.Path
# Write the path to console
Write-Host $currentPath
```

This will print something like this (depending on where you saved it):

```plaintext
C:\Projects\PowerShell\Test.ps1
```

If you need just the **parent** folder, you need to do a bit more work.

You will need to use the [Split-Path](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/split-path?view=powershell-7.5) [cmdLet](https://learn.microsoft.com/en-us/powershell/scripting/powershell-commands?view=powershell-7.5) to extract what you need, passing it the `-Parent` parameter.

```powershell
$currentPath = (Split-Path -Parent $MyInvocation.MyCommand.Path)
```

This will print the following:

```plaintext
C:\Projects\PowerShell\
```

**NOTE: You have to save the script file for this to work; otherwise, the `Path` parameter will be `null`.**

### TLDR

**You can use the `MyInvocation` automatic variable to get information about the currently running script.**

Happy hacking!
