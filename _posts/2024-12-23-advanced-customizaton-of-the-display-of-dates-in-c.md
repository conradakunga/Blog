---
layout: post
title: Advanced Customization Of The Display Of Dates In C#
date: 2024-12-23 20:56:47 +0300
categories:
    - C#
    - Dates & Times
---

Displaying the parts of a date is a problem that has been solved pretty well - in C# we can make use of [format specifiers](https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings) that allow us complete flexibility in how to display dates.

Take, for example, if we were to display the current date, 23 Dec 2024.

```csharp
var currentDate = new DateOnly(2024,12,23);
Console.WriteLine(currentDate);
```

To print it as it is, the code will use the operating system settings to determine things like locale, date format, etc.

On my machine, it prints the following

```plaintext
23/12/2024
```

If we want to customize the display of the date, we can make use of format specifiers.

```csharp
var currentDate = new DateOnly(2024,12,23);
Console.WriteLine(currentDate.ToString("dd MMM yyyy"));
```

Here, we have specified:

1. `dd` - date, including leading zero
2. `MMM` - month, in short form
3. `yyyy` - year

Short form does not necessarily mean three letters. In French, June is *Juin,* and July is *Juillet*. The short forms for these are *juin* and *juil.* (note the full-stop).

We can establish this with this code, where we pass a format provider based on the culture we want (in this case, [fr-FR](https://simplelocalize.io/data/locales/))

```csharp
var juneDate = new DateOnly(2024, 6, 1);
var julyDate = new DateOnly(2024, 7, 1);

var frenchCulture = new CultureInfo("fr-FR");

Console.WriteLine(juneDate.ToString("dd MMM yyyy", frenchCulture));
Console.WriteLine(julyDate.ToString("dd MMM yyyy", frenchCulture));
```

This will print the following:

```plaintext
01 juin 2024
01 juil. 2024
```

Back to our code.

If we want the day of the week, we use the format specifier for full-day `dddd` or abbreviated day, `ddd`

```csharp
var currentDate = new DateOnly(2024, 12, 23);
Console.WriteLine(currentDate.ToString("dddd, dd MMM, yyyy"));
Console.WriteLine(currentDate.ToString("ddd, dd MMM, yyyy"));
```

This will print the following:

```plaintext
Monday, 23 Dec, 2024
Mon, 23 Dec, 2024
```

Suppose, for some reason, we wanted to change the abbreviated days of the week. 

Let us say we wanted to effect the following change:

| Current | Proposed |
| ------- | -------- |
| Mon     | Mond     |
| Tue     | Tues     |
| Wed     | Wedn     |
| Thu     | Thur     |
| Fri     | Frid     |
| Sat     | Satu     |
| Sun     | Sund     |

A format string will not help here. We have to make our modifications in the guts of the `culture` itself.

Rather than create a whole new culture, we can modify an existing one and specify our instructions.

```csharp
// Create a custom culture based on an existing one
var customCulture = CultureInfo.CreateSpecificCulture("en-KE");
// Get the date time format info
var dateTimeFormat = customCulture.DateTimeFormat;
// Set the abbreviated days
dateTimeFormat.AbbreviatedDayNames = ["Sund", "Mond", "Tues", "Wedn", "Thur", "Fri", "Satu"];

// Print sample dates
for (var i = 0; i < 7; i++)
{
  Console.WriteLine(currentDate.AddDays(i).ToString("ddd, d MMM, yyyy", customCulture));
}
```

This will print the following:

```plaintext
Mond, 23 Dec, 2024
Tues, 24 Dec, 2024
Wedn, 25 Dec, 2024
Thur, 26 Dec, 2024
Fri, 27 Dec, 2024
Satu, 28 Dec, 2024
Sund, 29 Dec, 2024
```

We can do the same thing for the months of the year - here I want to use their parent, Roman names..

| Current   | Proposed |
| --------- | -------- |
| January   | Janus    |
| February  | Februar  |
| March     | Mars     |
| April     | Aprilis  |
| May       | Maia     |
| June      | Juno     |
| July      | Julius   |
| August    | Augustus |
| September | Septa    |
| October   | Octa     |
| November  | Nona     |
| December  | Deca     |

We can update the code as follows:

```csharp
// Create a custom culture based on an existing one
var customCulture = CultureInfo.CreateSpecificCulture("en-KE");
// Get the date time format info
var dateTimeFormat = customCulture.DateTimeFormat;
// Set the month names
dateTimeFormat.MonthGenitiveNames = ["Janus", "Februar", "Mars", "Aprilis", "Maia", "Juno", "Julius", "Augustus", "Septa", "Octa", "Nona", "Deca", ""];

// Print sample dates
for (var i = 0; i < 12; i++)
{
  Console.WriteLine(currentDate.AddMonths(i).ToString("ddd, d MMMM, yyyy", customCulture));
}
```

This will print the following:

```plaintext
Mond, 23 Deca, 2024
Thur, 23 Janus, 2025
Sund, 23 Februar, 2025
Sund, 23 Mars, 2025
Wedn, 23 Aprilis, 2025
Fri, 23 Maia, 2025
Mond, 23 Juno, 2025
Wedn, 23 Julius, 2025
Satu, 23 Augustus, 2025
Tues, 23 Septa, 2025
Thur, 23 Octa, 2025
Sund, 23 Nona, 2025
```

BONUS

You can introduce a truly horrific behaviour by doing the following:

```csharp
dateTimeFormat.AbbreviatedDayNames = dateTimeFormat.AbbreviatedDayNames.OrderBy(x => Random.Shared.Next(6)).ToArray();
	dateTimeFormat.MonthGenitiveNames = dateTimeFormat.MonthGenitiveNames.OrderBy(x => Random.Shared.Next(11)).ToArray();
```

Happy hacking!