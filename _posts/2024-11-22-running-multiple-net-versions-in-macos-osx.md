---
layout: post
title: Running Multiple .NET Versions In MacOS OSX
date: 2024-11-22 08:38:27 +0300
categories:
  - .NET
  - C#
---

With .NET 9 [released the other day](https://devblogs.microsoft.com/dotnet/announcing-dotnet-9/), you might find not all your tools and libraries support .NET 9.

If you are on OSX, this presents some challenges, as using the .NET Installer does not allow you to run more than one version of the .NET SDK.

However there is a solution to this.

First you need to install and setup [Homebrew](https://brew.sh) for OSX.

Next you need to setup the cask that has the various .NET SDK Versions. This is done usng this command:

```powershell
brew tap isen-ng/dotnet-sdk-versions
```

Next, you can proceed to install the .NET version you require

```powershell
brew install --cask <version>
```

The list of versions available is as follows, as of 22 November 2022:


| Version | SDK |
|---|---|
| dotnet-sdk9	| 9.0.100 |
| dotnet-sdk8	| 8.0.404 | 

So, for instance, to install .NET 9 you would do so as follows:

```powershell
brew install --cask dotnet-sdk9
```

And then to install .NET 8

```powershell
brew install --cask dotnet-sdk8
```

Once done you can verify both are installed by running the following command

```powershell
dotnet --list-sdks
```

You should see the following output

```plaintext
dotnet --list-sdks
8.0.404 [/usr/local/share/dotnet/sdk]
9.0.100 [/usr/local/share/dotnet/sdk]
```

Happy hacking!