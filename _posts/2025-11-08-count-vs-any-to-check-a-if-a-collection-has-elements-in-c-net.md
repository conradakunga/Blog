---
layout: post
title: Count vs Any To Check A If A Collection Has Elements In C# & .NET
date: 2025-11-08 12:55:09 +0300
categories:
    - C#
    - .NET
---

In the course of writing applications, a common scenario is where you need to **check if a collection** of any kind **contains elements**.

Take, for example, the following:

```c#
string[] people = ["Peter", "Bartholomew", "Matthew", "Simon", "Jude"];
```

One way to check is as follows:

```c#
if (people.Length > 0)
{
	Console.WriteLine("There are elements");
}
```

Here, we are outright checking the **length** of the collection. In this case, the [array](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/arrays) structure has a [Length](https://learn.microsoft.com/en-us/dotnet/api/system.array.length?view=net-9.0) property.

Another way is as follows:

```c#
if (people.Any())
{
	Console.WriteLine("There are elements");
}
```

Here we are using the [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) extension method [Any](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.any?view=net-9.0) to check if there are any elements.

They may return the same result, but **they are not the same thing**!

Length makes use of the fact that the `array` **Length** is always known in advance, whereas `Any()` **tries to iterate** through the collection and **returns as soon as it is successful**.

**Not all collections store their lengths**, and thus, it may be **potentially expensive** to determine emptiness using this technique.

In fact, it is possible to have an **infinite collection** (that makes use of [yield](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/statements/yield)), and thus attempting to **count** the elements may not succeed.

### TLDR

It is advisable to use` Any()` rather than `Count` / `Length` to determine the **emptiness** of a collection.

Happy hacking
