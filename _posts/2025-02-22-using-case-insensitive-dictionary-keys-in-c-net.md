---
layout: post
title: Using Case Insensitive Dictionary Keys In C# & .NET
date: 2025-02-22 06:21:41 +0300
categories:
    - C#
    - .NET
---

Setting up and using a [Dictionary](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2?view=net-9.0) in .NET is very straightforward. 

Take the following example:

```c#
// Create a dictionary with a string key that stores integers

var dict = new Dictionary<string, int>();
// Add an item to the dictionary
dict.Add("James", 50);
dict.Add("Eve", 25);
dict.Add("Vesper", 35);

// Print sample name to console
Console.WriteLine(dict["James"]);
```

This will print the following:

```plaintext
50
```

Suppose we tweaked the program to capture the key from the user:

```c#
// Capture input from user
Console.WriteLine("Enter name of agent to search");

var name = Console.ReadLine();
// Print the value
if (!string.IsNullOrEmpty(name))
    Console.WriteLine(dict[name]);
else
    Console.WriteLine("Please enter a name");
```

If we entered ***James*** we would still get `50` printed.

Suppose we entered JAMES instead?

```plaintext
Unhandled exception. System.Collections.Generic.KeyNotFoundException: The given key 'JAMES' was not present in the dictionary.
   at System.Collections.Generic.Dictionary`2.get_Item(TKey key)
   at Program.<Main>$(String[] args) in /Users/rad/Projects/blog/BlogCode/DictionaryTest/Program.cs:line 18

```

Now we get an error because the `dictionary` **strictly** matches the key provided. In other words, `dictionary` keys are **case-sensitive**.

But there are cases where we want it **NOT** to be so.

How do we go about this?

The `Dictionary` class has a [constructor](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.dictionary-2.-ctor?view=net-9.0#system-collections-generic-dictionary-2-ctor(system-collections-generic-iequalitycomparer((-0)))) that allows you to pass it an [IEqualityComparer](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.iequalitycomparer-1?view=net-9.0), allowing you to tell the runtime **how to perform comparisons** of `key` values. This is especially useful when using a custom type as a dictionary key.

In this case, we can pass a [StringComparer](https://learn.microsoft.com/en-us/dotnet/api/system.stringcomparer?view=net-9.0) that satisfies our current problem.

Our `dictionary` definition now looks like this:

```c#
var dict = new Dictionary<string, int>(StringComparer.CurrentCultureIgnoreCase);
```

Our program now prints 50 regardless of how we input James - JAMES, James, james, or JaMeS.

### TLDR

**The `dictionary` class has an overload that allows you to pass an `IEqualityComparer` so that it knows how to match keys.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2025-02-22%20-%20Dictionary%20Case%20Insensitive).

Happy hacking!
