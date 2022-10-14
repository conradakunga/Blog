---
layout: post
title: Microsecond Precision In .NET
date: 2022-10-15 15:13:06 +0300
categories:
    - C#
    - .NET 7
---
The traditional way to make a [DateTime](https://learn.microsoft.com/en-us/dotnet/api/system.datetime?view=net-7.0) is as follows:

```csharp
var now = new DateTime(2022, 10, 14, 14, 58, 10, 10);
```

Here we are passing the following:
- Year
- Month
- Day
- Hour
- Minute
- Second
- MilliSecond

Is that to say that millisecond is the most accurate representation we can get?

No.

We can go even granular, but now we need to use a different [constructor](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.-ctor?view=net-7.0#system-datetime-ctor(system-int64)) - the one that takes [Ticks](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.ticks?view=net-7.0).

A tick is a 64 bit integer that represents one hundred nanoseconds.

You do not need to cram this.

You can interrogate the runtime for these values:

- TimeSpan.TicksPerMicrosecond
- TimeSpan.TicksPerMillisecond
- TimeSpan.TicksPerSecond
- TimeSpan.TicksPerMinute
- TimeSpan.TicksPerHour
- TimeSpan.TicksPerDay

The following code will print these out:

```csharp
Console.WriteLine($"TimeSpan.TicksPerMicrosecond - {TimeSpan.TicksPerMicrosecond:#,0}");
Console.WriteLine($"TimeSpan.TicksPerMillisecond - {TimeSpan.TicksPerMillisecond:#,0}");
Console.WriteLine($"TimeSpan.TicksPerSecond - {TimeSpan.TicksPerSecond:#,0}");
Console.WriteLine($"TimeSpan.TicksPerMinute - {TimeSpan.TicksPerMinute:#,0}");
Console.WriteLine($"TimeSpan.TicksPerHour - {TimeSpan.TicksPerHour:#,0}");
Console.WriteLine($"TimeSpan.TicksPerDay - {TimeSpan.TicksPerDay:#,0}");
```

This should print the following:

```plaintext
TimeSpan.TicksPerMicrosecond - 10
TimeSpan.TicksPerMillisecond - 10,000
TimeSpan.TicksPerSecond - 10,000,000
TimeSpan.TicksPerMinute - 600,000,000
TimeSpan.TicksPerHour - 36,000,000,000
TimeSpan.TicksPerDay - 864,000,000,000
```

So from this we know that a microsecond is 10 ticks.

So if we wanted to represent our example time to the precision of microseconds, say 999, we can do it like this:

```csharp
// Create the most accurate date
var now = new DateTime(2022, 10, 14, 14, 58, 10, 10);

// Add on the ticks
var preciselyNow = new DateTime(now.Ticks + 999 * TimeSpan.TicksPerMicrosecond);

// Write the date
Console.WriteLine(preciselyNow);
```

Note how we are computing the microseconds to add -  `999 * TimeSpan.TicksPerMicrosecond`

This prints the following:

```plaintext
14/10/2022 14:58:10
```

Note that it is not possible to see the microseconds!

To do so, print the ticks like this:

```csharp
// Check the ticks
Console.WriteLine(preciselyNow.Ticks);
```

This should print

```plaintext
638013562900109990
```

This process has been simplified in .NET 7.

To create an even more precise DateTime, there is a new overloaded constructor that accepts microseconds as a parameter.

```csharp
var nowAgain = new DateTime(2022, 10, 14, 14, 58, 10, 10, 999);

Console.WriteLine(nowAgain.Ticks);
```

This should print the exact value of `Ticks` as before

```plaintext
638013562900109990
```

The code is in my GitHub.

Happy hacking!