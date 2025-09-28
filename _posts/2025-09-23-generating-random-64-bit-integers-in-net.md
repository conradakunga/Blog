---
layout: post
title: Generating Random 64 Bit Integers In .NET
date: 2025-09-23 16:58:33 +0300
categories:
    - C#
    - .NET
---

When generating random integers in .NET, the goto is the [Next()](https://learn.microsoft.com/en-us/dotnet/api/system.random.next?view=net-9.0) method of the [Random](https://learn.microsoft.com/en-us/dotnet/api/system.random?view=net-9.0) class.

```c#
var randomNumber = Random.Shared.Next();

Console.WriteLine(randomNumber);
```

This will print something like this:

```plaintext
34234234
```



This, however, just gives you a 32 bit `integer` [int](https://learn.microsoft.com/en-us/dotnet/api/system.int32?view=net-9.0), bounded from [int.MinValue](https://learn.microsoft.com/en-us/dotnet/api/system.int32.minvalue?view=net-9.0) (-2,147,483,648) and [int.MaxValue](https://learn.microsoft.com/en-us/dotnet/api/system.int32.maxvalue?view=net-9.0) (`2,147,483,648`)

What if you wanted a larger number, an 64 bit integer - [Int64](https://learn.microsoft.com/en-us/dotnet/api/system.int64?view=net-9.0) (or `long`).

This is bounded by [long.MinValue](https://learn.microsoft.com/en-us/dotnet/api/system.int64.minvalue?view=net-9.0) (`-9,223,372,036,854,775,808`) and [long.MaxValue](https://learn.microsoft.com/en-us/dotnet/api/system.int64.maxvalue?view=net-9.0) (`-9,223,372,036,854,775,808`)

Integral **types** and their **sizes** is covered in the post [The Other Integer Types]({% post_url 2021-05-24-the-other-integer-types %})

The `Random` class  supports this via the [NextInt64()](https://learn.microsoft.com/en-us/dotnet/api/system.random.nextint64?view=net-9.0) method.

```c#
var randomNumber = Random.Shared.NextInt64();

Console.WriteLine(randomNumber);
```

This will print something like this:

```plaintext
8588670651705391622
```

### TLDR

**The `Random` class supports generation of 64 bit integers using the `NextInt64()` method.**

Happy hacking!
