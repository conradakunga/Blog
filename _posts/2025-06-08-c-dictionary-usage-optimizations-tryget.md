---
layout: post
title: C# Dictionary Usage Optimizations - TryGet
date: 2025-06-08 14:02:36 +0300
categories:
    - C#
    - .NET
    - Data Structures
---

This is a follow up post to yesterday's post on [C# Dictionary Usage Optimizations - TryAdd]({% post_url 2025-06-07-c-dictionary-usage-optimizations-tryadd %}).

Today we will look at how to **optimize value retrieval**.

Let us suppose we have the following `Dictionary` of a `int` **key** and and `string` **value**.

```c#
var numbers = new Dictionary<int, string>
{
    // Add items
    { 1, "One" },
    { 2, "Two" },
    { 3, "Three" },
    { 4, "Four" },
    { 5, "Five" }
};
```

You would tyically **retrieve** a value like this:

```c#
var itemValue = numbers[5];
```

This will print the following:

```plaintext
Five
```

The challenge arises when we try to access a **key that does not exist**.

```c#
itemValue = numbers[6];

Console.WriteLine(itemValue);
```

This will throw the following exception:

```plaintext
Unhandled exception. System.Collections.Generic.KeyNotFoundException: The given key '6' was not present in the dictionary.
   at System.Collections.Generic.Dictionary`2.get_Item(TKey key)
   at Program.<Main>$(String[] args) in /Users/rad/Projects/blog/BlogCode/2025-06-08 - TryGet/Program.cs:line 18
```

The solution to this is to **check if the key exists**. One way to do this is the [ContainsKey](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2.containskey?view=net-9.0) method.

```c#
if (numbers.ContainsKey(6))
{
    itemValue = numbers[6];
    Console.WriteLine(itemValue);
}
else
    Console.WriteLine("Key 6 does not exist");
```

A better, and simpler way is to use the [TryGetValue](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2.trygetvalue?view=net-9.0) method:

```c#
if (numbers.TryGetValue(6, out var number))
{
  itemValue = number;
  Console.WriteLine(itemValue);
}
else
  Console.WriteLine("Key 6 does not exist");
```

This method will **check if the key exists for you**, and if it does, it **retrieves** the value and returns `true`. If not, it simply returns `false`.

### TLDR

Use the `TryGetValue` method to safely retrieve values from a `dictionary`.

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-06-08%20-%20TryGet).

Happy hacking!
