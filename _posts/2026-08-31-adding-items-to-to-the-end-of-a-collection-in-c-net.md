---
layout: post
title: Adding Items To The End Of A Collection In C# & .NET
date: 2026-08-31 14:19:46 +0300
categories:
    - C#
    - .NET
---

In our previous post, "[Adding Items To The Beginning Of A Collection in C# & .NET]({% post_url 2026-08-30-adding-items-to-the-beginning-of-a-collection-in-c-net %})", we looked at a number of ways to add items to the **beginning** of a collection, in this case a [List](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1?view=net-10.0).

There were three techniques:

1. Insert method
2. Prepend method
3. Collection initializers

In this post, we will look at the opposite problem: how to add items to the end of a collection.

Likewise, here there are also three techniques.

## Insert

We can also use the [Insert](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.insert?view=net-10.0) method here, the twist being we need to specify **where exactly** to insert - the **tail** of the collection.

We obtain this by retrieving the **number of items already in the list**.

Like so:

```c#
List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

numbers.Insert(numbers.Count, 100);
```

## Append

Another way is to use the [Append](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.append?view=net-10.0) method.

```c#
List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

var newList = numbers.Append(100);
```

This returns a **new** `List` with the required element appended to the end.

## Collection Expressions

As in the previous case, we can also use [collection expressions](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/collection-expressions) to compose our new `List`.

```c#
List<int> numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

List<int> newList = [.. numbers, 100];
```

### TLDR

**There are at least three ways to *append* elements to an existing `List`.**

Happy hacking!
