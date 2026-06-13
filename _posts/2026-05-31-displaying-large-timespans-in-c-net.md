---
layout: post
title: Displaying Large TimeSpans In C# & .NET
date: 2026-05-31 22:13:50 +0300
categories:
    - C#
    - NET
    - StarLibrary
---

In a post last year, "[Displaying User-Friendly TimeSpans In C# & .NET]({% post_url 2025-07-24-displaying-user-friendly-timespans-in-csharp-net %})", we looked at how to display [TimeSpans](https://learn.microsoft.com/en-us/dotnet/api/system.timespan?view=net-10.0) in a **user-friendly** way using the [Humanizer](https://github.com/humanizr/humanizer) [nuget](https://www.nuget.org/) package.

This allows you to have code like this:

```c#
var diff = TimeSpan.FromHours(180.5);
Console.WriteLine(diff.Humanize(3));
```

Display like this:

```plaintext
1 week, 12 hours, 30 minutes
```

When the `TimeSpan` has a much **larger** range, you run into a **complication**.

```c#
var age = DateTime.Now - new DateTime(2010, 1, 1);
Console.WriteLine($"The duration is {age.Humanize()}");
```

This code will print the following:

```plaintext
The duration is 856 weeks
```

This is, technically, absolutely **true**. However, most people **do not think in weeks** when we have such a **large range**.

Typically, you'd want this to display in **years** and **weeks**.

This can be addressed in `Humanizer` by passing some parameters to the Humanize() method.

1. The largest unit to use, `maxUnit`
2. The `precision`

```c#
Console.WriteLine($"The duration is {age.Humanize(maxUnit: TimeUnit.Year, precision: 2)}");
```

This will print the following:

```plaintext
The duration is 16 years, 4 months
```

We can make it more **accurate** by **increasing the precision**:

```c#
Console.WriteLine($"The duration is {age.Humanize(maxUnit: TimeUnit.Year, precision: 3)}");
```

This will print the following:

```plaintext
The duration is 16 years, 4 months, 30 days
```

### TLDR

**You can customize the display or large `TimeSpans` by passing parameters for `maxUnit` and `precision`.**

Happy hacking!
