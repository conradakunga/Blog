---
layout: post
title: Random Sampling Of Arrays In C# & .NET
date: 2025-09-21 22:25:24 +0300
categories:
    - C#
    - NET
---

A problem you might run to in the course of your application development is that given a `array` of items, sample a number of elements **randomly**.

There are two ways we can go attempt this:

## Random Sorting, Take N Elements

The first way (and more **inefficient** way) is to **sort** the `array` randomly, and then **pick the desired number of elements** from the head of the array.

```c#
var numbers = Enumerable.Range(1, 25).ToArray();

var shuffled = numbers.OrderBy(n => Random.Shared.Next())
  .Take(10)
  .ToArray();

foreach (var number in shuffled)
{
  Console.Write($"{number} ");
}
```

This code will return `10` elements.

```plaintext
2 10 6 18 14 17 22 16 4 19 
```

The **drawback** of this technique is that it **sorts the entire array** before sampling. Which can be **inefficient** if the array is **large** but you just want to sample a **few** items.

## Random.GetItems Method

A much better way is to make use of the [Random.GetItems](https://learn.microsoft.com/en-us/dotnet/api/system.random.getitems?view=net-9.0) method that achieves precisely this.

```c#
var sampled = Random.Shared.GetItems(numbers, 10);

foreach (var number in sampled)
{
  Console.Write($"{number} ");
}
```

This is much **cleaner** and **terser**, and avoids the overhead of sorting the entire `array` first before selecting the **required** elements.

This code will return `10` elements.

```plaintext
24 3 22 9 3 10 2 18 15 21 
```

`Random.GetItems` also works with [Spans](https://learn.microsoft.com/en-us/dotnet/api/system.span-1?view=net-9.0).

### TLDR

**The `Random.GetItems` method can be used to randomly sample elements of an `array`.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-09-21%20-%20RandomSample).

Happy hacking!
