---
layout: post
title: Ordered Dictionary Improvements In .NET 9
date: 2024-12-05 03:32:09 +0300
categories:
    - C#
    - .NET 9
---

The [dictionary](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2?view=net-9.0) class is a workhorse of the developer. It is a data structure that allows you to store a `value` of any kind with an associated `key` to look up the said value. They key must be unique, and attempting to insert a duplicate throws an [exception](https://learn.microsoft.com/en-us/dotnet/api/system.argumentexception?view=net-9.0)

The following illustrates typical use:

```csharp
var spies = new Dictionary<string, string>();

spies.Add("bond", "James Bond");
spies.Add("salt", "Evelyn Salt");
spies.Add("bourne", "Jason Bourne");
spies.Add("smiley", "George Smiley");

Console.WriteLine(spies["salt"]);
```

This will print the following:

```plaintext
Evelyn Salt
```

The documentation for the `Dictionary` has this gem:

> For purposes of enumeration, each item in the dictionary is treated as a KeyValuePair<TKey,TValue> structure representing a value and its key. The order in which the items are returned is undefined.
> 

Suppose, for whatever reason, you wanted the items in your `Dictionary` ordered.

This problem was solved with the [OrderedDictionary](https://learn.microsoft.com/en-us/dotnet/api/system.collections.specialized.ordereddictionary?view=net-9.0)

The usage is exactly the same:

```csharp
var spies = new OrderedDictionary();

spies.Add("bond", "James Bond");
spies.Add("salt", "Evelyn Salt");
spies.Add("bourne", "Jason Bourne");
spies.Add("smiley", "George Smiley");

Console.WriteLine(spies["salt"]);
```

The `OrderedDictionary` additionally allows you to access items by index, so you can do this:

```charp
Console.WriteLine(spies[0])
```

Technically, you can achieve something similar with. dictionary using the ElementAt method

```charp
Console.WriteLine(spies.ElementAt(0))
```

But remember - **the ordering of a dictionary is undefied!**

There is a major difference between a generic `Dictionary` and an `OrderedDictionary` - in an `OrderedDictionary` they `key` and the `value` are `objects`.

So there is nothing to stop you from doing this:

```csharp
var spies = new OrderedDictionary();

spies.Add("bond", "James Bond");
spies.Add("salt", "Evelyn Salt");
spies.Add("bourne", "Jason Bourne");
spies.Add("smiley", "George Smiley");
spies.Add(1, ConsoleColor.Gray);
spies.Add(ConsoleColor.Yellow, new int[] { 1, 3, 4, 4, 5 });
```

This type safety issue has been addressed in .NET 9 where a [generic verision of the OrderedDictionary](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.ordereddictionary-2?view=net-9.0) has been introduced.

The code now looks like this, and the compiler enforces the types at insertion point.

```csharp
var spies = new OrderedDictionary<string, string>();

spies.Add("bond", "James Bond");
spies.Add("salt", "Evelyn Salt");
spies.Add("bourne", "Jason Bourne");
spies.Add("smiley", "George Smiley");

Console.WriteLine(spies["salt"]);
// Get the spy at the first position
Console.WriteLine(spies.GetAt(0).Value);
// Add a new spy at position 1
spies.Insert(0, "blaise", "Modesty Blaise");
// Get the spy at the first position
Console.WriteLine(spies.GetAt(0).Value);
```

This will print the following

```plaintext
Evelyn Salt
James Bond
Modesty Blaise
```

Of interest here is to access the element by position, you use the [GetAt method](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.ordereddictionary-2.getat?view=net-9.0), rather than index access. This, I would imagine, would be to avoid the ambigutiy if your `OrderedDictionary` was defined as `OrderdDictionary<int,[OtherType]>` - in that scenaro, what would `dict[0]` refer to?

Happy hacking!