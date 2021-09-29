---
layout: post
title: 30 Days Of .NET 6 - Day 13 - LINQ Improvements - Chunk
date: 2021-09-29 09:48:17 +0300
categories:
    - C#
    - 30 Days Of .NET 6
---
One of the cornerstones of modern computing is that there is much less emphasis on raw power and more on distributing work.

A common problem is you have a collection of data and you want to partition it in some way so that it can be processed in parallel - perhaps additional threads or processors or even additional machines!

Let us take an example.

Suppose you have an array of numbers.

```csharp
// Create a collection of 50 items (0-49)
var range = Enumerable.Range(0, 50).ToArray();
```

Let us also assume you have some expensive computing that is accessed via a web service. This service accepts an array as input.

How do we partition our range so that the pieces can be passed to to multiple instances of our service?

This is where the [Chunk](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.chunk?view=net-6.0) method comes into play.

`Chunk()` takes a size parameter and then attempts to partition the collection into multiple collections with the number of elements as specified by the size.

In other words, it returns a **collection of collections**.

In our example `Chunk()` when called on a collection of **50** elements will return **5** collections, each of **10** elements each

So the code looks like this:

```csharp
var range = Enumerable.Range(0, 50).ToArray();

// Partition the range into chunks of 10
var chunks = range.Chunk(size: 10).ToList();

// Loop though each chunk and process
for (var i = 0; i < chunks.Count(); i++)
{
    Console.WriteLine($"Processing chunk {i}");
    
    // Print the chunk
    Print(chunks[i]);
    
    // Call our expensive service and pass the partition
    
    // CallExpensiveService(chunks[i]);
}
```

This should print the following:

```plaintext
Processing chunk 0
0,1,2,3,4,5,6,7,8,9
Processing chunk 1
10,11,12,13,14,15,16,17,18,19
Processing chunk 2
20,21,22,23,24,25,26,27,28,29
Processing chunk 3
30,31,32,33,34,35,36,37,38,39
Processing chunk 4
40,41,42,43,44,45,46,47,48,49
```

# Thoughts

This is a very convenient method that will no doubt simplify a lot of partitioning code.

Also found that `Chunk()` accepts a size of 1. This will still return a collection, but each collection will have a single item.

In other words specifying `Chunk(size:1)` is not the same as doing nothing!

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2021-09-29%20-%2030%20Days%20Of%20.NET%206%20-%20Day%2013%20-%20LINQ%20Improvements%20-%20Chunk)

# TLDR

`Chunk()` allows you to partition a collection into multiple collections of a specified size.

**This is Day 13 of the 30 Days Of .NET 6 where every day I will attempt to explain one new / improved thing in the upcoming release of .NET 6.**

Happy hacking!