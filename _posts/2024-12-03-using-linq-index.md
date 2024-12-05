---
layout: post
title: Using LINQ Index
date: 2024-12-03 23:31:06 +0300
categories:
    - C#
    - LINQ
    - .NET 9
---

Here is a possible problem - you have a list of athletes and you would like to interate through them and generate an index for each.

You would typically do it like this:

```csharp
string[] runners = ["Usain Bolt", "Tyson Gay", "Nesta Carter", 
    "Letsile Tebogo", "Andre De Grasse"];

var indexed = runners.Select((name, index) => 
    new { Index = index + 1, Name = name });
    
foreach (var item in indexed)
{
    Console.WriteLine($"Runner #{item.Index} is {item.Name}");
}
```

This uses the [LINQ](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) [Select](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.select?view=net-9.0), which has an overload that allows you to access the index.

This has been simplified even further in .NET 9 that has introduced the [Index](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.index?view=net-9.0) method to LINQ, that returns each element and its index in a [tuple](https://learn.microsoft.com/en-us/dotnet/api/system.tuple?view=net-9.0).

You can simplify the code like this:

```csharp
foreach (var (index, runner) in runners.Index())
{
    Console.WriteLine($"Runner #{index + 1} is {runner}");
}
```
I am adding the 1 in both examples because I want the index to start from `1` and not from `0`

Happy hacking!