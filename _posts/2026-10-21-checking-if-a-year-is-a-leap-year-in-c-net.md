---
layout: post
title: Checking If A Year Is A Leap Year in C# & .NET
date: 2026-10-21 12:15:45 +0300
categories:
    - C#
    - .NET
---

A problem you may run into is checking whether a particular year is a **leap year.**

Many of us know a leap year is one that is **divisible by `4`**.

What we might not know is that there are **two other rules**:

1. If the year is divisible by `100,` it is **not** a leap year
2. If the year is divisible by `400`, it **is** a leap year

The algorithm is as follows:

```c#
bool IsLeapYear(int year)
{
	return year % 400 == 0 || (year % 4 == 0 && year % 100 != 0);
}
```

You can go a step further and make this an extension method for [DateTime](https://learn.microsoft.com/en-us/dotnet/api/system.datetime?view=net-10.0) and [DateOnly](https://learn.microsoft.com/en-us/dotnet/api/system.dateonly?view=net-10.0).

Like so:

```c#
public static class DateTimeExtensions
{
  public static bool IsLeapYear(this DateTime datetTime)
  {
  	return datetTime.Year % 400 == 0 || (datetTime.Year % 4 == 0 && datetTime.Year % 100 != 0);
  }
  public static bool IsLeapYear(this DateOnly dateOnly)
  {
  	return dateOnly.ToDateTime(TimeOnly.MinValue).IsLeapYear();
  }
}
```

.NET already has similar functionality- the static [DateTime.IsLeapYear](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.isleapyear?view=net-10.0) method.

```c#
Console.WriteLine(DateTime.IsLeapYear(2024));
```

### TLDR

**Rather than determining a leap year for yourself, you can use the  [DateTime.IsLeapYear](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.isleapyear?view=net-10.0) method.**

Happy hacking!
