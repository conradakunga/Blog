---
layout: post
title: Set Operations With LINQ
date: 2025-01-28 23:43:30 +0300
categories:
    - C#
    - .NET
    - LINQ
---

One of the more brilliant abilities that [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) exposes is the support for a number of key **set operations**. These can come in very useful when solving many algorithmic problems.

The best way to illustrate this is by example.

Assume we have the following collections:

```c#
int[] left = [1, 2, 3, 4, 5, 6, 7];
int[] right = [5, 6, 7, 8, 9, 10];
int[] other = [1, 1, 1, 2]
```

We can then go through a bunch of operations.

### Items In Left, But Not In Right

For this, we use the [Except](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.except?view=net-9.0) method

```c#
// Return items only in the left collection
var leftOnly = left.Except(right).ToList();
// Write to console
leftOnly.ForEach(x => Console.Write($"{x} "));
Console.WriteLine();
```

This should print the following:

```plaintext
1 2 3 4 
```

### Items In Right, But Not In Left

We also use the [Except](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.except?view=net-9.0) method, but we flip the order to specify **WHERE** we want to intersect to take place.

```c#
// Return items only in the right collection
var rightOnly = right.Except(left).ToList();
// Write to console
rightOnly.ForEach(x => Console.Write($"{x} "));
Console.WriteLine();
```
This should print the following:

```plaintext
8 9 10 
```

### Items Present In BOTH Collections

For this, we use the [Intersect](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.intersect?view=net-9.0) method.

```c#
// Returns items present in both collections
var both = left.Intersect(right).ToList().ToList();
// Write to console
both.ForEach(x => Console.Write($"{x} "));
Console.WriteLine();
```
For `Intersect`, it does not matter which collection is intersecting the other.

This should print the following:

```plaintext
5 6 7 
```

### All Items In Either Collection

For this, we use the [Union](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.union?view=net-9.0) method.

```c#
// Returns items from both collections
var combined = left.Union(right).ToList();
// Write to console
combined.ForEach(x => Console.Write($"{x} "));
Console.WriteLine();
```
Similar to `Intersect`, the order for `Union` does not matter.

This should print the following:

```plaintext
1 2 3 4 5 6 7 8 9 10 
```

### Items Only In Left, Or Only In Right

For this, we use a combination of `Except` and `Union`

```c#
// Returns items only in left or only in right
var unique = left.Except(right).Union(right.Except(left)).ToList();
// Write to console
unique.ForEach(x => Console.Write($"{x} "));
Console.WriteLine();
```

This should print the following:

```plaintext
1 2 3 4 8 9 10 
```

### Distinct

We can also determine the **unique members** of a collection using the [Distinct](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.distinct?view=net-9.0) method.

```c#
// Returns distinct elements in collection
var distinct = other.Distinct().ToList();
// Write to console
distinct.ForEach(x => Console.Write($"{x} "));
Console.WriteLine();
```

This will print the following:

```plaintext
1 2
```



### TLDR

***LINQ* exposes a number of methods that allow you to utilize set theory in your algorithms.**

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2025-01-28%20-%20Sets).

Happy hacking!
