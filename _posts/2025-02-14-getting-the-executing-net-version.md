---
layout: post
title: Getting The Executing .NET Version
date: 2025-02-14 03:30:48 +0300
categories:
    - C#
    - .NET
---

Knowing the .NET version at **compile time** is as simple as executing a command on the console.

```bash
dotnet --version
```

This will print for you the following (which is true on my machine on February 14, 2025)

```plaintext
9.0.200
```

If you want a little more information, you execute the following command:

```bash
dotnet --info
```

This will print for you much more detailed information:

```plaintext
.NET SDK:
 Version:           9.0.200
 Commit:            90e8b202f2
 Workload version:  9.0.200-manifests.b73bf4bc
 MSBuild version:   17.13.8+cbc39bea8

Runtime Environment:
 OS Name:     Mac OS X
 OS Version:  14.7
 OS Platform: Darwin
 RID:         osx-arm64
 Base Path:   /usr/local/share/dotnet/sdk/9.0.200/

.NET workloads installed:
There are no installed workloads to display.
Configured to use loose manifests when installing new manifests.

Host:
  Version:      9.0.2
  Architecture: arm64
  Commit:       80aa709f5d

.NET SDKs installed:
  8.0.406 [/usr/local/share/dotnet/sdk]
  9.0.200 [/usr/local/share/dotnet/sdk]

.NET runtimes installed:
  Microsoft.AspNetCore.App 8.0.13 [/usr/local/share/dotnet/shared/Microsoft.AspNetCore.App]
  Microsoft.AspNetCore.App 9.0.2 [/usr/local/share/dotnet/shared/Microsoft.AspNetCore.App]
  Microsoft.NETCore.App 8.0.13 [/usr/local/share/dotnet/shared/Microsoft.NETCore.App]
  Microsoft.NETCore.App 9.0.2 [/usr/local/share/dotnet/shared/Microsoft.NETCore.App]
```

Here you can see my machine is a [Mac](https://www.apple.com/ke/macbook-pro/) running [OSX Sonoma](https://en.wikipedia.org/wiki/MacOS_Sonoma), and I have **two** .NET versions installed - 8 and 9, but the active one on the current path is 9. This can be changed using a [global.json](https://learn.microsoft.com/en-us/dotnet/core/tools/global-json) file.

Now suppose, for whatever reason, you needed the current SDK version at **runtime**?

You might be tempted to shell to the command line, execute `dotnet --version` and read the response, like so:

```c#
using System.Diagnostics;

// Setup our process start info
var startInfo = new ProcessStartInfo
{
    FileName = "dotnet",
    Arguments = "--version",
    RedirectStandardOutput = true,
    UseShellExecute = false,
    CreateNoWindow = true
};

// Create a process
var process = new Process();
process.StartInfo = startInfo;

// Start process
process.Start();
// Read output, and discard the newline
string output = process.StandardOutput.ReadToEnd().Trim();
process.WaitForExit();
// Print 
Console.WriteLine(output);
```

This prints the following:

```plaintext
9.0.200
```



There are two problems with this approach:

1. This works, but is very clunky
2. It makes an **assumption you cannot validly make** - that the .NET SDK will be available on the target machine. Remember that .NET applications can be published [self-contained](https://learn.microsoft.com/en-us/dotnet/core/deploying/runtime-patch-selection).

A much easier way is to use the [Environment.Version](https://learn.microsoft.com/en-us/dotnet/api/system.environment.version?view=net-9.0) property.

```c#
// Use a simpler way
Console.WriteLine(Environment.Version);
```

This will print the following:

```plaintext
9.0.2
```

Note that with this technique, the trailing zeroes are not returned.

### TLDR

**`Environment.Version` will return the .NET version of the executing application at runtime.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-02-14%20-%20Executing%20.NET%20Version).

Happy hacking!
