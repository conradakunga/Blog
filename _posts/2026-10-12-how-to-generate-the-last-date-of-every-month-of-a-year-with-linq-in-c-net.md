---
layout: post
title: How To Generate The Last Date Of Every Month Of A Year With LINQ In C# & .NET
date: 2026-10-12 15:08:37 +0300
categories:
    - C#
    - .NET
    - LINQ
---

I recently need to generate the **last day of each month**, for some processing in an algorithm.

The default goto would be this:

```c#
public IEnumerable<DateOnly> GetDatesInYear(int year)
{
  var temp = new DateOnly(year, 1, 1);
  while (temp.Year == year)
  {
    yield return temp.AddMonths(1).AddDays(-1);
    temp = temp.AddMonths(1);
  }
}

```

Straightforward enough.

You can also achieve the same thing using a [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) expression.

```c#
public IEnumerable<DateOnly> GetDatesInYear(int year)
{
	return Enumerable.Range(1, 12).Select(x => new DateOnly(year, x, DateTime.DaysInMonth(year, x)));
}
```

This can be **visualized** with this harness:

```c#
var year = 2026;
foreach (var date in GetDatesInYear(year))
{
	Console.WriteLine(date);
}
```

![firstDayOfMonth](../images/2026/10/lastDayOfMonth.png)


The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-10-11%20-%20FirstDayOfMonth).

Happy hacking!
