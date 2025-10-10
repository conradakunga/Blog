---
layout: post
title: What Is The Largest Duration A TimeSpan Can Store In C# & .NET
date: 2025-10-10 21:55:52 +0300
categories:
    - C#
    - .NET
---

While writing yesterday's post, "[Getting The System Uptime In C# & .NET]({% post_url 2025-10-09-getting-the-system-uptime-in-c-net %})", I learned that the [Environment.TickCount64](https://learn.microsoft.com/en-us/dotnet/api/system.environment.tickcount64?view=net-9.0) returns a `64-bit` [integer](https://learn.microsoft.com/en-us/dotnet/api/system.int64?view=net-9.0).

I found myself wondering - **what is the largest duration this can store**?

I need not have looked far. there is a [TimeSpan.MaxValue](https://learn.microsoft.com/en-us/dotnet/api/system.timespan.maxvalue?view=net-9.0) property that has everything we need.

```c#
Console.WriteLine($"{TimeSpan.MaxValue.TotalDays:#,0} days");
Console.WriteLine($"{TimeSpan.MaxValue.TotalHours:#,0} hours");
Console.WriteLine($"{TimeSpan.MaxValue.TotalMinutes:#,0} minutes");
```

This prints the following:

```plaintext
10,675,199 days
256,204,779 hours
15,372,286,728 minutes
```

These, you can see, are very **long** durations!

An uptime of `10 million` days is about `27,000` years.

That is quite some uptime!

### TLDR

**The `TimeSpan.MaxValue` has properties that indicate the upper bounds of the largest value.**

Happy hacking!
