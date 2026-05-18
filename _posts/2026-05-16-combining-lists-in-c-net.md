---
layout: post
title: Combining Lists In C# & .NET
date: 2026-05-16 17:26:28 +0300
categories:
    - C#
    - .NET
---

Sooner or later, you will encounter a scenario where you need to **combine the elements** of **two** `list` objects into a new `list`.

Take the following case:

```c#
List<string> currentNames = ["Brenda", "Latisha", "Linda", "Felicia", "Dawn", "LeShaun", "Ines", "Alicia"];
List<string> newNames = ["LeShaun", "Ines", "Alicia", "Teresa", "Monica", "Sharon", "Nicki", "Lisa", "Veronica", "Karen", "Vicky"];
```

We have two lists, `currenNames`, and `newNames`, and we want to **combine** them.

The usual go-to is the [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) [union](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.union?view=netframework-4.8.1) method.

```c#
var newList = currentNames.Union(newNames).ToList();
```

There is also the [Concat](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.concat?view=netframework-4.8.1&viewFallbackFrom=net-10.0) method that you can use.

```c#
var newList = currentNames.Union(newNames).ToList();
```

They seem **interchangeable**, but they **aren't**.

If we run this code:

```c#
Console.WriteLine($"newList has {newList.Count} elements, and otherNewList has {otherNewList.Count}");
```

We get the following results:

![joinLists](../images/2026/05/joinLists.png)

Why do they have **different lengths**?

Because `union` is based on [set theory](https://byjus.com/maths/union-of-sets/), and does not allow **duplicates**.

`Concat`, on the other hand, has **no such restrictions**. Which means it has the additional benefit of being **faster**, as it does not need to check for duplicates.

The choice of which to use depends on your **requirements**.

This code will also work for `arrays` and **most** of the other **collections**.

### TLDR

**You can use `union` or `concat` to combine two collections, depending on your needs.**

Happy hacking!
