---
layout: post
title: .NET 11 Preview - Collection Expression Arguments
date: 2026-07-03 14:13:30 +0300
categories:
    - C#
    - .NET
    - .NET 11 Preview
---

One of the more brilliant [innovations](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-version-history) in C# 12  was [collection expressions](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/collection-expressions).

Typically, **initializing** a collection required code **specific** to that expression. Take the following examples:

```c#
// Initialize a list
List<string> namesList = new List<string>() { "Brenda", "Latisha", "Linda", "Felicia" };
// Initialize an array
string[] nameArray = new string[] { "Brenda", "Latisha", "Linda", "Felicia" };
// Initialize a HashSet
HashSet<string> nameHashSet = new HashSet<string> { "Brenda", "Latisha", "Linda", "Felicia" };
```

You can simplify the code for the [List](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1?view=net-10.0) and the [HashSet](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.hashset-1?view=net-10.0) as follows:

```c#
// Initialize a list
List<string> namesList = new() { "Brenda", "Latisha", "Linda", "Felicia" };
// Initialize a HashSet
HashSet<string> nameHashSet = new() { "Brenda", "Latisha", "Linda", "Felicia" };
```

Unfortunately, for a `string array`, it cannot get any simpler.

This problem is solved with **collection expressions.**

This means there is a **universal syntax for initializing collections.**

```c#
// Initialize a list
List<string> namesList = ["Brenda", "Latisha", "Linda", "Felicia"];
// Initialize an array
string[] nameArray = ["Brenda", "Latisha", "Linda", "Felicia"];
// Initialize a HashSet
HashSet<string> nameHashSet = ["Brenda", "Latisha", "Linda", "Felicia"];
```

You can see here that it does not matter the type of collection; initialization is the same.

The problem with this syntax is that there are times you need to **initialize some properties** on the collection.

For example, with a `List`, you can set its [size](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.-ctor?view=net-10.0#system-collections-generic-list-1-ctor(system-int32)) in advance to prevent the runtime from having to [recreate the object as it grows](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1.capacity?view=net-10.0).

```c#
var names = new List<string>(40);
```

Here we want our `List` to have a **preallocated** size of 40`.`

It has not been possible to do this with collection expressions.

This is now possible in .NET 11.

Your code would look like this:

```c#
List<string> namesList = [with(capacity: 4), "Brenda", "Latisha", "Linda", "Felicia"];
```

If you are initializing the collection from **another** collection, your code would look like this:

```c#
string[] otherCollection = ["Brenda", "Latisha", "Linda", "Felicia"];
List<string> namesList = [with(capacity: 4), .. otherCollection];
```

### TLDR

**You can pass parameters to collections during initialization using the `[with]` keyword.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-07-03%20-%20CollectionExpressionInit).

Happy hacking!
