---
layout: post
title: How To Set Scoped Environment Variables In PowerShell
date: 2026-02-27 17:07:04 +0300
categories:
    - PowerShell
---

In a previous post, "[How To Read Environment Variables In PowerShell]({% post_url 2026-02-24-how-to-read-environment-variables-in-powershell %})", we looked at how to **read** [environment variables](https://en.wikipedia.org/wiki/Environment_variable) in [PowerShell](https://learn.microsoft.com/en-us/powershell/).

In a subsequent post, "[About Environment Variable Scopes]({% post_url 2026-02-26-about-environment-variable-scopes %})", we learned that environment variables are **scoped**.

In this post, we will look at how to **write** or **set** environment variables in [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-overview?view=powershell-7.6).

## Process Scoped Variables

To set process-scoped variables, there are three ways:

The first is to use the `$env` variable.

```powershell
$env:Mood = "Happy"
```

The next method is to use the [set-item](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.management/set-item?view=powershell-7.6) [cmdlet](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/cmdlet-overview?view=powershell-7.6).

```powershell
Set-Item -Path Env:Mood -Value "Happy"
```

The last method is to invoke the static .NET methods.

```powershell
[Environment]::SetEnvironmentVariable('Mode', 'Happy')
```

## User Scoped Variables

Setting **user-scoped** environment variables depends on your operating system.

For windows you invoke the .NET Environment object and set your scope to "**User**"

```powershell
[Environment]::SetEnvironmentVariable("Mood", "Sad", "User")
```

For macOS & Unix, there is **no direct equivalent**.

### Machine Scoped Variables

## User Scoped Variables

Setting **machine-scoped** environment variables depends on your operating system.

For windows you invoke the .NET Environment object and set your scope to "**Machine**".

```powershell
[Environment]::SetEnvironmentVariable("Mood", "Sad", "Machine")
```

For this to work, you must invoke it from an [elevated terminal](https://learn.microsoft.com/en-us/windows/terminal/faq) with **administrative** rights.

For macOS & Unix, there is **no direct equivalent**.

The closest is to [export](https://phoenixnap.com/kb/bash-export-variable) the variables like this:

```bash
export Mood=Crying
```

To have them persist across restarts, append this to your `$profile` (depending in your shell)

Happy hacking!
