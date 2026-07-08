---
layout: post
title: .NET 11 Preview - Starting A Detached Process
date: 2026-07-07 15:37:14 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
---

Yesterday's post, "[.NET 11 Preview - Starting and Forgetting A Process]({% post_url 2026-07-06-net-11-preview-starting-and-forgetting-a-process %})", looked at how to **start and forget** a process. Which is to say, a process you want to start but don't necessarily want to interact with or its **results**.

A caveat with the `Run` APIs such as  [Run](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process.run?view=net-11.0), [RunAndCaptureText](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process.runandcapturetext?view=net-11.0), [ReadAllText,](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process.readalltext?view=net-11.0) [ReadAllLines](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process.readalllines?view=net-11.0), [ReadAllBytes](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process.readallbytes?view=net-11.0), etc., is that **once you terminate the main program, the underlying child process also terminates.**

This is **generally a good thing**, but there are times when you want the **child process to outlive** its parent.

In this scenario, [StartAndForget](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process.startandforget?view=net-11.0) has an overload that takes a [ProcessStartInfo](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.processstartinfo?view=net-11.0) object.

You can use this to specify that you want a **detached** process as follows:

```c#
using System.Diagnostics;

var info = new ProcessStartInfo
{
    FileName = "ping",
    Arguments = "google.com",
    StartDetached = true,
    UseShellExecute = false
};

// Start the detached process
Process.StartAndForget(info);
```

Here, we set the [StartDetached](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.processstartinfo.startdetached?view=net-11.0#system-diagnostics-processstartinfo-startdetached) property to `true`.

### TLDR

**The `StartAndForget` method has an overload that takes a `ProcessStartInfo` object you can use to specify a detached process.**

The code is in my GitHub.

Happy hacking!
