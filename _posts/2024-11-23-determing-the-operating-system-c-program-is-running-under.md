---
layout: post
title: Determining The Operating System C# .NET Program Is Running Under
date: 2024-11-23 11:56:40 +0300
categories:	
    - C#
    - .NET
---

Periodically, you will need to determine the operating system your code is running under in order to perform different logic. For example, you want the behaviour to be different depending on whether the code is running under Linux, Windows or OSX.

Your first temptation would be to use the [Environment.OSVersion.Platform API](https://learn.microsoft.com/en-us/dotnet/api/system.environment.osversion?view=net-8.0) and retrieve the `PlatformID` property like so:

```csharp
switch (Environment.OSVersion.Platform)
{
    case PlatformID.Win32NT: // Windows NT or later
        Console.WriteLine("Windows NT");
        break;
    case PlatformID.MacOSX:
        Console.WriteLine("OSX");
        break;
    case PlatformID.Unix:
        Console.WriteLine("Unix");
        break;
}
```

This code has two problems:
1. It will never return **OSX**, as it considers **OSX** as **Unix**
2. There is no [PlatformID](https://learn.microsoft.com/en-us/dotnet/api/system.platformid?view=net-8.0) defined for **Linux**, and so It also considers **Linux** as **Unix**

The correct way is to use the [RuntimeInformation.IsOSPlatform](https://learn.microsoft.com/en-us/dotnet/api/system.runtime.interopservices.runtimeinformation.isosplatform?view=net-8.0) API like so:

```csharp
if (RuntimeInformation.IsOSPlatform(OSPlatform.OSX))
{
  Console.WriteLine("OSX - {RuntimeInformation.OSDescription}");
}
else if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux))
{
  Console.WriteLine($"Linux - {RuntimeInformation.OSDescription}");
}

else if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
{
  Console.WriteLine($"Windows - {RuntimeInformation.OSDescription}");
}
else
{
  Console.WriteLine($"Other - {RuntimeInformation.OSDescription}");
}
```
Running under **OSX**, it prints the following:

```plaintext
OSX - Unix 14.7.1
```

Under **Linux,** it prints the following:

```plaintext
OSX - Linux - Unix 5.15.0.122
```

Under **Windows,** it prints the following:

```plaintext
Windows - Microsoft Windows NT 10.0.22631.0
```

Thus, the code will return the correct value whether running under Windows, OSX or Linux.

Happy hacking!