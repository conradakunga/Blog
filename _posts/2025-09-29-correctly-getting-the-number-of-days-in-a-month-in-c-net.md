---
layout: post
title: Correctly Getting The Number Of Days In A Month In C# & .NET
date: 2025-09-29 20:51:49 +0300
categories:
    - C#
    - .NET
---

Our last post, ["Getting The Number Of Days In A Month In C# & .NET"]({% post_url 2025-09-28-getting-the-number-of-days-in-a-month-in-c-net %}), looked at two ways to get the **number of days in a particular month**.

The code is correct, but it may potentially be **wrong**..

Why?

[Calendar systems](https://en.wikipedia.org/wiki/Calendar)!

The calendar **most** of the world currently uses is the [Gregorian Calendar](https://en.wikipedia.org/wiki/Gregorian_calendar).

The **proper** way to get the days in the month in this calendar is to use the [GregorianCalendar](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.gregoriancalendar?view=net-9.0) class as follows:

```c#
var dateOnly = new DateOnly(2000, 1, 1);
var gregorian = new GregorianCalendar();
var daysInMonth = gregorian.GetDaysInMonth(dateOnly.Year, dateOnly.Month);
Console.WriteLine($"{dateOnly:MMMM yyyy} has {daysInMonth} days in the Gregorian Calendar");
```

This will print the following:

```plaintext
January 2000 has 31 days in the Gregorian Calendar
```

If you were using another calendar, say [Hijri](https://en.wikipedia.org/wiki/Islamic_calendar), you would use the [HijriCalendar](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.hijricalendar?view=net-9.0) class as follows:

```c#
var dateOnly = new DateOnly(2000, 1, 1);
var hijri = new HijriCalendar();
var daysInMonth = hijri.GetDaysInMonth(dateOnly.Year, dateOnly.Month);
Console.WriteLine($"{dateOnly:MMMM yyyy} has {daysInMonth} days in the Hijri Calendar");
```

This will print the following:

```plaintext
January 2000 has 30 days in the Hijri Calendar
```

We can pull a list of calendars using reflection as folllows:

```c#
var calendar = typeof(Calendar);
// Get the assembly
var calendars = calendar.Assembly
    // Get the types in the assembly
    .GetTypes()
    // Filter out the non-abstract classes, and get those that are assignable
    .Where(t => !t.IsAbstract && calendar.IsAssignableFrom(t))
    // Order by name
    .OrderBy(t => t.Name);

Console.WriteLine("Calendars:");

foreach (var type in calendars!)
{
    Console.WriteLine($"- {type.Name}");
}
```

This code will print the following:

```c#
Calendars:
- ChineseLunisolarCalendar
- GregorianCalendar
- HebrewCalendar
- HijriCalendar
- JapaneseCalendar
- JapaneseLunisolarCalendar
- JulianCalendar
- KoreanCalendar
- KoreanLunisolarCalendar
- PersianCalendar
- TaiwanCalendar
- TaiwanLunisolarCalendar
- ThaiBuddhistCalendar
- UmAlQuraCalendar

```

These are the **calendars** currently supported by .NET.

### TLDR

**Days in the month are a construct of a calendar, as well as the year and the month.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-09-29%20-%20DaysInMonth).

Happy hacking!
