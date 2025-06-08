---
layout: post
title: C# Dictionary Usage Optimizations - TryAdd
date: 2025-06-07 13:12:49 +0300
categories:
    - C#
    - .NET
    - Data Structures
---

One of the data structures you will commonly use is a [Dictionary](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2?view=net-9.0), which is a pair of two elements a **key** and a **value**.

The **key** is what is used to look up and retrieve the corresponding **value**.

For example, if we wanted do define a dictionary of an `integer` as a **key**, and a `value` as a **string**, we would do it as follows:

```c#
var numbers = new Dictionary<int, string>();
```

We would then add items like this:

```c#
// Add items
numbers.Add(1, "One");
numbers.Add(2, "Two");
numbers.Add(3, "Three");
numbers.Add(4, "Four");
numbers.Add(5, "Five");

// Print items
foreach (var element in numbers)
{
  Console.WriteLine($"Key: {element.Key} ; Value: {element.Value}");
}
```

This will print the following:

```plaintext
Key: 1 ; Value: One
Key: 2 ; Value: Two
Key: 3 ; Value: Three
Key: 4 ; Value: Four
Key: 5 ; Value: Five
```

What if we did the following - try to add item whose **key already exists**:

```c#
// Add items
numbers.Add(1, "One");
numbers.Add(2, "Two");
numbers.Add(3, "Three");
numbers.Add(4, "Four");
numbers.Add(5, "Five");
// Add an item with an existiting key
numbers.Add(5, "Six");

// Print items
foreach (var element in numbers)
{
  Console.WriteLine($"Key: {element.Key} ; Value: {element.Value}");
}
```

This will throw an exception:

```plaintext
Unhandled exception. System.ArgumentException: An item with the same key has already been added. Key: 5
   at System.Collections.Generic.Dictionary`2.TryInsert(TKey key, TValue value, InsertionBehavior behavior)
   at System.Collections.Generic.Dictionary`2.Add(TKey key, TValue value)
   at Program.<Main>$(String[] args) in /Users/rad/Projects/blog/BlogCode/OptimizeDictionaryAdd/Program.cs:line 12
```

You cannot add a key that already exists.

There are three solutions to this, depending on your intent.

If your intent is to **replace** the value  if it exists, you can do it as follows:

```c#
// Add items
numbers[1] = "One";
numbers[2] = "Two";
numbers[3] = "Three";
numbers[4] = "Four";
numbers[5] = "Five";
// Update existing key
numbers[5] = "Six";
```

This will print the following:

```plaintext
Key: 1 ; Value: One
Key: 2 ; Value: Two
Key: 3 ; Value: Three
Key: 4 ; Value: Four
Key: 5 ; Value: Six
```

If, however you do want to treat adding an existing key as an **anomaly**, you can **check first** before adding using the [ContainsKey](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2.containskey?view=net-9.0) method.

```c#
// Add items
numbers.Add(1, "One");
numbers.Add(2, "Two");
numbers.Add(3, "Three");
numbers.Add(4, "Four");
numbers.Add(5, "Five");
// Check if index exists before adding
if (!numbers.ContainsKey(5))
    numbers.Add(5, "Six");

// Print items
foreach (var element in numbers)
{
  Console.WriteLine($"Key: {element.Key} ; Value: {element.Value}");
}
```

This will print the following, as the code to add the item with value "Six" will not run:

```plantext
Key: 1 ; Value: One
Key: 2 ; Value: Two
Key: 3 ; Value: Three
Key: 4 ; Value: Four
Key: 5 ; Value: Five
```

An even better alternative is to call the [TryAdd](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2.tryadd?view=net-9.0) method:

```c#
// Add items
numbers.Add(1, "One");
numbers.Add(2, "Two");
numbers.Add(3, "Three");
numbers.Add(4, "Four");
numbers.Add(5, "Five");

if (!numbers.TryAdd(5, "Six"))
    Console.WriteLine("Could not add item with index 5 as it already exists!");
```

This method returns a `boolean` of whether the call **succeeded** or **not**, which you can check and act on, depending on your logic. It will succeed if the key does not already exist, and fail otherwise.

This saves you the trouble of looking if the key exists yourself first.

### TLDR

Call TryAdd when adding items to a dictionary and write your logic accordingly.

The code is in my GitHub.

Happy hacking!
