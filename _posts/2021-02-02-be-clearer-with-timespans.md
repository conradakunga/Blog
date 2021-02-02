---
layout: post
title: Be Clearer With TimeSpans
date: 2021-02-02 14:30:02 +0300
categories:
    - Tips
---
Many of the .NET APIs take time intervals as their parameters, and it usually is in milliseconds.

For example:

```csharp
Thread.Sleep(1000);
```

From your primary school days, you will remember 1000 milliseconds make one second.

This is fine for simple examples but what if you want your thread to sleep for 30 minutes.

Many people would do it like this:

```csharp
Thread.Sleep(1000 * 60 * 30)
```

Which is perfectly correct, but it is difficult to read. You have to spend some mental cycles to find out what is happening here.

A far easier, and clearer way to write the same code is to use the [TimeSpan](https://docs.microsoft.com/en-us/dotnet/api/system.timespan?view=net-5.0#:~:text=The%20value%20of%20a%20TimeSpan,MinValue%20to%20TimeSpan.) class.

```csharp
// Sleep for 30 minutes
Thread.Sleep(TimeSpan.FromMinutes(30));
```

In addition to minutes you also have methods that operate with [ticks](https://docs.microsoft.com/en-us/dotnet/api/system.timespan.fromticks?view=net-5.0#System_TimeSpan_FromTicks_System_Int64_), [milliseconds](https://docs.microsoft.com/en-us/dotnet/api/system.timespan.frommilliseconds?view=net-5.0#System_TimeSpan_FromMilliseconds_System_Double_), [seconds](https://docs.microsoft.com/en-us/dotnet/api/system.timespan.fromseconds?view=net-5.0#System_TimeSpan_FromSeconds_System_Double_), [hours](https://docs.microsoft.com/en-us/dotnet/api/system.timespan.fromhours?view=net-5.0#System_TimeSpan_FromHours_System_Double_) and even [days](https://docs.microsoft.com/en-us/dotnet/api/system.timespan.fromdays?view=net-5.0#System_TimeSpan_FromDays_System_Double_).

This makes the code much easier to understand and maintain.

Happy hacking!