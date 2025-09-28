---
layout: post
title: Getting The Number Of Days In A Month In C# & .NET
date: 2025-09-28 19:25:57 +0300
categories:
    - C#
    - .NET
---

While idly going through the **documentation**, or the **intellisense** of your favourite IDE, you will almost certainly always stumble across a **method** or **property** you **did not know existed**.

**There is no shame in this**!

I have written before about ["Determining The Number Of Days In A Year"]({% post_url 2024-12-13-determining-the-number-of-days-in-a-year-in-c %}). Recently, I needed to determine the **number of days in a given month**.

Assuming you know at least the **year** (this matters for [leap years!](https://en.wikipedia.org/wiki/Leap_year)), a possible solution would be to do it like this:

```c#
// Get the start of the given month, here we want February 2020
var startOfCurrentMonth = new DateOnly(2020, 2, 1);
// Add a month to this date, to get the start of the next month	
var startOfNextMonth = startOfCurrentMonth.AddMonths(1);
// Move back one day to get the last day of the previos month
var endOfPreviousMonth = startOfNextMonth.AddDays(-1);
// Get the day
var day = endOfPreviousMonth.Day;

Console.WriteLine($"{startOfCurrentMonth:MMMM, yyyy} has {day} days");
```

This will print the following:

```plaintext
February, 2020 has 29 days
```

If we run it for the next year, 2021:

```plaintext
February, 2021 has 28 days
```

It turns out there is a method of the [DateTime](https://learn.microsoft.com/en-us/dotnet/api/system.datetime?view=net-9.0) class that can do this - [DaysInMonth](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.daysinmonth?view=net-9.0)

The above code can be rewritten as follows:

```c#
var daysInMonth = DateTime.DaysInMonth(startOfCurrentMonth.Year, startOfCurrentMonth.Month);
Console.WriteLine($"{startOfCurrentMonth:MMMM, yyyy} has {daysInMonth} days");
```

This also prints what we expect:

```plaintext
February, 2020 has 29 days
```

### TLDR

**The [DateTime](https://learn.microsoft.com/en-us/dotnet/api/system.datetime?view=net-9.0) class has a static method [DaysInMonth](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.daysinmonth?view=net-9.0) that, given the year and the month, returns the number of days of that month.**

Happy hacking!
