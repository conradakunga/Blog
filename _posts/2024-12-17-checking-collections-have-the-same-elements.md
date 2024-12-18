---
layout: post
title: Checking Collections Have The Same Elements
date: 2024-12-17 03:40:29 +0300
categories:
    - C#
---

There may be occasions when you have two collections and want to verify that they are the same.

```csharp
int[] first = [1, 2, 3, 4, 5];
int[] second = [5, 2, 3, 4, 1];
int[] third = [1, 2, 3, 4, 5];
int[] fourth = first;
```

The first order of business is to decide what **"they are the same"** means.

1. Do they contain the same elements?
2. Do they contain the same elements and in the same order?
3. Do they refer to the same `object`?

Depending on your definition, you must approach this problem differently.

We can start with what seems like a valid approach - an equality check.

```csharp
Console.WriteLine(first == second);
Console.WriteLine(first == third);
Console.WriteLine(first == fourth);
```

This will print the following:

```plaintext
False
False
True
```

The third one is `true` because `fourth` is merely a **reference** to first. This is also why the other two comparisons return `false`.

If you want to compare the elements and their order, you use the [Linq](https://learn.microsoft.com/en-us/dotnet/csharp/linq/) [SeqenceEqual](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.sequenceequal?view=net-9.0) method.

```csharp
Console.WriteLine(first.SequenceEqual(second));
Console.WriteLine(first.SequenceEqual(third));
Console.WriteLine(first.SequenceEqual(fourth));
```

This returns the following:

```plaintext
False
True
True
```

Which makese sense.

The challenge is to verify that two collections contain the same elements, **regardless of order**. In our example `first` (`[1, 2, 3, 4, 5]`) and `second` (`[5, 2, 3, 4, 1]`).

There are a number of ways to do this.

### Order, Then Compare

Here, we explicitly order the elements first and then compare them.

```csharp
Console.WriteLine(first.Order().SequenceEqual(second.Order()));
```

### Use Specialized Data Structures

We can also make use of the fact that there is a specialized data structure, a [HashSet](https://learn.microsoft.com/en-us/dotnet/fundamentals/runtime-libraries/system-collections-generic-hashset%7Bt%7D), that stores a collection of **unique** elements.

So we put both collections into different sets and check that the sets have the same elements using the [SetEquals](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.hashset-1.setequals?view=net-9.0) method.

```csharp
Console.WriteLine(new HashSet<int>(first).SetEquals(new HashSet<int>(second)));
```

You can simplify this still further by making use of `Linq` extension methods that directly convert a collection to a `HashSet`, [ToHashSet](https://learn.microsoft.com/en-us/dotnet/api/system.linq.enumerable.tohashset?view=net-9.0)

```csharp
Console.WriteLine(first.ToHashSet().SetEquals(second.ToHashSet()));
```

### FluentAssertions

If you are doing these comparisons in the context of unit testing, an even better way to do this is to use the [FluentAssertions](https://fluentassertions.com/) library, which has extension methods to help with this sort of problem.

If we want to verify that two collections have the same elements, and in the same order, we do it like this:

```csharp
// Check have the same elements, in the same order
first.Should().Equal(second);
first.Should().Equal(third);
```

This will throw an exception for the first comparison, with this message

```csharp
Expected collection to be equal to {5, 2, 3, 4, 1}, but {1, 2, 3, 4, 5} differs at index 0.
```

If we want to check that two collections have the same elements, regardless of order, we do it like this:

```csharp
// Check have the same elements, regardless of order
first.Should().BeEquivalentTo(second);
first.Should().BeEquivalentTo(third);
```

The examples in this post use the `Array` collection but will also work for most collections that implement [IEnumberable](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.ienumerable-1?view=net-9.0) - such as [Lists](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1?view=net-9.0).

Happy hacking!