---
layout: post
title: Beware - ParseExact Over Parse When Processing Dates In C# & .NET
date: 2025-11-23 17:12:47 +0300
categories:
    - C#
    - .NET
---

Parsing data to convert to types is always going to be a minefield.

Take this simple example.

```c#
var dateString = "2/1/2025";
var date = DateTime.Parse(dateString);
Console.WriteLine(date.ToString("d MMM yyyy"));
```

This parses the `string`  "**2/1/2025**" into a DateTime.

This prints the following:

```plaintext
2 Jan 2025
```

It happens to print this because my machine is set to the locale `en-KE`, where the **short date** format is **day/month/year**.

If I change my locale, either in my system settings or in code, I get very different results:

```c#
Thread.CurrentThread.CurrentCulture = new CultureInfo("en-gb");
var dateString = "2/1/2025";
var date = DateTime.Parse(dateString);
Console.WriteLine(date.ToString("d MMM yyyy"));
```

Here I am changing the locale to `en-US`, where the **short date** format is **month/day/year**

This prints the following:

```plaintext
1 Feb 2025
```

A completely different result!

Give you cannot control the user's settings, you have to tell the runtime what to do in all situations.

For this, we use the ParseExact method.

```c#
var dateString = "2/1/2025";
if (DateTime.TryParseExact(dateString, ParseFormat, CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime date))
{
  Console.WriteLine(date.ToString("d MMM yyyy"));
}
else
{
  Console.WriteLine($"Could not parse {dateString} in the format {ParseFormat}");
}
```

Here, I am using [TryParseExact](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.tryparseexact?view=net-10.0) rather than the direct [ParseExact](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.parseexact?view=net-10.0) because I want to **inform the user when parsing fails**.

We have discussed [TryParse]({% post_url 2025-06-15-dont-parse-tryparse %}) before.

Now, the **locale does not matter** - we always get the same result:

```c#
string[] cultures = ["en-US", "en-GB", "fr-FR", "es-ES"];
foreach (var culture in cultures)
{
  Thread.CurrentThread.CurrentCulture = new CultureInfo(culture);
  const string ParseFormat = "d/M/yyyy";
  var dateString = "2/1/2025";
  if (DateTime.TryParseExact(dateString, ParseFormat, CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime date))
  {
    Console.WriteLine($"{culture} - {date.ToString("d MMM yyyy")}");
  }
  else
  {
    Console.WriteLine($"Could not parse {dateString} in the format {ParseFormat}");
  }
}
```

This code prints the following:

```plaintext
en-US - 2 Jan 2025
en-GB - 2 Jan 2025
fr-FR - 2 janv. 2025
es-ES - 2 ene 2025
```

Here we can see that regardless of the culture, we always get back **2 January, 2025**.

### TLDR

**Prefer `TryParseExact` and `ParseExact` over `TryParse` and `Parse`**

The code is in my GitHub.

Happy hacking!
