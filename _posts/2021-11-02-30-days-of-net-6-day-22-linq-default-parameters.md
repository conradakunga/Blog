---
layout: post
title: 30 Days Of .NET 6 - Day 22 - LINQ Default Parameters
date: 2021-11-02 16:36:22 +0300
categories:
    - .NET
    - C#
    - 30 Days Of .NET 6
---
One of the things to think about when writing LINQ
filter expressions (`First`, `Last`, or `Single`) is what happens when the thing you are looking for was not found.

Take this code for example:

```csharp
var numbers = new[] { 3, 4, 5, 6, 7, 9 };

var lowest = numbers.Single(n => n < 4);

Console.WriteLine(lowest);
```

This code will print ``3, which is the only number less than `4`.

If we change the code like this:

```csharp
var lowest = numbers.Single(n => n < 3);

Console.WriteLine(lowest);
```

It will crash with an `InvalidOperationException` at runtime, as no value satisfies the expression `< 3` 

To mitigate against this, you can use the `SingleOrDefault` method. 

Like this:

```csharp
var lowest = numbers.SingleOfDefault(n => n < 3);

Console.WriteLine(lowest);
```

Instead of crashing unceremoniously, this version will print a `0` instead, as nothing matched the expression.

The `0` here is no accident - it is the default value of an `integer` type.

If it was an array of `booleans`, it would have printed `false`, as `false` is the default value of a `boolean`.

What if you didn't want a `0`, or `0` might be a valid output and you want something else to signal that there was no match?

.NET 6 introduces an overload where you can specify a custom default.

So our previous example becomes:

```csharp
var numbers = new[] { 3, 4, 5, 6, 7, 9 };

var lowest = numbers.SingleOrDefault(n => n < 3, -1);
```

This now prints `-1` as its output.

This is great for primitive objects, but what about for a complex objects like a `class`?

Let us try with this `class`:

```csharp
public record Animal
{
    public string Name { get; init; }
    public byte Legs { get; init; }
}
```

If we run this code:

```csharp
var animals = new Animal[] 
{
    new Animal() { Name = "Cat", Legs = 4},
    new Animal() { Name = "Dog", Legs = 4}
};

var twoLegged = animals.SingleOrDefault(n => n.Legs == 2);
Console.WriteLine(twoLegged);
```

This will print `null`, as no animal satisfies the expression `Legs == 2`.

Why? Because the `default` of a reference object is `null`.

However the overload still works for classes. So we can do this:

```csharp
var animals = new Animal[] 
{
    new Animal() { Name = "Cat", Legs = 4},
    new Animal() { Name = "Dog", Legs = 4}
};

var twoLegged = animals.SingleOrDefault(n => n.Legs == 2, new Animal() { Name = "Bird", Legs = 2 });
```

Here we are creating a new `Animal`, a *Bird*, if our expression does not return any matches.

You an also provide **another** expression as the argument, provided that expression returns an `Animal`.

```csharp
var twoLegged = animals.SingleOrDefault(n => n.Legs == 2, animals.First());
```

This will return a **Cat**.

What would happen if you used a `struct` instead of a `class`?

```csharp
public record struct Animal
{
    public string Name { get; init; }
    public byte Legs { get; init; }
}
```

What would you expect this code to return, given a `struct`, being a value type, cannot be `null`?

```csharp
var animals = new Animal[] 
{
    new Animal() { Name = "Cat", Legs = 4},
    new Animal() { Name = "Dog", Legs = 4}
};

var twoLegged = animals.SingleOrDefault(n => n.Legs == 2);
```

This will **still** return an `Animal` `struct`, but its values will be initialized to the defaults - `Name` will be `null` and `Legs` will be `0`.

This new overload works with these extension methods:

* [LastOrDefault](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.lastordefault?view=net-6.0)
* [SingleOrDefault](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.singleordefault?view=net-6.0)
* [FirstOrDefault](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.firstordefault?view=net-6.0)

It does not seem to have been implemented for [ElementAtOrDefault](https://docs.microsoft.com/en-us/dotnet/api/system.linq.enumerable.elementatordefault?view=net-6.0)

# Thoughts

This will allow for the writing of cleaner code when handling edge cases for expressions that fail to return results.

# TLDR

LINQ expressions that have the `OrDefault` signature now have an overload to allow you to pass a default value if the expression does not return a result.

**This is Day 22 of the 30 Days Of .NET 6 where every day I will attempt to explain one new / improved thing in the upcoming release of .NET 6.**
