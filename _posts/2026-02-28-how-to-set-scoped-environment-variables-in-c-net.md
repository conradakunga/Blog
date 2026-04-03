---
layout: post
title: How To Set Scoped Environment Variables In C# & .NET
date: 2026-02-28 21:53:22 +0300
categories:
    - C#
    - .NET
---

In a previous post, "[How To Read Environment Variables In C# & .NET]({% post_url 2026-02-25-how-to-read-environment-variables-in-c-net %})", we looked at how to **read** [environment variables](https://en.wikipedia.org/wiki/Environment_variable) in C# & .NET.

In a subsequent post, "[About Environment Variable Scopes]({% post_url 2026-02-26-about-environment-variable-scopes %})", we learned that environment variables are **scoped**.

In this post, we will look at how to **write** or **set** environment variables in C#.

## Process Scoped Variables

To set process-scoped variables, we use the [SetEnvironmentVariable](https://learn.microsoft.com/en-us/dotnet/api/system.environment.setenvironmentvariable?view=net-10.0) method of the [Environment](https://learn.microsoft.com/en-us/dotnet/api/system.environment?view=net-10.0) `class`, specifying the scope via the [EnvironmentVariableTarget](https://learn.microsoft.com/en-us/dotnet/api/system.environmentvariabletarget?view=net-10.0) `enum`.

```c#
Environment.SetEnvironmentVariable("Mood", "Happy", EnvironmentVariableTarget.Process);
```

This particular method works across operating systems - macOS, Windows, and Linux.

## User Scoped Variables

To set **user-scoped** variables, pass the [EnvironmentVariableTarget.User](https://learn.microsoft.com/en-us/dotnet/api/system.environmentvariabletarget?view=net-10.0) [enum](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/enum). It is important to note that this only works in Windows, as this information is stored in the [Windows registry](https://learn.microsoft.com/en-us/troubleshoot/windows-server/performance/windows-registry-advanced-users).

```c#
Environment.SetEnvironmentVariable("Mood", "Happy", EnvironmentVariableTarget.User);
```

## Machine Scoped Variables.

To set **machine-scoped** variables, pass the [EnvironmentVariableTarget.Machine](https://learn.microsoft.com/en-us/dotnet/api/system.environmentvariabletarget?view=net-10.0) [enum](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/enum). It is important to note that this only works in Windows, as this information is stored in the [Windows registry](https://learn.microsoft.com/en-us/troubleshoot/windows-server/performance/windows-registry-advanced-users).

Additionally, the process setting this variable must be **elevated**, as setting a **machine-level** environment variable requires **administrative** access.

```c#
Environment.SetEnvironmentVariable("Mood", "Happy", EnvironmentVariableTarget.Machine);
```

### TLDR

**The `SetEnvironmentVariable()` method has an overload that allows specification of the scope.**

Happy hacking! 
