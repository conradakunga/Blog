---
layout: post
title: .NET 10 Release Candidate Is Out
date: 2025-09-11 01:49:35 +0300
categories:
    - C#
    - .NET
---

**The Release Candidate for .NET 10 is out.**

```bash
dotnet --info
```

This now prints the following:

```plaintext
.NET SDK:
 Version:           10.0.100-rc.1.25451.107
 Commit:            2db1f5ee2b
 Workload version:  10.0.100-manifests.1a2d104c
 MSBuild version:   17.15.0-preview-25451-107+2db1f5ee2

Runtime Environment:
 OS Name:     Mac OS X
 OS Version:  15.6
 OS Platform: Darwin
 RID:         osx-arm64
 Base Path:   /usr/local/share/dotnet/sdk/10.0.100-rc.1.25451.107/
```

What does [Release Candidate](https://en.wikipedia.org/wiki/Software_release_life_cycle) mean?

The important part is in the [announcement](https://devblogs.microsoft.com/dotnet/dotnet-10-rc-1/):

> This is our first of two release candidates which come with a [go-live support license](https://dotnet.microsoft.com/platform/support/policy/dotnet-core#previews) so you can confidently use this release for your production applications. 

You can download it [here](https://dotnet.microsoft.com/en-us/download/dotnet/10.0)

If you are on macOS, you can use the [technique outlined here]({% post_url 2024-11-22-running-multiple-net-versions-in-macos-osx %}).

Happy hacking!
