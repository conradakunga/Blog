---
layout: post
title: The Difference Between String.Format and ToString
date: 2025-08-20 15:50:56 +0300
categories:
    - C#
    - .NET
---

In the last post, [Adding Ordinal Support To DateTime Format Strings In C# & .NET]({% post_url 2025-08-19-adding-ordinal-support-to-datetime-format-strings-in-c-net %}) we looked at how to implement robust support for ordinal format strings.

This allows us to write code like this:

```c#
var date = DateTime.Now.AddDays(-2);
Console.WriteLine(string.Format(new OrdinalDateFormatProvider(), "{0:do MMM}", date));
Console.WriteLine(string.Format(new OrdinalDateFormatProvider(), "{0:MMM do MMM}", date));
```

This will print the following:

```plaintext
20th Aug
Aug 20th Aug
```

I however noticed something curious when I attempted to use the [ToString()](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.tostring?view=net-9.0) method of the [DateTime](https://learn.microsoft.com/en-us/dotnet/api/system.datetime?view=net-9.0). Indeed, there is an [overload](https://learn.microsoft.com/en-us/dotnet/api/system.datetime.tostring?view=net-9.0#system-datetime-tostring(system-iformatprovider)) supporting passing of am [IFormatProvider](https://learn.microsoft.com/en-us/dotnet/api/system.iformatprovider?view=net-9.0).

```c#
Console.WriteLine(date.ToString("do MMM yyyy", new OrdinalDateFormatProvider()));
```

This prints the following:

```plaintext
20o Aug 2025
```

You can see here that the ordinal format string , `o`, is **ignored**.

I found this curious, because on paper it should work.

I turns out that how `ToString()` and `String.Format()` work are different.

`String.Format()` direcly **delegates the formatting to the specified provider**. It is up to the provider to either **handle** it or **delegate** it further..

`ToString()` however **works the other way, and to get it to use the custom one, the entire string, treated as a block, must be rejected but the default provider**.

In this case, it is recognizing `MMM` as a valid string **and deciding to use that instead**.

### TLDR

To have maximum flexibility, use string.Format to be in full control of how your data is formatted.

Happy hacking!
