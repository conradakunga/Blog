---
layout: post
title: Displaying User-Friendly TimeSpans In C# & .NET
date: 2025-07-24 16:43:17 +0300
categories:
    - C#
    - .NET
    - StarLibrary
    - Humanizer
---

A [TimeSpan](https://learn.microsoft.com/en-us/dotnet/api/system.timespan?view=net-9.0) can be defined as the difference between two [DateTime](https://learn.microsoft.com/en-us/dotnet/api/system.datetime?view=net-9.0) objects, an interval.

For example, take the following code, which captures the **current time**, **waits** 65 seconds, captures the **current time again**, and computes the **difference**.

```c#
// Capture the current time
var start = DateTime.Now;
// Wait 65 seconds
await Task.Delay(TimeSpan.FromSeconds(65));
var stop = DateTime.Now;
// Capture the current time
var diff = stop - start;
```

The variable diff here is a `TimeSpan`.

How do we display this?

We have a number of options.

We can display it in **minutes**, using the [TotalMinutes](https://learn.microsoft.com/en-us/dotnet/api/system.timespan.totalminutes?view=net-9.0) property, like this:

```c#
Console.WriteLine(diff.TotalMinutes);
```

This will print the following:

```plaintext
1.0833333333333333
```

This means that there is a complete minute (`60`/`60`), and 0.833 of a minute (`5`/`60`)

We can also display it in seconds, using the [TotalSeconds](https://learn.microsoft.com/en-us/dotnet/api/system.timespan.totalminutes?view=net-9.0) property like this:

```plaintext
Console.WriteLine(diff.TotalSeconds);
```

This will print the following:

```plaintext
65
```

But what if we wanted to show **both**?

This requires a little more work and uses the [Minutes](https://learn.microsoft.com/en-us/dotnet/api/system.timespan.minutes?view=net-9.0) and [Seconds](https://learn.microsoft.com/en-us/dotnet/api/system.timespan.seconds?view=net-9.0) property. We have discussed the difference in the post [Tip - TimeSpan Minutes vs TotalMinutes]({% post_url 2021-06-11-tip-timespan-minutes-vs-totalminutes %})

```c#
Console.WriteLine($"{diff.Minutes} minute and {diff.Seconds} seconds");
```

This will print the following:

```plaintext
1 minute and 5 seconds
```

What if the duration were **longer**? 

```c#
diff = TimeSpan.FromSeconds(4000);
```

We have the same challenge in terms of how to display this. We can do it in **hours**, in **minutes**, in **seconds**, or any combination thereof.

```c#
Console.WriteLine($"{diff.Hours} hour, {diff.Minutes} minutes and {diff.Seconds} seconds");
```

This prints the following:

```plaintext
1 hour, 6 minutes and 40 seconds
```

The problem arises when we pass this code a very **small** `Timespan`.

```c#
diff = TimeSpan.FromSeconds(1.5);
```

This prints the following:

```plaintext
0 hour, 0 minutes and 1 seconds
```

Things get complicated if there are **even smaller units** - the `TimeSpan` can also display **milliseconds**, **microseconds,** and **nanoseconds**. 

There are also larger units; the `TimeSpan` can represent **days**.

In short, if we have `TimeSpans` that can be of arbitrary size, displaying them in a user-friendly way can be very problematic.

The solution to this is the [Humanizer](https://github.com/Humanizr/Humanizer) library, specifically the `Humanize` method.

Let us demonstrate using some simple scenarios.

```c#
var diff = TimeSpan.FromHours(180);
Console.WriteLine(diff.Humanize());

diff = TimeSpan.FromHours(168);
Console.WriteLine(diff.Humanize());

diff = TimeSpan.FromHours(60);
Console.WriteLine(diff.Humanize());

diff = TimeSpan.FromHours(50);
Console.WriteLine(diff.Humanize());

diff = TimeSpan.FromMinutes(65);
Console.WriteLine(diff.Humanize());

diff = TimeSpan.FromMinutes(60);
Console.WriteLine(diff.Humanize());

diff = TimeSpan.FromSeconds(65);
Console.WriteLine(diff.Humanize());

diff = TimeSpan.FromSeconds(60);
Console.WriteLine(diff.Humanize());

diff = TimeSpan.FromMilliseconds(1300);
Console.WriteLine(diff.Humanize());

diff = TimeSpan.FromMilliseconds(1000);
Console.WriteLine(diff.Humanize());
```

This will print the following:

```plaintext
1 week
1 week
2 days
2 days
1 hour
1 hour
1 minute
1 minute
1 second
1 second

```

It is technically correct, but upon closer examination, you will notice a slight **loss of accuracy**.

We can fix this by specifying the **desired precision** as a parameter to the `Humanize` method.

```plaintext
1 week, 12 hours
1 week
2 days, 12 hours
2 days, 2 hours
1 hour, 5 minutes
1 hour
1 minute, 5 seconds

```

The `2` here indicates we want the time in its **two largest representative units**.

It can be as accurate as you like. If the data were even more granular, we can specify `3`.

```c#
diff = TimeSpan.FromHours(180.5);
Console.WriteLine(diff.Humanize(3));

diff = TimeSpan.FromHours(168.5);
Console.WriteLine(diff.Humanize(3));

diff = TimeSpan.FromHours(60.5);
Console.WriteLine(diff.Humanize(3));

diff = TimeSpan.FromHours(50.5);
Console.WriteLine(diff.Humanize(3));

diff = TimeSpan.FromMinutes(65.5);
Console.WriteLine(diff.Humanize(3));

diff = TimeSpan.FromMinutes(60.5);
Console.WriteLine(diff.Humanize(3));

diff = TimeSpan.FromSeconds(65.5);
Console.WriteLine(diff.Humanize(3));
```

This will print the following:

```plaintext
1 week, 12 hours, 30 minutes
1 week, 30 minutes
2 days, 12 hours, 30 minutes
2 days, 2 hours, 30 minutes
1 hour, 5 minutes, 30 seconds
1 hour, 30 seconds
1 minute, 5 seconds, 500 milliseconds
```

As an added bonus, `Humanizer` takes care of the correct pluralization of the time units, as discussed in the post [Pet Peeve - Properly Pluralizing Counts In C# & .NET]({% post_url 2025-07-16-pet-peeve-properly-pluralizing-counts-in-c-net %}).

Another bonus is that the `TimeSpan` allows the display of larger **intervals** - **weeks**, **months**, **years**.

### TLDR

**The `Humanizer` package contains extension methods that can be very useful for displaying `TimeSpan` in a human-readable way.**

The code is in my GitHub.

Happy hacking!
