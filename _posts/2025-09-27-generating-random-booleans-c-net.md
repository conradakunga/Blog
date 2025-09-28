---
layout: post
title: Generating Random Booleans C# & .NET
date: 2025-09-27 18:54:43 +0300
categories:
    - C#
    - .NET
---

[Over]({% post_url 2025-09-23-generating-random-64-bit-integers-in-c-net %}) [the]({% post_url 2025-09-24-generating-random-values-for-other-integral-types-in-c-net %}) [past]({% post_url 2025-09-25-generating-random-unsigned-integers-in-c-net %}) [week]({% post_url 2025-09-26-generating-random-unsigned-64-bit-integers-in-c-net %}), we have been looking at some of the challenges of generating random values of the various **integral** types from `bytes` to **unsigned** 64 bit `integers`.

There is, however, a case that you will encounter - generating a **random** `boolean`.

This is a common use case for scenarios where you need to generate a **choice**, like a coin toss.

A simple way to achieve this is to use [Random.Next()](https://learn.microsoft.com/en-us/dotnet/api/system.random.next?view=net-9.0), and pass an upper bound of `2`.

This means you will either get back a `0` or a `1`, that you can map to `false` and `true`.

```c#
 Random.Shared.Next(2) == 0;
```

Another is to use [Random.NextDouble()](https://learn.microsoft.com/en-us/dotnet/api/system.random.nextdouble?view=net-9.0), which returns a `double` value between `0.0` and `1.0`, and check if that is < `0.5`.

```c#
Random.Shared.NextDouble() < 0.5;
```

For most purposes, these techniques are **good enough**.

If, however, for security purposes you require a [cryptographically secure](https://en.wikipedia.org/wiki/Cryptographically_secure_pseudorandom_number_generator) random generator, you can use the [RandomNumberGenerator](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.randomnumbergenerator?view=net-9.0) for this purpose, using its [Fill](https://learn.microsoft.com/en-us/dotnet/api/system.security.cryptography.randomnumbergenerator.fill?view=net-9.0) method to generate random values into a buffer.

Your code would look like this:

```c#
using System.Security.Cryptography;

// Create a single random byte buffer
Span<byte> buffer = stackalloc byte[1];
// Fill buffer with the random number generator
RandomNumberGenerator.Fill(buffer);
// Use the lowest bit to determine true or false
var randomBoolean = (buffer[0] & 1) == 1;

// Output
Console.WriteLine(randomBoolean);
```

### TLDR

The `Random` class can also be used to generate random `boolean` values. For cryptographically secure purposes, the `RandomNumberGenerator` can be used.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-09-27%20-%20RandomBoolean).

Happy hacking!
