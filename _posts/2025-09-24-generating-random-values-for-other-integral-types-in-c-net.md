---
layout: post
title: Generating Random Values For Other Integral Types In C# & .NET
date: 2025-09-24 17:18:13 +0300
categories:
    - C#
    - .NET
---

In our last post, ["Generating Random 64 Bit Integers In C# & .NET"]({% post_url 2025-09-23-generating-random-64-bit-integers-in-c-net %}), we looked at how to generate `64` bit `integral` values.

But, as we had discussed before in the post  ["The Other Integer Types"]({% post_url 2021-05-24-the-other-integer-types %}), there are a number of other `integral` types:

- [sbyte](https://learn.microsoft.com/en-us/dotnet/api/system.sbyte)
- [byte](https://learn.microsoft.com/en-us/dotnet/api/system.byte)
- [short](https://learn.microsoft.com/en-us/dotnet/api/system.int16)
- [ushort](https://learn.microsoft.com/en-us/dotnet/api/system.uint16)
- [uint](https://learn.microsoft.com/en-us/dotnet/api/system.uint32)
- [ulong](https://learn.microsoft.com/en-us/dotnet/api/system.uint64)

Suppose we wanted to generate **random** values for these?

The [Random](https://learn.microsoft.com/en-us/dotnet/api/system.random?view=net-9.0) class **does not have equivalent methods** for these.

But this is not a problem.

For `sbyte`, `byte`, `short`, `ushort` we can make use of the fact that all these are smaller than the `32` bit `integer`, int.

And this we can make use of the [Next()](https://learn.microsoft.com/en-us/dotnet/api/system.random.next?view=net-9.0#system-random-next(system-int32-system-int32)) overload that accepts bounds.

Note that this overload is exclusive of the upper bound, so we have to add `1` to our bounds.

## Byte

The `byte` is an `8` bit `integer` constrained between `0` and `255`.

We can generate one as follows:

```c#
var randomByte = (byte)Random.Shared.Next(byte.MinValue, byte.MaxValue + 1);

Console.WriteLine(randomByte);
```

## Sbyte

The `sbyte` (singed `byte`) is an `8` bit `integer` constrained between `-128` and `127`.

We can generate one as follows:

```c#
var randomsByte = (sbyte)Random.Shared.Next(sbyte.MinValue, sbyte.MaxValue + 1);

Console.WriteLine(randomsByte);
```

## Short

The `short` is a `16` bit `integer` constrained between `-32,768` and `32,767`.

We can generate one as follows:

```c#
var randomShort = (short)Random.Shared.Next(short.MinValue, short.MaxValue + 1);

Console.WriteLine(randomShort);
```

## Ushort

The `ushort` (unsigned `short`) is a `16` bit integer is constrained between `0` and `65,535`.

We can generate one as follows:

```c#
var randomuShort = (ushort)Random.Shared.Next(ushort.MinValue, ushort.MaxValue + 1);

Console.WriteLine(randomuShort);
```

We will look at how to generate a random `uint` and `ulong` in future posts.

### TLDR

**We can make use of the `Random` class to contrain the bounds of generated values to generate random values of integral types.**

The code is in my GitHub.

Happy hacking!
