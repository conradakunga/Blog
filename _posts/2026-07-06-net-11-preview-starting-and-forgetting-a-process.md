---
layout: post
title: .NET 11 Preview - Starting and Forgetting A Process
date: 2026-07-06 22:17:26 +0300
categories:
   - C#
    - .NET
    - .NET 11 Preview
---

Yesterday's post, "[.NET 11 Preview - Capturing Process Exit Status]({% post_url 2026-07-05-net-11-preview-capturing-process-exit-status %})", looked at how to **start a process and capture its exit status**, which is useful in scenarios where you want to know whether your **process ran to completion successfully**.

In today's post, we will look at another scenario - where you want to **start a process** and **forget**, typically in a scenario where your application executes a long-running child process.

Currently, we would do it like this:

```c#
Process.Start(new ProcessStartInfo
{
    FileName = "ping",
    Arguments = "-v google.com",
    CreateNoWindow = true
});
```

This is not the best of examples, as the whole point of **ping** is to **read** the results, but this is just an **illustration**.

The problem with this is that, much as it works, the **intent is not very clear**.

This has been addressed in NET 11 with the introduction of the aptly named [StartAndForget](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process.startandforget?view=net-11.0) method, added to the [Process](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process?view=net-11.0) class.

The equivalent code as follows:

```c#
Process.StartAndForget("ping", ["-v", "conradakunga.com"]);
```

Not only is this much **simpler**, but it is also much **clearer** in terms of **communicating** the **intent**.

### TLDR

**The `StartAndForget` method has been introduced to the `Process` class for cases where you want to start a child process without waiting for it.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-07-06%20-%20FireAndForget).

Happy hacking!
