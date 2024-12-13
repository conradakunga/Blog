---
layout: post
title: Determining The Number Of Days In A Year In C#
date: 2024-12-13 23:25:32 +0300
categories:
    - C#
---

Suppose we need to determine the number of days in a year, say this year (2024).

There are a number of ways to do this:

The first is to determine the date of the last day of the year and subtract that date from the first day of the year. To the result, we add now (as the computation is day-exclusive).

```csharp
var daysInYear = (new DateTime(2024, 12, 31) - new DateTime(2024, 1, 1)).TotalDays + 1;
Console.WriteLine(daysInYear);
```

We can improve this code by making it a reusable function.

```csharp
public int DaysInYear(int year)
{
	return Convert.ToInt32( (new DateTime(year, 12, 31) - new DateTime(year, 1, 1)).TotalDays) + 1;
}
```

A second way is to use the fact that [leap years have 366](https://en.wikipedia.org/wiki/Leap_year) days and the rest have 356 days.

We can avoid the computations altogether and check if a year is a leap year. How do we tell if a year is a leap year? We could [write a function](https://en.wikipedia.org/wiki/Leap_year), but there is a static method of [DateTime](https://learn.microsoft.com/en-us/dotnet/api/system.datetime?view=net-9.0) that we can use for this: [IsLeapYear](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.isleapyear?view=net-9.0)

```csharp
public int DaysInYear2(int year)
{
  if (DateTime.IsLeapYear(year))
    return 366;
  return 365;
}
```

The final and probably most appropriate method is to utilize the concept of [Calendars](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.calendar?view=net-9.0).

It is easy to overlook the fact that several calendars are in use worldwide. The most common one is the [Gregorian Calendar](https://en.wikipedia.org/wiki/Gregorian_calendar). But you have probably come across, or at least heard of, the [Julian Calendar](https://en.wikipedia.org/wiki/Julian_calendar), the [Hebrew Calendar,](https://en.wikipedia.org/wiki/Hebrew_calendar) the [Korean Calendar](https://en.wikipedia.org/wiki/Korean_calendar) and the [Japanese Calendar](https://en.wikipedia.org/wiki/Japanese_calendar).

Implementations of these calendars are in the [System.Globalization](https://learn.microsoft.com/en-us/dotnet/api/system.globalization?view=net-9.0) namespace.

```csharp
var gregorianCalendar = new GregorianCalendar();
Console.WriteLine(gregorianCalendar.GetDaysInYear(2024));
```

When you use the other calendars, you may discover how complicated the concepts of a year, month, days in a month and days in a year are.

Let us rewrite the code to pass a known `DateTime`, 1 Jan 2024, and determine how many days are in the year for that `DateTime`.

```csharp
var dateTime = new DateTime(2024, 1, 1);

var gregorianCalendar = new GregorianCalendar();
Console.WriteLine($"Gregorian: {gregorianCalendar.GetDaysInYear(gregorianCalendar.GetYear(dateTime))}");

var hebrewCalendar = new HebrewCalendar();
Console.WriteLine($"Hebrew: {hebrewCalendar.GetDaysInYear(hebrewCalendar.GetYear(dateTime))}");

var hijiriCalendar = new HijriCalendar();
Console.WriteLine($"Hijri: {hijiriCalendar.GetDaysInYear(hebrewCalendar.GetYear(dateTime))}");

var koreanCalendar = new KoreanCalendar();
Console.WriteLine($"Korean: {koreanCalendar.GetDaysInYear(hebrewCalendar.GetYear(dateTime))}");
```

If you run this code, it should print the following:

```plaintext
Gregorian: 366
Hebrew: 383
Hijri: 355
Korean: 365
```

All the days are different!

I have mentioned that you probably will be using the [GregorianCalendar](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.gregoriancalendar?view=net-9.0). But if you are working with historical dates, especially dates before October 15, 1582, and you need to do date arithmetic - you will probably need to use the [JulianCalendar](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.juliancalendar?view=net-9.0).

There are also other calendars that have not (yet) been implemented in the base class library, such as the [Ethiopian Calendar](https://en.wikipedia.org/wiki/Ethiopian_calendar). But thanks to the wonders of Open Source Software, some people have implemented them, like [this one](https://github.com/eyuelberga/ethiopian-calendar).

The main takeaway is that **"days in a year" is a concept that only has proper meaning in the context of a particular calendar**.

Happy hacking!