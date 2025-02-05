---
layout: post
title: Using LINQ Repeat To Generate Copies Of Objects
date: 2025-02-04 12:22:21 +0300
categories:
    - C#
    - .NET
    - LINQ
---

You will also occasionally have a situation where you need to **clone an object several times**.

Let us take, for example, the following type:

```c#
public sealed record Agent
{
    public required string Name { get; init; }
    public required DateOnly DateOfBirth { get; init; }
}
```

Suppose, for whatever reason, we need **100 copies** of the agent *James Bond*, perhaps for testing purposes.

There are several ways to do it.

One way to do this is to combine [Enumerable.Range](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.range?view=net-9.0) to generate a **sequence** and then use that sequence to **project**. Like so:

```c#
// First create an enumerable of 100 numbers, 0 - 99
var jamesBonds = Enumerable.Range(0, 100)
    // Project into an Agent object, but since we're not using the numbers, 
    // Discard them using the discard _
    .Select(_ => new Agent { Name = "James Bond", DateOfBirth = new DateOnly(1970, 1, 1) }).ToList();
```

This will give us a list of 100 *James Bonds*.

There is a simpler way to do this - using the LINQ [Repeat](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.repeat?view=net-9.0) method.

```c#
var jamesBonds = Enumerable.Repeat(new Agent { Name = "James Bond", DateOfBirth = new DateOnly(1970, 1, 1) }, 100)
    .ToList();
```

Much shorter, terser, and clearer.

### TLDR

**`LINQ` offers the `Repeat` method to assist in duplicating objects a required number of times.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-02-04%20-%20Repeat).

Happy hacking!
