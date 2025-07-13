---
layout: post
title: Determining If A Running Process Is 64 Bit In .NET
date: 2025-08-13 13:25:55 +0300
categories:
    - C#
    - .NET
---

Recently, from within an application, I needed to [shell](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process.start?view=net-9.0) into a process. The challenge was that this process was **different** depending on whether it was being run started a [32 bit or a 64 bit environment](https://learn.microsoft.com/en-us/answers/questions/1610861/whats-the-difference-between-32-bit-and-64-bit).

In other words, in a `32` bit environment I needed to start `process32.exe` and from a `64` bit environment, I needed to start `process64.exe`.

There are a couple of solutions to this:

## Check If The Operating System Is 64 Bit

In this approach, we check if the operating system itself is **64-bit** using the [Is64BitOperatingSystem](https://learn.microsoft.com/en-us/dotnet/api/system.environment.is64bitoperatingsystem?view=net-9.0) property of the [Environment](https://learn.microsoft.com/en-us/dotnet/api/system.environment?view=net-9.0) class.

```c#
if (Environment.Is64BitOperatingSystem)
{
  //This is 64 bit
  Process.Start("process64.exe");
}
else
{
  // This is 32 bit
  Process.Start("process64.exe");
}
```

## Check If The Process Is 64 Bit

In this approach, we check if the current process is **64-bit** using the [Is64BitProcess](https://learn.microsoft.com/en-us/dotnet/api/system.environment.is64bitprocess?view=net-9.0) property of the [Environment](https://learn.microsoft.com/en-us/dotnet/api/system.environment?view=net-9.0) class.

```c#
if (Environment.Is64BitProcess)
{
  //This is 64 bit
  Process.Start("process64.exe");
}
else
{
  // This is 32 bit
  Process.Start("process64.exe");
}
```

### TLDR

**You can determine if an operating system is 32 or 64 bit, as well as the current executing process at runtime.**

Happy hacking!
