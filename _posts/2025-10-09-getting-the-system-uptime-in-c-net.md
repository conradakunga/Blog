---
layout: post
title: Getting The System Uptime In C# & .NET
date: 2025-10-09 21:30:55 +0300
categories:
    - C#
    - .NET

---

Recently, I was wondering **how long it had been since I had last restarted my machine**, better known as [uptime](https://en.wikipedia.org/wiki/Uptime).

Is it possible to find this out?

It is - the [Environment.TickCount64](https://learn.microsoft.com/en-us/dotnet/api/system.environment.tickcount64?view=net-9.0) property.

This is defined as:

> Gets the number of milliseconds elapsed since the system started.

It returns:

> A 64-bit signed integer containing the amount of time in milliseconds that has passed since the last time the computer was started.

We can get the time for this using the [TimeStamp](https://learn.microsoft.com/en-us/dotnet/api/system.timespan?view=net-9.0) class.

```c#
var uptime = TimeSpan.FromMilliseconds(Environment.TickCount64);
Console.WriteLine($"Current uptime is {uptime.Humanize(3)}");
```

This prints the following:

```plaintext
Current uptime is 23 hours, 23 minutes, 9 seconds
```

Here we are using the [Humanizer](https://github.com/Humanizr/Humanizer) library to do the heavy lifting in terms of extracting the period elapsed.

It is important to use the `TickCount64` and not the similar `TickCount`, as the latter returns a `32-bit integer`.

The last bit is important - given a `32-bit` signed integer is in the range `-2,147,483,648` to `2,147,483,647`, that means we have a range of 4,294,967,295 milliseconds, which works out to about `49.7` days.

This essentially means that the value **rolls over every `50` or so days**.

Thus, it is better to use the `TickCount64`.

### TLDR

**The `Environment.TickCount64` returns the current uptime of the system.**

Happy hacking!
