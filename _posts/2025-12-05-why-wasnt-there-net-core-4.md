---
layout: post
title: Why wasn't there .NET Core 4
date: 2025-12-05 10:55:45 +0300
categories:
    - .NET
---

This is a post in a similar bent to yesterday's post, "[Why wasn't there Windows 9]({% post_url 2025-12-04-why-wasnt-there-windows-9 %})"

The reason is even more straightforward.

The [.NET Framework](https://en.wikipedia.org/wiki/.NET_Framework), first launched in 2002, has the following releases:

- 1
- 1.1
- 2
- 3
- 3.5
- 4.0
- 4.5
- 4.5.1
- 4.5.2
- 4.6
- 4.6.1
- 4.6.2
- 4.7
- 4.7.1
- 4.7.2
- 4.8
- 4.8.1 

This was a [Windows](https://en.wikipedia.org/wiki/Microsoft_Windows)-only affair.

In 2016, a pivotal change came about: the .NET Framework was **rewritten** to be cross-platform, with a new name: .NET Core.

These were the releases:

- .NET Core 1.0
- .NET Core 1.1
- .NET Core 2.0
- .NET Core 2.1
- .NET Core 2.2
- .NET Core 3.0
- .NET Core 3.1
- .NET 5
- .NET 6
- .NET 7
- .NET 8
- .NET 9
- .NET 10

A couple of things to note:

1. There is **no** .NET 4
2. The **name changed** from .NET Core to .NET from version `5`

The reason for this is pretty simple - it would have been a nightmare for developers and users to have **both** a .NET Framework `4` and a .NET Core `4`. Think web searches, documentation, blogs, StackOverflow.

**Omitting .NET Core 4 and going to 5 neatly sidestepped this problem.**

You might be asking what is special about .NET 4, given that the same problem would exist for prior versions.

The reason is that .NET Framework 4 is **still actively supported**, and many current applications still run on those versions.

To be specific, these are the versions under active support:

| Version                                                      | Release date     |
| ------------------------------------------------------------ | ---------------- |
| [.NET Framework 4.8.1](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net481) | August 9, 2022   |
| [.NET Framework 4.8](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net48) | April 18, 2019   |
| [.NET Framework 4.7.2](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net472) | April 30, 2018   |
| [.NET Framework 4.7.1](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net471) | October 17, 2017 |
| [.NET Framework 4.7](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net47) | April 5, 2017    |
| [.NET Framework 4.6.2](https://dotnet.microsoft.com/en-us/download/dotnet-framework/net462) | August 2, 2016   |

### TLDR

**There is no .NET Core 5 because it would massively confuse developers and users.**

Happy hacking!
