---
layout: post
title: Checking If Collection Enumeration Is Cheap In C# & .NET
date: 2025-11-09 13:17:44 +0300
categories:
    - C#
    - .NET
---

Our last post, "[Count vs Any To Check A If A Collection Has Elements In C# & .NET]({% post_url % 2025-11-08-count-vs-any-to-check-a-if-a-collection-has-elements-in-c-net })", looked at considerations around determining the length or size of a collection.

In this post, we will look at a potential middle ground that will allow you to **check whether the computations of a collection length are expensive beforehand**.

This can be achieved using the [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) [TryGetNonEnumeratedCount](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.trygetnonenumeratedcount?view=net-9.0) extension method.

This method does **various checks** to determine if the enumeration of the collection can be done **cheaply**. If it can, it returns `true` as well as the **count**. Otherwise, it returns `false`.

A `false` return means that the enumeration is a **potentially expensive operation**, and if you really want to do it, **you can proceed at your own risk**.

Take, for example, an `array`.

```c#
string[] people = ["Peter", "Bartholomew", "Matthew", "Simon", "Jude"];

if (people.TryGetNonEnumeratedCount(out var count))
{
	Console.WriteLine($"This is a cheap operation - we got {count}");
}
```

If we run this, the following will be printed:

```plaintext
This is a cheap operation - we got 5
```

Another example is this expression:

```c#
var complex = Enumerable.Range(1, 50).Where(n => n % 2 == 0);

if (complex.TryGetNonEnumeratedCount(out var _))
{
	Console.WriteLine($"This is a cheap operation");
}
else
{
	Console.WriteLine("This is expensive!");
}
```

To count the number of elements is a potentially **expensive** operation, as the **modulus division** must be done for **all the elements**.

Running this code will print the following:

```plaintext
This is expensive!
```

You can therefore decide **whether or not to perform the enumeration** anyway in the `else` block.

```c#
var complex = Enumerable.Range(1, 50).Where(n => n % 2 == 0);

if (complex.TryGetNonEnumeratedCount(out var _))
{
	Console.WriteLine($"This is a cheap operation");
}
else
{
  Console.WriteLine("This is expensive!");
  //
  // Have our enumeration here
  //
  var result = complex.ToList();

  Console.WriteLine($"There are {result.Count} even numbers");
}
```

### TLDR

**The LINQ `TryGetNonEnumeratedCount` extension method allows you to check whether or not enumerating a collection to determine its length is an expensive operation.**

The code is in my GitHub.

Happy hacking!
