---
layout: post
title: Checking for Other Running Operating Systems in C# & .NET
date: 2026-09-23 11:38:19 +0300
categories:
    - C#
    - .NET
---

In previous posts, "[Checking If the Operating System Is macOS in C# & .NET]({% post_url 2026-09-20-checking-if-the-operating-system-is-macos-in-c-net %})", "[Checking If the Operating System Is Linux in C# & .NET]({% post_url 2026-09-21-checking-if-the-operating-system-is-linux-in-c-net %})", and "[Checking If the Operating System Is Windows in C# & .NET]({% post_url 2026-09-22-checking-if-the-operating-system-is-windows-in-c-net %})", we looked at a simpler API to check whether we are running on **macOS**, **Linux** and **Windows**, respectively.

The APIs are largely formulaic, but there is more to explore.

## Other Operating Systems

You can also check for **other operating systems**, including the following:

- [Android](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.isandroid?view=net-10.0#system-operatingsystem-isandroid)
- [FreeBSD](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.isfreebsd?view=net-10.0#system-operatingsystem-isfreebsd)
- [IOS](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.isios?view=net-10.0#system-operatingsystem-isios)
- [TvOS](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.istvos?view=net-10.0#system-operatingsystem-istvos)
- [WatchOS](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.iswatchos?view=net-10.0#system-operatingsystem-iswatchos)

## Particular Versions of Operating System

If you are interested in not just the operating system, but its **versions**, there are these APIs.

- [Android](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.isandroidversionatleast?view=net-10.0#system-operatingsystem-isandroidversionatleast(system-int32-system-int32-system-int32-system-int32))
- [FreeBSD](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.isfreebsdversionatleast?view=net-10.0#system-operatingsystem-isfreebsdversionatleast(system-int32-system-int32-system-int32-system-int32))
- [IOS](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.isiosversionatleast?view=net-10.0#system-operatingsystem-isiosversionatleast(system-int32-system-int32-system-int32))
- [macOS](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.ismacosversionatleast?view=net-10.0#system-operatingsystem-ismacosversionatleast(system-int32-system-int32-system-int32))
- [TvOS](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.istvosversionatleast?view=net-10.0#system-operatingsystem-istvosversionatleast(system-int32-system-int32-system-int32))
- [WatchOS](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.iswatchosversionatleast?view=net-10.0#system-operatingsystem-iswatchosversionatleast(system-int32-system-int32-system-int32))
- [Windows](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.iswindowsversionatleast?view=net-10.0#system-operatingsystem-iswindowsversionatleast(system-int32-system-int32-system-int32-system-int32))

## Platforms

You can also check whether you are running on a particular **platform**.

- [Browser](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.isbrowser?view=net-10.0#system-operatingsystem-isbrowser)
- [MacCatalyst](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.ismaccatalyst?view=net-10.0#system-operatingsystem-ismaccatalyst)
- [Wasi](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem.iswasi?view=net-10.0#system-operatingsystem-iswasi)

## TLDR

**The [OperatingSystem](https://learn.microsoft.com/en-us/dotnet/api/system.operatingsystem?view=net-10.0) class has various API that you can use to determine the current operating system**

Happy hacking!
