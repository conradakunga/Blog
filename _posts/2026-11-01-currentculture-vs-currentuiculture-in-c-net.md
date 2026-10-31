---
layout: post
title: CurrentCulture vs CurrentUICulture In C# & .NET
date: 2026-11-01 11:06:15 +0300
categories:
    - C#
    - .NET
---

In our previous post, "[Dynamically Changing Date Separators at Runtime in C# & .NET]({% post_url 2026-10-31-dynamically-changing-date-separators-at-runtime-in-c-net %})",  and a bunch of others, like "[Dynamically Changing Decimal & Thousand Separators At Runtime]({% post_url 2025-12-14-dynamically-changing-decimal-thousand-separators-at-runtime %})", we have been modifying the [culture](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.cultureinfo?view=net-10.0) that the current [thread](https://learn.microsoft.com/en-us/dotnet/api/system.threading.thread?view=net-10.0) is running under.

Like so:

```c#

// Clone the current culture, to use as a base
var culture = CultureInfo.InvariantCulture.Clone() as CultureInfo;

// Modify what we want to change - the date separator
culture!.DateTimeFormat.DateSeparator = "+";

// Set the thread's culture to our new culture
Thread.CurrentThread.CurrentCulture = culture;
```

[CurrentCulture](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.cultureinfo.currentculture?view=net-10.0) here instructs the runtime **how** to carry out various operations when it comes to the **formatting** and **display** of data.

There is a similarly named property, [CurrentUICulture](https://learn.microsoft.com/en-us/dotnet/api/system.globalization.cultureinfo.currentuiculture?view=net-10.0) that occasionally **trips me up**.

This is an entirely **different thing**, as its purpose is **user interface localization**. This is what controls the **captions** of various elements of the user interface.

For example, a user might want to use an **English** interface but display data using **French** localization.

In which case you can achieve this programmatically as follows:

```c#
// Set UI to english
Thread.CurrentThread.CurrentUICulture = new CultureInfo("en-GB");

// Set formatting & other aspects to french	
Thread.CurrentThread.CurrentUICulture = new CultureInfo("fr-FR");
```

So your buttons and other elements would use **English** (typically specified using resource files) but the logic around parsing and displaying wound use **French**.

### TLDR

**`CurrentUICulture` controls the user interface elements while `CurrentCulture` controls formatting and parsing of data.**
