---
layout: post
title: Code Housekeeping - Part 14 - Don't Return NULL Collections
date: 2026-03-21 18:33:24 +0300
categories:
    - C#
    - Languages
    - CodeHouseKeeping
    - Code
    - Quality
---

**Code Housekeeping** refers to general rules of thumb that make code easier to **read**, **digest**, and **modify** for other developers, **yourself** included.

In today's post, we will look at a common problem with [collections](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/collections).

Let us take our usual example, a domain model with the following types - a `Spy`, defined thus:

```c#
public sealed class Spy
{
  public required string FirstName { get; init; }
  public required string Surname { get; init; }
  public required DateOnly DateOfBirth { get; init; }
}
```

And an `Agency`, defined thus:

```c#
public sealed class Agency
{
  public required string Name { get; init; }
  public required Spy[] Spies { get; init; }
}
```

Suppose we want to create a new `Agency` that does not presently have any `Spy`.

One way would be to do it this way:

```c#
var agency = new Agency()
{
  Name = "Savak",
  Spies = null
};
```

This works, but it is a **problem** waiting for you downstream.

Suppose later in the program we wrote this code:

```c#
//
// Later
//

// List all the spies in this agency
foreach (var spy in agency.Spies)
{
    Console.WriteLine($"{spy.FirstName} {spy.Surname}");
}
```

Running this program will throw a [NullReferenceException](https://learn.microsoft.com/en-us/dotnet/api/system.nullreferenceexception?view=net-10.0).

```plaintext
Unhandled exception. System.NullReferenceException: Object reference not set to an instance of an object.
   at Program.<Main>$(String[] args) in /Users/rad/Projects/BlogCode/EmptyCollections/Program.cs:line 12
```

The solution to this is to initialize the `Spies` collection with an **empty collection**.

This can be done in several ways:

```c#
var agency2 = new Agency()
{
    Name = "Savak",
    Spies = Array.Empty<Spy>()
};
```

A **better** way to do this is as follows:

```c#
var agency2 = new Agency()
{
    Name = "Savak",
    Spies = []
};
```

This is using the [collection expression](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/collection-expressions) syntax, which besides being **terse**, means if you change the collection type to something else like a [list](https://learn.microsoft.com/en-us/dotnet/api/system.collections.generic.list-1?view=net-10.0), for example, your **initialization code does not need to change**.

If you are using a traditional class without the [required](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/required) and [init](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/init) modifiers, define it like this:

```c#
public sealed class Agency
{
    public string Name { get; set; }
    public Spy[] Spies { get; set; } = [];
}
```

This way if the user **forgets to initialize** the collection, it is always **safely** an **empty** collection.

### TLDR

**Do not return `NULL` in the place of empty collections.**

The code is in my [GitHub](https://github.com/conradakunga/BlogCode/tree/master/2026-03-21%20-%20Empty%20Collections).

Happy hacking!
