---
layout: post
title: 30 Days Of .NET 6 - Day 3 - TimeOnly Type
date: 2021-09-08 08:52:17 +0300
categories:
    - C#
    - 30 Days Of .NET 6
---
[We looked at the new DateOnly Type]({% post_url 2021-09-06-30-days-of-net-6-dateonly-type %}) on Day 1 of this series, and it should come as no surprise that there is a companion [TimeOnly](https://docs.microsoft.com/en-us/dotnet/api/system.timeonly?view=net-6.0) type that has been introduced to deal with only the time component of a [DateTime](https://docs.microsoft.com/en-us/dotnet/api/system.datetime?view=net-6.0).

There are three constructors, depending on the accuracy of the time you want:

```csharp
// Create the time 9.30 with varying levels of detail
var time = new TimeOnly(9, 30);
var timeWithSeconds = new TimeOnly(9, 30, 30);
var timeWithMilliSeconds = new TimeOnly(9, 30, 30, 99);
```

There is also a constructor that takes [Ticks](https://docs.microsoft.com/en-us/dotnet/api/system.timeonly.-ctor?view=net-6.0#System_TimeOnly__ctor_System_Int64_) as a parameter. Ticks in this instance would refer to every 100 nanoseconds since 00:00:00.0000000

```csharp
var time = new TimeOnly(100);
```

You can also obtain a `TimeOnly` from a `TimeSpan`, using the [FromTimeSpan](https://docs.microsoft.com/en-us/dotnet/api/system.timeonly.fromtimespan?view=net-6.0#System_TimeOnly_FromTimeSpan_System_TimeSpan_) method.

```csharp
var span = TimeSpan.FromMinutes(10);
var timeFromSpan = TimeOnly.FromTimeSpan(span);
```

I expect there may be some confusion between these two types because the [TimeSpan](https://docs.microsoft.com/en-us/dotnet/api/system.timeonly.fromtimespan?view=net-6.0#System_TimeOnly_FromTimeSpan_System_TimeSpan_) is currently how the `DateTime` deals with the time element. Additionally, a `TimeSpan` refers to a time interval.

You can also obtain a `TimeOnly` from a `DateTime` using the [FromDateTime](https://docs.microsoft.com/en-us/dotnet/api/system.timeonly.fromdatetime?view=net-6.0#System_TimeOnly_FromDateTime_System_DateTime_) static method.

```csharp
var now = TimeOnly.FromDateTime(DateTime.Now);
```

The `TimeOnly` type operates using the 24 hour clock, so midnight is 00:00 and noon is 12:00.

With a `TimeOnly` object you can perform the expected manipulations.

For example, if you would like to know what the Time would be one hour, thirty minutes form now:

```csharp
var future = TimeOnly.FromDateTime(DateTime.Now)
    .AddHours(1)
    .AddMinutes(30);
```

For some reason there isn't an `AddSeconds` or `AddMilliseconds` method!

But if you wanted to add an additional 5 milliseconds you would do it like so, making use of the [Add](https://docs.microsoft.com/en-us/dotnet/api/system.timeonly.add?view=net-6.0#System_TimeOnly_Add_System_TimeSpan_) method that takes a TimeSpan as a parameter.

```csharp
var future = TimeOnly.FromDateTime(DateTime.Now)
    .AddHours(1)
    .AddMinutes(30)
    .Add(TimeSpan.FromMilliseconds(5));
```

To move in the other direction, that is to find out the time one hour, thirty minutes ago, use negative numbers as parameters to the `Add` methods.

Keep in mind that `TimeOnly` only stores the time, so this computation (one minute before midnight) will wrap around and give you 23:56.

```csharp
// Passing no arguments assumes you want to start at 0:00.00.000000
var newYearEve = new TimeOnly().AddMinutes(-4);
```

However, you might want to know when the day has wrapped.

There are overloaded `Add` methods that take `out` parameters where this information is stored.

So using our previous example:

```csharp
var newYearEveWrapped = new TimeOnly().AddMinutes(-1, out var daysWrapped);
```

The `daysWrapped` variable here will contain -1, which will be the additional information that the returned `TimeOnly` is in fact a day ago.

This would be useful information for some computations involving time but have a date factor (for example late fees calculation).

Finally, the `TimeOnly` has a brilliant method that helps with determining the relationship between two dates.

The following code will print "Good morning" if you run it between midnight and noon; and something else anytime after that.

```csharp
var midnight = new TimeOnly(0, 0);
var noon = new TimeOnly(12, 0);

if (now.IsBetween(midnight, noon))
    Console.WriteLine("Good morning");
else
    Console.WriteLine("Good afternoon/evening");
```

For anything more advanced, you can subtract two `TimeOnly` objects. The resulting object is a `TimeSpan` that you can interrogate.

# Thoughts

This is an excellent type that will make time arithmetic much easier.

Personally I **struggle** with using the `TimeSpan` correctly to represent time for computations - it is not exactly intuitive to use the same construct for the dual purposes of a time period as well as an actual time.

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2021-09-08%20-%2030%20Days%20Of%20.NET%206%20-%20Day%203%20-%20TimeOnly).

# TLDR

There is a companion `TimeOnly` type that is designed for use for dealing with `time` without a `date` component. It is much more intuitive to use than a `TimeSpan`

**This is Day 3 of the 30 Days Of .NET 6 where every day I will attempt to explain one new / improved thing in the upcoming release of .NET 6.**

Happy hacking!