---
layout: post
title: Deconstructing A DateTime To Date And Time In C# & .NET
date: 2026-10-23 19:08:46 +0300
categories:
    - C#
    - .NET
---

Recently, I ran into a problem where I needed to extract the [Date](https://learn.microsoft.com/en-us/dotnet/api/system.dateonly?view=net-10.0) and [Time](https://learn.microsoft.com/en-us/dotnet/api/system.timeonly?view=net-10.0) components from a [DateTime](https://learn.microsoft.com/en-us/dotnet/api/system.datetime?view=net-10.0).

There are a couple of options around this.

## Fetch The Values Directly From The DateTime

The first approach is perhaps the **simplest**. From the `DateTime`:

1. Fetch the `Date` directly from the [Date](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.date?view=net-10.0) property
2. Fetch the `Time` directly from the [TimeOfDay](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.timeofday?view=net-10.0) property.

```c#
var now = DateTime.Now;

Console.WriteLine(now.Date);
Console.WriteLine(now.TimeOfDay);
```

## Construct TimeOnly and DateOnly From The DateTime

In this approach we use **factory** methods to **construct** the respective objects.

```c#
var now = DateTime.Now;
Console.WriteLine(DateOnly.FromDateTime(now));
Console.WriteLine(TimeOnly.FromDateTime(now));
```

## Deconstruct The DateTime Into Its Constituents

The other method is to use the [Deconstruct](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.deconstruct?view=net-10.0) method of the `DateTime` to deconstruct. Curiously, this method isn't exposed to the IDE ([EditorBrowsable](https://learn.microsoft.com/en-us/dotnet/api/system.componentmodel.editorbrowsableattribute?view=net-10.0)) so you **just have to know that it is there, or read the documentation to discover it**.

```c#
var now = DateTime.Now;
now.Deconstruct(out var date, out var time);
Console.WriteLine(date);
Console.WriteLine(time);
```

### TLDR

**There are a number of techniques to extract the `Date` and `Time` components from a given `DateTime`.**
