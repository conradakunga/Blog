---
layout: post
title: .NET 11 Preview - Get Random Integral Numbers
date: 2026-06-29 18:38:54 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
---

In a previous post, "[Generating Random Values For Other Integral Types In C# & .NET]({% post_url 2025-09-24-generating-random-values-for-other-integral-types-in-c-net %})", we looked at the additional **gymnastics** needed to generate **random** values for other `integral` types, given that the [Next](https://learn.microsoft.com/en-us/dotnet/api/system.random.next?view=net-10.0) method for the [Random](https://learn.microsoft.com/en-us/dotnet/api/system.random?view=net-10.0) type was designed for integers.

This means that for a `byte`, you needed to do something like this:

```c#
var randomByte = (byte)Random.Shared.Next(byte.MinValue, byte.MaxValue + 1);

Console.WriteLine(randomByte);
```

We are doing `byte.MaxValue + 1` because the **upper bound is not included** in the range.

This is no longer necessary.

A new [generic method](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/generics/generic-methods) has been introduced for this very purpose: [NextInteger()](https://learn.microsoft.com/lv-lv/dotnet/api/system.random.nextinteger?view=net-11.0&viewFallbackFrom=net-10.0).

The equivalent code is as follows:

```c#
var randomByte = Random.Shared.NextInteger<byte>();

Console.WriteLine(randomByte);
```

The same exists for other **integral** types.

- `byte`
- `sbyte`
- `short`
- `ushort`
- `int`
- `uint`
- `long`
- `ulong`
- `nint`
- `nuint`

A `short`, for instance, is as follows:

```c#
var randomByte = Random.Shared.NextInteger<short>();

Console.WriteLine(randomByte);
```

Overloads that take a [range](https://learn.microsoft.com/lv-lv/dotnet/api/system.random.nextinteger?view=net-11.0#system-random-nextinteger-1(-0-0)) are also available.

Happy hacking!
