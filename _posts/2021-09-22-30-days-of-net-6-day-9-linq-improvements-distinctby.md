---
layout: post
title: 30 Days Of .NET 6 - Day 9 - LINQ Improvements - DistinctBy
date: 2021-09-22 14:41:51 +0300
categories:
    - C#
    - .NET
    - 30 Days Of .NET 6
---
Another improvement that has been added to the LINQ engine is the [DistinctBy](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.distinctby?view=net-6.0) method.

This is best explained with an example.

Assume you have the following array:

```csharp
var ages = new[] { 30, 33, 35, 36, 40, 30, 33, 36, 30, 40 };
```

How would you get the unique ages in the collection?

The simplest solution is a LINQ expression.

```csharp
var uniqueAges = ages.Distinct().ToArray();
foreach (var age in uniqueAges)
{
    Console.Write($"{age} ");
}
```

This should print the following:

```plaintext
30 33 35 36 40
```

We are turning it back into an array because after running `Distinct` we get back an `IEnumerable`.

Pretty straightforward.

Now imagine it is not a simple array of numbers, but a collection of objects?

Here we are using our `Agent`, but this time it is a [record](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/record) (the `Name` and `Age` can only be set once)

```csharp
public record Agent
{
    public string Name { get; init; }
    public byte Age { get; init; }
}
```

Assume we have a collection of `Agents`:

```csharp
var agents = new[]
{
    new Agent() {Name = "Ethan Hunt", Age = 40},
    new Agent() {Name = "James Bond", Age = 40},
    new Agent() {Name = "Jason Bourne", Age = 35},
    new Agent() {Name = "Evelyn Salt", Age = 30},
    new Agent() {Name = "Jack Ryan", Age = 36},
    new Agent() {Name = "Jane Smith", Age = 35},
    new Agent() {Name = "Oren Ishii", Age = 30},
    new Agent() {Name = "Natasha Romanoff", Age = 33}
};
```

If we wanted to get a list of `Agents` with unique ages, you likely have to do it in two passes:
1. Get the distinct ages
2. For each distinct age, query the collection and pick the **First** agent whose age is a match.

This is simplified using the `DistinctBy` method.

To get a list of all the agents with unique ages, you write this expression:

```csharp
var distinctlyAgedAgents = agents.DistinctBy(x => x.Age);
foreach (var agent in distinctlyAgedAgents)
{
    Console.WriteLine($"Agent {agent.Name} is {agent.Age}");
}
```

This should print the following:

```plaintext
Agent Ethan Hunt is 40
Agent Jason Bourne is 35
Agent Evelyn Salt is 30
Agent Jack Ryan is 36
Agent Natasha Romanoff is 33
```

The beauty of this is not only is it concise, but you can also **chain** methods to do additional things like sorting.

For example we can order the agents by their `Name`.

```csharp
var distinctAgents = agents.DistinctBy(x => x.Age).OrderBy(x => x.Name);
```

# Thoughts

Very simple yet very useful addition to the LINQ toolbelt.

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2021-09-22%20-%2030%20Days%20Of%20.NET%206%20-%20Day%209%20-%20LINQ%20Improvements%20-%20DistinctBy)

# TLDR

The new `DistinctBy` LINQ method allows to select distinct objects from a collection based on a child property.

**This is Day 9 of the 30 Days Of .NET 6 where every day I will attempt to explain one new / improved thing in the upcoming release of .NET 6.**
