---
layout: post
title: Check If You Have The Latest .NET SDK
date: 2024-12-24 00:20:03 +0300
categories:
    - C#
    - .NET
---

How do you know if you have the latest version of the SDK?

The first question is to determine what version do you have now.

This is done using the info tool

```bash
dotnet --info
```

This will return a result like this:

```plaintext
.NET SDK:
 Version:           9.0.101
 Commit:            eedb237549
 Workload version:  9.0.100.1
 MSBuild version:   17.12.12+1cce77968

Runtime Environment:
 OS Name:     Mac OS X
 OS Version:  14.7
 OS Platform: Darwin
 RID:         osx-arm64
 Base Path:   /usr/local/share/dotnet/sdk/9.0.101/

.NET workloads installed:
There are no installed workloads to display.
Configured to use workload sets when installing new manifests.

Host:
  Version:      9.0.0
  Architecture: arm64
  Commit:       9d5a6a9aa4

.NET SDKs installed:
  9.0.101 [/usr/local/share/dotnet/sdk]

.NET runtimes installed:
  Microsoft.AspNetCore.App 9.0.0 [/usr/local/share/dotnet/shared/Microsoft.AspNetCore.App]
  Microsoft.NETCore.App 9.0.0 [/usr/local/share/dotnet/shared/Microsoft.NETCore.App]

Other architectures found:
  None

Environment variables:
  Not set

global.json file:
  Not found

Learn more:
  https://aka.ms/dotnet/info

Download .NET:
  https://aka.ms/dotnet/download
```

Traditionally, there are a couple of ways to do this:

1. Leave it to your package manager
    - [Chocolatey](https://chocolatey.org/) or [Winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/) for Windows
    - [Homebrew](https://brew.sh/) for OSX
    - Linux Package Manager (e.g. apt for Debian based, etc)
2. Perodically check yourself on the [.NET home page](https://dotnet.microsoft.com/en-us/)

The best way to do this that requires no additional software or extra work is to use the [tool built into the .NET SDK for this purpose](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-sdk-check). To check, run the following command

```bash
dotnet sdk check
```

This will return a result like this if you are not running the latest SDK

```plaintext
.NET SDKs:
Version      Status                     
----------------------------------------
9.0.100      Patch 9.0.101 is available.

Try out the newest .NET SDK features with .NET 9.0.101.

.NET Runtimes:
Name                          Version      Status     
------------------------------------------------------
Microsoft.AspNetCore.App      9.0.0        Up to date.
Microsoft.NETCore.App         9.0.0        Up to date.
```

It has indicated that there is a patch available.

Which you can proceed to install depending on your OS and how you installed it in the first place.

If you are up to date, you will see the following:

```plaintext
.NET SDKs:
Version      Status     
------------------------
9.0.101      Up to date.

.NET Runtimes:
Name                          Version      Status     
------------------------------------------------------
Microsoft.AspNetCore.App      9.0.0        Up to date.
Microsoft.NETCore.App         9.0.0        Up to date.
```

Happy hacking!