---
layout: post
title: LINQ Single and First Are Not Interchangeable
date: 2025-05-18 00:27:20 +0300
categories:
    - .NET
    - C#
---

[LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) has two methods that exhibit very similar behaviour - [Single](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.single?view=net-9.0) and [First](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.first?view=net-9.0).

Let us review this by way of an example.

Take the following collection, an `array` of **numbers**.

```c#
int[] numbers = [1, 2, 3, 4, 5, 6, 7, 8];
```

If we wanted the **first** number **greater than 7**, we could retrieve it like this, using the `First` method.

```c#
Console.WriteLine(numbers.First(n => n > 7));
```

We could also retrieve it like this, using the `Single` method:

```c#
Console.WriteLine(numbers.Single(n => n > 7));
```

Insofar as this example is concerned, **these are interchangeable**.

Now, imagine that the collection was like this:

```c#
int[] numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
```

And we ran the code again:

`First` would return the following:

```plaintext
8
```

`Single`, however, would return the following:

```plaintext
Unhandled exception. System.InvalidOperationException: Sequence contains more than one matching element
   at System.Linq.ThrowHelper.ThrowMoreThanOneMatchException()
   at System.Linq.Enumerable.TryGetSingle[TSource](IEnumerable`1 source, Func`2 predicate, Boolean& found)
   at System.Linq.Enumerable.Single[TSource](IEnumerable`1 source, Func`2 predicate)
   at Program.<Main>$(String[] args) in /Users/rad/Projects/blog/BlogCode/FirstSingle/Program.cs:line 5
```

The issue is that **two** numbers satisfy the condition `> 7` - `8` and `9`.

And herein is where we need to be careful.

It is tempting to say, "To avoid this problem, always use `First`"!

This is convenient, but **incorrect**.

**The semantics matter.**

Suppose you had an `Order` object:

```c#
public record Order(string OrderID, DateOnly orderDate, decimal Amount);
```

 and wanted to retrieve the count of `Order` objects with a particular ID.

```c#
Console.WriteLine(orders.Where(x => x.OrderID == "1000").Count());
```

Suppose this returned `2`.

The question is, **under what circumstances would querying an `Order` for a particular order number return more than one result?**

This likely indicates that something is seriously amiss.

If you used `First` here, it would return a **single** result, hiding the problem.

```c#
orders.First(x => x.OrderID == "1000")
```

If, however, you used `Single` here, it would **throw an exception**.

```c#
orders.Single(x => x.OrderID == "1000")
```

This is a good thing - you are directly signaling that you expect one, and only one result.

### TLDR

**`First` and `Single` are not interchangeable - use `Single` when you expect exactly one result, and to throw an exception if you don't get it, and `First` otherwise.**

Happy hacking!
