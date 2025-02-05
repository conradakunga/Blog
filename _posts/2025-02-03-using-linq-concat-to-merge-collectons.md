---
layout: post
title: Using LINQ Concat To Merge Collections
date: 2025-02-03 17:38:41 +0300
categories:
    - C#
    - .NET
    - LINQ
---

In yesterday's post, "[Using LINQ UnionBy To Merge Collections]({% post_url 2025-02-02-using-linq-unionby-to-merge-collections %})", we talked about the difference between [Union](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.union?view=net-9.0) and [UnionBy](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.unionby?view=net-9.0), and how **sets do not allow duplicate values**.

However, there are times when you want to merge two collections, **whether or not they contain duplicates**. There can be many valid reasons for this - perhaps you are collecting data from two different sources and want to perform some analysis from both sources.

Let us take, for example, the following type:

```c#
public sealed record Agent
{
    public required string Name { get; init; }
    public required DateOnly DateOfBirth { get; init; }
}
```

Then, let us write a program that creates a collection of legacy agents (agents in the field during the [Cold War](https://en.wikipedia.org/wiki/Cold_War))

```c#
Agent[] legacy =
[
    new() { Name = "Jason Bourne", DateOfBirth = new DateOnly(1970, 1, 1) },
    new() { Name = "James Bond", DateOfBirth = new DateOnly(1950, 1, 1) },
    new() { Name = "Evelyn Salt", DateOfBirth = new DateOnly(1980, 1, 1) },
    new() { Name = "Vesper Lynd", DateOfBirth = new DateOnly(1960, 1, 1) },
    new() { Name = "Eve MoneyPenny", DateOfBirth = new DateOnly(1990, 1, 1) }
];
```

And then another list of current agents:

```c#
Agent[] current =
[
    new() { Name = "Eve MoneyPenny", DateOfBirth = new DateOnly(1990, 1, 1) },
    new() { Name = "Evelyn Salt", DateOfBirth = new DateOnly(1980, 1, 1) },
    new() { Name = "Ethan Hunt", DateOfBirth = new DateOnly(1970, 1, 1) },
    new() { Name = "Luther Stickell", DateOfBirth = new DateOnly(1970, 1, 1) },
    new() { Name = "Benji Dunn", DateOfBirth = new DateOnly(1985, 1, 1) },
];
```

If we were to do a **union** of these two agents:

```c#
var allAgents = legacy.Union(current).ToList();
allAgents.ForEach(agent => Console.WriteLine($"{agent.Name}, born on {agent.DateOfBirth}"));
```

The following would be printed:

```plaintext
Jason Bourne, born on 01/01/1970
James Bond, born on 01/01/1950
Evelyn Salt, born on 01/01/1980
Vesper Lynd, born on 01/01/1960
Eve MoneyPenny, born on 01/01/1990
Ethan Hunt, born on 01/01/1970
Luther Stickell, born on 01/01/1970
Benji Dunn, born on 01/01/1985
```

Notice here that *Eve MoneyPenny* and *Evelyn Salt* appear **once** despite being on **both** lists. This is correct behaviour for `Union`.

If we want all the agents to appear, regardless of duplicates, we use the LINQ [Concat](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.concat?view=net-9.0) method.

```c#
// Concat both collections
allAgents = legacy.Concat(current).ToList();
// Print to console
allAgents.ForEach(agent => Console.WriteLine($"{agent.Name}, born on {agent.DateOfBirth}"));
```

This should print the following:

```plaintext
Jason Bourne, born on 01/01/1970
James Bond, born on 01/01/1950
Evelyn Salt, born on 01/01/1980
Vesper Lynd, born on 01/01/1960
Eve MoneyPenny, born on 01/01/1990
Eve MoneyPenny, born on 01/01/1990
Evelyn Salt, born on 01/01/1980
Ethan Hunt, born on 01/01/1970
Luther Stickell, born on 01/01/1970
Benji Dunn, born on 01/01/1985
```

You can see here that *Eve MoneyPenny* and *Evelyn Salt* now appear twice.

### TLDR

**`LINQ` offers the `Concat` method to assist in operations for merging lists, regardless of duplicates.** 

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-02-03%20-%20Concat).

Happy hacking!
