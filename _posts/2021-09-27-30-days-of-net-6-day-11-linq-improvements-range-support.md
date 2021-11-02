---
layout: post
title: 30 Days Of .NET 6 - Day 11 - LINQ Improvements - Range Support
date: 2021-09-24 13:54:41 +0300
categories:
    - C#
    - .NET
    - 30 Days Of .NET 6
---
One of the most powerful features of LINQ is the ability to select a range of elements from a collection.

This is accomplished using the [Take](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.take?view=net-5.0) and [Skip](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.skip?view=net-5.0) LINQ expressions, and their derivatives ([TakeLast](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.takelast?view=net-5.0), [SkipLast](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.skiplast?view=net-5.0)) that allow you to specify what you want (`Take`) and what to discard (`Skip`).

These work perfectly well, but can be a bit ungainly.

A very welcome improvement is now that LINQ supports [range operators](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/csharp-8.0/ranges) operators.

These allow you to specify very tersely what values you want to pull out of a something.

These were previously defined for `strings` and `arrays`, but now in .NET 6 this has been extended to any collection that implements `IEnumerable` which is most collections.

This is best explained using examples that demonstrate use.

Assuming you have the following array:

```csharp
var numbers = new[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 };
```

Tip - you can also get an equivalent range of numbers quickly using [Enumerable.Range](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.range?view=net-5.0#System_Linq_Enumerable_Range_System_Int32_System_Int32_) as follows:

```csharp
var numbers = Enumerable.Range(1, 15);
```

Following are a bunch of expressions to query this data demonstrating the traditional query technique and the new technique.

To get the **last** 5 numbers:

```csharp
var oldLastFive = numbers.TakeLast(5);
var newLastFive = numbers.Take(^5..);
```

This should return:

```plaintext
11,12,13,14,15
```

A bit more elaborate: to get 5 numbers and then **skip** 2

```csharp
var oldTakeFiveSkipTwo = numbers.Take(5).Skip(2);
var newTakeFiveSkipTwo = numbers.Take(2..5);
```

This should return

```plaintext
3,4,5
```

You need to be very careful about the order! The order in which you `Take` and `Skip` matters! Consider this expression:

```csharp
numbers.Take(2).Skip(5);
```

If you `Take` 2 elements **first**, and **then** proceed to `Skip` 5 from the 2 you have taken, your resulting collection will be empty!

To get all the elements **except** the first 5:

```csharp
var oldSkipFive = numbers.Skip(5);
var newSkipFive = numbers.Take(5..);
```

This should return

```plaintext
6,7,8,9,10,11,12,13,14,15
```

To get all the elements **except** the last 5:

```csharp
var oldSkipLastFive = numbers.SkipLast(5);
var newSkipLastFive = numbers.Take(..^5);
```

To get the **last** 10 elements, and then **skip** the last 5 of those:

```csharp
var oldLastTenSkipLast5 = numbers.TakeLast(10).SkipLast(5);
var newLastTenSkipLast5 = numbers.Take(^10..^5);
```

# Thoughts

This is a great addition to the LINQ engine.

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2021-09-27%20-%2030%20Days%20Of%20.NET%206%20-%20Day%2011%20-%20LINQ%20Improvements%20-%20Index%20%26%20Range%20Support)

# TLDR

Index and range support to LINQ makes it easier to write more expressive queries when managing collections.

**This is Day 11 of the 30 Days Of .NET 6 where every day I will attempt to explain one new / improved thing in the upcoming release of .NET 6.**

Happy hacking!
