---
layout: post
title: Using LINQ CountBy In .NET 9
date: 2024-12-14 22:18:22 +0300
categories:
    - C#
    - .NET 9
---

Often in the course of your regular programming, you will need to do some basic analysis of data by aggregation, and the goto method here is typically [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) and it's [GroupBy](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.groupby?view=net-9.0).

Take the following domain:

```csharp
record Spy(string Name, string Service);
```

And the following dataset:

```csharp
// Build a list of spies
Spy[] spies =
  [
    new Spy("James Bond (007)","MI-6"),
    new Spy("Vesper Lynd","MI-6"),
    new Spy("Q","MI-6"),
    new Spy("Ethan Hunt","IMF"),
    new Spy("Luther Stickell","IMF"),
    new Spy("Benji Dunn","IMF"),
    new Spy("Jason Bourne","CIA"),
    new Spy("Harry Pearce","MI-5"),
    new Spy("Adam Carter","MI-5"),
    new Spy("Ros Myers","MI-5")
  ];
```

Suppose we need to know how many `spies` does a `Service` have?

A quick solution would be a simple `GroupBy` as follows:

```csharp
var results = spies.GroupBy(s => s.Service)
	.Select(t => new { Service = t.Key, Count = t.Count() });

// Iterate through each result and print
foreach (var rawResult in results)
{
	Console.WriteLine($"{rawResult.Service} : ({rawResult.Count})");
}
```

This groups the `spies` by `Service` and the creates an [enumerable](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable?view=net-9.0) of a new type that has two properties - `Service` which is the name of the service (gotten by the key) and `Count` which is a computation of the number of `spies` per service.

This will print the following:

```plaintext
MI-6 : (3)
IMF : (3)
CIA : (1)
MI-5 : (3)
```

This code can be simplified now with a new LINQ extension method - [CountBy](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.countby?view=net-9.0).

It will now look like this:

```csharp
var results = spies.CountBy(s => s.Service);

foreach (var result in results)
{
	Console.WriteLine($"{result.Key} : ({result.Value})");
}
```

Much terser, easier to read and easier to understand.

`CountBy` cannot be levereaged by a property only - it can be something evaluated.

If we re-work our domain like this:

```csharp
record Spy(string Name, int Age, string Service);
```

And our data like this:

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

We can do this:

```csharp
var results = spies.CountBy(s => s.Age >= 50);
foreach (var result in results)
{
	Console.WriteLine($"{(result.Key ? "50 Or Older" : "Less Than 50")} : ({result.Value})");
}
```

Which prints this:

```plaintext
50 Or Older : (3)
Less Than 50 : (7)
```

You can also improve the clarity of your returned results by projecting them into anonymous types, because dealing with `Key` and `Value` can quickly get confusing.

```csharp
var results = spies.CountBy(s => s.Age >= 50)
  //Project the result into a new type
  .Select(x => new { GreaterThanFifty = x.Key, Count = x.Value });

foreach (var result in results)
{
	Console.WriteLine($"{(result.GreaterThanFifty ? "50 Or Older" : "Less Than 50")} : ({result.Count})");
}
```

Happy hacking!