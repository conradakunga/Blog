---
layout: post
title: Locale Considerations When Parsing Dates
date: 2025-06-16 21:12:03 +0300
categories:
    - C#
    - .NET
---

The previous post, [Don't Parse - TryParse]({% post_url 2025-06-15-dont-parse-tryparse %}), talked about the safe way to attempt parsing of data and check for success.

However, whenever we parse data, we seldom consider [localization](https://en.wikipedia.org/wiki/Language_localisation) issues.

For example, here is code that prints the data in 4 different [locales](https://learn.microsoft.com/en-us/dotnet/core/extensions/localization):

```c#
// Japan
Thread.CurrentThread.CurrentCulture = new CultureInfo("ja-JP");
Console.WriteLine(DateTime.Now);
// Kenya (English)
Thread.CurrentThread.CurrentCulture = new CultureInfo("en-KE");
Console.WriteLine(DateTime.Now);
// German
Thread.CurrentThread.CurrentCulture = new CultureInfo("de-DE");
Console.WriteLine(DateTime.Now);
// USA (English)
Thread.CurrentThread.CurrentCulture = new CultureInfo("en-US");
Console.WriteLine(DateTime.Now);
```

This code will print the following:

```plaintext
2025/06/16 21:32:29
16/06/2025 21:32:29
16.06.2025 21:32:29
6/16/2025 9:32:29 PM
```

You can see here that for **each** of those locales, the date is in a different **format**, with different **separators**.

Why is this rellevant?

Because that becomes a problem during **parsing**.

You need to provide some information to the runtime so that it knows how to parse your dates.

There are three ways to go about it:

### Set The Local For The Application

In this technique, we configure the application or thread locale and then parse our data as usual. The simplest way is by setting the [CurrentCulture](https://learn.microsoft.com/en-us/dotnet/fundamentals/runtime-libraries/system-globalization-cultureinfo-currentculture) of the [thread](https://learn.microsoft.com/en-us/dotnet/standard/threading/using-threads-and-threading). Here, the `thread` can be from any application - console, class library, web application, etc.

```c#
var japanDate = "2025/06/16 21:32:29";
Thread.CurrentThread.CurrentCulture = new CultureInfo("ja-JP");
_ = DateTime.Parse(japanDate);
var kenyaDate = "16/06/2025 21:32:29";
Thread.CurrentThread.CurrentCulture = new CultureInfo("en-KE");
_ = DateTime.Parse(kenyaDate);
var germanyDate = "16.06.2025 21:32:29";
Thread.CurrentThread.CurrentCulture = new CultureInfo("de-DE");
_ = DateTime.Parse(germanyDate);
var usaDate = "6/16/2025 9:32:29 PM";
Thread.CurrentThread.CurrentCulture = new CultureInfo("en-US");
_ = DateTime.Parse(usaDate);
```

### Set The Locale During Parsing

In this technique, we provide the locale information **during** parsing.

```c#
japanDate = "2025/06/16 21:32:29";
_ = DateTime.Parse(japanDate, new CultureInfo("ja-JP"));
kenyaDate = "16/06/2025 21:32:29";
Thread.CurrentThread.CurrentCulture = new CultureInfo("en-KE");
_ = DateTime.Parse(kenyaDate, new CultureInfo("en-KE"));
germanyDate = "16.06.2025 21:32:29";
_ = DateTime.Parse(germanyDate, new CultureInfo("de-DE"));
usaDate = "6/16/2025 9:32:29 PM";
_ = DateTime.Parse(usaDate, new CultureInfo("en-US"));
```

### Provide The Exact Format String For Parsing

In this technique, we provide the [format string](https://learn.microsoft.com/en-us/dotnet/standard/base-types/standard-numeric-format-strings) for parsing (assuming it is known in **advance**, or can be provided at **runtime**).

```c#
panDate = "2025/06/16 21:32:29";
_ = DateTime.ParseExact(japanDate, "yyyy/MM/dd HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None);
kenyaDate = "16/06/2025 21:32:29";
_ = DateTime.ParseExact(kenyaDate, "dd/MM/yyyy HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None);
germanyDate = "16.06.2025 21:32:29";
_ = DateTime.ParseExact(germanyDate, "dd.MM.yyyy HH:mm:ss", CultureInfo.InvariantCulture, DateTimeStyles.None);
usaDate = "6/16/2025 9:32:29 PM";
_ = DateTime.ParseExact(usaDate, "M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture, DateTimeStyles.None);
```

Note in this technique that **no culture information is provided for parsing** - the format string alone is used to perform the parsing. If there is a mismatch, an `exception` will be thrown.

This is the most flexible technique.

**The [DateTime.TryParse](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.tryparse?view=net-9.0) method has overloads supporting these techniques.**

### TLDR

**Do not make any assumptions about the format of your data before parsing. Set the locale directly or use the relevant `ParseExact` method.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-06-16%20-%20Parsing%20%26%20Locales)

Happy hacking!
