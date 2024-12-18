---
layout: post
title: Using AggegateBy In C# & .NET 9
date: 2024-12-18 12:12:08 +0300
categories:
    - C#
    - .NET 9
    - LINQ
---

Aggregation is a fairly common operation when it comes to data analysis, which is catered for pretty well in [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/).

Given this type:

```c#
public record Spy(string Name, int Age, string Agency);
```

And this collection:

```csharp
Spy[] spies =
[
  new Spy("James Bond (007)",50,"MI-6"),
  new Spy("Vesper Lynd",35,"MI-6"),
  new Spy("Q",30,"MI-6"),
  new Spy("Ethan Hunt",45,"IMF"),
  new Spy("Luther Stickell",48,"IMF"),
  new Spy("Benji Dunn",36,"IMF"),
  new Spy("Jason Bourne",55,"CIA"),
  new Spy("Harry Pearce",60,"MI-5"),
  new Spy("Adam Carter",40,"MI-5"),
  new Spy("Ros Myers",37,"MI-5")
];
```

How would you answer the question, **"What is the total age of all spies per agency?"**

Traditionally, you would use [Group](https://learn.microsoft.com/en-us/dotnet/csharp/linq/standard-query-operators/grouping-data) to group the collection by `Agency` and then aggregate by the sum of the age of each entry.

```csharp
var analysis = spies.GroupBy(s => s.Agency)
	.Select(group => new { Agency = group.Key, TotalAge = group.Sum(spy => spy.Age) });

foreach (var entry in analysis)
{
  Console.WriteLine($"Total Age Of Agents In {entry.Agency} is {entry.TotalAge}");
}
```

This will print the following:

```plaintext
Total Age Of Agents In MI-6 is 115
Total Age Of Agents In IMF is 129
Total Age Of Agents In CIA is 55
Total Age Of Agents In MI-5 is 137
```

This has been improved in .NET 9, where a new method, [AggregateBy](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.aggregateby?view=net-9.0) has been introduced for similar scenarios.

The code looks like this:

```csharp
var newAnalysis = spies.AggregateBy(x => x.Agency, 0,
	(total, spy) => total + spy.Age);

foreach (var entry in newAnalysis)
{
  Console.WriteLine($"Total Age Of Agents In {entry.Key} is {entry.Value}");
}
```

The magic is happening here:

```csharp
spies.AggregateBy(x => x.Agency, 0,
	(total, spy) => total + spy.Age)
```

A couple of things are happening here:

1. We are telling the compiler that we want to perform the aggregation per `Agency`
2. We are initializing the total per aggregate to `0`
3. We are then adding to `total` the age of every `Spy` per `Agency`

The result is the same as before.

In the interest of clarity, I prefer to project the result into a new [anonymous type](https://learn.microsoft.com/en-us/dotnet/csharp/fundamentals/types/anonymous-types) with readable properties.

In this case, `newAnalysis.Agency` and `newAnalysis.TotalAge` is clearer than `newAnalysis.Key` and `newAnalysis.Value`.

So, a slight modification:

```csharp
var newAnalysis = spies.AggregateBy(x => x.Agency, 0,
  (total, spy) => total + spy.Age)
  .Select(x => new { Agency = x.Key, TotalAge = x.Value });

foreach (var entry in newAnalysis)
{
  Console.WriteLine($"Total Age Of Agents In {entry.Agency} is {entry.TotalAge}");
}
```

Happy hacking!