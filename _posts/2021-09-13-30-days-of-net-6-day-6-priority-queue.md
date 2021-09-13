---
layout: post
title: 30 Days Of .NET 6 - Day 6 - Priority Queue
date: 2021-09-13 12:31:58 +0300
categories:
    - C#
    - 30 Days Of .NET 6
---
We are all familiar with the [Queue](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.queue-1?view=net-5.0) class.

This is a generic data structure that items are retrieved in the order that they are put in.

```csharp
// Create a queue of agents
var agents = new Queue<Agent>();

// Enqueue 3 agents
agents.Enqueue(new Agent() { Name = "James Bond" });
agents.Enqueue(new Agent() { Name = "Jason Bourne" });
agents.Enqueue(new Agent() { Name = "Evelyn Salt" });

// Pop all the agents
while (agents.TryDequeue(out var agent))
{
    Console.WriteLine($"Popping agent {agent.Name}");
}
```

This should print the following:

```plaintext
Popping agent James Bond
Popping agent Jason Bourne
Popping agent Evelyn Salt
```

Pretty straightforward.

Now imagine you wanted to use another criteria to prioritize the order the agents are popped, regardless of the order they are en-queued.

Let us say each agent has a score, `Effectiveness`, that we can use for this purpose.

We can use the [PriorityQueue](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.priorityqueue-2?view=net-6.0) class for this purpose.

```csharp
// Create a priority queue of agents
var prioritizedAgents = new PriorityQueue<Agent, int>();

// Enqueue 3 agents, specifying their effectiveness
prioritizedAgents.Enqueue(new Agent() { Name = "James Bond" }, 95);
prioritizedAgents.Enqueue(new Agent() { Name = "Jason Bourne" }, 85);
prioritizedAgents.Enqueue(new Agent() { Name = "Evelyn Salt" }, 90);

// Pop all the agents
while (prioritizedAgents.TryDequeue(out var agent, out var effectiveness))
{
    Console.WriteLine($"Popping agent {agent.Name}, who has effectiveness of {effectiveness}");
}
```

For this class you specify the type to enqueue and a second type, what to use for the prioritization.

Here we are queueing `Agent` types, and for priority we are using an `int`

```csharp
var prioritizedAgents = new PriorityQueue<Agent, int>();
```

If we run the code it will produce the following results:

```plaintext
Popping agent Jason Bourne, who has effectiveness of 85
Popping agent Evelyn Salt, who has effectiveness of 90
Popping agent James Bond, who has effectiveness of 95
```

Note the order relative to the enqueueing.

The semantics for the priority appears to be a **lower** value is a **higher** priority.

This type used to define priority does not have to be a number - it can be anything that implements [IComparer](https://docs.microsoft.com/en-us/dotnet/api/system.collections.generic.icomparer-1?view=net-6.0).

Take for example a scenario where it is a military dining mess and you are writing a program that dictates which staff to serve depending on who has entered the mess.

For this problem we define a `Rank` that we want to use for this purpose. 

```csharp
public class Rank
{
    public string Name { get; set; }
    public byte Weight { get; set; }
}
```

The greater the weight, the more the higher the rank.

We then write a `Comparer` to communicate how to determine which rank is greater than the other. We do this by implementing the `IComparer` interface

For the priority queue, a lower value is higher, so we write our `comparer` accordingly.

```csharp
public class RankComparable : IComparer<Rank>
{
    public int Compare(Rank a, Rank b)
    {
        // Equal rank
        if (a.Weight == b.Weight)
        	return 0;
        // Higher rank
        if (a.Weight > b.Weight)
        	return -1;
        // Lower rank
        return 1;
    }
}
```

We then have a simple soldier class.

```csharp
public class Soldier
{
    public string Name { get; set; }
}
```

Finally we create our `PriorityQueue`, making sure to specify the `Comparer`.

```csharp
void Main()
{
    var sergeant = new Rank() { Name = "Sergeant", Weight = 1 };
    var lieutenant = new Rank() { Name = "Lieutenant", Weight = 2 };
    var major = new Rank() { Name = "Major", Weight = 3 };
    var colonel = new Rank() { Name = "Colonel", Weight = 4 };
    
    var soldiersToServe = new PriorityQueue<Soldier, Rank>(new RankComparable());
    soldiersToServe.Enqueue(new Soldier() { Name = "John" }, sergeant);
    soldiersToServe.Enqueue(new Soldier() { Name = "Mary" }, lieutenant);
    soldiersToServe.Enqueue(new Soldier() { Name = "Anne" }, major);
    soldiersToServe.Enqueue(new Soldier() { Name = "Jeff" }, colonel);
    
    // Pop all the agents
    while (soldiersToServe.TryDequeue(out var soldier, out var rank))
    {
    	Console.WriteLine($"Serving agent {soldier.Name}, a {rank.Name}");
    }
}
```

This should print the following:

```plaintext
Serving agent Jeff, a Colonel
Serving agent Anne, a Major
Serving agent Mary, a Lieutenant
Serving agent John, a Sergeant
```

# Thoughts

This is an excellent class for problems where data structures are processed based on both order and priority.

You do, however, need to be clear what priority means.

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2021-09-13%20-%2030%20Days%20Of%20.NET%206%20-%20Day%206%20-%20PriorityQueue).

# TLDR

The `PriorityQueue` class is an implementation of a queue that factors in, in addition to the insertion order, a weight of each item.

**This is Day 6 of the 30 Days Of .NET 6 where every day I will attempt to explain one new / improved thing in the upcoming release of .NET 6.**

Happy hacking!