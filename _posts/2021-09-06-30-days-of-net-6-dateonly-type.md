---
layout: post
title: 30 Days Of .NET 6 - DateOnly Type
date: 2021-09-06 09:14:19 +0300
categories:
    - C#
    - .NET
    - 30 Days Of .NET 6
---
In .NET when manipulating dates and times, you generally use the [DateTime](https://docs.microsoft.com/en-us/dotnet/api/system.datetime?view=net-5.0) type for such purposes.

This generally works but can be a bit clumsy and can trip you up do to the fact that a `DateTime` contains a date and a time component.

Strictly speaking this is not incorrect - the two are completely interrelated.

However there are times when you are only interested in the date and the time is a distraction. For example you want to know orders placed today - regardless of the time.

[I have discussed this briefly in a previous post]({% post_url 2021-08-07-tip-get-current-date-in-c %}) but in .NET 6 there is an even better solution to this problem - the [DateOnly](https://docs.microsoft.com/en-us/dotnet/api/system.dateonly?view=net-6.0) type.

It is very similar to a `DateTime` object at first glance - it just omits all the time details.

```csharp
var newDate = new DateOnly(2022, 1, 1);
```

You can also get a `DateOnly` instance form an existing `DateTime` object.

```csharp
var otherNewDate = DateOnly.FromDateTime(DateTime.Now);
```

You can also get a `DateOnly` form a day number - where day 0 is 1 January 0000

```csharp
var dayZero = DateOnly.FromDayNumber(0);
```

`DateOnly` also has the `Parse`, `TryParse` and `ParseExect` methods to allow construction from strings.

```csharp
var christmas = DateOnly.ParseExact("2021-12-25", "yyyy-MM-dd");
```

In terms of operations the `DateOnly` supports the usual manipulations - Adding or subtracting the relevant properties - Day, Month and Year.

For example, to get the `DateOnly` a year from an existing `DateOnly` object:

```csharp
var nextYear = newDate.AddYears(1);
```
(Note: subtraction is done by adding a **negative** number)

Finally, the `DateOnly` object by default works with the [Gregorian Calendar](https://www.timeanddate.com/calendar/gregorian-calendar.html). However there is an overload that allows you to construct a `DateOnly` from any supported calendar.

For example, to use a [Persian](https://docs.microsoft.com/en-us/dotnet/api/system.globalization.persiancalendar?view=net-5.0) calendar, you construct a `DateOnly` as follows:

```csharp
var persianCalendar = new PersianCalendar();
var persianCurrentDate = new DateOnly(2021, 1, 1, persianCalendar);
Console.WriteLine(persianCurrentDate);
```

This should generate the following:

```plaintext
21 Mar 2642
```

You might wonder why it was called `DateTime` and not just `Date`.

A couple of reasons:
1. In [Visual Basic .NET](https://docs.microsoft.com/en-us/dotnet/visual-basic/) **Date** is an alias for the `DateTime` type.
2. There is already a [Date](https://docs.microsoft.com/en-us/dotnet/api/system.datetime.date?view=net-5.0#System_DateTime_Date) property of the `DateTime` type, which is also a `DateTime` (but with the time component set to midnight)

The `DateOnly` type also has a number of handy properties that make general coding easier:

* [Day](https://docs.microsoft.com/en-us/dotnet/api/system.dateonly.day?view=net-6.0#System_DateOnly_Day)
* [DayNumber](https://docs.microsoft.com/en-us/dotnet/api/system.dateonly.daynumber?view=net-6.0#System_DateOnly_DayNumber)
* [DayOfTheWeek](https://docs.microsoft.com/en-us/dotnet/api/system.dateonly.dayofweek?view=net-6.0#System_DateOnly_DayOfWeek)
* [DayOfTheYear](https://docs.microsoft.com/en-us/dotnet/api/system.dateonly.dayofyear?view=net-6.0#System_DateOnly_DayOfYear)
* [Month](https://docs.microsoft.com/en-us/dotnet/api/system.dateonly.month?view=net-6.0#System_DateOnly_Month)
* [Year](https://docs.microsoft.com/en-us/dotnet/api/system.dateonly.year?view=net-6.0#System_DateOnly_Year)

# Thoughts
This is an excellent, long overdue type

1. It communicates clearly the intent of the developer (I am only interested in the date, regardless of the time)

2. It will avoid all sorts of logic bugs when using a normal `DateTime`.

    For example innocent looking code like this often fails

    ```csharp
    var ordersPlacedToday = allOrders.Where(x => x.OrderDate == DateTime.Now)
    ```

    Why? Because **DateTime.Now** has a `Time` component and this query will almost always fail because in the data source `OrderDate` is set to midnight but `DateTime.Now` will return in addition to the date the current time down to milliseconds, making the evaluation fail.
    
Would be interesting to understand the rationale of why this

```csharp
var otherNewDate = DateOnly.FromDateTime(DateTime.Now);
```

was chosen rather than this:

```csharp
var otherNewDate = DateTime.Now.ToDateOnly();
```

I think the latter is more discoverable to current users.

# TLDR

There is a new [DateOnly](https://docs.microsoft.com/en-us/dotnet/api/system.dateonly?view=net-6.0) type that unlike the [DateTime](https://docs.microsoft.com/en-us/dotnet/api/system.datetime?view=net-6.0) that deals with dates and time, only deals with the date.

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2021-09-06%20-%2030%20Days%20Of%20.NET%206%20-%20Day%201%20-%20DateOnly).

**This is Day 1 of the 30 Days Of .NET 6 where every day I will attempt to explain one new / improved thing in the upcoming release of .NET 6.**
    
Happy hacking!