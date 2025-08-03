---
layout: post
title: Mutative vs Non-Mutative List Manipulation In C# & .NET
date: 2025-07-30 14:44:35 +0300
categories:
    - C#
    - .NET
    - Data Structures
---

As [discussed previously]({% post_url 2025-07-29-considerations-when-adding-items-to-a-list-in-c-net %}), the [List](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1?view=net-9.0) is one of the **workhorses** of the typical program.

When it comes to working with the `List`, there is a need to be very clear about **how you want the underlying data in the `List` itself to be treated after processing**.

For example, take the following program.

```c#
List<int> list = [0, 1, 2, 3, 4, 5];
// Print elements
list.ForEach(Console.Write);
Console.WriteLine();
// Reverse the list
list.Reverse();
// Print elements
list.ForEach(Console.Write);
Console.WriteLine();
```

This will print the following:

```plaintext
012345
543210
```

Then, let us take the following, similar program:

```c#
list = [0, 1, 2, 3, 4, 5];
// Print elements
list.ForEach(Console.Write);
Console.WriteLine();
// Sort the list
list.OrderByDescending(x => x).ToList().ForEach(Console.Write);
Console.WriteLine();
// Print elements
list.ForEach(Console.Write);
Console.WriteLine();
```

This prints the following:

```plaintext
012345
543210
012345
```

What, you might be wondering, is the difference?

The difference is that in this second program, reversing the `List` **does not mutate the original** `List`.

```c#
list.OrderByDescending(x => x).ToList().ForEach(Console.Write);
```

The code above returns a **new** `List`, that happens to contain the sorted elements.

This is different from the first program:

```c#
list.Reverse();
```

The code above **mutates** the original `List`.

There is no wrong or right way here - it depends on your **requirements** and **circumstances**.

The same considerations arise when you need to **sort** the list - you can either sort **in place** using the [Sort](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.sort?view=net-9.0) method, or you can use the [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) [OrderBy](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.orderby?view=net-9.0).

### TLDR

**When manipulating a `List` with operations like `Sort` or `Reverse`, you need to be clear whether or not you want to mutate the original list.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-07-30%20-%20List%20Manipulation).

Happy hacking!
