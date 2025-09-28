---
layout: post
title: Generating Random Unsigned 64 Bit Integers In C# & .NET
date: 2025-09-26 18:08:46 +0300
categories:
    - C#
    - .NET
---

In a previous post, ["Generating Random Values For Other Integral Types In C# & .NET"]({% post_url 2025-09-24-generating-random-values-for-other-integral-types-in-c-net %}) we looked at the challenges of generating **random values for other integral types**, outlined here in the post ["The Other Integer Types"]({% post_url 2021-05-24-the-other-integer-types %}).

One of the types outlined was the **unsigned** `64` bit `integer`, [ulong](https://learn.microsoft.com/en-us/dotnet/api/system.int64).

We cannot use the [Next64()](https://learn.microsoft.com/en-us/dotnet/api/system.random.nextint64?view=net-9.0) method of the [Random](https://learn.microsoft.com/en-us/dotnet/api/system.random?view=net-9.0) class for this purpose, as it returns an `64` bit `integer` ([long](https://learn.microsoft.com/en-us/dotnet/api/system.uint64)) that is constrained between `-9223372036854775808` and `9223372036854775807`.

The **unsigned** `64` bit `integer`, `ulong`, however, is constrained between `0` and `18446744073709551615`.

This means that the largest signed `integer` is **too smal**l to accommodated the largest **unsigned** `integer`.

Luckily, there is a solution to this problem.

We can make use of the fact that the [Random](https://learn.microsoft.com/en-us/dotnet/api/system.random?view=net-9.0) class can generate random bytes using the [NextBytes()](https://learn.microsoft.com/en-us/dotnet/api/system.random.nextbytes?view=net-9.0) method, and make use of this to fill an `array` of a known size.

Given a `ulong` is `64` bits, we need an array of `8` bytes.

The code will look something like this:

```c#
// Create a 64 bit array
var randomNumberBytes = new byte[8];
// Fill with random bytes
Random.Shared.NextBytes(randomNumberBytes);
// Convert to an unsinged int64 (long)
var randomNumber = BitConverter.ToUInt64(randomNumberBytes);
Console.WriteLine(randomNumber);
```

### TLDR

We can generate random bytes to fill a 64 bit buffer, and use that to generate unsigned 64 bit integers.

The code is in my GitHub.

Happy hacking!
