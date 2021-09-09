---
layout: post
title: 30 Days Of .NET 6 - Day 4 - LINQ Improvements - MaxBy & Min By
date: 2021-09-09 11:40:32 +0300
categories:
    - C#
    - 30 Days Of .NET 6
---
One of the most powerful features introduced in the .NET Framework, all the way back in 2008 in .NET 3.5 was [Language Integrated Query, better known as LINQ](https://docs.microsoft.com/en-us/dotnet/csharp/programming-guide/concepts/linq/#:~:text=Language%2DIntegrated%20Query%20(LINQ)%20is%20the%20name%20for%20a,directly%20into%20the%20C%23%20language.&text=The%20LINQ%20family%20of%20technologies,XML%20(LINQ%20to%20XML).)

This allows you to do solve problems like these:

> Assume you have the following class, `Agent`:

```csharp
public record Agent
{
    public string Name { get; init; }
    public byte Age { get; init; }
}
```

> Assume you have the following collection of `Agents`:

```csharp
var agents = new Agent[] {
    new Agent() { Name = "James Bond", Age = 40 } ,
    new Agent() { Name = "Jason Bourne", Age = 35 } ,
    new Agent() { Name = "Evelyn Salt", Age = 30 }
};
```

> List all the agents 35 or older.


Traditionally you would write some sort of loop to solve this problem.

In .NET this is solved using LINQ.

Like so:

```csharp
var candidates = agents.Where(agent => agent.Age >= 35);
foreach (var candidate in candidates)
{
    Console.WriteLine(candidate.Name);
}
```

Naturally most languages have something similar - support some sort of lambda expressions. In Java it is implemented using the [Stream API](https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html).

Some improvements have been made in .NET 6 to improve the LINQ functionality.

Using our prior example, suppose we are to get the **oldest** agent.

In .NET 5 and prior you would have to do something like ordering by the age, and then take the first.

Like so:

```csharp
var oldestV1 = agents.OrderByDescending(agent => agent.Age).First();
Console.WriteLine(oldestV1.Name);
```

Which works perfectly.

You could also do the same thing my using two LINQ expressions - one to determine the maximum age, and a second to filter based on that.

In .NET 6 this experience has been improved.

You can now do it like so:

```csharp
var oldestV2 = agents.MaxBy(agent => agent.Age);
Console.WriteLine(oldestV2.Name);
```

There is a new extension method, [MaxBy](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.maxby?view=net-6.0) that has been introduced to make it easier to write code to solve what is often a common problem - getting the largest value of a collection based on a maxmium complex property.

This is different from the [Max](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.max?view=net-5.0) method.

You can, in fact, use `Max` for this purpose, but the class you want to filter using would have to implement the `IComparable<T>` interface. This is usually impractical:
1. You would have to implement it for every class you want to use in this way
2. You don't always have control of the class you want to use to filter - so you may not be able to even if you wanted.

There is also, naturally, an equivalent [MinBy](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.minby?view=net-6.0) method that does the opposite.

If we want to get the youngest agent we would do it like so:

```csharp
var youngest = agents.MinBy(agent => agent.Age);
Console.WriteLine(youngest.Name);
```

You can use these methods to solve more exotic problems.

For example:

```csharp
// The agent with the longest name
var longestName = agents.MaxBy(agent => agent.Name.Length);
Console.WriteLine(longestName.Name);

// The agent with the shortest name
var shortestName = agents.MinBy(agent => agent.Name.Length);
Console.WriteLine(shortestName.Name);
```

# Thoughts

These extension methods make writing code for a number of common problems that much easier, increasing productivity and reducing bugs.

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2021-09-09%20-%2030%20Days%20Of%20.NET%206%20-%20Day%204%20-%20LINQ%20Improvements%20-%20MaxBy%20%26%20Min%20By).

# TLDR

LINQ now has `MaxBy` and `MinBy` extension methods that make selection of objects based on complex properties easier without having to implement `IComparable<T>`

**This is Day 4 of the 30 Days Of .NET 6 where every day I will attempt to explain one new / improved thing in the upcoming release of .NET 6.**

Happy hacking!