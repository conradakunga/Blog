---
layout: post
title: Using LINQ OfType To Filter Collections By Type
date: 2025-02-06 19:47:02 +0300
categories:
    - C#
    - NET
---

[Polymorphism](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/object-oriented/polymorphism) is a concept that allows for the development of very **powerful** and **maintainable** software. Provided, of course, you use it wisely.

Occasionally this presents some problems when you need to **filter** your types.

Take for example the following types:

```c#
public record Agent
{
    public required string Name { get; init; }
}

public record FieldAgent : Agent;

public record SleeperAgent : FieldAgent
{
    public required string Station { get; init; }
}

public record UnderCoverAgent : Agent;
```

We then have a simple program that creates some instances of these types and adds them to a list.

```c#
var smiley = new Agent { Name = "George Smiley" };
var bond = new FieldAgent { Name = "James Bond" };
var evelyn = new SleeperAgent { Name = "Evelyn Salt", Station = "USA" };
var phil = new SleeperAgent { Name = "Phil Jennings", Station = "USA" };
var bourne = new FieldAgent { Name = "Jason Bourne" };
var montes = new UnderCoverAgent { Name = "Anna Montes" };

// Add all agents to a collection
Agent[] agents = [smiley, bond, evelyn, phil, bourne, montes];
```

Suppose, for whatever reason, we needed to perform some operation with only the `SleeperAgents`.

We could **filter** that like so:

```c#
// Get all sleepers
var sleepers = agents.Where(x => x.GetType() == typeof(SleeperAgent)).ToList();
sleepers.ForEach(sleeper => Console.WriteLine(sleeper.Name));
```

This should print the following:

```plaintext
Evelyn Salt
Phil Jennings
```

There is a **simpler** way to achieve this - using the [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) [OfType](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.oftype?view=net-9.0) method. This method, unsurprisingly, returns a collection of objects of the specified type.

You use it like so:

```c#
// Get all sleepers into a list of sleeper agents
var sleeperAgents = agents.OfType<SleeperAgent>().ToList();
sleeperAgents.ForEach(sleeper => Console.WriteLine(sleeper.Name));
```

Much terser and clearer.

It is important to note that the difference in syntax aside, both preceding queries **return different things**!

```c#
var sleepers = agents.Where(x => x.GetType() == typeof(SleeperAgent)).ToList();
```

This returns a list of `Agent` objects.

Whereas:

```c#
var sleeperAgents = agents.OfType<SleeperAgent>().ToList();
```

This returns a list of `SleeperAgent` objects.

If you want the filter to return a particular type, use the [Cast](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.cast?view=net-9.0) method. Like so:

```c#
// Get all sleepers into a SleeperAgent List
var sleeperAgentsFiltered = agents.Where(x => x.GetType() == typeof(SleeperAgent))
    .Cast<SleeperAgent>()
    .ToList();
    
sleeperAgentsFiltered.ForEach(sleeper => Console.WriteLine(sleeper.Name));
```

Now let us take a situation where we want all `FieldAgents`

The code would be as follows:

```c#
var fieldAgents = agents.OfType<FieldAgent>().ToList();
fieldAgents.ForEach(field => Console.WriteLine(field.Name));
```

This prints the following:

```plaintext
James Bond
Evelyn Salt
Phil Jennings
Jason Bourne
```

This is because *James Bond* and *Jason Bourne* are `FieldAgents`. *Evelyn Salt* and *Phil Jennings* are `SleeperAgents`. And remember that `SleeperAgent` inherits from `FieldAgent`. Thus four agents are returned.

### TLDRD

**The `OfType` method allows you to filter a collection of types for objects that are of a particular type.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-02-06%20-%20OfType).

Happy hacking!
