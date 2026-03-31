---
layout: post
title: Code Housekeeping - Part 4 - Avoid NULL Wherever Possible
date: 2026-02-12 21:42:33 +0300
categories:
   - C#
    - Languages
    - CodeHouseKeeping
    - Code
    - Quality
---

In an ideal world, we would always have **all the data** for the properties of our `types`.

Take this simple example:

```c#
public record Person
{
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public Gender Gender { get; set; }
}
```

We can see here a property `Gender`, that is an [Enum](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/enum);

```c#
public enum Gender
{
    Male,
    Female
}
```

We would use it like this:

```c#
using Serilog;

Log.Logger = new LoggerConfiguration().WriteTo.Console().CreateLogger();

var james = new Person()
{
    FirstName = "James",
    LastName = "Bond",
    Gender = Gender.Male,
};

Log.Information("Welcome {FirstName} {LastName}", james.FirstName, james.LastName);
```

However, what if there is a situation where you **don't know** the `Gender`?

One way to go about this is as follows:

```c#
var other = new Person()
{
    FirstName = "Great",
    LastName = "Scott",
    Gender = null,
};
```

To get this to work, you must change the `Person` to make `Gender` [nullable](https://learn.microsoft.com/en-us/dotnet/csharp/nullable-references).

```c#
public record Person
{
    public required string FirstName { get; init; }
    public required string LastName { get; init; }
    public required Gender? Gender { get; init; }
}
```

This works, but presents a number of issues:

1. Your logic must factor in `Male`, `Female` and `NULL`
2. You have to keep checking whether `Gender` is `NULL` before using it

A better solution is to introduce an **actual value to represent unknown**, like this:

```c#
public enum Gender
{
    Male,
    Female,
    Unknown
}
```

This allows us to do the following:

```c#
var unknown = new Person()
{
    FirstName = "Jane",
    LastName = "Bond",
    Gender = Gender.Unknown,
};
```

This is much **cleaner**, and **explicit**.

It also allows us to write logic like this:

```c#
public sealed record Person
{
    public required string FirstName { get; init; }
    public required string LastName { get; init; }
    public required Genders? Gender { get; init; }

    public string Salutation => Gender switch
    {
        Genders.Male => "Mr",
        Genders.Female => "Mrs/Miss",
        Genders.Unknown => "Other",
        _ => "Fellow Kenyan"
    };
}
```

The `Salutation` logic here uses [switch expressions](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/switch-expression) that ensures the compiler enforces all the paths.

However, there are situations where `NULL` is unavoidable.

Take this updated `Person`:

```c#
var bourne = new Person()
{
    FirstName = "Jason",
    LastName = "Bourne",
    Gender = Genders.Male,
    DateOfBirth = null
};


```

In this case, a default `DateOfBirth` makes no sense if we did not know it at the point of data entry.

### TLDR

**Avoid `NULL` values whenever possible.**

The code is in my GitHub.

Happy hacking!
