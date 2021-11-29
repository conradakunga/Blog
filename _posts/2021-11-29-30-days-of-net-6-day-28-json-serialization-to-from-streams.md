---
layout: post
title: 30 Days Of .NET 6 - Day 28 - JSON Serialization To & From Streams
date: 2021-11-29 10:28:43 +0300
categories:
    - .NET
    - C#
    - 30 Days Of .NET 6
---
Most of the time, when serializing JSON, you already have access to the underlying object that you are serializing.

Conversely, when de-serializing JSON, you usually have access to the JSON as a `string`.

There are, however, scenarios when you do not yet have access to the underling object or string - but you have the data in a stream of some sort - either a stream in memory ([MemoryStream](https://docs.microsoft.com/en-us/dotnet/api/system.io.memorystream?view=net-6.0)) or an IO stream of some sort - a [FileStream](https://docs.microsoft.com/en-us/dotnet/api/system.io.filestream?view=net-6.0) or a [NetworkStream](https://docs.microsoft.com/en-us/dotnet/api/system.net.sockets.networkstream?view=net-6.0).

Traditionally this has been a challenge, as you would have to get access to the underling data structures first. 

But from .NET 6 you can perform these operations directly - you can serialize **from** a stream as well as serializing **to** a stream.

We will use our usual example class:

```csharp
public record Animal
{
    public string Name { get; init; }
    public byte Legs { get; init; }
}
```


First we construct an array of animals

```csharp
// Create an array of animals
var animals = new[]
{
    new Animal(){ Name = "Dog" , Legs = 4},
    new Animal(){ Name = "Cat" , Legs = 4},
    new Animal(){ Name = "Chicken" , Legs = 2}
};
```


Next we write the code to serialize the array to a `stream`, in this case we make use of the fact that the `Console` in fact has an underlying `stream` that we can capture.

```csharp
// Construct the serialization options, we want to camel-case the attributes
var options = new JsonSerializerOptions() 
    { WriteIndented = true, PropertyNamingPolicy = JsonNamingPolicy.CamelCase };

// Stream to standard output
using (var stream = Console.OpenStandardOutput())
{
    JsonSerializer.Serialize(stream, animals, options);
}
```

If we run this code, we should see the following printed to the console:

```json
[
  {
    "name": "Dog",
    "legs": 4
  },
  {
    "name": "Cat",
    "legs": 4
  },
  {
    "name": "Chicken",
    "legs": 2
  }
]
```

The reverse, deserialization, is pretty similar.

Here we will use a file, `animals.json`, with the following content:

```json
[
    {
      "name": "Monkey",
      "legs": 4
    },
    {
      "name": "Donkey",
      "legs": 4
    },
    {
      "name": "Grasshopper",
      "legs": 6
    }
]
```

The logic here is to read this file into a stream, to demonstrate the fact that we can serialize from a stream. 

```csharp
// Load the file into a stream
using (var fileStream = new FileStream("animals.json", FileMode.Open))
{
    var newAnimals = JsonSerializer.Deserialize<Animal []>(fileStream, options);
    foreach (var animal in newAnimals)
        Console.WriteLine($"I am {animal.Name} with {animal.Legs} legs");
}
```

This should print the following:

```plaintext
I am Monkey with 4 legs
I am Donkey with 4 legs
I am Grasshopper with 6 legs
```

Now this is technically possible in .NET 5, but you have to do this using the async version of this API - [DeserializeAsync](https://docs.microsoft.com/en-us/dotnet/api/system.text.json.jsonserializer.deserializeasync?view=net-5.0) - a synchronous version is not available.

.NET 6 has both the sync and the async versions available to work with a `stream`.

# Thoughts

This will make it a lot easier to write performant code in scenarios where the data source or target is a `stream`.

The code is in my [Github](https://github.com/conradakunga/BlogCode/tree/master/2021-11-29%20-%2030%20Days%20Of%20.NET%206%20-%20Day%2028%20-%20Json%20Serlalization%20To%20%26%20From%20Streams).

# TLDR

There are new overloads to support JSON serialization and de-serialization to and from  `stream` objects.

**This is Day 28 of the 30 Days Of .NET 6 where every day I will attempt to explain one new / improved thing in the new release of .NET 6.**

Happy hacking!