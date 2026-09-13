---
layout: post
title: Adding Items To The Beginning Of A Collection in C# & .NET
date: 2026-08-31 01:22:45 +0300
categories:
    - C#
    - .NET
---

A scenario you have probably run into is needing to modify a collection by **inserting** items at the **beginning**.

Take, for instance, the following [List](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1?view=net-10.0) of `integers`.

```c#
var numbers = new List<int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
```

If we wanted to insert a `0` at the start of this list,  there are a number of ways to do this:

## Insert

The first is to use the [Insert](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.insert?view=net-10.0) method, which takes the following parameters:

- The position to insert
- The value to insert

Like so:

```c#
List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

numbers.Insert(0, 0);
```

## Prepend

Another way is to use the [Prepend](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.prepend?view=net-10.0) method:

```c#
List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

numbers.Prepend(0);
```

## Collection Expressions

Another way is to use [collection expressions](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/collection-expressions) as follows:

```c#
List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

List<int> newList = [0, .. numbers];
```

Unlike the previous two methods, **this does not mutate the existing collection - it creates a new one.**

### TLDR

**There are several ways to add items to the beginning of a collection.**

Happy hacking!

