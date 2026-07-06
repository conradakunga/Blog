---
layout: post
title: .NET 11 Preview - Capturing Process Exit Status
date: 2026-07-05 21:57:54 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
---

In yesterday's post, "[.NET 11 Preview - Capturing Process Output & Errors]({% post_url 2026-07-04-net-11-preview-capturing-process-output-errors %})", we looked at how .NET 11 simplifies **starting a process** and **capturing its outpu**t.

Today we will look at another scenario - where we want to simply capture the **status** of a [Process](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process?view=net-10.0) upon its **exit**.

Currently, the standard way to do it is like this:

First, we set up our logging with [Serilog](https://github.com/serilog/serilog-sinks-console):

```c#
Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .CreateLogger();
```

Then our code will look like this:

```c#
var startInfo = new ProcessStartInfo
{
    FileName = "pwd",
    Arguments = "",
    RedirectStandardOutput = true,
    RedirectStandardError = true,
    UseShellExecute = false,
    CreateNoWindow = true
};

using (var process = Process.Start(startInfo))
{
    await process.WaitForExitAsync();

    if (process.ExitCode == 0)
        Log.Information("Success!");

    else
        Log.Error("Failed!");
}
```

Here, we are using the [Process](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process?view=net-10.0) and [ProcessStartInfo](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.processstartinfo?view=net-10.0) classes, and then examining the [ExitCode](https://learn.microsoft.com/en-us/dotnet/api/system.diagnostics.process.exitcode?view=net-10.0) of the returned `Process`.

This has been further simplified in .NET 11 by the introduction of a new method, [RunAsync](https://learn.microsoft.com/sr-latn-rs/dotnet/api/system.diagnostics.process.runasync?view=net-11.0&viewFallbackFrom=netcore-3.0), as well as its synchronous counterpart, [Run](https://learn.microsoft.com/sr-latn-rs/dotnet/api/system.diagnostics.process.run?view=net-11.0).

The code now looks like this:

```c#
var result = await Process.RunAsync("pwd");
if (result.ExitCode == 0)
    Log.Information("Success");
else
    Log.Error("Failure");
```

If the process you want to run has arguments, there is an **overload** that accepts them as an [IList](https://learn.microsoft.com/sr-latn-rs/dotnet/api/system.collections.generic.ilist-1?view=net-11.0) of `strings`.

```c#
var result = await Process.RunAsync("pwd", ["-L"]);
if (result.ExitCode == 0)
    Log.Information("Success");
else
    Log.Error("Failure");
```

Unlike the `Start` method, this returns a [ProcessExitStatus](https://learn.microsoft.com/sr-latn-rs/dotnet/api/system.diagnostics.processexitstatus?view=net-11.0) directly that you can **examine** for **success** or **failure**.

### TLDR

**Running a process and capturing its result has been simplified in .NET 11 with the `Run` and `RunAsync` methods.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-07-05%20-%20CaptureProcessResult).

Happy hacking!
