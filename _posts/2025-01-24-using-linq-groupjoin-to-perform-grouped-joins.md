---
layout: post
title: Using LINQ GroupJoin To Perform Grouped Joins
date: 2025-01-24 11:40:24 +0300
categories:
    - C#
    - .NET
    - LINQ
---

One of the more interesting operators that [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) provides is [GroupJoin](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.groupjoin?view=net-9.0). This allows you to perform **joins** on two **collections related by a common key** and returns a **third collection of groups**, each consisting of a **key** and a **collection of matching elements**.

Take the following example.

 We start by defining an `Agency` type.

```c#
public sealed record Agency
{
  public required int AgencyID { get; init; }
  public required string Name { get; init; }
}
```

And then an `Agent` type:

```c#
public sealed record Agent
{
  public required int AgentID { get; init; }
  public required int AgencyID { get; init; }
  public required string Name { get; init; }
}
```

We then setup our data.

```c#
Agency[] agencies =
[
  new Agency { AgencyID = 1, Name = "MI-6" },
  new Agency { AgencyID = 2, Name = "MI-5" },
  new Agency { AgencyID = 3, Name = "IMF" },
  new Agency { AgencyID = 4, Name = "CIA" },
];

Agent[] agents =
[
  new Agent { AgentID = 1, AgencyID = 1, Name = "George Smiley" },
  new Agent { AgentID = 2, AgencyID = 1, Name = "James Bond" },
  new Agent { AgentID = 3, AgencyID = 2, Name = "Harry Pearce" },
  new Agent { AgentID = 4, AgencyID = 2, Name = "Roz Myers" },
  new Agent { AgentID = 5, AgencyID = 3, Name = "Ethan Hunt" },
  new Agent { AgentID = 6, AgencyID = 3, Name = "Luther Stickell" },
  new Agent { AgentID = 7, AgencyID = 3, Name = "Benji Dunn" },
  new Agent { AgentID = 8, AgencyID = 4, Name = "Evelyn Salt" },
  new Agent { AgentID = 9, AgencyID = 4, Name = "Jason Bourne" },
];
```

Now we can proceed to `GroupJoin` our data, taking advantage of the fact that the `AgencyID` key relates the `Agency` and the `Agent`.

```c#
// Perform the Join
var results = agencies.GroupJoin(
    agents,
    agency => agency.AgencyID, // Outer key 
    agent => agent.AgencyID, // Inner key 
    (agencyResult, agentsResult) => new //Project into a new anonymous type
    {
        Agency = agencyResult.Name,
        Agents = agentsResult.Select(x => x.Name)
    }
).ToArray();

foreach (var result in results)
{
    Console.WriteLine($"Agency: {result.Agency}");
    foreach (var agent in result.Agents)
    {
        Console.WriteLine($"\tAgent: {agent}");
    }
}
```

This will print the following:

```plaintext
Agency: MI-6
        Agent: George Smiley
        Agent: James Bond
Agency: MI-5
        Agent: Harry Pearce
        Agent: Roz Myers
Agency: IMF
        Agent: Ethan Hunt
        Agent: Luther Stickell
        Agent: Benji Dunn
Agency: CIA
        Agent: Evelyn Salt
        Agent: Jason Bourne
```

Suppose you wanted access to the **entire** original objects so that you can subsequently use them later in your program. 

This is also possible, as you can **project whatever you want**, including the entire object.

```c#
// Perform the Join and return an array
var results = agencies.GroupJoin(
    agents,
    agency => agency.AgencyID, // Outer key 
    agent => agent.AgencyID, // Inner key 
    (agencyResult, agentsResult) => new // Project into a new anonymous type
    {
        Agency = agencyResult,
        Agents = agentsResult
    }
).ToArray();

foreach (var result in results)
{
    Console.WriteLine($"Agency: {result.Agency.Name} (ID - {result.Agency.AgencyID})");
    foreach (var agent in result.Agents)
    {
        Console.WriteLine($"\tAgent: {agent.Name} (AgentID - {agent.AgentID})");
    }
}
```

This will print the following:

```plaintext
Agency: MI-6 (ID - 1)
        Agent: George Smiley (AgentID - 1)
        Agent: James Bond (AgentID - 2)
Agency: MI-5 (ID - 2)
        Agent: Harry Pearce (AgentID - 3)
        Agent: Roz Myers (AgentID - 4)
Agency: IMF (ID - 3)
        Agent: Ethan Hunt (AgentID - 5)
        Agent: Luther Stickell (AgentID - 6)
        Agent: Benji Dunn (AgentID - 7)
Agency: CIA (ID - 4)
        Agent: Eveylyn Salt (AgentID - 8)
        Agent: Jason Bourne (AgentID - 9)

```

### TLDR

**The [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) [GroupJoin](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.groupjoin?view=net-9.0) operator allows you to perform joins with collections and returns a new collection grouped by a join performed on the keys.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-01-24%20-%20Group%20Joins)

Happy hacking!
