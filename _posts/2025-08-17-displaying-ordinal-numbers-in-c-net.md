---
layout: post
title: Displaying Ordinal Numbers In C# & .NET
date: 2025-08-17 20:12:21 +0300
categories:
    - C#
    - .NET
    - StarLibrary
    - Humanizer
---

Suppose you wanted to present some dates like this:

- 1st August 2025
- 2nd August 2025
- 3rd August 2025
- 4th August 2025

Or some other data like this:

- The 1st date
- The 2nd date
- The 3d date
- The 4th date

The parts 1<sup>st</sup>, 2<sup>nd</sup>, 3<sup>rd</sup>, 4<sup>th</sup> are called [ordinal numerals](https://en.wikipedia.org/wiki/Ordinal_numeral).

Currently, **there is no provision for this** in any of the .[NET format strings](https://learn.microsoft.com/en-us/dotnet/standard/base-types/formatting-types).

However, our old and trusted friend [Humanizer](https://github.com/Humanizr/Humanizer) can help with this problem.

For the dates, we can display them as follows:

```c#
DateOnly[] dates = [
  new DateOnly(2025, 8, 1),
  new DateOnly(2025, 8, 2),
  new DateOnly(2025, 8, 3),
  new DateOnly(2025, 8, 4)
];

foreach (var date in dates)
{
  Console.WriteLine($"- {date.Day.Ordinalize()} {date:MMM} {date:yyyy}");
}
```

This will output the following:

```plaintext
- 1st Aug 2025
- 2nd Aug 2025
- 3rd Aug 2025
- 4th Aug 2025
```

The magic is happening in the `Ordinalize()` method.

Our second example we can resolve like this:

```c#
var numbers = Enumerable.Range(1, 4);
foreach (var number in numbers)
{
  Console.WriteLine($"- The {number.Ordinalize()} date");
}
```

This will print the following:

```plaintext
- The 1st date
- The 2nd date
- The 3rd date
- The 4th date
```

### TLDR

**Humanizer has an `Orinalize()` method that allows you to print oridinal numbers.**

Happy hacking!
