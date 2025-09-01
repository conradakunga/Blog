---
layout: post
title: Adding Items To An Existing List In C# & .NET
date: 2025-08-01 15:35:33 +0300
categories:
    - C#
    - .NET
    - Data Structures
---

When working with the [generic](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/types/generics) [List](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1?view=net-9.0), you will naturally have to add elements to the said `List`.

There are **several** ways to do this:

## Constructor Initialization

If you know the elements you need to add at compile time, you can add them using [constructor initialization](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.-ctor?view=net-9.0).

```c#
List<int> list = new List<int> { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
```

## Collection Initialization

Similarly, if you know the elements at compile time, you can add them using [collection initialization](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/object-and-collection-initializers), which works with most of the other collections.

```c#
List<int> list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
```

## Add Method

You can add single elements using the [Add](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.add?view=net-9.0) method.

```c#
// Add single element
List<int> list = [];
list.Add(1);
list.Add(2);
```

## AddRange Method

You can add multiple elements using the [AddRange](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.addrange?view=net-9.0) method. This will add the elements to the **end of the collection**.

```c#
// Add multiple elements
List<int> list = [];
list.AddRange([1, 2, 3, 4, 5, 6, 7, 8, 9]);
```

## Insert Element In Position

If you have an element and you want to insert it into a specific position, you can use the [Insert](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.insert?view=net-9.0) method, which specifies the **position** and the **element** to insert.

```c#
// Add elements at a particular position
List<int> list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
list.Insert(0, -1);
list.ForEach(Console.Write);
Console.WriteLine();
```

## Inserting Multiple Elements In Position

If you have a number of elements and you want to insert them into a particular position, you can use the [InsertRange](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.insertrange?view=net-9.0) method, which specifies the **position** to insert and the **elements** to insert.

```c#
// Add range of elements at particular position
List<int> list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
list.InsertRange(0, [-1, -2, -3, -4]);
list.ForEach(Console.Write);
Console.WriteLine();
```

You can also use [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) to add elements to an existing `List` and return a new `List`:

- [Prepend](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.prepend?view=net-9.0)
- [Append](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.append?view=net-9.0)
- [Union](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.union?view=net-9.0)

### TLDR

**There are several ways to add elements to a `List`.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-08-01%20-%20Add%20Items%20To%20List).

------

Happy hacking!
