---
layout: post
title: Getting The Time In Different Timezones In C# & .NET
date: 2025-10-01 22:12:37 +0300
categories:
    - C#
    - .NET
---

One of the realities of modern living in 2025 is that **the world is truly a melting pot**, and people are **distributed all over** it.

Many of my closest friends, by circumstance, are not in [Kenya](https://magicalkenya.com/) and are **truly distributed** all over the world.

Despite my best efforts, it is not possible to remember when it is 8:00 PM my time (Nairobi), **what time it is wherever they are**.

Perhaps I can build a small utility for this purpose?

Very simply, given a time, it prints for me what time it is in other [time zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) that I am interested in.

| City              | Time Zone           |
| ----------------- | ------------------- |
| **Algiers**       | Africa/Algiers      |
| **Wollongong**    | Australia/Sydney    |
| **London**        | Europe/London       |
| **Dublin**        | Europe/Dublin       |
| **Cape Town**     | Africa/Johannesburg |
| **San Francisco** | America/Los_Angeles |

The package [NodaTime](https://nodatime.org/) can assist with the actual heavy lifting.

We start off with a simple `type` to hold the **city** and **time zone**:

```c#
internal record ZoneInfo(string City, string TimeZone);
```

Then the code that does the actual work:

```c#
// Print current system date
Console.WriteLine($"It is {DateTime.Now:ddd, d MMM yyyy h:mm tt} in Nairobi");
Console.WriteLine();

// Get the current time as an Instant
var now = SystemClock.Instance.GetCurrentInstant();

// Build an array of zone info types
ZoneInfo[] zones =
[
    new("Algiers", "Africa/Algiers"),
    new("Atlanta", "America/Los_Angeles"),
    new("Wollongong", "Australia/Sydney"),
    new("London", "Europe/London"),
    new("Dublin", "Europe/Dublin"),
    new("Cape Town", "Africa/Johannesburg"),
    new("San Francisco", "America/Los_Angeles")
];

// Build the display pattern for the date and time
var pattern = ZonedDateTimePattern.CreateWithInvariantCulture("ddd d MMM yyyy, h:mm tt", DateTimeZoneProviders.Tzdb);

foreach (var zone in zones.OrderBy(x => x.City))
{
    // Get the current zone date time
    var zonedDateTime = now.InZone(DateTimeZoneProviders.Tzdb[zone.TimeZone]);
    // Output
    Console.WriteLine($"{zone.City} - {pattern.Format(zonedDateTime)}");
}
```

This prints something like this:

```plaintext
It is Wed, 1 Oct 2025 11:00 PM in Nairobi

Algiers - Wed 1 Oct 2025, 9:00 PM
Atlanta - Wed 1 Oct 2025, 1:00 PM
Cape Town - Wed 1 Oct 2025, 10:00 PM
Dublin - Wed 1 Oct 2025, 9:00 PM
London - Wed 1 Oct 2025, 9:00 PM
San Francisco - Wed 1 Oct 2025, 1:00 PM
Wollongong - Thu 2 Oct 2025, 6:00 AM
```

Now I can tell whether it is a **reasonable** hour to call or [Whatsapp](https://www.whatsapp.com/) my friends.

### TLDR

**`NodaTime` is a powerful library that can assist in the conversion and display of dates across time zones.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-10-01%20-%20TimezoneInfo).

Happy hacking!
