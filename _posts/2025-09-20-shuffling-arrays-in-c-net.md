---
layout: post
title: Shuffling Arrays In C# & .NET
date: 2025-09-20 11:28:42 +0300
categories:
    - C#
    - .NET
---

If you have an array of numbers (of any numeric type) and you need to shuffle it, you have two options.

## Random Ordering

The first is to use the [Random](https://learn.microsoft.com/en-us/dotnet/api/system.random?view=net-9.0) object to order the values randomly using [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/), and [project](https://learn.microsoft.com/en-us/dotnet/csharp/linq/standard-query-operators/projection-operations) that into a new `array`.

Like so:

```c#
var numbers = Enumerable.Range(1, 25).ToArray();

var shuffled = numbers.OrderBy(n => Random.Shared.Next()).ToArray();

foreach (var number in shuffled)
{
  Console.Write($"{number} ");
}
```

This code will print something like this:

```plaintext
3 6 7 15 18 9 24 12 10 16 1 20 4 2 17 8 5 11 19 25 21 23 13 22 14 
```

## Random Shuffle

This was such a common situation that the [Random](https://learn.microsoft.com/en-us/dotnet/api/system.random?view=net-9.0) class introduced a [Shuffle](https://learn.microsoft.com/en-us/dotnet/api/system.random.shuffle?view=net-9.0) method from .NET 6.

For thread-safe use, the static [Shared](https://learn.microsoft.com/en-us/dotnet/api/system.random.shared?view=net-9.0) property also exposes the [Shuffle](https://learn.microsoft.com/en-us/dotnet/api/system.random.shuffle?view=net-9.0) method.

You use it like this:

```c#
// Shuffle in place

Random.Shared.Shuffle(numbers);

foreach (var number in numbers)
{
    Console.Write($"{number} ");
}
```

Unlike the previous technique, this one **mutates the array in place**.

This is simpler and easier to read than the previous technique.

This will also work with Span

### TLDR

**Use the `Random.Shuffle` method to shuffle *arrays* in place.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-09-20%20-%20RandomShuffle).

Happy hacking!
