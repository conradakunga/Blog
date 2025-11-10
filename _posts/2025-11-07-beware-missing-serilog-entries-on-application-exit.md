---
layout: post
title: Beware - Missing Serilog Entries On Application Exit
date: 2025-11-07 12:37:37 +0300
categories:
    - C#
    - .NET
    - Logging
    - Serilog
---

I have blogged at length about **logging**, and in particular, using the [Serilog](https://serilog.net/) library.

Something to be very particular about is that you must always remember to **close and flush your logs when the application is exiting**.

This is because the client **batches** its log messages, which it then periodically writes to the sink of choice.

If you terminate **before** the client has the opportunity to write the buffered logs to the sink, those **logs may be lost**.

For example, on my machine, the code below does not log anything:

```c#
using Serilog;

Log.Logger = new LoggerConfiguration()
    .WriteTo.Seq("http://localhost:5341")
    .CreateLogger();

string fruit = "Apple";

Log.Information("The fruit is a {Fruit}", fruit);

var animal = new Animal { Name = "Dog", Legs = 4 };
Log.Information("Here is the {@Animal}", animal);
animal = new Animal { Name = "Bird", Legs = 2 };
Log.Information("Here is the {Animal}", animal);
```

The proper way to write this is as follows:

```c#
using Serilog;

try
{
    Log.Logger = new LoggerConfiguration()
        .WriteTo.Seq("http://localhost:5341")
        .CreateLogger();

    string fruit = "Apple";

    Log.Information("The fruit is a {Fruit}", fruit);

    var animal = new Animal { Name = "Dog", Legs = 4 };
    Log.Information("Here is the {@Animal}", animal);
    animal = new Animal { Name = "Bird", Legs = 2 };
    Log.Information("Here is the {Animal}", animal);
}
catch (Exception ex)
{
    Log.Error(ex, "An error occurred");
}
finally
{
    Log.CloseAndFlush();
}
```

Here, we have wrapped the code in a **try-catch-finally** block.

### TLDR

**Always *close* and *flush* your Log to ensure data is not lost on exit or in the event of an exception.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-11-07%20-%20ComplexLogging).

Happy hacking!
