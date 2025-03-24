---
layout: post
title: Collection Expressions & Dictionaries
date: 2025-03-23 04:24:34 +0300
categories:
    - C#
    - .NET
---

One of the more convenient introductions in [C# 12](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-12) and [.NET 8](https://learn.microsoft.com/en-us/dotnet/core/whats-new/dotnet-8/overview) is [collection expressions](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/collection-expressions).

Typically, you would create and initialize a `List<T>` as follows:

```c#
var list = new List<int> { 1, 2, 3, 4, 5 };
```

Similarly, an `array` would be created and initialized as follows:

```c#
var array = new int[] { 1, 2, 3, 4, 5 };
```

With collection expressions, these can be rewritten as follows:

```c#
List<int> list = [1, 2, 3, 4, 5];
```

Similarly, for the array:

```c#
int[] array = [1, 2, 3, 4, 5];
```

As you can see, the **initialization of the collections is identical**, regardless of the collection type.

This means that you can do the same for an `IEnumerable<T>`

```c#
IEnumerable<int> array = [1, 2, 3, 4, 5];
```

Or a `ConcurrentBag<T>`

```c#
ConcurrentBag<int> bag = [1, 2, 3, 4, 5];
```

For a `Stack<T>` and `Queue<T>,` collection initializers don't quite work as is, but they help make it easier by taking advantage of their constructor overloads that accept collections.

```c#
Stack<int> stack = new([1, 2, 3, 4, 5]);
	
Queue<int> queue = new([1, 2, 3, 4, 5]);
```

Collection expressions also work for the [Dictionary](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2?view=net-9.0).

```c#
var dict = new Dictionary<int, string>
{
  [1] = "One",
  [2] = "Two",
  [3] = "Three"
};
```

You can also write this as follows:

```c#
Dictionary<int, string> dict = new()
{
  [1] = "One",
  [2] = "Two",
  [3] = "Three"
};
```

This even works for dictionaries with complex types.

Assuming we have this type:

```c#
public record Agent(string Name);
```

You can initialize a dictionary as follows:

```c#
Dictionary<int, Agent> dict = new()
{
  [1] = new Agent("James Bond"),
  [2] = new Agent("Vesper Lynd"),
  [3] = new Agent("Eve Moneypenny"),
};
```

### TLDR

**Collection initializers make it easy to create and initialize various collections.**

Happy hacking!
