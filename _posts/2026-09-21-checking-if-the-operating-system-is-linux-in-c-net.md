---
layout: post
title: Checking If the Operating System Is Linux in C# & .NET
date: 2026-09-21 12:43:05 +0300
categories:
    - C#
    - .NET
---

Yesterday's post, "[Checking If the Operating System Is macOS in C# & .NET]()", looked at a quicker, simpler API to check whether your code is running on [macOS](https://en.wikipedia.org/wiki/MacOS).

In today's post, we will look at a similar problem: checking for [Linux](https://en.wikipedia.org/wiki/Linux).

Unsurprisingly, there is a similar API that you can use: [OperatingSystem.IsLinux()](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.islinux?view=net-10.0)

```c#
void Main()
{
  Console.WriteLine(OperatingSystem.IsLinux());
}
```

### TLDR

**You can use `OperatingSystem.IsLinux()` to check if your code is running on a Linux operating system.**
